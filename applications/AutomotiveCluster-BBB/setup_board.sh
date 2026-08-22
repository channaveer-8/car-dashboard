#!/bin/bash
# Exit immediately if a command exits with a non-zero status
set -e

echo "=== Running BeagleBone Black Setup Script ==="

# 1. Ensure permissions are correct
chmod +x /home/debian/appAutomotiveCluster
chmod +x /home/debian/bt_gateway.py

# 2. Register systemd service configurations
mv -f /tmp/bt-serial-gateway.service /tmp/automotive-dashboard.service /etc/systemd/system/
systemctl daemon-reload

# 3. Enable and restart both services
systemctl enable automotive-dashboard.service
systemctl enable bt-serial-gateway.service

systemctl restart automotive-dashboard.service
systemctl restart bt-serial-gateway.service

echo "=== Verification ==="
echo "Unix Socket file:"
ls -la /home/debian/dashboard.sock || echo "Socket NOT found!"

echo "GUI Service Status:"
systemctl status automotive-dashboard.service -n 5 --no-pager

echo "Gateway Service Status:"
systemctl status bt-serial-gateway.service -n 5 --no-pager
