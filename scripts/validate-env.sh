#!/bin/sh
# Environment variable validation script
# This script checks for required environment variables before starting Directus

set -e

echo "Validating environment variables..."

# Required variables
REQUIRED_VARS="SECRET ADMIN_EMAIL ADMIN_PASSWORD PUBLIC_URL"
MISSING_VARS=""

# Check required variables
for var in $REQUIRED_VARS; do
  eval value=\$$var
  if [ -z "$value" ]; then
    MISSING_VARS="$MISSING_VARS $var"
  fi
done

# Check database variables (required for Directus to start)
DB_REQUIRED_VARS="DB_HOST DB_PORT DB_DATABASE DB_USER DB_PASSWORD"
for var in $DB_REQUIRED_VARS; do
  eval value=\$$var
  if [ -z "$value" ]; then
    MISSING_VARS="$MISSING_VARS $var"
  fi
done

# If any variables are missing, print helpful error message
if [ -n "$MISSING_VARS" ]; then
  echo ""
  echo "ERROR: Missing required environment variables:"
  echo ""
  for var in $MISSING_VARS; do
    echo "  - $var"
  done
  echo ""
  echo "Setup Instructions:"
  echo ""
  echo "1. Add PostgreSQL Service:"
  echo "   - Go to Railway dashboard"
  echo "   - Click '+ New' → 'Database' → 'Add PostgreSQL'"
  echo "   - Railway will auto-inject database variables"
  echo ""
  echo "2. Set Required Variables in Railway:"
  echo "   - Go to your Directus service → Variables"
  echo "   - Set SECRET (generate with: openssl rand -hex 32)"
  echo "   - Set ADMIN_EMAIL (e.g., admin@example.com)"
  echo "   - Set ADMIN_PASSWORD (change after first login)"
  echo "   - Set PUBLIC_URL (usually: https://\${{RAILWAY_PUBLIC_DOMAIN}})"
  echo ""
  echo "3. Verify Database Variables Are Set:"
  echo "   - DB_HOST should be: \${{Postgres.PGHOST}}"
  echo "   - DB_PORT should be: \${{Postgres.PGPORT}}"
  echo "   - DB_DATABASE should be: \${{Postgres.PGDATABASE}}"
  echo "   - DB_USER should be: \${{Postgres.PGUSER}}"
  echo "   - DB_PASSWORD should be: \${{Postgres.PGPASSWORD}}"
  echo ""
  echo "   If these aren't auto-injected:"
  echo "   - Make sure PostgreSQL service is in the same Railway project"
  echo "   - Check that services are linked"
  echo "   - Try redeploying after adding PostgreSQL"
  echo ""
  exit 1
fi

echo "All required environment variables are set"
echo ""
echo "Starting Directus..."

