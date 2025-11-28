#!/bin/bash
set -e

# n8n Restore Script
# Restores n8n from a backup created by backup-n8n.sh

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}n8n Restore Script${NC}"
echo -e "${GREEN}================================${NC}"

# Configuration
BACKUP_DIR="$HOME/n8n-backups"
N8N_DIR="$HOME/n8n"
N8N_CONTAINER="n8n-n8n-1"

# Check if backups exist
if [ ! -d "$BACKUP_DIR" ] || [ -z "$(ls -A $BACKUP_DIR)" ]; then
    echo -e "${RED}Error: No backups found in ${BACKUP_DIR}${NC}"
    exit 1
fi

# List available backups
echo -e "${YELLOW}Available backups:${NC}"
echo ""
BACKUPS=($(ls -t "$BACKUP_DIR"))
INDEX=1
for backup in "${BACKUPS[@]}"; do
    BACKUP_DATE=$(echo $backup | grep -oP '\d{4}-\d{2}-\d{2}-\d{6}' || echo "Unknown date")
    BACKUP_SIZE=$(du -sh "$BACKUP_DIR/$backup" 2>/dev/null | cut -f1)
    echo "$INDEX) $backup (Size: $BACKUP_SIZE, Date: $BACKUP_DATE)"
    INDEX=$((INDEX + 1))
done
echo ""

# Select backup
read -p "Enter the number of the backup to restore (or 'q' to quit): " SELECTION

if [ "$SELECTION" = "q" ]; then
    echo -e "${YELLOW}Restore cancelled.${NC}"
    exit 0
fi

# Validate selection
if ! [[ "$SELECTION" =~ ^[0-9]+$ ]] || [ "$SELECTION" -lt 1 ] || [ "$SELECTION" -gt ${#BACKUPS[@]} ]; then
    echo -e "${RED}Invalid selection.${NC}"
    exit 1
fi

SELECTED_BACKUP="${BACKUPS[$((SELECTION - 1))]}"
BACKUP_PATH="${BACKUP_DIR}/${SELECTED_BACKUP}"

echo -e "${GREEN}Selected backup: ${SELECTED_BACKUP}${NC}"
echo ""

# Show backup info
if [ -f "$BACKUP_PATH/BACKUP-INFO.txt" ]; then
    echo -e "${BLUE}Backup Information:${NC}"
    cat "$BACKUP_PATH/BACKUP-INFO.txt"
    echo ""
fi

# Confirm restore
echo -e "${RED}WARNING: This will replace your current n8n installation with the backup!${NC}"
echo -e "${YELLOW}All current data, workflows, and credentials will be replaced.${NC}"
read -p "Are you sure you want to continue? (yes/no): " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
    echo -e "${YELLOW}Restore cancelled.${NC}"
    exit 0
fi

# Change to n8n directory
cd "${N8N_DIR}"

# Step 1: Stop n8n
echo -e "${YELLOW}Stopping n8n container...${NC}"
docker-compose stop n8n
echo -e "${GREEN}✓ n8n container stopped${NC}"

# Step 2: Restore docker-compose.yml
echo -e "${YELLOW}Restoring docker-compose.yml...${NC}"
if [ -f "$BACKUP_PATH/docker-compose.yml.backup" ]; then
    cp "$BACKUP_PATH/docker-compose.yml.backup" "${N8N_DIR}/docker-compose.yml"
    echo -e "${GREEN}✓ docker-compose.yml restored${NC}"
else
    echo -e "${YELLOW}Warning: docker-compose.yml not found in backup${NC}"
fi

# Step 3: Restore Caddyfile
echo -e "${YELLOW}Restoring Caddyfile...${NC}"
if [ -f "$BACKUP_PATH/Caddyfile.backup" ]; then
    cp "$BACKUP_PATH/Caddyfile.backup" "${N8N_DIR}/Caddyfile"
    echo -e "${GREEN}✓ Caddyfile restored${NC}"
else
    echo -e "${YELLOW}Warning: Caddyfile not found in backup${NC}"
fi

# Step 4: Restore n8n data volume
echo -e "${YELLOW}Restoring n8n data volume...${NC}"
DATA_ARCHIVE=$(ls "$BACKUP_PATH"/n8n-data-*.tar.gz 2>/dev/null | head -1)
if [ -f "$DATA_ARCHIVE" ]; then
    # Remove existing volume data and restore from backup
    docker run --rm \
        -v n8n_n8n_data:/target \
        -v "$BACKUP_PATH":/backup \
        alpine \
        sh -c "rm -rf /target/* /target/..?* /target/.[!.]* 2>/dev/null || true; tar xzf /backup/$(basename $DATA_ARCHIVE) -C /target"
    echo -e "${GREEN}✓ Data volume restored${NC}"
else
    echo -e "${RED}Error: Data archive not found in backup!${NC}"
    exit 1
fi

# Step 5: Pull the correct Docker image version
echo -e "${YELLOW}Checking Docker image version...${NC}"
if [ -f "$BACKUP_PATH/image-info.txt" ]; then
    IMAGE_VERSION=$(cat "$BACKUP_PATH/image-info.txt" | grep -oP 'n8nio/n8n:\K[0-9.]+' | head -1)
    if [ ! -z "$IMAGE_VERSION" ]; then
        echo -e "${YELLOW}Pulling n8n version ${IMAGE_VERSION}...${NC}"
        docker pull n8nio/n8n:${IMAGE_VERSION}
        echo -e "${GREEN}✓ Docker image pulled${NC}"
    fi
fi

# Step 6: Start n8n
echo -e "${YELLOW}Starting n8n...${NC}"
docker-compose up -d n8n
echo -e "${GREEN}✓ n8n container started${NC}"

# Step 7: Wait for n8n to be ready
echo -e "${YELLOW}Waiting for n8n to start...${NC}"
sleep 10

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
    exit 1
fi

# Step 8: Verify restoration
echo -e "${YELLOW}Verifying restoration...${NC}"
sleep 5
RESTORED_VERSION=$(docker exec ${N8N_CONTAINER} n8n --version 2>&1 | grep -oP '\d+\.\d+\.\d+' || echo "Unable to detect")
echo -e "${BLUE}Restored version: ${RESTORED_VERSION}${NC}"

# Final summary
echo ""
echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}Restore Completed Successfully!${NC}"
echo -e "${GREEN}================================${NC}"
echo -e "Restored from: ${SELECTED_BACKUP}"
echo -e "n8n version: ${RESTORED_VERSION}"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo "1. Visit https://n8n.terryglennon.org to verify everything works"
echo "2. Check your workflows are present and working"
echo "3. Verify credentials are intact"
echo ""
echo -e "${GREEN}Your n8n instance has been restored from backup!${NC}"
