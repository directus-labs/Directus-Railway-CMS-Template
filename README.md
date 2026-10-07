<div align="center">
  <img src="directus-logo-stacked.png" alt="Directus Logo" width="250" />
</div>

# Directus Railway CMS Template

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template)

A production-ready, one-click deployment template for [Directus 12](https://directus.io) on [Railway](https://railway.app).
Deploy a fully configured headless CMS with PostgreSQL database, Redis cache, and S3 storage in minutes—no configuration
required.

**Directus** is an open-source headless CMS that lets you create, manage, and scale content. Design your data model,
build powerful REST and GraphQL APIs, and manage content for anything from simple websites to complex applications.

## How This Repo Relates to Starters

This repo is the **Railway deployment wrapper** — Dockerfile, bootstrap scripts, Railway env vars, and health checks.
The CMS schema and content come from [`directus-labs/starters`](https://github.com/directus-labs/starters) and are
applied at deploy time via `directus-template-cli` (not copied into this repo).

| Repo | Role |
|------|------|
| **This repo** | One-click Railway deploy, Docker image, S3/Redis/Postgres wiring |
| **[directus-labs/starters](https://github.com/directus-labs/starters)** | CMS template JSON (`cms/directus/template/`) and frontend apps |

Frontends (Next.js, Nuxt, Astro, SvelteKit) are deployed separately from the starters monorepo — see
[FRONTEND_ADDONS.md](./FRONTEND_ADDONS.md).

## What's Included

- **Directus 12.5.0** - Headless CMS with REST + GraphQL API
- **PostgreSQL Database** - Automatically provisioned and linked via Railway's private network
- **Redis Cache** - Enabled for caching and WebSocket support
- **Railway S3 Storage** - Persistent file storage for multi-replica deployments
- **CMS Template** - Pre-configured content collections (pages, posts, forms, navigation) applied on first deploy
- **Auto-setup Scripts** - Admin user and CMS template automatically configured
- **Health Checks** - Railway liveness via `/server/ping`
- **Frontend Starters** - Ready to connect to Next.js, Nuxt, Astro, and SvelteKit
- **Production Ready** - Configured with best practices, security, and scalability in mind

## Quick Start

### Deploy to Railway

1. **Click the [Deploy on Railway](https://railway.app/template) button above**
2. Railway will automatically:
   - Generate a secure `SECRET` (encryption key)
   - Set your `PUBLIC_URL` (from your Railway domain)
   - Provision a PostgreSQL database
   - Provision a Redis cache
   - Provision a Railway S3 storage bucket
   - Link all services to Directus via private network (zero egress fees)
   - Deploy your Directus instance
   - Create your admin user with secure credentials
   - Apply the CMS template from starters with pre-configured collections and flows
3. **Access your Directus admin panel** at your Railway URL

### Add a Frontend

Connect your Directus backend to Next.js, Nuxt, Astro, or SvelteKit starters from
[directus-labs/starters](https://github.com/directus-labs/starters).

When adding a frontend, update `CORS_ORIGIN` in Directus to your frontend URL — Directus 12 enforces CORS for
WebSocket connections.

**See [FRONTEND_ADDONS.md](./FRONTEND_ADDONS.md) for complete setup instructions.**

## Licensing (Directus 12)

Directus 12 uses the [MSCL license](https://directus.com/docs/licensing/overview). Self-hosted instances run on the
**Core tier** by default with no key required.

- **Core tier (default):** Works out of the box. Applies `template/` from starters.
- **Licensed tier (optional):** Set `LICENSE_KEY` in Railway env vars to unlock higher limits and enforceable RBAC
  filters. When `LICENSE_KEY` is set, bootstrap applies `template-licensed/` instead.

Existing instances upgrading from v11 get a 30-day grace period. See
[Directus v12 breaking changes](https://directus.com/docs/releases/breaking-changes/version-12) for details.

**Upgrading an existing deployment:** Do not re-run full template apply on a live instance. Deploy the updated image
and let bootstrap handle migrations. To add licensed RBAC to an existing core instance, see the starters repo
`rbac:sync-licensed` workflow.

## Features

### Private Networking

All communication between services (Directus, PostgreSQL, Redis, Storage) happens over Railway's private network. This
means:

- **Zero egress fees** for database and cache operations
- **Secure** - services are not exposed externally by default
- **Fast** - private network communication is optimized

### Scalable Storage

Uses Railway's S3-compatible storage buckets for file storage:

- **Multi-replica support** - Share storage across multiple Directus instances
- **Persistent** - Files survive container restarts and deployments
- **Scalable** - No storage limits tied to container size
- **Automatic configuration** - S3 bucket is automatically provisioned and configured

### Automatic Setup

The bootstrap scripts on first deploy:

- Create an admin user with your configured credentials
- Apply the CMS template from starters (collections, flows, roles, sample content)
- Skip template apply if the `pages` collection already exists (safe on redeploy)

## Development

### Local Development

Run Directus locally using Docker Compose with the same configuration as Railway:

1. **Navigate to directus directory:**

   ```bash
   cd directus
   ```

2. **Set up environment variables:**

   ```bash
   cp .env.example .env
   # Edit .env with your values
   ```

3. **Start services:**

   ```bash
   docker compose up -d --build
   ```

4. **Access Directus:**
   - Admin Panel: http://localhost:8055
   - Admin credentials are created automatically if `ADMIN_EMAIL` and `ADMIN_PASSWORD` are set in your `.env` file

**Note:** Local development uses local file storage by default. For S3 storage locally, configure the S3 environment
variables in your `.env` file (see `docker-compose.yml` for available options).

### Scripts

- `scripts/start-directus.sh` - Startup script that runs Directus bootstrap and optionally applies CMS template
- `scripts/bootstrap-admin.sh` - CMS template loading via `directus-template-cli` (core or licensed path)

## Resources

- **Directus Documentation**: https://docs.directus.io
- **Directus v12 Breaking Changes**: https://directus.com/docs/releases/breaking-changes/version-12
- **Railway Documentation**: https://docs.railway.app
- **Frontend Integration Guide**: [FRONTEND_ADDONS.md](./FRONTEND_ADDONS.md)
- **CMS Template Source**: [directus-labs/starters](https://github.com/directus-labs/starters/tree/main/cms/directus/template)
- **Directus Community Discord**: https://directus.chat
- **Directus GitHub**: https://github.com/directus/directus
- **Report Issues**: https://github.com/directus-labs/directus-railway-cms-template/issues

## License

MIT License - see [LICENSE](./LICENSE) file for details.
