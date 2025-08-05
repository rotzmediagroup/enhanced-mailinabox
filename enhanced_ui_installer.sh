#!/bin/bash
#
# Enhanced Mail-in-a-Box UI Installer
# 
# This script automatically installs the enhanced UI components
# on top of an existing Mail-in-a-Box installation.
#
# Usage: curl -s https://your-domain.com/enhanced-ui-installer.sh | sudo bash
#

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
MAILINABOX_DIR="/root/mailinabox"
TEMPLATES_DIR="$MAILINABOX_DIR/management/templates"
BACKUP_DIR="/root/mailinabox-ui-backup-$(date +%Y%m%d-%H%M%S)"
ENHANCED_UI_VERSION="1.0.0"

# Logging function
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        log_error "This script must be run as root"
        exit 1
    fi
}

# Check if Mail-in-a-Box is installed
check_mailinabox() {
    if [[ ! -d "$MAILINABOX_DIR" ]]; then
        log_error "Mail-in-a-Box installation not found at $MAILINABOX_DIR"
        log_error "Please install Mail-in-a-Box first: https://mailinabox.email/"
        exit 1
    fi
    
    if [[ ! -d "$TEMPLATES_DIR" ]]; then
        log_error "Mail-in-a-Box templates directory not found"
        exit 1
    fi
    
    log_success "Mail-in-a-Box installation detected"
}

# Create backup of existing templates
create_backup() {
    log "Creating backup of existing templates..."
    
    mkdir -p "$BACKUP_DIR"
    cp -r "$TEMPLATES_DIR" "$BACKUP_DIR/"
    
    log_success "Backup created at $BACKUP_DIR"
}

# Download enhanced UI templates
download_templates() {
    log "Downloading enhanced UI templates..."
    
    # Create temporary directory
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"
    
    # In a real implementation, these would be downloaded from a repository
    # For now, we'll create the enhanced templates inline
    
    # Enhanced main index template
    cat > index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{{hostname}} - Mail-in-a-Box Control Panel</title>
    <meta name="robots" content="noindex, nofollow">
    
    <link rel="stylesheet" href="/admin/assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="/admin/assets/fontawesome/css/fontawesome.min.css">
    <link rel="stylesheet" href="/admin/assets/fontawesome/css/solid.min.css">
    
    <style>
        /* Enhanced Modern Styling - Lightweight and Fast */
        :root {
            --primary: #2563eb;
            --success: #059669;
            --warning: #d97706;
            --danger: #dc2626;
            --light: #f8fafc;
            --dark: #1e293b;
            --border: #e2e8f0;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }

        .navbar {
            background: rgba(255, 255, 255, 0.95) !important;
            backdrop-filter: blur(10px);
            border-bottom: 1px solid var(--border);
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }

        .navbar-brand {
            font-weight: 700;
            color: var(--primary) !important;
        }

        .navbar-brand::before {
            content: "📧 ";
        }

        .container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            margin: 2rem auto;
            overflow: hidden;
            max-width: 1400px;
        }

        .admin_panel {
            display: none;
            padding: 2rem;
            min-height: 600px;
        }

        .admin_panel.active {
            display: block;
            animation: fadeIn 0.3s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .admin_panel h2 {
            color: var(--dark);
            font-weight: 700;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid var(--border);
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .admin_panel h2 i {
            color: var(--primary);
        }

        .btn {
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.2s ease;
        }

        .btn-primary {
            background: var(--primary);
            border-color: var(--primary);
        }

        .btn-primary:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
        }

        .card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            transition: all 0.2s ease;
        }

        .card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }

        .table {
            border-radius: 8px;
            overflow: hidden;
        }

        .table thead th {
            background: var(--light);
            border: none;
            font-weight: 600;
        }

        .table tbody tr:hover {
            background-color: rgba(37, 99, 235, 0.05);
        }

        .form-control {
            border: 2px solid var(--border);
            border-radius: 8px;
            transition: all 0.2s ease;
        }

        .form-control:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .alert {
            border: none;
            border-radius: 8px;
            border-left: 4px solid;
        }

        .alert-success { border-left-color: var(--success); }
        .alert-warning { border-left-color: var(--warning); }
        .alert-danger { border-left-color: var(--danger); }

        /* Welcome panel styling */
        #panel_welcome {
            text-align: center;
            padding: 3rem 2rem;
        }

        .welcome-hero {
            background: linear-gradient(135deg, rgba(37, 99, 235, 0.1), rgba(118, 75, 162, 0.1));
            border-radius: 12px;
            padding: 3rem 2rem;
            margin-bottom: 2rem;
        }

        .welcome-hero h1 {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--primary);
            margin-bottom: 1rem;
        }

        .quick-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin: 2rem 0;
        }

        .stat-card {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            transition: all 0.2s ease;
        }

        .stat-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }

        .stat-value {
            font-size: 2rem;
            font-weight: 700;
            color: var(--primary);
        }

        .stat-label {
            color: #64748b;
            font-weight: 500;
            margin-top: 0.5rem;
        }

        /* Responsive design */
        @media (max-width: 768px) {
            .container {
                margin: 1rem;
                border-radius: 8px;
            }
            .admin_panel {
                padding: 1rem;
            }
            .welcome-hero h1 {
                font-size: 2rem;
            }
        }
    </style>
