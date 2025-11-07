#!/bin/sh
# Bootstrap script for Directus CMS template loading
# This script runs automatically on Railway after Directus starts

echo "Starting template loading process..."

# Wait for Directus to be ready (health check)
# Railway sets PORT automatically, may be 8080 or another port
DIRECTUS_PORT="${PORT:-8055}"
echo "Waiting for Directus to be ready on port $DIRECTUS_PORT..."
max_attempts=30
attempt=0

while [ $attempt -lt $max_attempts ]; do
  node -e "const http=require('http'); const port=process.env.PORT||8055; http.get(\`http://localhost:\${port}/server/health\`, (r)=>{let d=''; r.on('data',c=>d+=c); r.on('end',()=>process.exit(r.statusCode===200&&d.includes('status')?0:1));}).on('error',(e)=>{process.exit(1);});" > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "Directus is ready!"
    break
  fi
  attempt=$((attempt + 1))
  if [ $attempt -lt $max_attempts ]; then
    echo "Attempt $attempt/$max_attempts: Waiting for Directus..."
    sleep 2
  fi
done

if [ $attempt -eq $max_attempts ]; then
  echo "Warning: Directus health check failed after $max_attempts attempts"
  echo "Template loading will be skipped. You can manually apply the template later."
  exit 0
fi

# Load CMS template if DIRECTUS_TEMPLATE=cms (default)
template_setting="${DIRECTUS_TEMPLATE:-cms}"

if [ "$template_setting" != "cms" ]; then
  echo "DIRECTUS_TEMPLATE is set to '$template_setting' (not 'cms')."
  echo "Starting with a blank Directus instance."
  exit 0
fi

# Apply CMS template
# Use defaults if not set (Directus may have created admin with these)
ADMIN_EMAIL="${ADMIN_EMAIL:-admin@example.com}"
ADMIN_PASSWORD="${ADMIN_PASSWORD:-change-this-password}"

echo ""
echo "Loading CMS backend template..."

# Since this script runs inside the Directus container, we can use localhost
# Use PORT env var (Railway sets this automatically, may be 8080 or 8055)
DIRECTUS_PORT="${PORT:-8055}"
directus_url="http://localhost:${DIRECTUS_PORT}"
echo "Using Directus URL: $directus_url"

# Use GitHub template type - CMS template from directus-labs/starters
# Railway's environment is non-interactive, so CI=true and stdin redirect prevent prompts
echo "Running: npx directus-template-cli apply (programmatic mode)..."
CI=true npx -y directus-template-cli@latest apply -p \
  --directusUrl="${directus_url}" \
  --userEmail="${ADMIN_EMAIL}" \
  --userPassword="${ADMIN_PASSWORD}" \
  --templateLocation="https://github.com/directus-labs/starters/tree/main/cms/directus/template" \
  --templateType="github" \
  < /dev/null \
  2>&1 || {
    echo "Warning: Failed to apply CMS template. This may be because:"
    echo "1. Template already applied (check Directus admin panel)"
    echo "2. Network/authentication issues (verify ADMIN_EMAIL and ADMIN_PASSWORD)"
    echo "3. Admin user was created with different credentials"
    echo ""
    echo "You can manually apply the template later using:"
    echo "CI=true npx -y directus-template-cli@latest apply -p \\"
    echo "  --directusUrl=\"${directus_url}\" \\"
    echo "  --userEmail=\"<your-admin-email>\" \\"
    echo "  --userPassword=\"<your-admin-password>\" \\"
    echo "  --templateLocation=\"https://github.com/directus-labs/starters/tree/main/cms/directus/template\" \\"
    echo "  --templateType=\"github\""
    exit 0
  }

echo "CMS template loading completed!"
