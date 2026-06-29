# ============================================================================
# Base Image - Explicitly pinned for stability (Supervisor 2026.04.0+)
# ============================================================================
ARG BUILD_FROM=ghcr.io/home-assistant/aarch64-base-debian:trixie-2026.04.0
FROM ${BUILD_FROM}

# ============================================================================
# Metadata
# ============================================================================
LABEL \
    io.hass.name="Paperclip AI" \
    io.hass.description="Multi-Agent Orchestration Platform" \
    io.hass.type="addon" \
    io.hass.version="1.0.0" \
    io.hass.arch="aarch64|amd64" \
    maintainer="GaRoN <garon@example.com>" \
    io.hass.apparmor="default"

# ============================================================================
# Layer 1: System Dependencies (Minimal & Optimized)
# ============================================================================
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        su-exec \
        git \
        wget \
        ripgrep \
        python3 \
        openssh-client \
        jq \
        tzdata \
        sqlite3 \
        libsqlite3-dev \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# ============================================================================
# Layer 2: Node.js and pnpm
# ============================================================================
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Enable corepack and install pnpm with pinned version
RUN corepack enable && \
    corepack prepare pnpm@9.15.2 --activate

# ============================================================================
# Layer 3: User and Directory Setup
# ============================================================================
RUN useradd -m -s /bin/bash paperclip && \
    mkdir -p /paperclip /share/paperclip && \
    chown -R paperclip:paperclip /paperclip /share/paperclip

# ============================================================================
# Layer 4: Paperclip Build
# ============================================================================
ARG PAPERCLIP_VERSION=v2026.428.0
WORKDIR /tmp/paperclip-build

RUN git clone --depth 1 --branch ${PAPERCLIP_VERSION} https://github.com/paperclipai/paperclip.git . && \
    pnpm install --frozen-lockfile && \
    pnpm --filter @paperclipai/ui build && \
    pnpm --filter @paperclipai/plugin-sdk build && \
    pnpm --filter @paperclipai/server build && \
    test -f server/dist/index.js || (echo "ERROR: server build output missing" && exit 1)

# ============================================================================
# Layer 5: Install to Final Location
# ============================================================================
RUN cp -r /tmp/paperclip-build/* /app/ && \
    rm -rf /tmp/paperclip-build

WORKDIR /app

# ============================================================================
# Layer 6: Health Check
# ============================================================================
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD /usr/local/bin/healthcheck.sh || exit 1

# ============================================================================
# Layer 7: Entrypoint and Health Check Scripts
# ============================================================================
COPY run.sh /usr/local/bin/run.sh
COPY healthcheck.sh /usr/local/bin/healthcheck.sh
RUN chmod +x /usr/local/bin/run.sh /usr/local/bin/healthcheck.sh

# ============================================================================
# Environment Variables
# ============================================================================
ENV NODE_ENV=production \
    HOME=/paperclip \
    HOST=0.0.0.0 \
    PORT=3100 \
    SERVE_UI=true \
    PAPERCLIP_HOME=/paperclip \
    PAPERCLIP_INSTANCE_ID=default \
    PAPERCLIP_CONFIG=/paperclip/instances/default/config.json \
    PAPERCLIP_DEPLOYMENT_MODE=authenticated \
    PAPERCLIP_DEPLOYMENT_EXPOSURE=private \
    OPENCODE_ALLOW_ALL_MODELS=true

# ============================================================================
# Permissions and User Switch
# ============================================================================
RUN chown -R paperclip:paperclip /app /paperclip

USER paperclip

# ============================================================================
# Expose Port
# ============================================================================
EXPOSE 3100

# ============================================================================
# Entrypoint
# ============================================================================
CMD ["/usr/local/bin/run.sh"]

# ============================================================================
# Health Check Endpoint
# ============================================================================
# The application should provide a /health endpoint on port 3100
# This allows the Supervisor to monitor the add-on's health status