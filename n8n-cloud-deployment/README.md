# n8n Cloud Deployment on GCP

This directory contains scripts and documentation for managing your n8n instance running on Google Cloud Platform.

## Quick Reference

- **n8n URL:** https://n8n.terryglennon.org
- **VM Instance:** n8n-vm-01
- **Zone:** us-central1-c
- **Project:** root-cortex-473004-r3

## Emergency: n8n is Down

If your n8n instance has stopped, SSH into your VM and run:

```bash
# Quick check
./check-status.sh

# Quick restart
./restart-n8n.sh
```

For detailed troubleshooting, see [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

## Contents

- **scripts/** - Management scripts for n8n
  - `start-n8n.sh` - Start n8n with PM2
  - `restart-n8n.sh` - Restart n8n (auto-detects PM2/systemd/Docker)
  - `stop-n8n.sh` - Stop n8n
  - `check-status.sh` - Check n8n health and status
  - `health-check.sh` - Automated health check with auto-restart
  - `setup-systemd.sh` - Setup n8n as systemd service
  - `setup-monitoring.sh` - Setup automated monitoring via cron
- **n8n.service** - Systemd service file template
- **TROUBLESHOOTING.md** - Detailed troubleshooting guide

## Setup Instructions

### Option 1: PM2 (Recommended for Development)

PM2 is a process manager that automatically restarts your app if it crashes.

```bash
# 1. SSH into your VM
gcloud compute ssh n8n-vm-01 --zone=us-central1-c --project=root-cortex-473004-r3

# 2. Clone or download these scripts
# Copy the scripts to your VM

# 3. Make scripts executable
chmod +x scripts/*.sh

# 4. Start n8n with PM2
./scripts/start-n8n.sh

# 5. Verify it's running
./scripts/check-status.sh
```

### Option 2: Systemd Service (Recommended for Production)

Systemd ensures n8n starts automatically on system boot and restarts on crashes.

```bash
# 1. SSH into your VM
gcloud compute ssh n8n-vm-01 --zone=us-central1-c --project=root-cortex-473004-r3

# 2. Run the setup script
./scripts/setup-systemd.sh

# 3. Verify service is running
sudo systemctl status n8n

# 4. Check if n8n is accessible
./scripts/check-status.sh
```

### Option 3: Automated Monitoring

Setup a cron job to automatically check n8n health and restart if needed.

```bash
# 1. SSH into your VM
gcloud compute ssh n8n-vm-01 --zone=us-central1-c --project=root-cortex-473004-r3

# 2. Run the monitoring setup
./scripts/setup-monitoring.sh

# 3. Choose check interval (recommended: every 5 minutes)

# 4. Monitor the logs
tail -f /var/log/n8n-health-check.log
```

## Common Tasks

### Check if n8n is Running

```bash
./scripts/check-status.sh
```

### Restart n8n

```bash
./scripts/restart-n8n.sh
```

### Start n8n

```bash
./scripts/start-n8n.sh
```

### Stop n8n

```bash
./scripts/stop-n8n.sh
```

### View Logs

**PM2:**
```bash
pm2 logs n8n
pm2 logs n8n --lines 100
```

**Systemd:**
```bash
sudo journalctl -u n8n -f
sudo journalctl -u n8n -n 100 --no-pager
```

**Docker:**
```bash
docker logs n8n --tail 100 -f
```

### Check System Resources

```bash
# Memory usage
free -h

# Disk space
df -h

# CPU and load
top
# or
htop
```

## Accessing Your n8n Instance

### Web Interface
Open in browser: https://n8n.terryglennon.org

### SSH Access

**Via Google Cloud Console:**
1. Go to: https://console.cloud.google.com/compute/instances
2. Find: n8n-vm-01
3. Click: SSH button

**Via gcloud CLI:**
```bash
gcloud compute ssh n8n-vm-01 --zone=us-central1-c --project=root-cortex-473004-r3
```

**Via standard SSH (if configured):**
```bash
ssh your-username@n8n.terryglennon.org
```

## Firewall Configuration

Your VM has the following firewall rules configured:

- Port 22 (SSH): Open from all IPs
- Port 80 (HTTP): Open from all IPs
- Port 443 (HTTPS): Open from all IPs
- Port 5678 (n8n): Open from all IPs

These are configured in Google Cloud Console under VPC Network > Firewall.

## Environment Variables

Key environment variables for n8n (set in service files/scripts):

```bash
N8N_HOST=0.0.0.0
N8N_PORT=5678
N8N_PROTOCOL=https
WEBHOOK_URL=https://n8n.terryglennon.org
N8N_EDITOR_BASE_URL=https://n8n.terryglennon.org
GENERIC_TIMEZONE=America/New_York
```

## Troubleshooting

If n8n is not working, see the detailed [TROUBLESHOOTING.md](TROUBLESHOOTING.md) guide.

Common issues:
- Out of memory → Increase VM memory or add swap
- Disk full → Clean up logs and old files
- Port already in use → Kill existing process
- SSL/HTTPS issues → Check reverse proxy (nginx/caddy)

## Security Best Practices

1. **Keep n8n updated:**
   ```bash
   npm update -g n8n
   ```

2. **Use strong passwords** for n8n admin account

3. **Enable SSL/HTTPS** (already configured at n8n.terryglennon.org)

4. **Regular backups:**
   ```bash
   # Backup n8n data directory
   tar -czf n8n-backup-$(date +%Y%m%d).tar.gz ~/.n8n/
   ```

5. **Monitor logs regularly:**
   ```bash
   tail -f /var/log/n8n-health-check.log
   ```

6. **Keep VM updated:**
   ```bash
   sudo apt update && sudo apt upgrade -y
   ```

## Additional Resources

- [n8n Documentation](https://docs.n8n.io/)
- [n8n Community Forum](https://community.n8n.io/)
- [Google Cloud Documentation](https://cloud.google.com/docs)

## Support

For issues specific to this setup:
1. Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
2. Review logs using commands above
3. Check VM resources in Google Cloud Console

For n8n-specific issues:
- Visit [n8n Documentation](https://docs.n8n.io/)
- Ask in [n8n Community](https://community.n8n.io/)
