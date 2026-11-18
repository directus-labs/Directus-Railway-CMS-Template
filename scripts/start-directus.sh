#!/bin/sh
# Startup script for Directus
# Runs bootstrap and optionally applies CMS template

# Detect a fresh install BEFORE bootstrap creates the system tables.
# The CMS template is only ever applied to a brand-new database, so redeploys and
# Directus version upgrades never touch a user's (possibly customized) schema.
# Only a "table does not exist" error counts as fresh; any other failure
# (e.g. database not reachable yet) is treated as an existing install, to be safe.
fresh_install=false
db_check=$(node /directus/cli.js count directus_users 2>&1)
if [ $? -ne 0 ] && echo "$db_check" | grep -qiE "does not exist|doesn't exist|no such table"; then
  fresh_install=true
  echo "Empty database detected - this is a fresh install."
else
  echo "Existing Directus database detected - CMS template will not be applied."
fi

# Run Directus bootstrap (idempotent - safe to run on every startup)
# This will:
# - Create tables if database is empty
# - Run migrations if database exists but is outdated
# - Create admin user if ADMIN_EMAIL and ADMIN_PASSWORD are set
echo "Running Directus bootstrap..."
node /directus/cli.js bootstrap || {
  echo "Bootstrap completed (or already initialized)"
}

# Start CMS template loading in background
# (only on a fresh install, and only if DIRECTUS_TEMPLATE=cms and admin creds are set)
if [ "$fresh_install" = "true" ] && \
   [ -n "$DIRECTUS_TEMPLATE" ] && [ "$DIRECTUS_TEMPLATE" = "cms" ] && \
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
