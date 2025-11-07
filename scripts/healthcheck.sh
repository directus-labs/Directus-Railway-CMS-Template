#!/bin/sh
# Health check script for local testing
# Exits with non-zero status if health check fails

HEALTH_URL="${HEALTH_URL:-http://localhost:8055/server/health}"
MAX_ATTEMPTS=${MAX_ATTEMPTS:-10}
ATTEMPT=0

echo "Checking Directus health at: $HEALTH_URL"

while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
  # Use Node.js (available in Directus container)
  node -e 'const http=require("http"); http.get(process.env.HEALTH_URL, (r)=>{process.exit(r.statusCode===200?0:1);}).on("error",()=>process.exit(1));' > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "Health check passed!"
    exit 0
  fi
  ATTEMPT=$((ATTEMPT + 1))
  echo "Attempt $ATTEMPT/$MAX_ATTEMPTS: Waiting..."
  sleep 3
done

echo "Health check failed after $MAX_ATTEMPTS attempts"
exit 1
