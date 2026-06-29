#!/usr/bin/with-contenv bashio
set -e

# ============================================================================
# Health Check Script for Paperclip AI
# ============================================================================

HEALTH_DIR="/share/paperclip/health"
STATUS_FILE="${HEALTH_DIR}/status"
START_TIME_FILE="${HEALTH_DIR}/start_time"

# Check if status file exists
if [ ! -f "${STATUS_FILE}" ]; then
    echo "stopped"
    exit 1
fi

# Read status and validate it's not empty
STATUS=$(cat "${STATUS_FILE}" 2>/dev/null || echo "")

# Validate status file has content
if [ -z "${STATUS}" ]; then
    echo "status file empty"
    exit 1
fi

# Check status
case "${STATUS}" in
    running)
        # Check if process is actually running
        if ! pgrep -f "node.*server/dist/index.js" > /dev/null; then
            echo "Process not running"
            exit 1
        fi

        # Check if HTTP endpoint is responding
        if ! curl -f -s http://localhost:3100/health > /dev/null 2>&1; then
            echo "HTTP endpoint not responding"
            exit 1
        fi

        # All checks passed
        exit 0
        ;;
    starting)
        # Still starting, return unhealthy
        exit 1
        ;;
    stopped|failed)
        # Stopped or failed
        exit 1
        ;;
    *)
        # Unknown status
        echo "Unknown status: ${STATUS}"
        exit 1
        ;;
esac