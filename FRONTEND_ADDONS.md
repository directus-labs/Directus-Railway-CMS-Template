# Frontend Starter Addons

This guide explains how to deploy frontend starter templates (Next.js, Nuxt, Astro, SvelteKit) with your Directus CMS backend. You can deploy frontends on Railway or use Vercel/Netlify.

## Overview

You have two options for deploying frontends:

1. **Railway** - Deploy frontend alongside backend (all in one place, private networking)
2. **Vercel/Netlify** - Deploy frontend separately (better free tier, industry standard)

Both options work great! Choose based on your needs.

## Frontend Starter Options

The following frontend frameworks are available as optional addons:

- **Next.js** - React framework with SSR/SSG support
- **Nuxt** - Vue.js framework with SSR/SSG support  
- **Astro** - Content-focused framework with island architecture
- **SvelteKit** - Svelte framework with full-stack capabilities

## Adding Frontend Services to Railway Template

### Step 1: Add Frontend Service to Template

When configuring your Railway template in the template composer:

1. **Add New Service** for each frontend framework you want to offer
2. **Set Service Source**:
   - Repository: `https://github.com/directus-labs/starters`
   - Branch: `main`
   - Root Directory: `cms/nextjs` (or `cms/nuxt`, `cms/astro`, `cms/sveltekit`)
3. **Mark as Optional**: Users can choose which frontend(s) to deploy
4. **Set Service Name**: "Next.js Frontend", "Nuxt Frontend", etc.

### Step 2: Configure Environment Variables

Each frontend service needs to connect to the Directus backend:

**Required Variables:**
```bash
# Directus API URL (use Railway private network reference)
DIRECTUS_URL=${{Directus.RAILWAY_PUBLIC_DOMAIN}}
# Or for private networking:
DIRECTUS_URL=https://${{Directus.RAILWAY_PRIVATE_DOMAIN}}

# Directus API Key (optional - for public content)
DIRECTUS_ACCESS_TOKEN=

# Or use user authentication in the frontend
```

**Optional Variables:**
```bash
# Framework-specific variables
NODE_ENV=production
PORT=3000  # Or 4321 for Astro, 5173 for Vite-based
```

### Step 3: Configure Service Settings

For each frontend service:

1. **Root Directory**: Set if using monorepo (e.g., `nextjs/`, `nuxt/`)
2. **Build Command**: Framework-specific (e.g., `npm run build`)
3. **Start Command**: Framework-specific (e.g., `npm start` or `node .output/server/index.mjs`)
4. **Health Check**: Set to framework health endpoint (if available)

### Step 4: Enable Public Networking

1. Enable **Public Networking** for each frontend service
2. Set **HTTP** or **TCP Proxy** as needed
3. Frontends will get their own Railway domains

## Repository Structure

