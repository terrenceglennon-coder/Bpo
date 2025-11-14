# n8n Troubleshooting Guide for GCP VM

## Quick Fix: Restart n8n

If your n8n instance has stopped, try these steps in order via SSH console:

### 1. Check if n8n is running

```bash
# Check n8n process
ps aux | grep n8n

# If using PM2
pm2 list

# If using systemd
systemctl status n8n

# If using Docker
docker ps -a | grep n8n
```

### 2. Check VM resources

```bash
# Check memory usage
free -h

# Check disk space
df -h

# Check CPU usage
top -bn1 | head -20
```

### 3. Restart n8n

**If using PM2:**
```bash
pm2 restart n8n
# or if first time
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
# or
docker-compose -f /path/to/docker-compose.yml restart
```

**If running directly with npm/npx:**
```bash
# Find and kill the process
pkill -f n8n

# Start n8n (choose based on your setup)
npx n8n start &
# or
n8n start &
```

### 4. Check logs for errors

**PM2 logs:**
```bash
pm2 logs n8n --lines 100
```

**Systemd logs:**
```bash
journalctl -u n8n -n 100 --no-pager
```

**Docker logs:**
```bash
docker logs n8n --tail 100
```

**Direct log files (if applicable):**
```bash
tail -n 100 ~/.n8n/logs/n8n.log
```

## Common Issues

### Issue 1: Out of Memory
**Symptoms:** VM crashes, n8n stops unexpectedly
**Solution:**
```bash
# Check memory
free -h

# Increase swap space if needed
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

### Issue 2: Disk Full
**Symptoms:** n8n won't start, errors writing to disk
**Solution:**
```bash
# Find large files
sudo du -h / | sort -rh | head -20

# Clean up logs
sudo journalctl --vacuum-time=3d

# Clean up Docker (if using Docker)
docker system prune -a
```

### Issue 3: Port Already in Use
**Symptoms:** Error: "Port 5678 is already in use"
**Solution:**
```bash
# Find process using the port
sudo lsof -i :5678
sudo netstat -tlnp | grep 5678

# Kill the process
sudo kill -9 <PID>
```

### Issue 4: SSL/HTTPS Issues
**Symptoms:** HTTPS not working, SSL certificate errors
**Solution:**
```bash
# Check nginx/reverse proxy status
sudo systemctl status nginx

# Restart nginx
sudo systemctl restart nginx

# Renew Let's Encrypt certificate
sudo certbot renew
```

### Issue 5: Database Connection Issues
**Symptoms:** n8n starts but workflows don't load
**Solution:**
```bash
# Check if using PostgreSQL/MySQL
sudo systemctl status postgresql
# or
sudo systemctl status mysql

# Restart database
sudo systemctl restart postgresql
```

## Verify n8n is Working

After restarting, verify n8n is accessible:

```bash
# Check if n8n is responding locally
curl http://localhost:5678

# Check from external (replace with your domain)
curl https://n8n.terryglennon.org
```

## Access Your n8n Instance

- **URL:** https://n8n.terryglennon.org
- **VM SSH:** Use the Google Cloud Console SSH button
- **Direct SSH:** `gcloud compute ssh n8n-vm-01 --zone=us-central1-c --project=root-cortex-473004-r3`

## Emergency Commands

```bash
# Force restart VM (last resort)
sudo reboot

# Check system logs for crashes
sudo journalctl -p err -n 50

# Check kernel logs
sudo dmesg | tail -50
```

## Need More Help?

If these steps don't resolve your issue:
1. Check the logs using the commands above
2. Note any error messages
3. Check the VM's monitoring dashboard in Google Cloud Console
4. Consider increasing VM resources if running out of memory/CPU
