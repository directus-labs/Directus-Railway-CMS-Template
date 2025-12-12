<div align="center">
  <img src="directus-logo-stacked.png" alt="Directus Logo" width="250" />
</div>

# Directus Railway CMS Template

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template)

A production-ready, one-click deployment template for [Directus](https://directus.io) on [Railway](https://railway.app).
Deploy a fully configured headless CMS with PostgreSQL database, Redis cache, and S3 storage in minutes—no configuration
required.

**Directus** is an open-source headless CMS that lets you create, manage, and scale content. Design your data model,
build powerful REST and GraphQL APIs, and manage content for anything from simple websites to complex applications.

## What's Included

- **Directus CMS** - Headless CMS with REST + GraphQL API
- **PostgreSQL Database** - Automatically provisioned and linked via Railway's private network
- **Redis Cache** - Enabled for caching and WebSocket support
- **Railway S3 Storage** - Persistent file storage for multi-replica deployments
- **CMS Template** - Pre-configured content collections (pages, posts, forms, navigation) applied on first deploy
- **Auto-setup Scripts** - Admin user and CMS template automatically configured
- **Health Checks** - Built-in monitoring for Railway
- **Frontend Starters** - Ready to connect to Next.js, Nuxt, Astro, and SvelteKit
- - **Production Ready** - Configured with best practices, security, and scalability in mind

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
   - Apply CMS template with pre-configured collections, flows, and dashboards
3. **Access your Directus admin panel** at your Railway URL

### Add a Frontend

Connect your Directus backend to Next.js, Nuxt, Astro, or SvelteKit starters from
[directus-labs/starters](https://github.com/directus-labs/starters).

**See [FRONTEND_ADDONS.md](./FRONTEND_ADDONS.md) for complete setup instructions.**

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

The CMS template includes automatic setup scripts that:

- Create admin user on first deployment with secure credentials
- Apply CMS template with pre-configured collections (pages, posts, forms, navigation, etc.)
- Install and configure popular extensions from the marketplace
- Configure S3 storage bucket automatically
- Set up health checks and monitoring
- Create sample flows and dashboards

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
   docker-compose up -d
   ```

4. **Access Directus:**
   - Admin Panel: http://localhost:8055
   - Admin credentials are created automatically if `ADMIN_EMAIL` and `ADMIN_PASSWORD` are set in your `.env` file

**Note:** Local development uses local file storage by default. For S3 storage locally, configure the S3 environment
variables in your `.env` file (see `docker-compose.yml` for available options).

### Scripts

- `scripts/start-directus.sh` - Startup script that runs Directus bootstrap and optionally applies CMS template
- `scripts/bootstrap-admin.sh` - Admin user creation and template loading (CMS template only)

## Resources

- **Directus Documentation**: https://docs.directus.io
- **Railway Documentation**: https://docs.railway.app
- **Frontend Integration Guide**: [FRONTEND_ADDONS.md](./FRONTEND_ADDONS.md)
- **Directus Community Discord**: https://directus.chat
- **Directus GitHub**: https://github.com/directus/directus
- **Report Issues**: https://github.com/directus-labs/directus-railway-cms-template/issues

## License

MIT License - see [LICENSE](./LICENSE) file for details.
