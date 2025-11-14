#!/bin/bash
# Health check and auto-restart script for n8n
# Can be run as a cron job to monitor n8n and restart if needed

# Configuration
N8N_URL="http://localhost:5678"
N8N_EXTERNAL_URL="https://n8n.terryglennon.org"
MAX_RETRIES=3
RETRY_DELAY=5
LOG_FILE="/var/log/n8n-health-check.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Check if n8n is responding
check_n8n() {
    local url=$1
    if curl -f -s --max-time 10 "$url" > /dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

# Restart n8n based on how it's running
restart_n8n() {
    log "${YELLOW}Attempting to restart n8n...${NC}"

    if command -v pm2 &> /dev/null && pm2 list | grep -q "n8n"; then
        log "Restarting via PM2..."
        pm2 restart n8n
        return $?
    elif systemctl is-active --quiet n8n 2>/dev/null; then
        log "Restarting via systemd..."
        sudo systemctl restart n8n
        return $?
    elif docker ps -a | grep -q "n8n"; then
        log "Restarting via Docker..."
        docker restart n8n
        return $?
    else
        log "${RED}Could not determine how to restart n8n${NC}"
        return 1
    fi
}

# Send notification (customize as needed)
send_notification() {
    local status=$1
    local message=$2

    # Log to file
    log "$message"

    # TODO: Add your notification method here
    # Examples:
    # - Email: echo "$message" | mail -s "n8n Health Check: $status" admin@example.com
    # - Slack webhook: curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"$message\"}" YOUR_SLACK_WEBHOOK_URL
    # - Discord webhook: curl -X POST -H 'Content-type: application/json' --data "{\"content\":\"$message\"}" YOUR_DISCORD_WEBHOOK_URL
}

# Main health check logic
main() {
    log "Starting health check..."

    # Check if n8n process is running
    if ! pgrep -f n8n > /dev/null; then
        log "${RED}n8n process is not running${NC}"
        send_notification "DOWN" "n8n process is not running. Attempting restart..."

        if restart_n8n; then
            log "${GREEN}n8n restarted successfully${NC}"
            send_notification "RECOVERED" "n8n has been restarted successfully"
        else
            log "${RED}Failed to restart n8n${NC}"
            send_notification "CRITICAL" "Failed to restart n8n. Manual intervention required."
            exit 1
        fi

        # Wait for n8n to start
        sleep 10
    fi

    # Check if n8n is responding to HTTP requests
    retry_count=0
    while [ $retry_count -lt $MAX_RETRIES ]; do
        if check_n8n "$N8N_URL"; then
            log "${GREEN}n8n is healthy (local check)${NC}"

            # Also check external URL
            if check_n8n "$N8N_EXTERNAL_URL"; then
                log "${GREEN}n8n is healthy (external check)${NC}"
            else
                log "${YELLOW}Warning: n8n local check passed but external URL is not responding${NC}"
                send_notification "WARNING" "n8n local check passed but external URL is not responding. Check reverse proxy/firewall."
            fi

            exit 0
        fi

        retry_count=$((retry_count + 1))
        if [ $retry_count -lt $MAX_RETRIES ]; then
            log "${YELLOW}n8n not responding, retry $retry_count/$MAX_RETRIES...${NC}"
            sleep $RETRY_DELAY
        fi
    done

    # All retries failed
    log "${RED}n8n is not responding after $MAX_RETRIES attempts${NC}"
    send_notification "DOWN" "n8n is not responding. Attempting restart..."

    if restart_n8n; then
        log "${GREEN}n8n restarted successfully${NC}"

        # Wait and verify
        sleep 10
        if check_n8n "$N8N_URL"; then
            log "${GREEN}n8n is now responding${NC}"
            send_notification "RECOVERED" "n8n has been restarted and is now responding"
            exit 0
        else
            log "${RED}n8n still not responding after restart${NC}"
            send_notification "CRITICAL" "n8n was restarted but is still not responding. Manual intervention required."
            exit 1
        fi
    else
        log "${RED}Failed to restart n8n${NC}"
        send_notification "CRITICAL" "Failed to restart n8n. Manual intervention required."
        exit 1
    fi
}

# Run main function
main
