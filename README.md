# Directus Railway CMS Template

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template)

A production-ready, one-click deployment template for [Directus](https://directus.io) on [Railway](https://railway.app). Get a fully configured Directus backend with PostgreSQL database and Redis cache in minutes.

**Directus** lets you create, manage, and scale headless content. Design your data model, build powerful APIs, and manage content for anything from simple websites to complex applications.

## What's Included

- **Directus** (v11.13.0) - Latest stable version with REST + GraphQL API
- **PostgreSQL Database** - Automatically provisioned and linked via Railway's private network (no egress fees)
- **Redis Cache** - Enabled by default for caching and WebSocket support
- **WebSockets** - Real-time features enabled by default
- **CMS Template** - Pre-configured content collections (pages, articles, etc.) applied automatically
- **Extensions Marketplace** - Access to extensions and plugins for enhanced functionality
- **Health Checks** - Built-in monitoring for Railway
- **Admin User** - Automatically created on first deployment
- **Frontend Starters** - Optional Next.js, Nuxt, Astro, and SvelteKit starters from [directus-labs/starters](https://github.com/directus-labs/starters)
- **Production Ready** - Configured with best practices for production use

## Use Cases

- **Content Management**: Enable teams to create, manage, and publish content without technical knowledge
- **API Development**: Build REST and GraphQL APIs from your database schema in minutes
- **Headless CMS**: Power websites, mobile apps, and other frontend applications with a flexible content API
- **Admin Panels**: Build custom admin interfaces for your applications
- **Data Management**: Visualize and manage data from any SQL database through an intuitive interface

## Quick Start

### Deploy to Railway

1. Click the [Deploy on Railway](https://railway.app/template) button above
2. Railway will prompt you to configure a few settings:
   - **SECRET**: A secure random string (32+ characters) - Railway can generate this for you
   - **ADMIN_EMAIL**: Your admin user email (e.g., `admin@example.com`)
   - **ADMIN_PASSWORD**: Your admin password (change this after first login!)
   - **PUBLIC_URL**: Usually auto-filled with your Railway domain
3. Railway will automatically:
   - Provision a PostgreSQL database
   - Link the database to Directus
   - Deploy your Directus instance
   - Create your admin user
   - Apply CMS template (default)
4. Once deployed, access your Directus admin panel at your Railway URL
5. **Important**: Change your admin password immediately after first login

### Generate Secret

For production, generate a secure random secret:

```bash
# Generate SECRET (32+ characters recommended)
openssl rand -hex 32
```

Set this as the `SECRET` environment variable in Railway.

### Apply CMS Backend Template (Default)

By default, the template will automatically apply the official Directus CMS backend template on first deploy. The bootstrap script applies the CMS template after admin user creation using the `directus-template-cli` tool (same as the official CLI uses).

**Template Options:**

- **CMS Template (default)**: The CMS template is loaded by default - includes pre-configured collections (pages, articles, etc.)
- **Blank Instance**: Set `DIRECTUS_TEMPLATE=` (empty) or `DIRECTUS_TEMPLATE=blank` to start with a clean Directus instance

If you want a blank instance instead, set `DIRECTUS_TEMPLATE` to an empty value in your Railway environment variables.

### Add Frontend Starter (Optional)

You can deploy a frontend starter alongside Directus. Railway can deploy frontends, or you can use Vercel/Netlify:

**Option 1: Deploy Frontend on Railway** (Recommended for simplicity)

- Railway can deploy Next.js, Nuxt, Astro, and SvelteKit frontends
- Frontend and backend communicate over Railway's private network (no egress fees)
- All services in one place for easier management

**Option 2: Deploy Frontend on Vercel/Netlify** (Recommended for hobby users)

- Better free tier limits for static sites
- Frontend connects to Railway backend via public API
- May incur egress fees for API calls (usually minimal)

See [FRONTEND_ADDONS.md](FRONTEND_ADDONS.md) for detailed setup instructions for both options.

## Post-Deployment Steps

### 1. Custom Domain

1. Go to your Railway project settings
2. Add a custom domain
3. Update `PUBLIC_URL` environment variable to match your domain

### 2. Configure Storage (Highly Recommended)

**Option A: S3-Compatible Storage (Recommended)**

1. Set up an S3 bucket (AWS S3, Cloudflare R2, DigitalOcean Spaces, etc.)
2. In Railway dashboard, go to your Directus service → **Variables** tab
3. Add these environment variables:
   ```
   STORAGE_LOCATIONS=s3
   STORAGE_S3_DRIVER=s3
   STORAGE_S3_KEY=your-access-key
   STORAGE_S3_SECRET=your-secret-key
   STORAGE_S3_BUCKET=your-bucket-name
   STORAGE_S3_REGION=us-east-1
   STORAGE_S3_ENDPOINT=  # Leave empty for AWS, set for R2/Spaces
   ```
4. Configure the storage location in Directus admin panel

**Option B: Railway Volume (For smaller projects)**

1. Add a volume to your Directus service in Railway
2. Mount it to `/directus/uploads`
3. Note: Volumes are tied to a single instance, scaling may cause issues

### 3. Configure Email (Optional)

In Railway dashboard, go to your Directus service → **Variables** tab and add:

```
EMAIL_TRANSPORT=smtp
EMAIL_FROM=noreply@yourdomain.com
EMAIL_SMTP_HOST=smtp.yourprovider.com
EMAIL_SMTP_PORT=587
EMAIL_SMTP_USER=your-username
EMAIL_SMTP_PASSWORD=your-password
```

## Local Usage

### Prerequisites

- Docker and Docker Compose

### Running Locally

1. Clone this repository and navigate to the `directus/` directory:

   ```bash
   git clone <repository-url>
   cd directus-railway-cms/directus
   ```

2. Create a `.env` file in the `directus/` directory (for local development only):

   ```bash
   cat > .env << EOF
   SECRET=$(openssl rand -hex 32)
   ADMIN_EMAIL=admin@example.com
   ADMIN_PASSWORD=d1r3ctu5
   PUBLIC_URL=http://localhost:8055
   EOF
   ```

   **Note**: This `.env` file is only for local development with Docker Compose. Railway uses environment variables set in the Railway dashboard, not a `.env` file.

3. Start services:

   ```bash
   docker-compose up
   ```

4. Once Directus is running, apply the CMS template:

   ```bash
   npx directus-template-cli@latest apply -p \
     --directusUrl="http://localhost:8055" \
     --userEmail="admin@example.com" \
     --userPassword="d1r3ctu5" \
     --templateLocation="https://github.com/directus-labs/starters/tree/main/cms/directus/template" \
     --templateType="github"
   ```

5. Access Directus at `http://localhost:8055` and login with your admin credentials

### Local Development Features

- **Redis Cache**: Enabled by default for better performance
- **WebSockets**: Enabled for real-time features
- **Extensions**: Add custom extensions to `directus/extensions/`
- **CORS**: Pre-configured for common frontend ports (3000, 4321, 5173)

## FAQ / Troubleshooting

### File Uploads Disappear

**Problem**: Files uploaded to Directus disappear after restart.

**Solution**: Configure S3/R2 storage or mount a persistent volume. Railway containers are ephemeral by default.

### Admin User Not Created

**Problem**: Can't login after deployment.

**Solutions**:

1. Check that `ADMIN_EMAIL` and `ADMIN_PASSWORD` are set correctly
2. Wait a few minutes for the bootstrap script to complete
3. Check Railway logs for bootstrap script output

### Database Connection Errors

**Problem**: Directus can't connect to PostgreSQL.

**Solutions**:

1. Verify PostgreSQL service is running in your Railway project
2. Check that database connection variables are set (should be auto-injected)
3. Check Railway logs for connection errors
4. Try redeploying the service

### Health Check Failing

**Problem**: Railway reports service as unhealthy.

**Solutions**:

1. Wait 1-2 minutes for Directus to fully start
2. Check Railway logs for startup errors
3. Verify all required environment variables are set
4. Check that PostgreSQL service is running

## Security Best Practices

1. **Change Default Password**: Immediately change admin password after first login
2. **Rotate Secret**: Periodically rotate `SECRET` (requires re-encryption)
3. **Use Environment Variables**: Never commit secrets to git
4. **Enable HTTPS**: Always use custom domains with SSL
5. **Limit Admin Access**: Create separate admin accounts for team members
6. **Use S3 Storage**: Prefer S3/R2 over local storage for production

## Support

- [Directus Documentation](https://docs.directus.io)
- [Railway Documentation](https://docs.railway.app)
- [Directus Community](https://community.directus.io/)
- [Railway Discord](https://discord.gg/railway)

## Issues & Bug Reports

This is a maintained project. If you encounter issues or bugs, please submit them via GitHub Issues. We review all issues and address bugs as needed.

## Why This Template?

This template provides everything you need to get Directus running in production:

- **One-Click Deploy**: Deploy with a single click - no manual configuration needed
- **Production Ready**: Pre-configured with PostgreSQL, Redis, and best practices
- **Automatic Setup**: Database schema, admin user, and CMS template applied automatically
- **Private Networking**: Database and cache communication over Railway's private network (no egress fees) - automatically configured when using Railway's service reference variables
- **Scalable**: Built to scale horizontally and vertically as your needs grow
- **Secure**: Pre-configured with security best practices and private networking

## Dependencies

- **Directus**: [Official Website](https://directus.io) | [Documentation](https://docs.directus.io) | [GitHub](https://github.com/directus/directus)
- **Frontend Starters**: [directus-labs/starters](https://github.com/directus-labs/starters) - Next.js, Nuxt, Astro, SvelteKit
- **Railway**: [Railway Platform](https://railway.app) - Deployment platform

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Related Projects

- [Directus Starters](https://github.com/directus-labs/starters) - Frontend starter templates for Next.js, Nuxt, Astro, and SvelteKit
