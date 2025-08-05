#!/bin/bash
#
# Enhanced Mail-in-a-Box Setup Script
# 
# This script installs Mail-in-a-Box with enhanced UI and advanced features
# on a fresh Ubuntu 22.04 LTS server.
#
# Usage: curl -s https://raw.githubusercontent.com/rotzmediagroup/enhanced-mailinabox/main/setup/enhanced_start.sh | sudo bash
#

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (use sudo)" 
   exit 1
fi

# Check Ubuntu version
if [ ! -f /etc/lsb-release ]; then
    echo "This script requires Ubuntu."
    exit 1
fi

source /etc/lsb-release
if [[ $DISTRIB_ID != "Ubuntu" || $DISTRIB_RELEASE != "22.04" ]]; then
    echo "Enhanced Mail-in-a-Box requires Ubuntu 22.04 LTS."
    exit 1
fi

# Welcome message
echo "=========================================="
echo "  Enhanced Mail-in-a-Box Setup"
echo "=========================================="
echo ""
echo "This will install Mail-in-a-Box with:"
echo "• All original Mail-in-a-Box features"
echo "• Modern, responsive web interface"
echo "• Enhanced user management"
echo "• Mail analytics dashboard"
echo "• Advanced system monitoring"
echo "• Mobile-optimized design"
echo ""
echo "Installation will begin in 5 seconds..."
echo "Press Ctrl+C to cancel."
sleep 5

# Create installation directory
INSTALL_DIR="/root/enhanced-mailinabox"
if [ -d "$INSTALL_DIR" ]; then
    echo "Removing existing installation directory..."
    rm -rf "$INSTALL_DIR"
fi

echo "Downloading Enhanced Mail-in-a-Box..."
cd /root
git clone https://github.com/rotzmediagroup/enhanced-mailinabox.git

if [ ! -d "$INSTALL_DIR" ]; then
    echo "Failed to download Enhanced Mail-in-a-Box"
    exit 1
fi

cd "$INSTALL_DIR"

# Run the original Mail-in-a-Box setup with our enhancements
echo ""
echo "Starting Enhanced Mail-in-a-Box installation..."
echo "This may take 30-60 minutes depending on your server speed."
echo ""

# Make sure the original start script is executable
chmod +x setup/start.sh

# Run the original setup script
./setup/start.sh

# Check if installation was successful
if [ $? -eq 0 ]; then
    echo ""
    echo "Installing SOGo Enterprise Webmail..."
    ./setup/sogo_install.sh
    
    if [ $? -eq 0 ]; then
        echo "SOGo installation completed successfully!"
    else
        echo "Warning: SOGo installation failed, but Mail-in-a-Box is functional"
    fi
    echo ""
    echo "=========================================="
    echo "  Enhanced Mail-in-a-Box Installation Complete!"
    echo "=========================================="
    echo ""
    echo "🎉 Your enterprise mail server is ready!"
    echo ""
    echo "Access URLs:"
    echo "• Control Panel: https://$(hostname)/admin"
    echo "• SOGo Webmail: https://$(hostname)/SOGo/"
    echo "• Direct Webmail: https://$(hostname)/webmail"
    echo ""
    echo "Next steps:"
    echo "1. Create your first user (this becomes the admin)"
    echo "2. Configure DNS records as instructed"
    echo "3. Access SOGo for email, calendar, and contacts"
    echo "4. Set up mobile devices with ActiveSync"
    echo ""
    echo "Enterprise features include:"
    echo "• Professional Plesk-like control panel"
    echo "• SOGo enterprise webmail with calendar/contacts"
    echo "• Visual user management with quota bars"
    echo "• Real-time system monitoring dashboard"
    echo "• Microsoft ActiveSync for mobile devices"
    echo "• CalDAV/CardDAV for desktop clients"
    echo "• Advanced search and filtering capabilities"
    echo "• Bulk user operations for administration"
    echo ""
    echo "SOGo Features:"
    echo "• Modern webmail interface"
    echo "• Integrated calendar and contacts"
    echo "• Mobile device synchronization"
    echo "• Team collaboration tools"
    echo "• IMAP-based storage (no external database)"
    echo ""
    echo "For help and documentation:"
    echo "• Enhanced features guide: https://github.com/rotzmediagroup/enhanced-mailinabox"
    echo "• Original documentation: https://mailinabox.email"
    echo ""
    echo "Thank you for choosing Enhanced Mail-in-a-Box!"
else
    echo ""
    echo "❌ Installation failed. Please check the error messages above."
    echo "For support, visit: https://github.com/rotzmediagroup/enhanced-mailinabox/issues"
    exit 1
fi

