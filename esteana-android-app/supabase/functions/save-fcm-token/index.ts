// Edge Function: save-fcm-token
// يستقبل POST بـ { fcm_token: string } ويُدخل/يحدّث جدول device_tokens

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2"

const cors = { "Content-Type": "application/json; charset=UTF-8", "Access-Control-Allow-Origin": "*" }

serve(async (req: Request) => {
  if (req.method === "OPTIONS") return new Response(null, { status: 204, headers: cors })

  if (req.method !== "POST") {
    return new Response(JSON.stringify({ error: "Method not allowed" }), { status: 405, headers: cors })
  }

  try {
    const body = await req.json().catch(() => ({})) as {
      fcm_token?: string
      notifications_enabled?: boolean
      frequency_hours?: number
      timezone_offset?: number
    }
    const fcmToken = typeof body.fcm_token === "string" ? body.fcm_token.trim() : ""
    if (!fcmToken) {
      return new Response(JSON.stringify({ error: "fcm_token required" }), { status: 400, headers: cors })
    }

    const supabase = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? Deno.env.get("SUPABASE_ANON_KEY")!
    )

    const row: Record<string, unknown> = {
      fcm_token: fcmToken,
      updated_at: new Date().toISOString(),
    }
    if (typeof body.notifications_enabled === "boolean") row.notifications_enabled = body.notifications_enabled
    if (typeof body.frequency_hours === "number" && [1, 3, 6].includes(body.frequency_hours)) row.frequency_hours = body.frequency_hours
    if (typeof body.timezone_offset === "number" && body.timezone_offset >= -12 && body.timezone_offset <= 14) row.timezone_offset = body.timezone_offset

    const { error } = await supabase.from("device_tokens").upsert(row as Record<string, never>, { onConflict: "fcm_token" })

    if (error) {
      return new Response(JSON.stringify({ error: error.message }), { status: 500, headers: cors })
    }
    return new Response(JSON.stringify({ ok: true }), { status: 200, headers: cors })
  } catch (e) {
    return new Response(JSON.stringify({ error: String(e) }), { status: 500, headers: cors })
  }
})
