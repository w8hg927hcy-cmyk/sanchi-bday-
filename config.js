/* ---------------------------------------------------------------------
   Mochi & Moonlight — cloud settings
   ---------------------------------------------------------------------
   Leave both values empty and the website still works (all 7 screens),
   but photo/video SAVING and completion tracking are OFF.


   To turn them on, follow README.md → "Supabase setup", then paste:
     supabaseUrl      → "sb_publishable_4JyyYWxoFf-TFO3SHOtX8g_zDgzcucY"        (https://uhiqntvnugzddrsgurog.supabase.co)
     supabaseAnonKey  →  "sb_publishable_4JyyYWxoFf-TFO3SHOtX8g_zDgzcucY" 
   The anon/publishable key is designed to be public. NEVER paste the
   "service_role" / "secret" key here.
--------------------------------------------------------------------- */
window.MOCHI_CONFIG = {
  supabaseUrl: "",
  supabaseAnonKey: "",
  bucket: "birthday-media"
};
