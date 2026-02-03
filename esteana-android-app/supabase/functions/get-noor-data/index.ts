import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2"

serve(async (req) => {
  try {
    const corsHeaders = { "Content-Type": "application/json; charset=UTF-8", "Access-Control-Allow-Origin": "*" }

    // 1. استقبال المعاملات: من query (GET) أو body (POST)
    let lat = "30.04", lon = "31.23", ageParam: string | null = null, ageGroup = "adult"
    let targetOccupation = "any", targetGender = "both", deviceTime = ""

    if (req.method === "POST" && req.body) {
      const body = await req.json().catch(() => ({}))
      lat = String(body.lat ?? "30.04")
      lon = String(body.lon ?? "31.23")
      const ageNum = body.age != null ? Number(body.age) : NaN
      if (!Number.isNaN(ageNum)) {
        ageParam = String(ageNum)
        ageGroup = ageNum <= 12 ? "child" : ageNum >= 13 && ageNum <= 17 ? "both" : "adult"
      }
      targetOccupation = body.target_occupation ?? body.job ?? "any"
      targetGender = body.gender ?? body.target_gender ?? "both"
      deviceTime = body.time ?? ""
    } else {
      const url = new URL(req.url)
      lat = url.searchParams.get("lat") ?? "30.04"
      lon = url.searchParams.get("lon") ?? "31.23"
      ageParam = url.searchParams.get("age")
      const ageNum = ageParam != null ? Number(ageParam) : NaN
      if (!Number.isNaN(ageNum)) ageGroup = ageNum <= 12 ? "child" : ageNum >= 13 && ageNum <= 17 ? "both" : "adult"
      else if (url.searchParams.get("age_group")) ageGroup = url.searchParams.get("age_group")!
      targetOccupation = url.searchParams.get("target_occupation") ?? url.searchParams.get("job") ?? "any"
      targetGender = url.searchParams.get("gender") ?? url.searchParams.get("target_gender") ?? "both"
      deviceTime = url.searchParams.get("time") ?? ""
    }

    const age = ageParam != null ? Number(ageParam) : null

    // 2. جلب الطقس وتوقيتات الصلاة
    const [weatherRes, prayerRes] = await Promise.all([
      fetch(`https://api.open-meteo.com/v1/forecast?latitude=${lat}&longitude=${lon}&current_weather=true`),
      fetch(`https://api.aladhan.com/v1/timings?latitude=${lat}&longitude=${lon}&method=5`)
    ])
    const weatherData = await weatherRes.json()
    const prayerData = await prayerRes.json()
    const isRaining = weatherData?.current_weather?.weathercode > 50 ?? false

    const now = new Date()
    now.setHours(now.getUTCHours() + 2)
    const hour = now.getHours()
    const currentMinutes = hour * 60 + now.getMinutes()
    const isSleepTime = hour >= 23 || hour < 4
    const isWakeupTime = hour >= 4 && hour <= 8

    let isNearPrayer = false
    const prayerTimes = ["Fajr", "Dhuhr", "Asr", "Maghrib", "Isha"]
    const timings = prayerData?.data?.timings ?? {}
    for (const p of prayerTimes) {
      const t = timings[p]
      if (!t) continue
      const [pHour, pMin] = t.split(":").map(Number)
      const prayerMinutes = pHour * 60 + pMin
      const diff = prayerMinutes - currentMinutes
      if (diff > 0 && diff <= 20) {
        isNearPrayer = true
        break
      }
    }

    // 3. Supabase
    const supabase = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_ANON_KEY")!)

    // 4. قاعدة الأربعين: من تجاوز 40 يُفضّل الحكمة والاستغفار (advice, dhikr)، ودون ذلك السنن والبناء (sunnah)
    const preferContentTypesOver40 = ["advice", "dhikr"]
    const preferContentTypesUnder40 = ["sunnah", "hadith"]

    let query = supabase.from("islamic_content").select("id, content_type, title, content, reference, target_gender, age_group, target_occupation, trigger_type")

    if (isRaining) {
      query = query.eq("trigger_type", "rain")
    } else if (isNearPrayer) {
      query = query.eq("trigger_type", "near_prayer")
    } else if (isWakeupTime) {
      query = query.eq("trigger_type", "wakeup")
    } else if (isSleepTime) {
      query = query.eq("trigger_type", "sleep")
    } else {
      query = query.or(`age_group.eq.${ageGroup},age_group.eq.all,age_group.eq.both`)
      query = query.or(`target_occupation.eq.${targetOccupation},target_occupation.eq.any`)
      query = query.or(`target_gender.eq.${targetGender},target_gender.eq.both`)
    }

    const { data: contents } = await query
    let selection = contents && contents.length > 0 ? contents[Math.floor(Math.random() * contents.length)] : null

    // تطبيق قاعدة الأربعين عند وجود خيارات
    if (contents && contents.length > 1 && age != null) {
      const over40 = age >= 40
      const preferred = over40 ? preferContentTypesOver40 : preferContentTypesUnder40
      const filtered = contents.filter((c: { content_type: string }) => preferred.includes(c.content_type))
      if (filtered.length > 0) selection = filtered[Math.floor(Math.random() * filtered.length)]
      else selection = contents[Math.floor(Math.random() * contents.length)]
    }

    const faithContent = selection ?? { content: "سبحان الله وبحمده", reference: null, title: null, content_type: "dhikr" }

    return new Response(JSON.stringify({
      status: "success",
      content: {
        content: faithContent.content,
        reference: faithContent.reference ?? null,
        title: faithContent.title ?? null,
        content_type: faithContent.content_type ?? "dhikr"
      },
      timings: timings,
      hijri_date: prayerData?.data?.date?.hijri ?? null,
      meta: {
        timezone: "Egypt (UTC+2)",
        current_hour: hour,
        is_sleep_time: isSleepTime,
        is_near_prayer: isNearPrayer,
        location: { lat, lon },
        age_group: ageGroup,
        target_occupation: targetOccupation,
        target_gender: targetGender,
        device_time: deviceTime
      }
    }), { headers: corsHeaders })
  } catch (err) {
    return new Response(JSON.stringify({ error: (err as Error).message }), { status: 500, headers: { "Content-Type": "application/json" } })
  }
})
