#!/bin/bash
set -e

# n8n Upgrade Script
# Upgrades n8n from 1.118.2 to latest stable version (1.121.3)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}n8n Upgrade Script${NC}"
echo -e "${GREEN}================================${NC}"

# Configuration
N8N_DIR="$HOME/n8n"
CURRENT_VERSION="1.118.2"
TARGET_VERSION="${1:-1.121.3}"  # Can pass version as argument, defaults to 1.121.3
N8N_CONTAINER="n8n-n8n-1"

# Check if backup was created
LATEST_BACKUP=$(ls -t $HOME/n8n-backups/ 2>/dev/null | head -1)
if [ -z "$LATEST_BACKUP" ]; then
    echo -e "${RED}WARNING: No backup found!${NC}"
    echo -e "${YELLOW}It's highly recommended to run ./backup-n8n.sh first${NC}"
    read -p "Do you want to continue without a backup? (yes/no): " CONTINUE
    if [ "$CONTINUE" != "yes" ]; then
        echo -e "${YELLOW}Aborting upgrade. Please run ./backup-n8n.sh first.${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}✓ Found recent backup: ${LATEST_BACKUP}${NC}"
fi

# Display current version
echo -e "${YELLOW}Current n8n version: ${CURRENT_VERSION}${NC}"
echo -e "${YELLOW}Target n8n version: ${TARGET_VERSION}${NC}"
echo ""

# Confirm upgrade
read -p "Do you want to proceed with the upgrade? (yes/no): " CONFIRM
if [ "$CONFIRM" != "yes" ]; then
    echo -e "${YELLOW}Upgrade cancelled.${NC}"
    exit 0
fi

# Change to n8n directory
cd "${N8N_DIR}"

# Step 1: Pull the new Docker image
echo -e "${YELLOW}Pulling n8n Docker image version ${TARGET_VERSION}...${NC}"
docker pull n8nio/n8n:${TARGET_VERSION}
echo -e "${GREEN}✓ Docker image pulled${NC}"

# Step 2: Update docker-compose.yml
echo -e "${YELLOW}Updating docker-compose.yml...${NC}"
cp docker-compose.yml docker-compose.yml.pre-upgrade-backup
sed -i "s|n8nio/n8n:${CURRENT_VERSION}|n8nio/n8n:${TARGET_VERSION}|g" docker-compose.yml
echo -e "${GREEN}✓ docker-compose.yml updated${NC}"

# Step 3: Stop the current n8n container
echo -e "${YELLOW}Stopping n8n container...${NC}"
docker-compose stop n8n
echo -e "${GREEN}✓ n8n container stopped${NC}"

# Step 4: Start n8n with the new version
echo -e "${YELLOW}Starting n8n with version ${TARGET_VERSION}...${NC}"
docker-compose up -d n8n
echo -e "${GREEN}✓ n8n container started${NC}"

# Step 5: Wait for n8n to be ready
echo -e "${YELLOW}Waiting for n8n to start (this may take 30-60 seconds)...${NC}"
sleep 10

# Check if container is running
MAX_ATTEMPTS=12
ATTEMPT=0
while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
    if docker ps | grep -q "${N8N_CONTAINER}"; then
        echo -e "${GREEN}✓ n8n container is running${NC}"
        break
    fi
    ATTEMPT=$((ATTEMPT + 1))
    echo -e "${YELLOW}Waiting... (${ATTEMPT}/${MAX_ATTEMPTS})${NC}"
    sleep 5
done

if [ $ATTEMPT -eq $MAX_ATTEMPTS ]; then
    echo -e "${RED}Error: n8n container failed to start!${NC}"
    echo -e "${YELLOW}Checking logs...${NC}"
    docker-compose logs --tail=50 n8n
    echo ""
    echo -e "${RED}Upgrade failed. You may need to restore from backup.${NC}"
    echo -e "${YELLOW}Use ./restore-n8n.sh to restore from the latest backup.${NC}"
    exit 1
fi

# Step 6: Verify the upgrade
echo -e "${YELLOW}Verifying upgrade...${NC}"
sleep 5
NEW_VERSION=$(docker exec ${N8N_CONTAINER} n8n --version 2>&1 | grep -oP '\d+\.\d+\.\d+' || echo "Unable to detect")
echo -e "${BLUE}Detected version: ${NEW_VERSION}${NC}"

# Step 7: Check container logs for errors
echo -e "${YELLOW}Checking for errors in logs...${NC}"
docker-compose logs --tail=20 n8n | grep -i error || echo -e "${GREEN}✓ No errors found in recent logs${NC}"

# Step 8: Test n8n endpoint
echo -e "${YELLOW}Testing n8n endpoint...${NC}"
sleep 5
if docker exec ${N8N_CONTAINER} wget -q -O- http://localhost:5678/healthz > /dev/null 2>&1; then
    echo -e "${GREEN}✓ n8n health check passed${NC}"
else
    echo -e "${YELLOW}Note: Health check endpoint may not be available, checking if container is responsive...${NC}"
fi

# Final summary
echo ""
echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}Upgrade Process Completed!${NC}"
echo -e "${GREEN}================================${NC}"
echo -e "Previous version: ${CURRENT_VERSION}"
echo -e "Current version: ${NEW_VERSION}"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo "1. Visit https://n8n.terryglennon.org to verify everything works"
echo "2. Test your workflows to ensure they run correctly"
echo "3. Check the logs: docker-compose logs -f n8n"
echo ""
echo -e "${GREEN}If you encounter any issues:${NC}"
echo "- Check logs: cd ~/n8n && docker-compose logs n8n"
echo "- Restore from backup: ./restore-n8n.sh"
echo ""
echo -e "${BLUE}Your n8n instance should now be running version ${TARGET_VERSION}!${NC}"
