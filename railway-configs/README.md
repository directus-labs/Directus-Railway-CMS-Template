# Railway Frontend Environment Variables

Copy the variables from the appropriate file into your Railway service environment variables. Each file contains **four** variables only (Directus URL, site URL, `DIRECTUS_SERVER_TOKEN`, and visual editing).

## Available Files

- `nextjs-env-vars.txt` — Next.js (CMS)
- `nuxt-env-vars.txt` — Nuxt (CMS)
- `astro-env-vars.txt` — Astro (CMS)
- `sveltekit-env-vars.txt` — SvelteKit (CMS)

## Usage

1. Open the file for your framework
2. Copy all variables into Railway's environment variables
3. Replace `your-webmaster-token` with your actual token from Directus (Webmaster user)
4. Service references use `Directus` — if your service has a different name, replace it in the env vars
5. Frontend service name defaults to `starters` — if you renamed it, replace `starters` with your service name
6. Enable Public Networking and add a domain in Railway's Networking settings

See [FRONTEND_ADDONS.md](../FRONTEND_ADDONS.md) for complete setup instructions.
