# Quick Start Guide - n8n Backup & Upgrade

## 30-Second Overview

You're upgrading n8n from **1.118.2** → **1.121.3** (3 versions)

## Step-by-Step Commands

### On Your Local Machine

```bash
# 1. Copy scripts to server
gcloud compute scp --recurse n8n-backup-upgrade n8n-vm-01:~/n8n-scripts \
  --project=root-cortex-473004-r3 \
  --zone=us-central1-c

# 2. SSH to server
gcloud compute ssh n8n-vm-01 \
  --project=root-cortex-473004-r3 \
  --zone=us-central1-c
```

### On the Server

```bash
# 3. Go to scripts directory
cd ~/n8n-scripts

# 4. Make scripts executable
chmod +x *.sh

# 5. Run backup (takes ~30 seconds)
./backup-n8n.sh

# 6. Run upgrade (takes ~2 minutes)
./upgrade-n8n.sh

# 7. Verify in browser
# Visit: https://n8n.terryglennon.org
```

## If Anything Goes Wrong

```bash
# Restore from backup
./restore-n8n.sh
```

## That's It!

Total time: **~5 minutes**
- Backup: 30 seconds
- Upgrade: 2 minutes
- Verification: 1 minute

## What to Check After Upgrade

✅ Site loads at https://n8n.terryglennon.org
✅ All workflows are visible
✅ Test run a workflow
✅ Credentials are intact

## Need Help?

Check the full README.md for detailed troubleshooting.
