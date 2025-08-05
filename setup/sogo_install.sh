#!/bin/bash
#
# SOGo Installation Script for Enhanced Mail-in-a-Box
# 
# This script installs SOGo webmail, calendar, and contacts server
# as a replacement for Nextcloud, providing enterprise-grade
# email collaboration features.
#

set -euo pipefail

echo "=========================================="
echo "  Installing SOGo Enterprise Webmail"
echo "=========================================="

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# Variables
SOGO_VERSION="5.8.4"
SOGO_USER="sogo"
SOGO_GROUP="sogo"
SOGO_HOME="/var/lib/sogo"
SOGO_CONFIG="/etc/sogo"
NGINX_SITES="/etc/nginx/sites-available"
NGINX_ENABLED="/etc/nginx/sites-enabled"

echo "Installing SOGo dependencies..."

# Add SOGo repository
apt-get update
apt-get install -y gnupg2 wget

# Add SOGo GPG key and repository
wget -qO- https://keys.openpgp.org/vks/v1/by-fingerprint/74FFC6D72B925A34B5D356BDF8A27B36A6E2EAE9 | apt-key add -
echo "deb https://packages.sogo.nu/nightly/5/ubuntu/ jammy jammy" > /etc/apt/sources.list.d/sogo.list

# Update package list
apt-get update

echo "Installing SOGo packages..."

# Install SOGo and dependencies
apt-get install -y \
    sogo \
    sogo-common \
    sogo-activesync \
    sogo-ealarms-notify \
    sogo-tool \
    memcached \
    postgresql-client \
    nginx

echo "Creating SOGo user and directories..."

# Create SOGo user if it doesn't exist
if ! id "$SOGO_USER" &>/dev/null; then
    useradd -r -s /bin/false -d "$SOGO_HOME" "$SOGO_USER"
fi

# Create necessary directories
mkdir -p "$SOGO_HOME"
mkdir -p "$SOGO_CONFIG"
mkdir -p /var/log/sogo
mkdir -p /var/spool/sogo

# Set permissions
chown -R "$SOGO_USER:$SOGO_GROUP" "$SOGO_HOME"
chown -R "$SOGO_USER:$SOGO_GROUP" /var/log/sogo
chown -R "$SOGO_USER:$SOGO_GROUP" /var/spool/sogo

echo "Configuring SOGo..."

# Create SOGo configuration
cat > "$SOGO_CONFIG/sogo.conf" << 'EOF'
{
  /* Database Configuration */
  SOGoProfileURL = "postgresql://sogo:SOGO_DB_PASSWORD@localhost:5432/sogo/sogo_user_profile";
  OCSFolderInfoURL = "postgresql://sogo:SOGO_DB_PASSWORD@localhost:5432/sogo/sogo_folder_info";
  OCSSessionsFolderURL = "postgresql://sogo:SOGO_DB_PASSWORD@localhost:5432/sogo/sogo_sessions_folder";
  OCSEMailAlarmsFolderURL = "postgresql://sogo:SOGO_DB_PASSWORD@localhost:5432/sogo/sogo_alarms_folder";

  /* Mail Configuration */
  SOGoIMAPServer = "localhost";
  SOGoSieveServer = "sieve://localhost:4190";
  SOGoSMTPServer = "localhost";
  SOGoMailDomain = "AUTO";
  SOGoMailingMechanism = "smtp";
  SOGoForceExternalLoginWithEmail = YES;
  SOGoMailSpoolPath = "/var/spool/sogo";

  /* Authentication */
  SOGoUserSources = (
    {
      type = sql;
      id = directory;
      viewURL = "postgresql://sogo:SOGO_DB_PASSWORD@localhost:5432/sogo/sogo_users";
      canAuthenticate = YES;
      isAddressBook = YES;
      userPasswordAlgorithm = "ssha";
    }
  );

  /* Web Interface */
  SOGoPageTitle = "Mail-in-a-Box Webmail";
  SOGoVacationEnabled = YES;
  SOGoForwardEnabled = YES;
  SOGoSieveScriptsEnabled = YES;
  SOGoMailAuxiliaryUserAccountsEnabled = YES;
  SOGoTrustProxyAuthentication = NO;

  /* Calendar & Contacts */
  SOGoCalendarDefaultRoles = (
    "PublicDAndTViewer",
    "ConfidentialDAndTViewer"
  );
  SOGoSuperUsernames = ("admin");
  SOGoTimeZone = "UTC";
  SOGoFirstDayOfWeek = 1;
  SOGoRefreshViewCheck = "every_minute";
  SOGoMailReplyPlacement = "below";
  SOGoMailSignaturePlacement = "below";
  SOGoMailComposeMessageType = "html";

  /* Security */
  SOGoPasswordChangeEnabled = YES;
  SOGoMaximumPingInterval = 3540;
  SOGoMaximumSyncInterval = 3540;
  SOGoInternalSyncInterval = 30;

  /* Memcached */
  SOGoMemcachedHost = "127.0.0.1";

  /* Logging */
  SOGoLogFile = "/var/log/sogo/sogo.log";
  SOGoLogLevel = "WARN";
  WOLogFile = "/var/log/sogo/sogo.log";
  WOLogLevel = "WARN";

  /* Performance */
  WOWorkersCount = 3;
  WOListenQueueSize = 5;
  WOPort = 20000;
}
EOF

