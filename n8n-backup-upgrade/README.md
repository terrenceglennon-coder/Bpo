# n8n Backup and Upgrade Scripts

Comprehensive scripts to backup and upgrade your n8n instance running on GCP.

## Current Setup

- **n8n URL**: https://n8n.terryglennon.org
- **Current Version**: 1.118.2
- **Target Version**: 1.121.3 (latest stable as of Nov 28, 2025)
- **Deployment**: Docker Compose with Caddy reverse proxy
- **Server**: GCP VM (n8n-vm-01, us-central1-c)

## Version Gap

You are currently **3 versions behind**:
- Current: 1.118.2
- Available: 1.119.x, 1.120.x, 1.121.x
- Latest Stable: 1.121.3

## Quick Start

### 1. Transfer Scripts to Server

On your local machine:
```bash
# Clone or download these scripts
git clone <repository-url>
cd n8n-backup-upgrade

# Copy to server
gcloud compute scp --recurse . n8n-vm-01:~/n8n-scripts \
  --project=root-cortex-473004-r3 \
  --zone=us-central1-c
```

### 2. SSH to Server

```bash
gcloud compute ssh n8n-vm-01 \
  --project=root-cortex-473004-r3 \
  --zone=us-central1-c
```

### 3. Make Scripts Executable

```bash
cd ~/n8n-scripts
chmod +x backup-n8n.sh upgrade-n8n.sh restore-n8n.sh
```

### 4. Run Backup

```bash
./backup-n8n.sh
```

This creates a timestamped backup in `~/n8n-backups/` containing:
- All workflows (exported JSON)
- All credentials (encrypted export)
- Complete n8n data volume (database, settings, etc.)
- Docker Compose configuration
- Caddyfile configuration
- Container and image information

### 5. Run Upgrade

```bash
./upgrade-n8n.sh
```

The script will:
- Verify backup exists
- Pull new n8n Docker image (1.121.3)
- Update docker-compose.yml
- Stop current container
- Start new version
- Verify upgrade success
- Run health checks

**Optional**: Specify a different version:
```bash
./upgrade-n8n.sh 1.120.0  # Upgrade to specific version
```

### 6. Verify Upgrade

1. Visit https://n8n.terryglennon.org
2. Check that all workflows are present
3. Test a few workflows to ensure they execute correctly
4. Verify credentials are intact

## If Something Goes Wrong

### Restore from Backup

If the upgrade fails or you encounter issues:

```bash
./restore-n8n.sh
```

This will:
- List all available backups
- Allow you to select which backup to restore
- Stop n8n
- Restore all data and configurations
- Start n8n with the restored version

### Check Logs

```bash
cd ~/n8n
docker-compose logs -f n8n
```

### Manual Rollback

If needed, manually rollback:

```bash
cd ~/n8n
docker-compose stop n8n
# Edit docker-compose.yml and change version back to 1.118.2
nano docker-compose.yml
docker-compose up -d n8n
```

## What Gets Backed Up

Each backup includes:

1. **Workflows**: `workflows-export-<timestamp>.json`
   - All workflow definitions
   - Exported using n8n CLI

2. **Credentials**: `credentials-export-<timestamp>.json`
   - All credentials (encrypted)
   - Exported using n8n CLI

3. **Data Volume**: `n8n-data-<timestamp>.tar.gz`
   - SQLite database
   - All workflow execution history
   - User settings
   - Encryption keys

4. **Configuration**:
   - `docker-compose.yml.backup`
   - `Caddyfile.backup`

5. **Metadata**:
   - `container-info.json` (container inspection)
   - `image-info.txt` (Docker image details)
   - `BACKUP-INFO.txt` (backup summary)

## Upgrade Process Details

The upgrade script performs these steps:

1. **Pre-flight Checks**
   - Verify backup exists
   - Show current and target versions
   - Request confirmation

2. **Pull New Image**
   - Download n8n:1.121.3 from Docker Hub

3. **Update Configuration**
   - Modify docker-compose.yml with new version
   - Keep backup of old config

4. **Stop Current Container**
   - Gracefully stop n8n

5. **Start New Version**
   - Start container with new image
   - Wait for container to be ready

6. **Verification**
   - Check container is running
   - Verify version number
   - Check logs for errors
   - Test health endpoint

## Important Notes

### Database Migration

n8n automatically handles database migrations between versions. The upgrade process will:
- Detect the current database schema
- Apply necessary migrations
- Update to new schema version

This happens automatically when the new version starts.

### Downtime

Expect **1-2 minutes** of downtime during the upgrade:
- ~10 seconds to stop the container
- ~30 seconds to pull the new image (if not cached)
- ~30-60 seconds for n8n to start and run migrations

### Reverting

If you need to revert to the old version:
1. Use the `restore-n8n.sh` script (recommended)
2. Or manually edit docker-compose.yml to use version 1.118.2

### Security

- Credentials are exported in encrypted format
- The encryption key is stored in the n8n data volume
- Keep backups secure and private

## Troubleshooting

### Container Won't Start

```bash
# Check logs
docker-compose logs n8n

# Check if volume is corrupted
docker volume inspect n8n_n8n_data

# Restore from backup
./restore-n8n.sh
```

### Database Migration Errors

If you see migration errors in logs:
```bash
# Check logs for specific error
docker-compose logs n8n | grep -i migration

# Restore from backup and try upgrading one version at a time
./restore-n8n.sh
./upgrade-n8n.sh 1.119.0
# Then upgrade to 1.120.0, then 1.121.3
```

### Workflows Not Loading

```bash
# Import workflows manually from backup
cd ~/n8n-backups/<latest-backup>/
docker cp workflows-export-*.json n8n-n8n-1:/tmp/
docker exec -it n8n-n8n-1 n8n import:workflow --input=/tmp/workflows-export-*.json
```

## Maintenance

### Regular Backups

Consider setting up a cron job for automated backups:

```bash
# Edit crontab
crontab -e

# Add daily backup at 3 AM
0 3 * * * /home/terrenceglennon/n8n-scripts/backup-n8n.sh
```

### Cleanup Old Backups

```bash
# Keep only last 7 backups
cd ~/n8n-backups
ls -t | tail -n +8 | xargs rm -rf
```

## Support

- **n8n Documentation**: https://docs.n8n.io
- **n8n Community**: https://community.n8n.io
- **n8n GitHub**: https://github.com/n8n-io/n8n

## License

These scripts are provided as-is for managing your n8n installation.
