#!/bin/bash
# Restart n8n service

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Restarting n8n...${NC}"

# Check what method n8n is running with and restart accordingly

if command -v pm2 &> /dev/null && pm2 list | grep -q "n8n"; then
    echo "Detected PM2 process manager"
    pm2 restart n8n
    pm2 status
    echo -e "${GREEN}n8n restarted via PM2${NC}"

elif systemctl is-active --quiet n8n 2>/dev/null; then
    echo "Detected systemd service"
    sudo systemctl restart n8n
    sudo systemctl status n8n --no-pager
    echo -e "${GREEN}n8n restarted via systemd${NC}"

elif docker ps -a | grep -q "n8n"; then
    echo "Detected Docker container"
    docker restart n8n
    docker ps | grep n8n
    echo -e "${GREEN}n8n restarted via Docker${NC}"

else
    echo -e "${RED}Could not detect how n8n is running${NC}"
    echo "Please check manually with:"
    echo "  ps aux | grep n8n"
    exit 1
fi

echo ""
echo "Checking if n8n is responding..."
sleep 3

if curl -f http://localhost:5678 &>/dev/null; then
    echo -e "${GREEN}n8n is responding on port 5678${NC}"
else
    echo -e "${YELLOW}Warning: n8n may not be responding yet. Check logs.${NC}"
fi
