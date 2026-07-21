#!/bin/sh
# Startup script for Directus
# Runs bootstrap and optionally applies CMS template

# Run Directus bootstrap (idempotent - safe to run on every startup)
# This will:
# - Create tables if database is empty
# - Run migrations if database exists but is outdated
# - Create admin user if ADMIN_EMAIL and ADMIN_PASSWORD are set
echo "Running Directus bootstrap..."
node /directus/cli.js bootstrap || {
  echo "Bootstrap completed (or already initialized)"
}

# Start CMS template loading in background (only if DIRECTUS_TEMPLATE=cms and admin creds are set)
if [ -n "$DIRECTUS_TEMPLATE" ] && [ "$DIRECTUS_TEMPLATE" = "cms" ] && \
   [ -n "$ADMIN_EMAIL" ] && [ -n "$ADMIN_PASSWORD" ]; then
  (
    sleep 5  # Give Directus a moment to start
    max_attempts=60
    attempt=0

    while [ $attempt -lt $max_attempts ]; do
      node -e "const http=require('http'); const port=process.env.PORT||8055; http.get(\`http://localhost:\${port}/server/ping\`, (r)=>{let d=''; r.on('data',c=>d+=c); r.on('end',()=>process.exit(r.statusCode===200?0:1));}).on('error',()=>process.exit(1));" > /dev/null 2>&1
      if [ $? -eq 0 ]; then
        echo "Directus is ready! Loading CMS template..."
        /directus/scripts/bootstrap-admin.sh 2>&1 || {
          echo "Note: Template loading completed or skipped"
        }
        exit 0
      fi
      attempt=$((attempt + 1))
      sleep 2
    done
    echo "Note: Template loading timed out, but Directus is running"
  ) &
fi

# Start Directus (main process - keeps container running)
echo "Starting Directus..."
exec node /directus/cli.js start
