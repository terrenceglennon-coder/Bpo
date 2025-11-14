# Quick Start: Fix n8n When It's Down

## Your n8n is down right now. Here's what to do:

### Step 1: SSH into your VM

Click this link or use the SSH button in Google Cloud Console:
https://console.cloud.google.com/compute/instances?project=root-cortex-473004-r3

Or use command line:
```bash
gcloud compute ssh n8n-vm-01 --zone=us-central1-c --project=root-cortex-473004-r3
```

### Step 2: Check what's running

```bash
# Check if n8n process exists
ps aux | grep n8n

# Check if using PM2
pm2 list

# Check if using systemd
systemctl status n8n

# Check if using Docker
docker ps -a
```

### Step 3: Restart n8n based on what you found

**If using PM2:**
```bash
pm2 restart n8n
# or if it's not in PM2 list:
pm2 start n8n
pm2 save
```

**If using systemd:**
```bash
sudo systemctl restart n8n
sudo systemctl status n8n
```

**If using Docker:**
```bash
docker restart n8n
```

**If none of the above:**
```bash
# Kill any existing process
pkill -f n8n

# Start n8n
npx n8n start &
# or
n8n start &
```

### Step 4: Verify it's working

```bash
# Check locally
curl http://localhost:5678

# Check your domain
curl https://n8n.terryglennon.org
```

Open in browser: https://n8n.terryglennon.org

## Install the Scripts for Easier Management

Once you get n8n running, download these management scripts:

```bash
# Create a directory for the scripts
mkdir -p ~/n8n-management
cd ~/n8n-management

# Download the scripts from this repository
# (You'll need to get them onto your VM - use git clone, scp, or copy/paste)

# Make them executable
chmod +x scripts/*.sh

# Use them easily
./scripts/check-status.sh   # Check if n8n is running
./scripts/restart-n8n.sh    # Restart n8n
./scripts/start-n8n.sh      # Start n8n
./scripts/stop-n8n.sh       # Stop n8n
```

## Prevent This from Happening Again

### Setup Auto-Restart (Choose ONE)

**Option A: Use PM2 (Easy)**
```bash
cd ~/n8n-management
./scripts/start-n8n.sh
```

**Option B: Use Systemd Service (Best for Production)**
```bash
cd ~/n8n-management
./scripts/setup-systemd.sh
```

**Option C: Add Monitoring (Checks every 5 minutes)**
```bash
cd ~/n8n-management
./scripts/setup-monitoring.sh
```

## Still Having Issues?

1. Check the logs:
   ```bash
   pm2 logs n8n              # If using PM2
   sudo journalctl -u n8n    # If using systemd
   ```

2. Check VM resources:
   ```bash
   free -h    # Memory
   df -h      # Disk space
   top        # CPU usage
   ```

3. See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for more help

## Common Causes

- **Out of memory** - VM ran out of RAM
- **Disk full** - No space left on disk
- **Process crashed** - Check logs for errors
- **VM restarted** - n8n wasn't set to auto-start
