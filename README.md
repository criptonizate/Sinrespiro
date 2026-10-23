# Protocolo de supervivencia

Juego idle en un solo `index.html`. Se publica en Vercel, y Supabase pone el login con Google, el guardado en la nube y el ranking.

| Archivo | Qué es |
|---|---|
| `index.html` | El juego completo |
| `config.js` | URL y anon key de Supabase (públicas por diseño) |
| `supabase.sql` | Tablas `saves` y `leaderboard` con sus políticas de seguridad |

Si `config.js` queda vacío, el juego funciona igual pero sin cuenta: guarda solo en el dispositivo y no tiene ranking.

## 1. Supabase

1. Creá un proyecto en https://supabase.com (o usá uno que ya tengas).
2. **SQL Editor → New query**: pegá todo `supabase.sql` y tocá **Run**.
3. **Project Settings → API**: copiá la *Project URL* y la clave *anon public* en `config.js`.

## 2. Google (para el botón "Entrar con Google")

1. Entrá a https://console.cloud.google.com, creá un proyecto y andá a **APIs y servicios → Pantalla de consentimiento de OAuth**.
   - Tipo **Externo**, nombre de la app, tu mail.
   - Al final, **Publicar app**. Si queda en "Prueba", solo pueden entrar los mails que agregues como testers.
2. **Credenciales → Crear credenciales → ID de cliente de OAuth → Aplicación web**.
   - En *URIs de redireccionamiento autorizados* poné: `https://TU-PROYECTO.supabase.co/auth/v1/callback`
3. Copiá el **Client ID** y el **Client Secret**.
4. En Supabase: **Authentication → Sign In / Providers → Google**: activalo y pegá el ID y el secret.

## 3. Vercel

En esta carpeta:

```bash
npx vercel          # la primera vez te pide loguearte y crea el proyecto
npx vercel --prod   # publica en producción y te da el link
```

## 4. Conectar la URL de Vercel con Supabase

En Supabase: **Authentication → URL Configuration**
- **Site URL**: `https://tu-juego.vercel.app`
- **Redirect URLs**: `https://tu-juego.vercel.app/**` y, para probar en tu compu, `http://localhost:5173/**`

## Probar en local

```bash
python -m http.server 5173
```

Después abrí http://localhost:5173

## Cómo funciona el guardado

- La partida se guarda siempre en el navegador. Con sesión iniciada, además se sube a Supabase cada 15 s como mucho y cada vez que salís de la pestaña.
- Al entrar desde otro dispositivo se carga la partida de la nube.
- Si alguien jugó sin cuenta y después entra con Google por primera vez, su progreso local pasa a su cuenta. Si esa cuenta ya tenía partida en la nube, se queda la de la nube.
- Al cerrar sesión se borra la copia local de ese dispositivo.
- El ranking ordena por prestigios, después por nivel máximo y después por monedas históricas.

> El juego corre entero en el navegador, así que alguien con conocimientos podría editar su puntaje desde la consola. Para jugar entre amigos alcanza. La base igual limita los valores (nivel 1–50, etc.).
