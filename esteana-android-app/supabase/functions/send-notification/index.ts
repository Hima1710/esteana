// Edge Function: send-notification
// يجلّب آخر fcm_token من device_tokens، محتوى عشوائي من islamic_content، ويرسل إشعار FCM
// المفتاح: أضف FIREBASE_SERVICE_ACCOUNT_JSON في Supabase Dashboard > Edge Functions > Secrets (محتوى ملف الـ JSON)

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2"
import * as jose from "https://deno.land/x/jose@v5.2.0/index.ts"

const cors = { "Content-Type": "application/json; charset=UTF-8", "Access-Control-Allow-Origin": "*" }

serve(async (req: Request) => {
  if (req.method === "OPTIONS") return new Response(null, { status: 204, headers: cors })
  try {
    const supabase = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? Deno.env.get("SUPABASE_ANON_KEY")!)

    // 1. آخر جهاز مسجّل مع إعدادات الإشعارات
    const { data: devices, error: tokErr } = await supabase
      .from("device_tokens")
      .select("fcm_token, notifications_enabled, frequency_hours, last_notification_sent, timezone_offset")
      .order("updated_at", { ascending: false })
      .limit(1)
    if (tokErr || !devices?.length) {
      return new Response(JSON.stringify({ error: "No FCM token in device_tokens", detail: tokErr?.message }), { status: 400, headers: cors })
    }
    const device = devices[0] as {
      fcm_token: string
      notifications_enabled?: boolean
      frequency_hours?: number
      last_notification_sent?: string | null
      timezone_offset?: number | null
    }
    const fcmToken = device.fcm_token

    if (device.notifications_enabled === false) {
      return new Response(JSON.stringify({ status: "skipped", reason: "notifications_disabled" }), { status: 200, headers: cors })
    }

    const freqHours = typeof device.frequency_hours === "number" ? Math.max(1, Math.min(6, device.frequency_hours)) : 3
    const lastSent = device.last_notification_sent ? new Date(device.last_notification_sent).getTime() : 0
    const now = Date.now()
    if (lastSent > 0 && (now - lastSent) < freqHours * 60 * 60 * 1000) {
      return new Response(JSON.stringify({ status: "skipped", reason: "frequency", next_after_hours: freqHours }), { status: 200, headers: cors })
    }

    const tzOffset = typeof device.timezone_offset === "number" ? device.timezone_offset : 2
    const deviceHour = (new Date().getUTCHours() + tzOffset + 24) % 24
    const isNight = deviceHour >= 23 || deviceHour < 5

    // 2. محتوى من islamic_content: ليلاً (11م–5ص) فقط sleep/wakeup، نهاراً أي محتوى
    let rows: { title?: string; content?: string }[] | null = null
    if (isNight) {
      const { data: nightRows } = await supabase.from("islamic_content").select("id, title, content").in("trigger_type", ["sleep", "wakeup"])
      const arr = (nightRows as { title?: string; content?: string }[]) ?? []
      if (arr.length) rows = [arr[Math.floor(Math.random() * arr.length)]]
    }
    if (!rows?.length) {
      const { count } = await supabase.from("islamic_content").select("id", { count: "exact", head: true })
      const total = count ?? 1
      const offset = Math.floor(Math.random() * Math.max(1, total))
      const { data: anyRows } = await supabase.from("islamic_content").select("title, content").range(offset, offset)
      rows = anyRows as { title?: string; content?: string }[] | null
    }
    const row = rows?.[0]
    const title = (row?.title?.trim() || "إستعانة") as string
    const body = (row?.content?.trim() || "ذكر من الكتاب والسنة") as string

    // 3. مفتاح Firebase من Secrets (محتوى ملف Service Account JSON)
    const raw = Deno.env.get("FIREBASE_SERVICE_ACCOUNT_JSON")
    if (!raw) {
      return new Response(JSON.stringify({ error: "FIREBASE_SERVICE_ACCOUNT_JSON secret not set" }), { status: 500, headers: cors })
    }
    const sa = JSON.parse(raw) as { client_email: string; private_key: string; project_id: string }

    // 4. JWT واستلام access_token من Google
    const key = await jose.importPKCS8(sa.private_key.replace(/\\n/g, "\n"), "RS256")
    const jwt = await new jose.SignJWT({ scope: "https://www.googleapis.com/auth/firebase.messaging" })
      .setIssuer(sa.client_email)
      .setSubject(sa.client_email)
      .setAudience("https://oauth2.googleapis.com/token")
      .setExpirationTime("1h")
      .setIssuedAt()
      .setProtectedHeader({ alg: "RS256" })
      .sign(key)
    const tokenRes = await fetch("https://oauth2.googleapis.com/token", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: new URLSearchParams({ grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer", assertion: jwt }),
    })
    if (!tokenRes.ok) {
      const err = await tokenRes.text()
      return new Response(JSON.stringify({ error: "Failed to get access token", detail: err }), { status: 502, headers: cors })
    }
    const tokenData = await tokenRes.json() as { access_token?: string }
    const accessToken = tokenData.access_token
    if (!accessToken) {
      return new Response(JSON.stringify({ error: "No access_token in response" }), { status: 502, headers: cors })
    }

    // 5. إرسال إشعار FCM HTTP v1
    const fcmUrl = `https://fcm.googleapis.com/v1/projects/${sa.project_id}/messages:send`
    const fcmBody = {
      message: {
        token: fcmToken,
        notification: { title, body },
        android: {
          priority: "high",
          notification: {
            channel_id: "esteana_notifications",
            title,
            body,
            default_vibrate_timings: true,
          },
        },
      },
    }
    const fcmRes = await fetch(fcmUrl, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${accessToken}`,
      },
      body: JSON.stringify(fcmBody),
    })
    if (!fcmRes.ok) {
      const errText = await fcmRes.text()
      return new Response(JSON.stringify({ error: "FCM send failed", detail: errText }), { status: 502, headers: cors })
    }

    await supabase.from("device_tokens").update({ last_notification_sent: new Date().toISOString() }).eq("fcm_token", fcmToken)

    return new Response(JSON.stringify({ status: "success", message: "Notification sent", title, body }), { status: 200, headers: cors })
  } catch (e) {
    return new Response(JSON.stringify({ error: (e as Error).message }), { status: 500, headers: cors })
  }
})