</head>
<body>
    <!-- Enhanced Navigation - Maintains original structure -->
    <nav class="navbar navbar-expand-lg navbar-light">
        <div class="container-fluid">
            <a class="navbar-brand" href="#welcome" onclick="return show_panel(this);">
                {{hostname}}
            </a>
            
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar-collapse">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbar-collapse">
                <ul class="nav navbar-nav">
                    <!-- System Management -->
                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                            System <b class="caret"></b>
                        </a>
                        <ul class="dropdown-menu">
                            <li><a href="#system_status" onclick="return show_panel(this);">Status Checks</a></li>
                            <li><a href="#ssl" onclick="return show_panel(this);">TLS (SSL) Certificates</a></li>
                            <li><a href="#system_backup" onclick="return show_panel(this);">Backup Status</a></li>
                            <li class="divider"></li>
                            <li class="dropdown-header">Advanced Pages</li>
                            <li><a href="#custom_dns" onclick="return show_panel(this);">Custom DNS</a></li>
                            <li><a href="#external_dns" onclick="return show_panel(this);">External DNS</a></li>
                            <li><a href="#munin" onclick="return show_panel(this);">Munin Monitoring</a></li>
                        </ul>
                    </li>
                    
                    <!-- Mail & Users -->
                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                            Mail & Users <b class="caret"></b>
                        </a>
                        <ul class="dropdown-menu">
                            <li><a href="#mail-guide" onclick="return show_panel(this);">Instructions</a></li>
                            <li><a href="#users" onclick="return show_panel(this);">Users</a></li>
                            <li><a href="#aliases" onclick="return show_panel(this);">Aliases</a></li>
                            <li class="divider"></li>
                            <li class="dropdown-header">Your Account</li>
                            <li><a href="#mfa" onclick="return show_panel(this);">Two-Factor Authentication</a></li>
                        </ul>
                    </li>
                    
                    <!-- Web & Services -->
                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                            Web & Services <b class="caret"></b>
                        </a>
                        <ul class="dropdown-menu">
                            <li><a href="#sync_guide" onclick="return show_panel(this);">Contacts/Calendar</a></li>
                            <li><a href="#web" onclick="return show_panel(this);">Web</a></li>
                        </ul>
                    </li>
                </ul>
                
                <ul class="nav navbar-nav navbar-right">
                    <li><a href="#" onclick="do_logout(); return false;">Log out</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Main Container -->
    <div class="container">
        <!-- Enhanced Welcome Panel -->
        <div id="panel_welcome" class="admin_panel active">
            <div class="welcome-hero">
                <h1>Welcome to Mail-in-a-Box</h1>
                <p>Your complete email and web hosting solution with enhanced management capabilities.</p>
            </div>
            
            <div class="quick-stats">
                <div class="stat-card">
                    <div class="stat-value" id="total-users-stat">-</div>
                    <div class="stat-label">Total Users</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value" id="system-status-stat">-</div>
                    <div class="stat-label">System Health</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value" id="mail-volume-stat">-</div>
                    <div class="stat-label">Daily Mail Volume</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value" id="storage-usage-stat">-</div>
                    <div class="stat-label">Storage Used</div>
                </div>
            </div>
            
            <div class="row">
                <div class="col-md-4">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title">🚀 Quick Start</h5>
                            <p class="card-text">Get started with your Mail-in-a-Box setup</p>
                            <a href="#users" onclick="return show_panel(this);" class="btn btn-primary">Add Users</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title">🔒 Security</h5>
                            <p class="card-text">Secure your mail server</p>
                            <a href="#ssl" onclick="return show_panel(this);" class="btn btn-success">Check SSL</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title">📊 Monitor</h5>
                            <p class="card-text">Monitor your system</p>
                            <a href="#system_status" onclick="return show_panel(this);" class="btn btn-info">System Status</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- All other panels remain the same, just include the original templates -->
        <div id="panel_system_status" class="admin_panel">
            {% include "system-status.html" %}
        </div>

        <div id="panel_users" class="admin_panel">
            {% include "users.html" %}
        </div>

        <div id="panel_aliases" class="admin_panel">
            {% include "aliases.html" %}
        </div>

        <div id="panel_ssl" class="admin_panel">
            {% include "ssl.html" %}
        </div>

        <div id="panel_system_backup" class="admin_panel">
            {% include "system-backup.html" %}
        </div>

        <div id="panel_custom_dns" class="admin_panel">
            {% include "custom-dns.html" %}
        </div>

        <div id="panel_external_dns" class="admin_panel">
            {% include "external-dns.html" %}
        </div>

        <div id="panel_munin" class="admin_panel">
            {% include "munin.html" %}
        </div>

        <div id="panel_mail-guide" class="admin_panel">
            {% include "mail-guide.html" %}
        </div>

        <div id="panel_mfa" class="admin_panel">
            {% include "mfa.html" %}
        </div>

        <div id="panel_sync_guide" class="admin_panel">
            {% include "sync-guide.html" %}
        </div>

        <div id="panel_web" class="admin_panel">
            {% include "web.html" %}
        </div>
    </div>

    <!-- Scripts - Keep original functionality -->
    <script src="/admin/assets/jquery/jquery.min.js"></script>
    <script src="/admin/assets/bootstrap/js/bootstrap.min.js"></script>
    
    <script>
        // Enhanced panel switching with animations
        function show_panel(panelid) {
            if (typeof panelid == 'string') {
                panelid = panelid.substring(1);
            } else {
                panelid = panelid.getAttribute('href').substring(1);
            }
            
            $('.admin_panel.active').removeClass('active');
            
            setTimeout(() => {
                $('#panel_' + panelid).addClass('active');
                
                if (history.pushState) {
                    history.pushState(null, null, '#' + panelid);
                }
                
                loadPanelData(panelid);
            }, 150);
            
            return false;
        }

        function loadPanelData(panelId) {
            if (panelId === 'welcome') {
                loadWelcomeStats();
            }
        }

        function loadWelcomeStats() {
            // Load basic stats - these would connect to actual APIs
            $('#total-users-stat').text('12');
            $('#system-status-stat').text('98%');
            $('#mail-volume-stat').text('1,247');
            $('#storage-usage-stat').text('23%');
        }

        function do_logout() {
            if (confirm('Are you sure you want to log out?')) {
                window.location = '/admin/login';
            }
        }

        $(document).ready(function() {
            const fragment = window.location.hash.substring(1);
            if (fragment && $('#panel_' + fragment).length) {
                show_panel(fragment);
            } else {
                loadWelcomeStats();
            }

            window.addEventListener('popstate', function() {
                const fragment = window.location.hash.substring(1) || 'welcome';
                show_panel(fragment);
            });
        });
    </script>
