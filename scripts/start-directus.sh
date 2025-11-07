#!/bin/sh
# Wrapper script to validate environment variables and start Directus
# Bootstrap is idempotent - safe to run on every startup

# Run validation script (this will exit if critical vars are missing)
/directus/scripts/validate-env.sh

# Log database connection info (for debugging)
echo "Database connection info:"
echo "  DB_HOST: $DB_HOST"
echo "  DB_PORT: $DB_PORT"
echo "  DB_DATABASE: $DB_DATABASE"
echo "  DB_USER: $DB_USER"
echo ""

# Run bootstrap
# This will:
# - Create tables if database is empty
# - Run migrations if database exists but is outdated
# - Create admin user if ADMIN_EMAIL and ADMIN_PASSWORD are set
echo "Running Directus bootstrap..."
node /directus/cli.js bootstrap || {
  echo "Bootstrap completed (or already initialized)"
}

# Start template loading in background (non-blocking, won't affect Directus startup)
(
  sleep 5  # Give Directus a moment to start
  echo "Waiting for Directus to be ready before loading template..."
  DIRECTUS_PORT="${PORT:-8055}"
  max_attempts=60
  attempt=0

  while [ $attempt -lt $max_attempts ]; do
    node -e "const http=require('http'); const port=process.env.PORT||8055; http.get(\`http://localhost:\${port}/server/health\`, (r)=>{let d=''; r.on('data',c=>d+=c); r.on('end',()=>process.exit(r.statusCode===200&&d.includes('status')?0:1));}).on('error',(e)=>{process.exit(1);});" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
      echo "Directus is ready! Loading CMS template in background..."
      /directus/scripts/bootstrap-admin.sh 2>&1 || {
        echo "Note: Template loading completed or skipped"
      }
      exit 0
    fi
    attempt=$((attempt + 1))
    if [ $attempt -lt $max_attempts ]; then
      sleep 2
    fi
  done
  echo "Note: Template loading timed out, but Directus is running"
) &

# Start Directus (this is the main process - keeps container running)
# Using exec replaces the shell process with Directus
echo "Starting Directus..."
exec node /directus/cli.js start

