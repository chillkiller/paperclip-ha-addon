#!/usr/bin/with-contenv bashio
set -e

# ============================================================================
# Paperclip AI Home Assistant Add-on - Run Script
# Debian Trixie Edition
# ============================================================================

# Enable debug mode if requested
if [ "$(bashio::config 'log_level')" = "debug" ]; then
    set -x
    bashio::log.info "Debug mode enabled"
fi

bashio::log.info "=========================================="
bashio::log.info "Starting Paperclip AI Add-on"
bashio::log.info "=========================================="

# ============================================================================
# Signal Handler for Graceful Shutdown
# ============================================================================
cleanup() {
    bashio::log.info "Shutting down Paperclip gracefully..."
    # Give Paperclip time to close connections and save state
    sleep 2
    bashio::log.info "Paperclip shutdown complete"
    exit 0
}

trap cleanup SIGTERM SIGINT

# ============================================================================
# Phase 1: Configuration Loading and Validation
# ============================================================================

bashio::log.info "Phase 1: Loading configuration..."

# Log level
LOG_LEVEL=$(bashio::config 'log_level')
bashio::log.info "Log level: ${LOG_LEVEL}"

# Database configuration
DATABASE_TYPE=$(bashio::config 'database.type')
bashio::log.info "Database type: ${DATABASE_TYPE}"

if [ "${DATABASE_TYPE}" = "postgres" ]; then
    # Check for manual PostgreSQL configuration first (has priority)
    MANUAL_HOST=$(bashio::config 'database.postgres_host')
    
    if [ -n "${MANUAL_HOST}" ]; then
        # Use manual configuration
        POSTGRES_HOST="${MANUAL_HOST}"
        POSTGRES_PORT=$(bashio::config 'database.postgres_port')
        POSTGRES_USER=$(bashio::config 'database.postgres_user')
        POSTGRES_PASSWORD=$(bashio::config 'database.postgres_password')
        POSTGRES_DATABASE=$(bashio::config 'database.postgres_database')
        
        bashio::log.info "Using manual PostgreSQL configuration"
    elif bashio::services.available "postgres"; then
        # Use Home Assistant PostgreSQL service
        POSTGRES_HOST=$(bashio::services "postgres" "host")
        POSTGRES_PORT=$(bashio::services "postgres" "port")
        POSTGRES_USER=$(bashio::services "postgres" "username")
        POSTGRES_PASSWORD=$(bashio::services "postgres" "password")
        POSTGRES_DATABASE=$(bashio::config 'database.postgres_database')
        
        bashio::log.info "Using Home Assistant PostgreSQL service"
    else
        bashio::log.error "No PostgreSQL configuration available. Please provide manual configuration or enable PostgreSQL service."
        exit 1
    fi
    
    # Validate PostgreSQL configuration
    if [ -z "${POSTGRES_HOST}" ] || [ -z "${POSTGRES_USER}" ] || [ -z "${POSTGRES_PASSWORD}" ]; then
        bashio::log.error "PostgreSQL configuration incomplete. Please provide host, user, and password."
        exit 1
    fi
    
    bashio::log.info "PostgreSQL: ${POSTGRES_USER}@${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DATABASE}"
    export DATABASE_URL="postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DATABASE}"
else
    SQLITE_PATH=$(bashio::config 'database.sqlite_path')
    bashio::log.info "SQLite: ${SQLITE_PATH}"
    
    # Ensure directory exists
    SQLITE_DIR=$(dirname "${SQLITE_PATH}")
    mkdir -p "${SQLITE_DIR}"
    
    export DATABASE_URL="sqlite://${SQLITE_PATH}"
fi

# OpenClaw configuration
OPENCLEW_ENABLED=$(bashio::config 'openclaw.enabled')
if [ "${OPENCLEW_ENABLED}" = "true" ]; then
    OPENCLEW_URL=$(bashio::config 'openclaw.url')
    OPENCLEW_API_KEY=$(bashio::config 'openclaw.api_key')
    
    # Validate OpenClaw URL
    if [ -z "${OPENCLEW_URL}" ]; then
        bashio::log.warning "OpenClaw enabled but URL not provided. Disabling OpenClaw integration."
        OPENCLEW_ENABLED="false"
    else
        bashio::log.info "OpenClaw integration enabled: ${OPENCLEW_URL}"
        export OPENCLEW_URL="${OPENCLEW_URL}"
        export OPENCLEW_API_KEY="${OPENCLEW_API_KEY}"
    fi
else
    bashio::log.info "OpenClaw integration disabled"
fi

# Deployment configuration
DEPLOYMENT_MODE=$(bashio::config 'deployment.mode')
DEPLOYMENT_EXPOSURE=$(bashio::config 'deployment.exposure')
bashio::log.info "Deployment: ${DEPLOYMENT_MODE} / ${DEPLOYMENT_EXPOSURE}"

# Features configuration
TELEMETRY_ENABLED=$(bashio::config 'features.enable_telemetry')
ROUTINES_ENABLED=$(bashio::config 'features.enable_routines')
WORKSPACES_ENABLED=$(bashio::config 'features.enable_workspaces')
FEEDBACK_ENABLED=$(bashio::config 'features.enable_feedback')

bashio::log.info "Features: telemetry=${TELEMETRY_ENABLED}, routines=${ROUTINES_ENABLED}, workspaces=${WORKSPACES_ENABLED}, feedback=${FEEDBACK_ENABLED}"

