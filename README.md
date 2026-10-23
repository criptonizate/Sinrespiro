# Sin Respiro

Juego idle de supervivencia: tu vida se drena sin parar y tenés que aguantar hasta el final del camino para pasar de nivel. Con las monedas comprás mejoras, cada 5 niveles hay un jefe (una epidemia), y el prestigio te devuelve al nivel 1 a cambio de beneficios permanentes.

Se juega en https://sinrespiro.vercel.app. Es un solo `index.html` publicado en Vercel; Supabase pone el login con Google, el guardado en la nube y el ranking.

## Archivos

| Archivo | Qué es |
|---|---|
| `index.html` | El juego completo (HTML, CSS y JS) |
| `config.js` | URL y anon key de Supabase (públicas por diseño) |
| `supabase.sql` | Tablas `saves` y `leaderboard` con sus políticas de seguridad |
| `manifest.webmanifest`, `sw.js`, `icon-*.png`, `apple-touch-icon.png` | Para instalarlo como app (PWA) |

Si `config.js` queda vacío, el juego funciona igual pero sin cuenta: guarda solo en el dispositivo y no tiene ranking.

## Qué tiene el juego

- **Dificultades** Fácil (hasta nivel 30), Normal (50) y Difícil (100). Cada una tiene su propia partida; lo único que se comparte es lo del prestigio.
- **Mejoras con monedas** en pestañas: Salud (vida, escudo, regeneración), Resistencia (drenaje, toxinas, jefes), Economía y Suerte.
- **Esencia ◆** y **Tienda ✦** (puntos de prestigio): mejoras permanentes como casco, armadura o guantes.
- **Compañero**: un animal con una habilidad única.
- **10 personajes** con habilidades pasivas; 3 vienen libres y el resto se desbloquean jugando.
- **Cápsulas** en el camino (máximo 2 por partida): pueden traer monedas, cura, escudo o pase asegurado, pero también esporas, trampas o muerte súbita. Las chances están en la pestaña Suerte.
- **Ranking** por prestigios, después nivel máximo y después monedas históricas, con el personaje y la dificultad de cada uno.
- **Consejos** para jugadores nuevos, que aparecen una sola vez.

Balance aproximado: el primer prestigio llega a la hora de juego, y ganar Difícil lleva unos 31 prestigios (~70 h).

## Puesta en marcha

### 1. Supabase

1. Creá un proyecto en https://supabase.com.
2. **SQL Editor → New query**: pegá todo `supabase.sql` y tocá **Run**. Se puede volver a correr sin problema cuando cambie (por ejemplo, para agregar columnas nuevas).
3. **Project Settings → API**: copiá la *Project URL* y la clave *anon public* en `config.js`.

### 2. Google (botón "Entrar con Google")

1. En https://console.cloud.google.com creá un proyecto y andá a **APIs y servicios → Pantalla de consentimiento de OAuth**.
   - Tipo **Externo**, nombre de la app, tu mail.
   - Al final, **Publicar app**. Si queda en "Prueba", solo entran los mails que agregues como testers.
2. **Credenciales → Crear credenciales → ID de cliente de OAuth → Aplicación web**.
   - En *URIs de redireccionamiento autorizados*: `https://TU-PROYECTO.supabase.co/auth/v1/callback`
3. En Supabase, **Authentication → Sign In / Providers → Google**: activalo y pegá el Client ID y el Client Secret.

> El Client Secret va **solo** en Supabase. Nunca en `config.js` ni en el repo.

### 3. Vercel

El proyecto está conectado al repo de GitHub: cada `git push` a `main` publica solo. No hace falta build: es un sitio estático.

### 4. Conectar la URL de Vercel con Supabase

En Supabase, **Authentication → URL Configuration**:
- **Site URL**: `https://sinrespiro.vercel.app`
- **Redirect URLs**: `https://sinrespiro.vercel.app/**` y, para probar en tu compu, `http://localhost:5173/**`

## Probar en local

```bash
python -m http.server 5173
```

Después abrí http://localhost:5173. En local no se registra el service worker (solo en https), así que siempre ves la última versión.

## Instalarlo como app

- **Android (Chrome)**: menú ⋮ → *Instalar app* / *Agregar a la pantalla principal*.
- **iPhone (Safari)**: botón Compartir → *Agregar a inicio*.

Abre a pantalla completa y carga aunque no haya conexión (sin conexión no hay login, nube ni ranking). Las actualizaciones llegan solas: el juego siempre pide primero la versión nueva y usa la guardada solo si no hay red.

## Cómo funciona el guardado

- La partida se guarda siempre en el navegador. Con sesión iniciada, además se sube a Supabase cada 30 s como mucho y cada vez que salís de la pestaña.
- Al entrar desde otro dispositivo se carga la partida de la nube.
- Si jugaste sin cuenta y entrás con Google:
  - si la cuenta no tenía partida, tu progreso local pasa a la cuenta;
  - si ya tenía, el juego te muestra las dos y elegís con cuál seguir.
- Al cerrar sesión se borra la copia local de ese dispositivo.

## Rendimiento

En celulares se activa solo el *modo liviano*: menos efectos, sin música y menos actualizaciones por segundo, para que no caliente. El juego se pausa cuando la pestaña no está visible.

> El juego corre entero en el navegador, así que alguien con conocimientos podría editar su puntaje desde la consola. Para jugar entre amigos alcanza. La base igual limita los valores (nivel 1–100, etc.).
