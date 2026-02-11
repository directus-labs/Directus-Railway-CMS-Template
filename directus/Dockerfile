ARG DIRECTUS_VERSION=11.15.1
FROM directus/directus:${DIRECTUS_VERSION}

# Switch to root to set up scripts and permissions
USER root

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
