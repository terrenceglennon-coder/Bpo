#!/bin/bash
# Setup n8n as a systemd service for automatic restart

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Setting up n8n systemd service...${NC}"

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    echo -e "${RED}Please do not run this script as root${NC}"
    exit 1
fi

# Get current user
CURRENT_USER=$(whoami)
echo "Current user: $CURRENT_USER"

# Find node path
NODE_PATH=$(which node)
if [ -z "$NODE_PATH" ]; then
    echo -e "${RED}Error: node not found in PATH${NC}"
    exit 1
fi
echo "Node path: $NODE_PATH"

# Find n8n path
N8N_PATH=$(which n8n)
if [ -z "$N8N_PATH" ]; then
    echo -e "${RED}Error: n8n not found in PATH${NC}"
    echo "Please install n8n first: npm install -g n8n"
    exit 1
fi
echo "n8n path: $N8N_PATH"

# Create temporary service file
TEMP_SERVICE=$(mktemp)
echo "Creating service file..."

cat > $TEMP_SERVICE << EOF
[Unit]
Description=n8n - Workflow Automation Tool
After=network.target

[Service]
Type=simple
User=$CURRENT_USER
WorkingDirectory=/home/$CURRENT_USER
ExecStart=$NODE_PATH $N8N_PATH start

# Environment variables
Environment="N8N_HOST=0.0.0.0"
Environment="N8N_PORT=5678"
Environment="N8N_PROTOCOL=https"
Environment="WEBHOOK_URL=https://n8n.terryglennon.org"
Environment="N8N_EDITOR_BASE_URL=https://n8n.terryglennon.org"
Environment="GENERIC_TIMEZONE=America/New_York"

# Restart policy
Restart=always
RestartSec=10
StartLimitInterval=0

# Logging
StandardOutput=journal
StandardError=journal
SyslogIdentifier=n8n

# Resource limits
LimitNOFILE=65536
MemoryLimit=2G

[Install]
WantedBy=multi-user.target
EOF

echo "Service file created at: $TEMP_SERVICE"
echo ""
echo "Review the service file:"
cat $TEMP_SERVICE
echo ""

# Ask for confirmation
read -p "Do you want to install this service? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Installation cancelled"
    rm $TEMP_SERVICE
    exit 0
fi

# Copy service file
echo "Installing service file..."
sudo cp $TEMP_SERVICE /etc/systemd/system/n8n.service
rm $TEMP_SERVICE

# Reload systemd
echo "Reloading systemd..."
sudo systemctl daemon-reload

# Enable service
echo "Enabling n8n service to start on boot..."
sudo systemctl enable n8n

# Start service
echo "Starting n8n service..."
sudo systemctl start n8n

# Check status
echo ""
echo "Checking service status..."
sleep 2
sudo systemctl status n8n --no-pager || true

echo ""
echo -e "${GREEN}Installation complete!${NC}"
echo ""
echo "Useful commands:"
echo "  sudo systemctl status n8n    - Check status"
echo "  sudo systemctl restart n8n   - Restart service"
echo "  sudo systemctl stop n8n      - Stop service"
echo "  sudo systemctl start n8n     - Start service"
echo "  sudo journalctl -u n8n -f    - Follow logs"
echo ""
echo "n8n will now automatically restart if it crashes and start on system boot."
