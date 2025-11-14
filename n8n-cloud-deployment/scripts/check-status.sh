#!/bin/bash
# Check n8n status and health

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "======================================"
echo "n8n Status Check"
echo "======================================"
echo ""

# Check if n8n process is running
echo "1. Process Status:"
if pgrep -f n8n > /dev/null; then
    echo -e "${GREEN}✓ n8n process is running${NC}"
    echo "  PIDs: $(pgrep -f n8n | tr '\n' ' ')"
else
    echo -e "${RED}✗ n8n process is NOT running${NC}"
fi
echo ""

# Check PM2
echo "2. PM2 Status:"
if command -v pm2 &> /dev/null; then
    if pm2 list | grep -q "n8n"; then
        echo -e "${GREEN}✓ n8n is managed by PM2${NC}"
        pm2 list | grep -A1 "name"
    else
        echo -e "${YELLOW}⚠ PM2 installed but n8n not in PM2${NC}"
    fi
else
    echo -e "${YELLOW}⚠ PM2 not installed${NC}"
fi
echo ""

# Check systemd
echo "3. Systemd Status:"
if systemctl list-unit-files | grep -q "n8n.service"; then
    if systemctl is-active --quiet n8n; then
        echo -e "${GREEN}✓ n8n systemd service is active${NC}"
    else
        echo -e "${RED}✗ n8n systemd service is inactive${NC}"
    fi
    systemctl status n8n --no-pager --lines=3 2>/dev/null || true
else
    echo -e "${YELLOW}⚠ n8n systemd service not configured${NC}"
fi
echo ""

# Check Docker
echo "4. Docker Status:"
if command -v docker &> /dev/null; then
    if docker ps | grep -q "n8n"; then
        echo -e "${GREEN}✓ n8n Docker container is running${NC}"
        docker ps | grep -E "CONTAINER|n8n"
    elif docker ps -a | grep -q "n8n"; then
        echo -e "${RED}✗ n8n Docker container exists but is stopped${NC}"
        docker ps -a | grep -E "CONTAINER|n8n"
    else
        echo -e "${YELLOW}⚠ No n8n Docker container found${NC}"
    fi
else
    echo -e "${YELLOW}⚠ Docker not installed${NC}"
fi
echo ""

# Check port
echo "5. Port Status:"
if netstat -tlnp 2>/dev/null | grep -q ":5678"; then
    echo -e "${GREEN}✓ Port 5678 is listening${NC}"
    netstat -tlnp 2>/dev/null | grep ":5678" || sudo netstat -tlnp | grep ":5678"
elif ss -tlnp 2>/dev/null | grep -q ":5678"; then
    echo -e "${GREEN}✓ Port 5678 is listening${NC}"
    ss -tlnp 2>/dev/null | grep ":5678" || sudo ss -tlnp | grep ":5678"
else
    echo -e "${RED}✗ Port 5678 is NOT listening${NC}"
fi
echo ""

# Check web response
echo "6. HTTP Response:"
if curl -f -s http://localhost:5678 > /dev/null; then
    echo -e "${GREEN}✓ n8n is responding on http://localhost:5678${NC}"
else
    echo -e "${RED}✗ n8n is NOT responding on http://localhost:5678${NC}"
fi

if curl -f -s https://n8n.terryglennon.org > /dev/null; then
    echo -e "${GREEN}✓ n8n is responding on https://n8n.terryglennon.org${NC}"
else
    echo -e "${RED}✗ n8n is NOT responding on https://n8n.terryglennon.org${NC}"
fi
echo ""

# Check system resources
echo "7. System Resources:"
echo "Memory:"
free -h | grep -E "Mem|Swap"
echo ""
echo "Disk:"
df -h / | grep -E "Filesystem|/$"
echo ""
echo "CPU Load:"
uptime
echo ""

echo "======================================"
echo "End of Status Check"
echo "======================================"
