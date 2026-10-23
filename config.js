// Configuración pública del juego.
// La "anon key" de Supabase es pública por diseño: la seguridad la dan las políticas RLS de supabase.sql.
// Supabase → Project Settings → API (o "Data API"): copiá "Project URL" y la clave "anon public".
window.PROTOCOLO_CONFIG = {
  supabaseUrl: '',      // ej: 'https://abcdefghijkl.supabase.co'
  supabaseAnonKey: ''   // ej: 'eyJhbGciOi...'
};
