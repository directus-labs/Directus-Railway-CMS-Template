FROM node:22-alpine AS template-cli
RUN npm install -g directus-template-cli@latest

ARG DIRECTUS_VERSION=12.1.1
FROM directus/directus:${DIRECTUS_VERSION}

# Switch to root to set up scripts and permissions
USER root

# Install template CLI (v12 image no longer includes npm/npx at runtime)
COPY --from=template-cli /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=template-cli /usr/local/bin/directus-template-cli /usr/local/bin/directus-template-cli

# Ensure extensions and uploads directories exist
RUN mkdir -p /directus/extensions /directus/uploads

# Copy scripts
COPY scripts/ /directus/scripts/

# Make scripts executable and set proper ownership
RUN chmod +x /directus/scripts/*.sh && \
    chown -R node:node /directus/scripts /directus/extensions /directus/uploads

# Set default database client (PostgreSQL)
ENV DB_CLIENT=pg

# Switch back to node user (default for Directus)
USER node

WORKDIR /directus

# Use our startup script as entrypoint
ENTRYPOINT ["/directus/scripts/start-directus.sh"]
