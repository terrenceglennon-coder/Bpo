#!/bin/bash
# Start n8n with PM2 for auto-restart and process management

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting n8n...${NC}"

# Check if PM2 is installed
if ! command -v pm2 &> /dev/null; then
    echo -e "${YELLOW}PM2 not found. Installing PM2...${NC}"
    npm install -g pm2
fi

# Check if n8n is installed
if ! command -v n8n &> /dev/null; then
    echo -e "${YELLOW}n8n not found. Installing n8n...${NC}"
    npm install -g n8n
fi

# Stop any existing n8n process
echo "Stopping any existing n8n processes..."
pm2 stop n8n 2>/dev/null || true
pm2 delete n8n 2>/dev/null || true

# Set environment variables (customize as needed)
export N8N_HOST="0.0.0.0"
export N8N_PORT=5678
export N8N_PROTOCOL="https"
export WEBHOOK_URL="https://n8n.terryglennon.org"
export N8N_EDITOR_BASE_URL="https://n8n.terryglennon.org"

# Optional: Set these if using custom database
# export DB_TYPE="postgresdb"
# export DB_POSTGRESDB_HOST="localhost"
# export DB_POSTGRESDB_PORT=5432
# export DB_POSTGRESDB_DATABASE="n8n"
# export DB_POSTGRESDB_USER="n8n"
# export DB_POSTGRESDB_PASSWORD="your_password"

# Start n8n with PM2
echo "Starting n8n with PM2..."
pm2 start n8n --name n8n -- start

# Save PM2 configuration
pm2 save

# Setup PM2 to start on system boot
echo "Setting up PM2 to start on boot..."
pm2 startup systemd -u $USER --hp $HOME
# Note: You may need to run the command that PM2 outputs with sudo

echo -e "${GREEN}n8n started successfully!${NC}"
echo ""
echo "Useful commands:"
echo "  pm2 status       - Check status"
echo "  pm2 logs n8n     - View logs"
echo "  pm2 restart n8n  - Restart n8n"
echo "  pm2 stop n8n     - Stop n8n"
echo ""
echo "Access n8n at: https://n8n.terryglennon.org"
