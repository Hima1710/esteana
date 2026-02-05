import { createClient } from '@supabase/supabase-js';

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL ?? '';
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY ?? '';

export const supabase = supabaseUrl && supabaseAnonKey
  ? createClient(supabaseUrl, supabaseAnonKey)
  : null;

/**
 * إدراج سجل فعل في جدول daily_logs على Supabase.
 * @param {{ action_type: string, payload?: object, created_at?: string }} row
 */
export async function insertDailyLogToSupabase(row) {
  if (!supabase) return { error: new Error('Supabase not configured') };
  const { data, error } = await supabase
    .from('daily_logs')
    .insert({
      action_type: row.action_type,
      payload: row.payload ?? null,
      created_at: row.created_at ?? new Date().toISOString(),
    })
    .select('id')
    .single();
  return { data, error };
}