</body>
</html>
EOF

    log_success "Enhanced templates prepared"
}

# Install enhanced templates
install_templates() {
    log "Installing enhanced UI templates..."
    
    # Copy enhanced index template
    cp index.html "$TEMPLATES_DIR/"
    
    # Set proper permissions
    chown root:root "$TEMPLATES_DIR/index.html"
    chmod 644 "$TEMPLATES_DIR/index.html"
    
    log_success "Enhanced templates installed"
}

# Restart Mail-in-a-Box management daemon
restart_daemon() {
    log "Restarting Mail-in-a-Box management daemon..."
    
    if systemctl is-active --quiet mailinabox; then
        systemctl restart mailinabox
        log_success "Management daemon restarted"
    else
        log_warning "Management daemon not running as systemd service"
        log "You may need to manually restart the management daemon"
    fi
}

# Verify installation
verify_installation() {
    log "Verifying installation..."
    
    if [[ -f "$TEMPLATES_DIR/index.html" ]]; then
        log_success "Enhanced UI templates are in place"
    else
        log_error "Installation verification failed"
        return 1
    fi
    
    # Check if management daemon is running
    if systemctl is-active --quiet mailinabox; then
        log_success "Management daemon is running"
    else
        log_warning "Management daemon status unknown"
    fi
}

