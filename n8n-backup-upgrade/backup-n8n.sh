#!/bin/bash
set -e

# n8n Backup Script
# This script creates a complete backup of your n8n installation
# Current version: 1.118.2 -> Upgrading to: 1.121.3 (latest stable)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}n8n Backup Script${NC}"
echo -e "${GREEN}================================${NC}"

# Configuration
BACKUP_DIR="$HOME/n8n-backups"
TIMESTAMP=$(date +%Y-%m-%d-%H%M%S)
BACKUP_NAME="n8n-backup-${TIMESTAMP}"
N8N_DIR="$HOME/n8n"
N8N_CONTAINER="n8n-n8n-1"

# Create backup directory
echo -e "${YELLOW}Creating backup directory...${NC}"
mkdir -p "${BACKUP_DIR}/${BACKUP_NAME}"

# Check if n8n is running
if ! docker ps | grep -q "${N8N_CONTAINER}"; then
    echo -e "${RED}Error: n8n container is not running!${NC}"
    exit 1
fi

echo -e "${GREEN}✓ n8n container is running${NC}"

# Backup 1: Export workflows using n8n CLI
echo -e "${YELLOW}Exporting workflows via n8n CLI...${NC}"
docker exec ${N8N_CONTAINER} n8n export:workflow --all --output=/tmp/workflows-export.json
docker cp ${N8N_CONTAINER}:/tmp/workflows-export.json "${BACKUP_DIR}/${BACKUP_NAME}/workflows-export-${TIMESTAMP}.json"
echo -e "${GREEN}✓ Workflows exported${NC}"

# Backup 2: Export credentials (encrypted)
echo -e "${YELLOW}Exporting credentials...${NC}"
docker exec ${N8N_CONTAINER} n8n export:credentials --all --output=/tmp/credentials-export.json
docker cp ${N8N_CONTAINER}:/tmp/credentials-export.json "${BACKUP_DIR}/${BACKUP_NAME}/credentials-export-${TIMESTAMP}.json"
echo -e "${GREEN}✓ Credentials exported${NC}"

# Backup 3: Backup the entire n8n data volume
echo -e "${YELLOW}Backing up n8n data volume...${NC}"
docker run --rm \
    -v n8n_n8n_data:/source:ro \
    -v "${BACKUP_DIR}/${BACKUP_NAME}":/backup \
    alpine \
    tar czf /backup/n8n-data-${TIMESTAMP}.tar.gz -C /source .
echo -e "${GREEN}✓ Data volume backed up${NC}"

# Backup 4: Copy docker-compose.yml and configuration files
echo -e "${YELLOW}Backing up configuration files...${NC}"
cp "${N8N_DIR}/docker-compose.yml" "${BACKUP_DIR}/${BACKUP_NAME}/docker-compose.yml.backup"
cp "${N8N_DIR}/Caddyfile" "${BACKUP_DIR}/${BACKUP_NAME}/Caddyfile.backup"
echo -e "${GREEN}✓ Configuration files backed up${NC}"

# Backup 5: Save current Docker image info
echo -e "${YELLOW}Saving Docker image information...${NC}"
docker inspect ${N8N_CONTAINER} > "${BACKUP_DIR}/${BACKUP_NAME}/container-info.json"
docker images n8nio/n8n --format "{{.Repository}}:{{.Tag}} ({{.ID}})" > "${BACKUP_DIR}/${BACKUP_NAME}/image-info.txt"
echo -e "${GREEN}✓ Docker image info saved${NC}"

# Create backup summary
echo -e "${YELLOW}Creating backup summary...${NC}"
cat > "${BACKUP_DIR}/${BACKUP_NAME}/BACKUP-INFO.txt" << EOF
n8n Backup Information
======================
Backup Date: $(date)
Backup Name: ${BACKUP_NAME}
n8n Version: $(docker exec ${N8N_CONTAINER} n8n --version 2>&1 || echo "1.118.2")
Container: ${N8N_CONTAINER}
Data Volume: n8n_n8n_data

Backup Contents:
- workflows-export-${TIMESTAMP}.json (All workflows)
- credentials-export-${TIMESTAMP}.json (All credentials - encrypted)
- n8n-data-${TIMESTAMP}.tar.gz (Complete data volume)
- docker-compose.yml.backup (Docker Compose configuration)
- Caddyfile.backup (Caddy reverse proxy config)
- container-info.json (Container inspection data)
- image-info.txt (Docker image details)

To restore from this backup, use the restore-n8n.sh script.
EOF

echo -e "${GREEN}✓ Backup summary created${NC}"

# Calculate backup size
BACKUP_SIZE=$(du -sh "${BACKUP_DIR}/${BACKUP_NAME}" | cut -f1)

# Final summary
echo ""
echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}Backup Completed Successfully!${NC}"
echo -e "${GREEN}================================${NC}"
echo -e "Backup Location: ${BACKUP_DIR}/${BACKUP_NAME}"
echo -e "Backup Size: ${BACKUP_SIZE}"
echo -e ""
echo -e "${YELLOW}Backup files created:${NC}"
ls -lh "${BACKUP_DIR}/${BACKUP_NAME}"
echo ""
echo -e "${GREEN}Your n8n data is now safely backed up!${NC}"
echo -e "${YELLOW}You can now proceed with the upgrade using ./upgrade-n8n.sh${NC}"
