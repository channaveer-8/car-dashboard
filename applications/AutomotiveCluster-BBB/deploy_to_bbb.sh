#!/bin/bash
# Helper script to deploy and run the Automotive Cluster GUI on the BeagleBone Black

TARGET_IP="192.168.7.2"
TARGET_USER="debian"
APP_NAME="appAutomotiveCluster"
HOST_BINARY_PATH="/home/channaveeragouda/bbb-dev/applications/AutomotiveCluster-BBB/build-qt6.11/appAutomotiveCluster"
QT_INSTALL_PATH="/home/channaveeragouda/bbb-dev/qt/install"

echo "=== BeagleBone Black Deployment Script ==="

# 1. Check if the compiled binary exists
if [ ! -f "$HOST_BINARY_PATH" ]; then
    echo "ERROR: Compiled ARM binary not found at $HOST_BINARY_PATH"
    echo "Please build the project for the 'BeagleBone Black Qt 6.11.1' kit in Qt Creator first."
    exit 1
fi

# 2. Check if the BBB is reachable
echo "Checking connection to BeagleBone Black ($TARGET_IP)..."
if ! ping -c 2 -W 2 "$TARGET_IP" > /dev/null; then
    echo "WARNING: BeagleBone Black ($TARGET_IP) is not reachable."
    echo "Please verify that:"
    echo "  1. The BeagleBone Black is connected to your host PC via USB."
    echo "  2. It has booted fully (LEDs heartbeat flashing, wait 30-60s)."
    echo "  3. The virtual network interface is active (check with 'ip addr')."
    echo "  4. The IP address of the board is indeed $TARGET_IP (or try 192.168.6.2)."
    echo ""
    echo "Would you like to skip the connection check and try deploying anyway? (y/N)"
    read -r response
    if [[ ! "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        exit 1
    fi
fi

# 3. Copy the compiled ARM binary to the BBB
echo "Deploying binary to BeagleBone Black..."
if scp "$HOST_BINARY_PATH" "${TARGET_USER}@${TARGET_IP}:/home/${TARGET_USER}/"; then
    echo "Binary successfully copied to /home/${TARGET_USER}/${APP_NAME}"
else
    echo "ERROR: Failed to copy binary to the target board. Check connection/credentials."
    exit 1
fi

# 4. Make it executable
echo "Setting executable permissions..."
ssh "${TARGET_USER}@${TARGET_IP}" "chmod +x /home/${TARGET_USER}/${APP_NAME}"

# 5. Check if Qt 6.11.1 runtime is deployed on the board
echo "Checking Qt 6.11.1 runtime libraries on the board..."
if ! ssh "${TARGET_USER}@${TARGET_IP}" "[ -d /home/${TARGET_USER}/qt6.11 ]"; then
    echo "Qt 6.11.1 runtime libraries not found in /home/${TARGET_USER}/qt6.11 on the board."
    echo "Do you want to deploy the Qt 6.11.1 runtime libraries now? This will copy around 80MB of files. (y/N)"
    read -r deploy_qt
    if [[ "$deploy_qt" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        echo "Copying Qt 6.11.1 libraries to the board (this may take a minute)..."
        if scp -r "$QT_INSTALL_PATH" "${TARGET_USER}@${TARGET_IP}:/home/${TARGET_USER}/qt6.11"; then
            echo "Qt libraries deployed successfully."
        else
            echo "ERROR: Failed to deploy Qt libraries."
            exit 1
        fi
    else
        echo "Skipping Qt library deployment. Make sure they are installed in /home/${TARGET_USER}/qt6.11."
    fi
fi

# 6. Run instructions
echo "=========================================================="
echo "Deployment Complete!"
echo "To run the GUI on the BeagleBone Black over VNC:"
echo ""
echo "1. Run this command on the board (via SSH):"
echo "   LD_LIBRARY_PATH=/home/debian/qt6.11/lib \\"
echo "   QT_PLUGIN_PATH=/home/debian/qt6.11/plugins \\"
echo "   QML2_IMPORT_PATH=/home/debian/qt6.11/qml \\"
echo "   /home/debian/appAutomotiveCluster -platform vnc:size=1024x600:draw-rate=15"
echo ""
echo "2. On your Host PC, open Remmina (or any VNC client) and connect to:"
echo "   Address: 192.168.7.2"
echo "   Port:    5900"
echo "=========================================================="