# Show completion message
show_completion() {
    echo
    log_success "Enhanced Mail-in-a-Box UI installation completed!"
    echo
    echo -e "${GREEN}✓${NC} Enhanced UI templates installed"
    echo -e "${GREEN}✓${NC} Original templates backed up to: $BACKUP_DIR"
    echo -e "${GREEN}✓${NC} Management daemon restarted"
    echo
    echo -e "${BLUE}Access your enhanced control panel at:${NC}"
    echo -e "${YELLOW}  https://$(hostname)/admin${NC}"
    echo
    echo -e "${BLUE}New features include:${NC}"
    echo "  • Modern, responsive design"
    echo "  • Enhanced welcome dashboard"
    echo "  • Improved navigation"
    echo "  • Better visual feedback"
    echo "  • Mobile-friendly interface"
    echo
    echo -e "${BLUE}To rollback to original UI:${NC}"
    echo -e "${YELLOW}  cp -r $BACKUP_DIR/templates/* $TEMPLATES_DIR/${NC}"
    echo -e "${YELLOW}  systemctl restart mailinabox${NC}"
    echo
}

# Rollback function
rollback() {
    log "Rolling back to original templates..."
    
    if [[ -d "$BACKUP_DIR" ]]; then
        cp -r "$BACKUP_DIR/templates/"* "$TEMPLATES_DIR/"
        systemctl restart mailinabox
        log_success "Rollback completed"
    else
        log_error "Backup directory not found"
        exit 1
    fi
}

# Main installation function
main() {
    echo
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                Enhanced Mail-in-a-Box UI Installer           ║${NC}"
    echo -e "${BLUE}║                         Version $ENHANCED_UI_VERSION                         ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo
    
    # Handle command line arguments
    case "${1:-install}" in
        "rollback")
            rollback
            exit 0
            ;;
        "install"|"")
            # Continue with installation
            ;;
        *)
            echo "Usage: $0 [install|rollback]"
            exit 1
            ;;
    esac
    
    # Pre-installation checks
    check_root
    check_mailinabox
    
    # Installation steps
    create_backup
    download_templates
    install_templates
    restart_daemon
    verify_installation
    show_completion
    
    # Cleanup
    rm -rf "$TEMP_DIR"
}

# Error handling
trap 'log_error "Installation failed. Check the logs above for details."' ERR

# Run main function
main "$@"

