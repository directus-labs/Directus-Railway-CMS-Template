# Frontend Starter Addons

Deploy Next.js, Nuxt, Astro, or SvelteKit frontends with your Directus CMS backend using starters from
[directus-labs/starters](https://github.com/directus-labs/starters).

## Adding a Frontend to Railway

1. **Add Service** in Railway:

   - Click "New Service" → "GitHub Repo"
   - Select: `directus-labs/starters`
   - **Set Root Directory** (required - this is a monorepo):
     - Next.js: `cms/nextjs`
     - Nuxt: `cms/nuxt`
     - Astro: `cms/astro`
     - SvelteKit: `cms/sveltekit`

2. **Add Environment Variables**:

   - Copy variables from `railway-configs/` folder (see files below)
   - Replace `your-webmaster-token-here` with token from Directus
   - Service references use `Directus` (if your service has a different name, replace it in the env vars)
   - Frontend service name defaults to `starters` - if you renamed it, replace `starters` with your service name

3. **Enable Public Networking**:
   - Go to Networking settings for the frontend service
   - Enable Public Networking
   - Add a domain (Railway will provide a default `.railway.app` domain)
   - **Port Configuration**: Railway automatically sets the `PORT` env var. Check your service logs to see what port the
     app is using (e.g., "Local: http://localhost:8080"), then set the networking port to match. Alternatively, let
     Railway auto-detect the port.

## Environment Variable Files

Copy variables from these files in `railway-configs/`:

- `nextjs-env-vars.txt` - Next.js
- `nuxt-env-vars.txt` - Nuxt
- `astro-env-vars.txt` - Astro
- `sveltekit-env-vars.txt` - SvelteKit

## Token Setup

**Webmaster Token (Required):**

- Directus admin → Users → Webmaster account → Token
- Replace `your-webmaster-token-here` in env vars

**Frontend Bot Token (Optional, for forms):**

- Directus admin → Users → Frontend Bot User → Token
- Generate token from that account

**Draft Mode Secret (Optional, for live preview):**

- Generate a random secret string

## Troubleshooting

**Application failed to respond:**

- Verify Public Networking is enabled in Railway
- Check that a domain is added in Networking settings
- **Port mismatch**: Check service logs to see what port the app is using (e.g., "Local: http://localhost:8080"), then
  ensure the Networking port matches. Railway sets `PORT` automatically - the networking port must match what the app
  listens on.
- Ensure the service is running (check deploy logs)

**Build failures:**

- Verify Directus service name matches in env vars (`Directus` by default)
- Check that `your-webmaster-token-here` is replaced with actual token
- Ensure Directus service is deployed and accessible

**Connection errors:**

- Verify CORS is enabled in Directus settings
- Check that Directus service has Public Networking enabled
- Verify service references resolve correctly in Railway
