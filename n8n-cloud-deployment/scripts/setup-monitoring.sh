#!/bin/bash
# Setup monitoring cron job for n8n

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Setting up n8n monitoring...${NC}"

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HEALTH_CHECK_SCRIPT="$SCRIPT_DIR/health-check.sh"

# Make sure health check script exists and is executable
if [ ! -f "$HEALTH_CHECK_SCRIPT" ]; then
    echo -e "${RED}Error: health-check.sh not found at $HEALTH_CHECK_SCRIPT${NC}"
    exit 1
fi

chmod +x "$HEALTH_CHECK_SCRIPT"

# Create log file and directory
sudo mkdir -p /var/log
sudo touch /var/log/n8n-health-check.log
sudo chown $(whoami):$(whoami) /var/log/n8n-health-check.log

echo "Health check script: $HEALTH_CHECK_SCRIPT"
echo ""

# Check if cron job already exists
if crontab -l 2>/dev/null | grep -q "health-check.sh"; then
    echo -e "${YELLOW}Monitoring cron job already exists${NC}"
    echo "Current cron jobs:"
    crontab -l | grep health-check.sh
    echo ""
    read -p "Do you want to update it? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Setup cancelled"
        exit 0
    fi
    # Remove existing cron job
    crontab -l | grep -v "health-check.sh" | crontab -
fi

# Ask for monitoring interval
echo "How often should n8n be monitored?"
echo "1) Every 1 minute"
echo "2) Every 5 minutes (recommended)"
echo "3) Every 15 minutes"
echo "4) Every 30 minutes"
read -p "Enter choice (1-4): " choice

case $choice in
    1)
        CRON_SCHEDULE="* * * * *"
        INTERVAL="1 minute"
        ;;
    2)
        CRON_SCHEDULE="*/5 * * * *"
        INTERVAL="5 minutes"
        ;;
    3)
        CRON_SCHEDULE="*/15 * * * *"
        INTERVAL="15 minutes"
        ;;
    4)
        CRON_SCHEDULE="*/30 * * * *"
        INTERVAL="30 minutes"
        ;;
    *)
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac

# Add cron job
echo "Adding cron job to run health check every $INTERVAL..."
(crontab -l 2>/dev/null; echo "$CRON_SCHEDULE $HEALTH_CHECK_SCRIPT >> /var/log/n8n-health-check.log 2>&1") | crontab -

echo ""
echo -e "${GREEN}Monitoring setup complete!${NC}"
echo ""
echo "Configuration:"
echo "  Health check script: $HEALTH_CHECK_SCRIPT"
echo "  Check interval: every $INTERVAL"
echo "  Log file: /var/log/n8n-health-check.log"
echo ""
echo "Useful commands:"
echo "  crontab -l                           - View cron jobs"
echo "  crontab -e                           - Edit cron jobs"
echo "  tail -f /var/log/n8n-health-check.log  - Watch logs"
echo "  $HEALTH_CHECK_SCRIPT                 - Run health check manually"
echo ""
echo "To remove monitoring:"
echo "  crontab -e  # then delete the line containing health-check.sh"
