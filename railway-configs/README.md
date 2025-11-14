# Railway Frontend Environment Variables

Copy the variables from the appropriate file into your Railway service environment variables.

## Available Files

- `nextjs-env-vars.txt` - Next.js
- `nuxt-env-vars.txt` - Nuxt
- `astro-env-vars.txt` - Astro
- `sveltekit-env-vars.txt` - SvelteKit

## Usage

1. Open the file for your framework
2. Copy all variables into Railway's environment variables
3. Replace `your-webmaster-token-here` with your actual token from Directus
4. Service references use `Directus` - if your service has a different name, replace it in the env vars
5. Frontend service name defaults to `starters` - if you renamed it, replace `starters` with your service name
6. Enable Public Networking and add a domain in Railway's Networking settings

See [FRONTEND_ADDONS.md](../FRONTEND_ADDONS.md) for complete setup instructions.