echo "Setting up PostgreSQL database for SOGo..."

# Install PostgreSQL if not already installed
if ! command -v psql &> /dev/null; then
    apt-get install -y postgresql postgresql-contrib
fi

# Generate random password for SOGo database
SOGO_DB_PASSWORD=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-25)

# Create SOGo database and user
sudo -u postgres psql << EOF
CREATE USER sogo WITH PASSWORD '$SOGO_DB_PASSWORD';
CREATE DATABASE sogo OWNER sogo;
GRANT ALL PRIVILEGES ON DATABASE sogo TO sogo;
\q
EOF

# Update SOGo configuration with actual password
sed -i "s/SOGO_DB_PASSWORD/$SOGO_DB_PASSWORD/g" "$SOGO_CONFIG/sogo.conf"

# Create SOGo database schema
sudo -u postgres psql -d sogo << 'EOF'
CREATE TABLE sogo_user_profile (
  c_uid VARCHAR(255) NOT NULL,
  c_defaults TEXT,
  c_settings TEXT,
  PRIMARY KEY (c_uid)
);

CREATE TABLE sogo_folder_info (
  c_folder_id SERIAL PRIMARY KEY,
  c_path VARCHAR(255) NOT NULL,
  c_path1 VARCHAR(255) NOT NULL,
  c_path2 VARCHAR(255),
  c_path3 VARCHAR(255),
  c_path4 VARCHAR(255),
  c_foldername VARCHAR(255) NOT NULL,
  c_location VARCHAR(2048) NOT NULL,
  c_quick_location VARCHAR(2048),
  c_acl_location VARCHAR(2048),
  c_folder_type VARCHAR(255) NOT NULL
);

CREATE TABLE sogo_sessions_folder (
  c_id VARCHAR(255) NOT NULL,
  c_value VARCHAR(255) NOT NULL,
  c_creationdate INTEGER NOT NULL,
  c_lastseen INTEGER NOT NULL,
  PRIMARY KEY (c_id)
);

CREATE TABLE sogo_alarms_folder (
  c_path VARCHAR(255) NOT NULL,
  c_name VARCHAR(255) NOT NULL,
  c_uid VARCHAR(255) NOT NULL,
  c_recurrence_id INTEGER,
  c_alarm_number INTEGER NOT NULL,
  c_alarm_date INTEGER NOT NULL,
  PRIMARY KEY (c_path, c_name, c_uid, c_recurrence_id, c_alarm_number)
);

CREATE TABLE sogo_users (
  c_uid VARCHAR(255) PRIMARY KEY,
  c_name VARCHAR(255),
  c_password VARCHAR(255),
  c_cn VARCHAR(255),
  mail VARCHAR(255)
);

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO sogo;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO sogo;
\q
EOF

echo "Configuring Nginx for SOGo..."

