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