# Performance configuration
MAX_CONCURRENT_RUNS=$(bashio::config 'performance.max_concurrent_runs')
RUN_TIMEOUT_MINUTES=$(bashio::config 'performance.run_timeout_minutes')
HEARTBEAT_INTERVAL_MINUTES=$(bashio::config 'performance.heartbeat_interval_minutes')

bashio::log.info "Performance: max_concurrent=${MAX_CONCURRENT_RUNS}, timeout=${RUN_TIMEOUT_MINUTES}m, heartbeat=${HEARTBEAT_INTERVAL_MINUTES}m"

# Backup configuration
BACKUP_ENABLED=$(bashio::config 'backup.enabled')
BACKUP_RETENTION_DAYS=$(bashio::config 'backup.retention_days')
BACKUP_PATH=$(bashio::config 'backup.backup_path')

if [ "${BACKUP_ENABLED}" = "true" ]; then
    bashio::log.info "Backups enabled: ${BACKUP_PATH} (retention: ${BACKUP_RETENTION_DAYS} days)"
    mkdir -p "${BACKUP_PATH}"
else
    bashio::log.info "Backups disabled"
fi

# ============================================================================
# Phase 2: Environment Setup
# ============================================================================

bashio::log.info "Phase 2: Setting up environment..."

# Paperclip home directory
PAPERCLIP_HOME="/paperclip"
export PAPERCLIP_HOME

# Data directory - all persistent data goes here
DATA_DIR="/share/paperclip"
export PAPERCLIP_DATA_DIR="${DATA_DIR}"

# Create necessary directories
mkdir -p "${PAPERCLIP_HOME}/instances/default"
mkdir -p "${DATA_DIR}"
mkdir -p "${DATA_DIR}/logs"
mkdir -p "${DATA_DIR}/temp"
mkdir -p "${DATA_DIR}/uploads"

# Set permissions
chown -R paperclip:paperclip "${PAPERCLIP_HOME}" "${DATA_DIR}"

bashio::log.info "Data directory: ${DATA_DIR}"
bashio::log.info "Paperclip home: ${PAPERCLIP_HOME}"

# ============================================================================
# Phase 3: Paperclip Configuration Generation
# ============================================================================

bashio::log.info "Phase 3: Generating Paperclip configuration..."

CONFIG_FILE="${PAPERCLIP_HOME}/instances/default/config.json"

cat > "${CONFIG_FILE}" << EOF
{
  "database": {
    "url": "${DATABASE_URL}"
  },
  "deployment": {
    "mode": "${DEPLOYMENT_MODE}",
    "exposure": "${DEPLOYMENT_EXPOSURE}"
  },
  "features": {
    "telemetry": ${TELEMETRY_ENABLED},
    "routines": ${ROUTINES_ENABLED},
    "workspaces": ${WORKSPACES_ENABLED},
    "feedback": ${FEEDBACK_ENABLED}
  },
  "performance": {
    "maxConcurrentRuns": ${MAX_CONCURRENT_RUNS},
    "runTimeoutMinutes": ${RUN_TIMEOUT_MINUTES},
    "heartbeatIntervalMinutes": ${HEARTBEAT_INTERVAL_MINUTES}
  },
  "backup": {
    "enabled": ${BACKUP_ENABLED},
    "retentionDays": ${BACKUP_RETENTION_DAYS},
    "path": "${BACKUP_PATH}"
  },
  "logging": {
    "level": "${LOG_LEVEL}"
  }
}
EOF

bashio::log.info "Configuration written to ${CONFIG_FILE}"

# ============================================================================
# Phase 4: Export Environment Variables
# ============================================================================

bashio::log.info "Phase 4: Exporting environment variables..."

export NODE_ENV=production
export HOST=0.0.0.0
export PORT=3100
export SERVE_UI=true
export PAPERCLIP_INSTANCE_ID=default
export PAPERCLIP_CONFIG="${CONFIG_FILE}"
export PAPERCLIP_DEPLOYMENT_MODE="${DEPLOYMENT_MODE}"
export PAPERCLIP_DEPLOYMENT_EXPOSURE="${DEPLOYMENT_EXPOSURE}"
export OPENCODE_ALLOW_ALL_MODELS=true

# Disable telemetry if requested
if [ "${TELEMETRY_ENABLED}" = "false" ]; then
    export DO_NOT_TRACK=1
    export PAPERCLIP_TELEMETRY_DISABLED=1
    bashio::log.info "Telemetry disabled"
fi

# ============================================================================
# Phase 5: Startup Information
# ============================================================================

bashio::log.info "=========================================="
bashio::log.info "Paperclip AI Configuration Summary"
bashio::log.info "=========================================="
bashio::log.info "Web UI: http://0.0.0.0:3100"
bashio::log.info "Data Directory: ${DATA_DIR}"
bashio::log.info "Config File: ${CONFIG_FILE}"
bashio::log.info "Database: ${DATABASE_TYPE}"
bashio::log.info "Deployment: ${DEPLOYMENT_MODE} / ${DEPLOYMENT_EXPOSURE}"
bashio::log.info "=========================================="

# ============================================================================
# Phase 6: Start Paperclip
# ============================================================================

bashio::log.info "Phase 6: Starting Paperclip server..."

cd /app

# Start Paperclip with proper signal handling
# Using exec to ensure PID 1 and proper signal propagation
exec node --import ./server/node_modules/tsx/dist/loader.mjs server/dist/index.js