# Create Nginx configuration for SOGo
cat > "$NGINX_SITES/sogo" << 'EOF'
server {
    listen 80;
    server_name _;
    
    # SOGo webmail interface
    location ^~ /SOGo {
        proxy_pass http://127.0.0.1:20000;
        proxy_redirect http://127.0.0.1:20000 default;
        
        # Forward headers
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $host;
        proxy_set_header x-webobjects-server-protocol HTTP/1.0;
        proxy_set_header x-webobjects-remote-host 127.0.0.1;
        proxy_set_header x-webobjects-server-name $server_name;
        proxy_set_header x-webobjects-server-url $scheme://$host;
        proxy_set_header x-webobjects-server-port $server_port;
        
        # Disable buffering
        proxy_buffering off;
        proxy_request_buffering off;
        
        # Timeouts
        proxy_connect_timeout 90;
        proxy_send_timeout 90;
        proxy_read_timeout 90;
        
        # Buffer sizes
        proxy_buffer_size 4k;
        proxy_buffers 4 32k;
        proxy_busy_buffers_size 64k;
        
        # Handle large requests
        client_max_body_size 50m;
        client_body_buffer_size 128k;
    }
    
    # SOGo DAV interface
    location ^~ /SOGo/dav {
        proxy_pass http://127.0.0.1:20000/SOGo/dav;
        proxy_redirect http://127.0.0.1:20000 default;
        
        # Forward headers for DAV
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $host;
        proxy_set_header Depth $http_depth;
        proxy_set_header Destination $http_destination;
        proxy_set_header Overwrite $http_overwrite;
        
        # Disable buffering for DAV
        proxy_buffering off;
        proxy_request_buffering off;
    }
    
    # Microsoft ActiveSync
    location ^~ /Microsoft-Server-ActiveSync {
        proxy_pass http://127.0.0.1:20000/SOGo/Microsoft-Server-ActiveSync;
        proxy_redirect http://127.0.0.1:20000 default;
        
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $host;
        proxy_set_header MS-ASProtocolVersion $http_ms_asprotocolversion;
        proxy_set_header MS-ASProtocolCommands $http_ms_asprotocolcommands;
    }
    
    # Static resources
    location ^~ /SOGo.woa/WebServerResources/ {
        alias /usr/lib/GNUstep/SOGo/WebServerResources/;
        allow all;
        expires max;
    }
    
    # Webmail redirect
    location = /webmail {
        return 301 /SOGo/;
    }
    
    location = /webmail/ {
        return 301 /SOGo/;
    }
}
EOF

# Enable SOGo site
ln -sf "$NGINX_SITES/sogo" "$NGINX_ENABLED/sogo"

echo "Configuring systemd services..."

# Create SOGo systemd service
cat > /etc/systemd/system/sogo.service << 'EOF'
[Unit]
Description=SOGo Enterprise Webmail
After=network.target postgresql.service memcached.service
Wants=postgresql.service memcached.service

[Service]
Type=forking
User=sogo
Group=sogo
ExecStart=/usr/sbin/sogod -WOWorkersCount 3 -WOLogFile /var/log/sogo/sogo.log -WOPidFile /var/run/sogo/sogo.pid
ExecReload=/bin/kill -HUP $MAINPID
PIDFile=/var/run/sogo/sogo.pid
RuntimeDirectory=sogo
RuntimeDirectoryMode=0755

[Install]
WantedBy=multi-user.target
EOF

# Create runtime directory
mkdir -p /var/run/sogo
chown sogo:sogo /var/run/sogo

echo "Starting services..."

# Enable and start services
systemctl daemon-reload
systemctl enable memcached
systemctl enable postgresql
systemctl enable sogo
systemctl enable nginx

systemctl start memcached
systemctl start postgresql
systemctl start sogo
systemctl restart nginx

echo "Creating SOGo integration script..."

# Create script to sync Mail-in-a-Box users with SOGo
cat > /usr/local/bin/sync-sogo-users << 'EOF'
#!/bin/bash
#
# Sync Mail-in-a-Box users with SOGo database
#

set -euo pipefail

