/**
 * استدعاء اهتزاز خفيف (Haptic) عبر جسر الأندرويد.
 * يدعم AndroidBridge.triggerVibration / vibrate و Android.triggerVibration / vibrate.
 */
function doVibrate(method) {
  if (typeof window === 'undefined') return;
  const bridge = window.AndroidBridge || window.Android;
  if (!bridge) return;
  if (typeof bridge[method] === 'function') {
    bridge[method]();
    return;
  }
  if (method !== 'vibrate' && typeof bridge.vibrate === 'function') {
    bridge.vibrate();
  }
}

export function vibrate() {
  doVibrate('vibrate');
}

/** اهتزاز عند التسبيح أو إتمام المهام (نفس vibrate، اسم موحّد للجسر). */
export function triggerVibration() {
  const bridge = window.AndroidBridge || window.Android;
  if (bridge?.triggerVibration) bridge.triggerVibration();
  else vibrate();
}

/**
 * طلب FCM Token من الأندرويد. يُرجع Promise يُستوفى عند استدعاء window.androidFCMTokenReceived(token).
 */
export function getFCMToken() {
  return new Promise((resolve) => {
    if (typeof window === 'undefined') {
      resolve('');
      return;
    }
    const bridge = window.AndroidBridge || window.Android;
    if (!bridge?.getFCMToken) {
      resolve('');
      return;
    }
    const handler = (token) => {
      window.androidFCMTokenReceived = null;
      resolve(token || '');
    };
    window.androidFCMTokenReceived = handler;
    bridge.getFCMToken();
    setTimeout(() => {
      if (window.androidFCMTokenReceived === handler) {
        window.androidFCMTokenReceived = null;
        resolve('');
      }
    }, 10000);
  });
}

/** true عند التشغيل داخل WebView الأندرويد (file:// أو app.esteana.local). */
function isAndroidWebView() {
  if (typeof window === 'undefined') return false;
  const p = window.location?.protocol;
  const h = window.location?.hostname;
  return p === 'file:' || h === 'app.esteana.local';
}

/**
 * جلب ملف JSON من أصول الأندرويد عبر الجسر (لأن Fetch قد يفشل في WebView مع file:// أو اعتراض الطلبات).
 * @param {string} assetPath - مسار الملف داخل assets، مثل "web/quran.json" أو "web/daily_actions.json"
 * @returns {Promise<object|null>}
 */
export function getAssetJson(assetPath) {
  return new Promise((resolve) => {
    if (typeof window === 'undefined') {
      resolve(null);
      return;
    }
    const bridge = window.AndroidBridge || window.Android;
    if (!bridge?.loadAsset || !isAndroidWebView()) {
      resolve(null);
      return;
    }
    if (!window.__assetLoadCallbacks__) {
      window.__assetLoadCallbacks__ = {};
      window.__onAssetLoaded__ = (path, base64) => {
        const cb = window.__assetLoadCallbacks__?.[path];
        if (!cb) return;
        clearTimeout(cb.timeout);
        delete window.__assetLoadCallbacks__[path];
        try {
          cb.resolve(JSON.parse(atob(base64)));
        } catch {
          cb.resolve(null);
        }
      };
      window.__onAssetLoadError__ = (path) => {
        const cb = window.__assetLoadCallbacks__?.[path];
        if (!cb) return;
        clearTimeout(cb.timeout);
        delete window.__assetLoadCallbacks__[path];
        cb.resolve(null);
      };
    }
    const timeout = setTimeout(() => {
      if (window.__assetLoadCallbacks__?.[assetPath]) {
        delete window.__assetLoadCallbacks__[assetPath];
        resolve(null);
      }
    }, 15000);
    window.__assetLoadCallbacks__[assetPath] = { resolve, timeout };
    bridge.loadAsset(assetPath);
  });
}
