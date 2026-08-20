# Global build arg — must be declared before any FROM to use in image tags
ARG DIRECTUS_VERSION=12.3.0

FROM node:22-alpine AS template-cli
WORKDIR /directus/template-cli
RUN npm init -y && npm install directus-template-cli@latest

FROM directus/directus:${DIRECTUS_VERSION}

# Switch to root to set up scripts and permissions
USER root

# Install template CLI locally with full dependency tree (v12 image has no npm/npx)
COPY --from=template-cli /directus/template-cli/node_modules /directus/template-cli/node_modules
RUN mkdir -p /directus/extensions /directus/uploads /directus/bin && \
    printf '#!/bin/sh\nexec node /directus/template-cli/node_modules/directus-template-cli/bin/run.js "$@"\n' \
      > /directus/bin/directus-template-cli && \
    chmod +x /directus/bin/directus-template-cli

# Copy scripts
COPY scripts/ /directus/scripts/

# Make scripts executable and set proper ownership
RUN chmod +x /directus/scripts/*.sh && \
    chown -R node:node /directus/scripts /directus/extensions /directus/uploads /directus/template-cli /directus/bin

# Set default database client (PostgreSQL)
ENV DB_CLIENT=pg
ENV PATH="/directus/bin:${PATH}"

# Switch back to node user (default for Directus)
USER node

WORKDIR /directus

# Use our startup script as entrypoint
ENTRYPOINT ["/directus/scripts/start-directus.sh"]
