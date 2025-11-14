#!/bin/bash
# Stop n8n service

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Stopping n8n...${NC}"

# Check what method n8n is running with and stop accordingly

if command -v pm2 &> /dev/null && pm2 list | grep -q "n8n"; then
    echo "Detected PM2 process manager"
    pm2 stop n8n
    pm2 status
    echo -e "${GREEN}n8n stopped via PM2${NC}"

elif systemctl is-active --quiet n8n 2>/dev/null; then
    echo "Detected systemd service"
    sudo systemctl stop n8n
    sudo systemctl status n8n --no-pager || true
    echo -e "${GREEN}n8n stopped via systemd${NC}"

elif docker ps | grep -q "n8n"; then
    echo "Detected Docker container"
    docker stop n8n
    echo -e "${GREEN}n8n stopped via Docker${NC}"

else
    echo -e "${YELLOW}n8n doesn't appear to be running${NC}"
    echo "Checking for any n8n processes..."
    if pgrep -f n8n > /dev/null; then
        echo "Found n8n process. Killing..."
        pkill -f n8n
        echo -e "${GREEN}n8n process killed${NC}"
    else
        echo "No n8n processes found"
    fi
fi