The frontend starters use the [Directus Labs Starters](https://github.com/directus-labs/starters) monorepo:

```
starters/
├── blank/          # For CLI tool users choosing blank template
├── cms/            # CMS template folder
│   ├── astro/      # Astro starter
│   ├── nextjs/     # Next.js starter
│   ├── nuxt/       # Nuxt starter
│   ├── sveltekit/  # SvelteKit starter
│   └── directus/   # Docker setup and example env
└── README.md
```

**Repository URL**: `https://github.com/directus-labs/starters`

**Frontend Service URLs** (for Railway template):
- Next.js: `https://github.com/directus-labs/starters/tree/main/cms/nextjs`
- Nuxt: `https://github.com/directus-labs/starters/tree/main/cms/nuxt`
- Astro: `https://github.com/directus-labs/starters/tree/main/cms/astro`
- SvelteKit: `https://github.com/directus-labs/starters/tree/main/cms/sveltekit`

**Root Directories** (set in Railway template):
- Next.js: `cms/nextjs`
- Nuxt: `cms/nuxt`
- Astro: `cms/astro`
- SvelteKit: `cms/sveltekit`

## Frontend Configuration

Each frontend starter should be configured to connect to Directus:

### Environment Variables Expected by Frontend

The [Directus Labs Starters](https://github.com/directus-labs/starters) use framework-specific environment variable names:

**Next.js:**
```bash
NEXT_PUBLIC_DIRECTUS_URL=https://your-directus.railway.app
NEXT_PUBLIC_SITE_URL=https://your-frontend.railway.app
DIRECTUS_PUBLIC_TOKEN=your-static-token
NEXT_PUBLIC_ENABLE_VISUAL_EDITING=true
```

**Nuxt:**
```bash
DIRECTUS_URL=https://your-directus.railway.app
NUXT_PUBLIC_SITE_URL=https://your-frontend.railway.app
DIRECTUS_SERVER_TOKEN=your-static-token
NUXT_PUBLIC_ENABLE_VISUAL_EDITING=true
```

**Astro:**
```bash
PUBLIC_DIRECTUS_URL=https://your-directus.railway.app
PUBLIC_SITE_URL=https://your-frontend.railway.app
DIRECTUS_PUBLIC_TOKEN=your-static-token
PUBLIC_ENABLE_VISUAL_EDITING=true
```

**SvelteKit:**
```bash
PUBLIC_DIRECTUS_URL=https://your-directus.railway.app
PUBLIC_SITE_URL=https://your-frontend.railway.app
PUBLIC_DIRECTUS_TOKEN=your-static-token
PUBLIC_ENABLE_VISUAL_EDITING=true
PUBLIC_DIRECTUS_FORM_TOKEN=user-with-form-permissions
DRAFT_MODE_SECRET=live-preview-token
```

**Note**: Each framework requires a static token from Directus. Users will need to:
1. Generate a static token in Directus admin panel (Users → Admin User → Token)
2. Set the appropriate token variable for their chosen framework

## Template Configuration Example

When creating the Railway template, configure services like this:

### Template Services

1. **Directus Backend** (Required)
   - Source: Your backend repo
   - Service name: "Directus CMS"

2. **PostgreSQL** (Auto-added)
   - Railway managed service

3. **Next.js Frontend** (Optional)
   - Source: `https://github.com/directus-labs/starters`
   - Branch: `main`
   - Root directory: `cms/nextjs`
   - Variables:
     - `NEXT_PUBLIC_DIRECTUS_URL=https://${{Directus.RAILWAY_PUBLIC_DOMAIN}}`
     - `NEXT_PUBLIC_SITE_URL=https://${{Nextjs.RAILWAY_PUBLIC_DOMAIN}}`
     - `DIRECTUS_PUBLIC_TOKEN` (user will set after generating token)
   - Mark as optional

4. **Nuxt Frontend** (Optional)
   - Source: `https://github.com/directus-labs/starters`
   - Branch: `main`
   - Root directory: `cms/nuxt`
   - Variables:
     - `DIRECTUS_URL=https://${{Directus.RAILWAY_PUBLIC_DOMAIN}}`
     - `NUXT_PUBLIC_SITE_URL=https://${{Nuxt.RAILWAY_PUBLIC_DOMAIN}}`
     - `DIRECTUS_SERVER_TOKEN` (user will set after generating token)
   - Mark as optional

5. **Astro Frontend** (Optional)
   - Source: `https://github.com/directus-labs/starters`
   - Branch: `main`
   - Root directory: `cms/astro`
   - Variables:
     - `PUBLIC_DIRECTUS_URL=https://${{Directus.RAILWAY_PUBLIC_DOMAIN}}`
     - `PUBLIC_SITE_URL=https://${{Astro.RAILWAY_PUBLIC_DOMAIN}}`
     - `DIRECTUS_PUBLIC_TOKEN` (user will set after generating token)
   - Mark as optional

6. **SvelteKit Frontend** (Optional)
   - Source: `https://github.com/directus-labs/starters`
   - Branch: `main`
   - Root directory: `cms/sveltekit`
   - Variables:
     - `PUBLIC_DIRECTUS_URL=https://${{Directus.RAILWAY_PUBLIC_DOMAIN}}`
     - `PUBLIC_SITE_URL=https://${{Sveltekit.RAILWAY_PUBLIC_DOMAIN}}`
     - `PUBLIC_DIRECTUS_TOKEN` (user will set after generating token)
     - `PUBLIC_DIRECTUS_FORM_TOKEN` (user will set)
     - `DRAFT_MODE_SECRET` (user will set)
   - Mark as optional

## User Experience

When users deploy the template:

1. **Template Selection**: User selects "Directus CMS + Frontend"
2. **Service Selection**: User can choose which frontend(s) to deploy:
   - ☑ Directus Backend (required)
   - ☐ Next.js Frontend (optional)
   - ☐ Nuxt Frontend (optional)
   - ☐ Astro Frontend (optional)
   - ☐ SvelteKit Frontend (optional)
3. **Configuration**: User fills in:
   - Admin credentials for Directus
   - Optionally selects which frontend(s) to deploy
4. **Deployment**: Railway deploys selected services
5. **Connection**: Frontends automatically connect to Directus via environment variables

## CORS Configuration

Ensure Directus CORS is configured to allow frontend domains:

```bash
# In Directus service environment variables
CORS_ENABLED=true
CORS_ORIGIN=${{Nextjs.RAILWAY_PUBLIC_DOMAIN}},${{Nuxt.RAILWAY_PUBLIC_DOMAIN}},${{Astro.RAILWAY_PUBLIC_DOMAIN}},${{Sveltekit.RAILWAY_PUBLIC_DOMAIN}}
```

Or for wildcard (less secure):
```bash
CORS_ORIGIN=*
```

## Testing Frontend Addons

To test frontend addons locally:

1. **Deploy Directus backend first** (or use local Directus)
2. **Generate static token** in Directus admin panel:
   - Go to Users → Admin User → Token
   - Generate and copy the token
3. **Clone starters repo**:
   ```bash
   git clone https://github.com/directus-labs/starters.git
   cd starters/cms/nextjs  # or nuxt, astro, sveltekit
   ```
4. **Set environment variables** (framework-specific):
   ```bash
   # Next.js example
   NEXT_PUBLIC_DIRECTUS_URL=https://your-directus.railway.app
   DIRECTUS_PUBLIC_TOKEN=your-static-token
   NEXT_PUBLIC_SITE_URL=http://localhost:3000
   ```
5. **Install and run**:
   ```bash
   npm install
   npm run dev
   ```

## Framework-Specific Notes

### Next.js
- Uses Node.js runtime
- Build command: `npm run build`
- Start command: `npm start`
- Default port: 3000

### Nuxt
- Uses Node.js runtime
- Build command: `npm run build`
- Start command: `node .output/server/index.mjs`
- Default port: 3000

### Astro
- Can use Node.js or static adapter
- Build command: `npm run build`
- Start command: `npm run preview` (for SSR) or serve static files
- Default port: 4321

### SvelteKit
- Uses Node.js runtime
- Build command: `npm run build`
- Start command: `node build/index.js`
- Default port: 3000

## Next Steps

1. **Add Frontend Services**: Add optional frontend services to Railway template using:
   - Repository: `https://github.com/directus-labs/starters`
   - Root directories: `cms/nextjs`, `cms/nuxt`, `cms/astro`, `cms/sveltekit`
2. **Configure Variables**: Set framework-specific environment variables with Railway references
3. **Update CORS**: Configure Directus CORS to include frontend domains
4. **Test Integration**: Deploy template with frontend addon and verify connection
5. **Document Token Generation**: Users will need to generate static tokens in Directus after deployment

## Support

For frontend-specific issues:
- Check frontend starter documentation
- Verify Directus API connection
- Check CORS configuration
- Review Railway service logs