# Database connection
SOGO_DB_PASSWORD=$(grep "postgresql://sogo:" /etc/sogo/sogo.conf | head -1 | sed 's/.*sogo:\([^@]*\)@.*/\1/')

# Get Mail-in-a-Box users
python3 << PYTHON
import sys
import os
sys.path.insert(0, '/root/mailinabox/management')

from mailconfig import get_mail_users_ex
import psycopg2

# Connect to SOGo database
conn = psycopg2.connect(
    host="localhost",
    database="sogo",
    user="sogo",
    password="$SOGO_DB_PASSWORD"
)
cur = conn.cursor()

# Clear existing users
cur.execute("DELETE FROM sogo_users")

# Get Mail-in-a-Box users
users = get_mail_users_ex(format="json")

for user in users:
    email = user['email']
    name = user.get('name', email.split('@')[0])
    
    # Insert user into SOGo database
    cur.execute("""
        INSERT INTO sogo_users (c_uid, c_name, c_password, c_cn, mail)
        VALUES (%s, %s, %s, %s, %s)
    """, (email, name, '{SSHA}dummy', name, email))

conn.commit()
cur.close()
conn.close()

print("SOGo users synchronized successfully")
PYTHON
EOF

chmod +x /usr/local/bin/sync-sogo-users

echo "Setting up automatic user synchronization..."

# Create cron job for user synchronization
cat > /etc/cron.d/sogo-sync << 'EOF'
# Sync Mail-in-a-Box users with SOGo every 5 minutes
*/5 * * * * root /usr/local/bin/sync-sogo-users >/dev/null 2>&1
EOF

echo "Configuring SOGo for Mail-in-a-Box integration..."

# Update SOGo configuration for Mail-in-a-Box
cat >> "$SOGO_CONFIG/sogo.conf" << 'EOF'

/* Mail-in-a-Box Integration */
SOGoMailingMechanism = "smtp";
SOGoSMTPServer = "localhost:587";
SOGoSMTPAuthenticationType = "PLAIN";

/* Enable all features */
SOGoCalendarDefaultRoles = (
  "PublicDAndTViewer",
  "ConfidentialDAndTViewer",
  "PrivateDAndTViewer",
  "ObjectCreator",
  "ObjectEraser"
);

SOGoContactsDefaultRoles = (
  "ObjectViewer",
  "ObjectCreator",
  "ObjectEraser"
);

/* Mobile device support */
SOGoMobileDeviceEnabled = YES;
SOGoDesktopDeviceEnabled = YES;

/* Backup and restore */
SOGoBackupEnabled = YES;
SOGoRestoreEnabled = YES;
EOF

echo "Running initial user synchronization..."
/usr/local/bin/sync-sogo-users

echo "=========================================="
echo "  SOGo Installation Complete!"
echo "=========================================="
echo ""
echo "SOGo Enterprise Webmail has been installed and configured."
echo ""
echo "Access URLs:"
echo "• Webmail: https://$(hostname)/SOGo/"
echo "• Direct: https://$(hostname)/webmail"
echo ""
echo "Features enabled:"
echo "• Enterprise webmail interface"
echo "• Calendar and contacts management"
echo "• Microsoft ActiveSync support"
echo "• CardDAV and CalDAV support"
echo "• Automatic user synchronization"
echo ""
echo "SOGo replaces Nextcloud for email collaboration."
echo "Users can access email, calendars, and contacts"
echo "through the modern web interface or mobile apps."
echo ""
echo "Configuration files:"
echo "• SOGo config: /etc/sogo/sogo.conf"
echo "• Nginx config: /etc/nginx/sites-available/sogo"
echo "• User sync script: /usr/local/bin/sync-sogo-users"
echo ""
echo "Services status:"
systemctl is-active sogo && echo "• SOGo: Running" || echo "• SOGo: Stopped"
systemctl is-active nginx && echo "• Nginx: Running" || echo "• Nginx: Stopped"
systemctl is-active postgresql && echo "• PostgreSQL: Running" || echo "• PostgreSQL: Stopped"
systemctl is-active memcached && echo "• Memcached: Running" || echo "• Memcached: Stopped"
echo ""
echo "SOGo installation completed successfully!"
EOF

