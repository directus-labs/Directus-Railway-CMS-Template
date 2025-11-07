FROM directus/directus:11.13.0

# Switch to root to set up scripts and permissions
USER root

# Ensure extensions directory exists
RUN mkdir -p /directus/extensions

# Copy scripts for validation and startup
COPY scripts/ /directus/scripts/

# Make scripts executable and set proper ownership
RUN chmod +x /directus/scripts/*.sh && \
    chown -R node:node /directus/scripts

# Set default database client (PostgreSQL)
ENV DB_CLIENT=pg

# Switch back to node user (default for Directus)
USER node

WORKDIR /directus
