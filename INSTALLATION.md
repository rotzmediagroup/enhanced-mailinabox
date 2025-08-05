# Enhanced Mail-in-a-Box Installation Guide

## 🚀 Quick Start (Recommended)

For a fresh Ubuntu 22.04 LTS server, run this single command:

```bash
curl -s https://raw.githubusercontent.com/rotzmediagroup/enhanced-mailinabox/main/setup/enhanced_start.sh | sudo bash
```

## 📋 Prerequisites

### Server Requirements
- **Fresh Ubuntu 22.04 LTS** server (x86-64)
- **Minimum 1GB RAM** (2GB+ recommended)
- **10GB+ disk space** (more for email storage)
- **Root access** (sudo privileges)
- **Internet connection** for package downloads

### Domain Requirements
- **Domain name** that you control
- **DNS access** to configure A, MX, and other records
- **No existing mail server** on the domain

### Network Requirements
- **Static IP address** (required for mail server)
- **Ports 25, 53, 80, 443, 587, 993, 995** open
- **No ISP blocking** of port 25 (check with your provider)

## 🛠 Installation Methods

### Method 1: One-Line Installation (Easiest)

```bash
# Download and run the enhanced installer
curl -s https://raw.githubusercontent.com/rotzmediagroup/enhanced-mailinabox/main/setup/enhanced_start.sh | sudo bash
```

### Method 2: Manual Installation

```bash
# Clone the repository
git clone https://github.com/rotzmediagroup/enhanced-mailinabox.git
cd enhanced-mailinabox

# Run the enhanced setup
sudo setup/enhanced_start.sh
```

### Method 3: Original Setup with Enhancement Upgrade

```bash
# Install original Mail-in-a-Box first
curl -s https://mailinabox.email/setup.sh | sudo bash

# Then upgrade to enhanced version
curl -s https://raw.githubusercontent.com/rotzmediagroup/enhanced-mailinabox/main/enhanced_ui_installer.sh | sudo bash
```

## 📝 Step-by-Step Installation

### Step 1: Prepare Your Server

1. **Get a fresh Ubuntu 22.04 LTS server**
   - VPS providers: DigitalOcean, Linode, Vultr, AWS, etc.
   - Minimum specs: 1GB RAM, 1 CPU, 10GB storage

2. **Connect to your server**
   ```bash
   ssh root@your-server-ip
   ```

3. **Update the system** (optional but recommended)
   ```bash
   apt update && apt upgrade -y
   ```

### Step 2: Configure Your Domain

1. **Point your domain to the server**
   - Create an A record: `mail.yourdomain.com` → `your-server-ip`
   - Create an A record: `yourdomain.com` → `your-server-ip` (optional)

2. **Set the hostname**
   ```bash
   hostnamectl set-hostname mail.yourdomain.com
   ```

### Step 3: Run the Installation

```bash
curl -s https://raw.githubusercontent.com/rotzmediagroup/enhanced-mailinabox/main/setup/enhanced_start.sh | sudo bash
```

The installer will:
- Download all necessary packages
- Configure email services (Postfix, Dovecot)
- Set up web services (Nginx, PHP)
- Install DNS server (nsd)
- Configure security (fail2ban, firewall)
- Install enhanced web interface
- Generate SSL certificates

### Step 4: Complete Setup

1. **Access the control panel**
   - Open: `https://mail.yourdomain.com/admin`
   - Or: `https://your-server-ip/admin`

2. **Create the first user**
   - This user becomes the system administrator
   - Use a strong password

3. **Configure DNS records**
   - Follow the instructions in the control panel
   - Update your domain's DNS settings

4. **Test email functionality**
   - Send a test email
   - Check spam folder settings
   - Verify mobile device setup

## 🎯 Post-Installation Configuration

### DNS Configuration

The control panel will show you exactly which DNS records to create:

```
# Example DNS records (replace with your actual values)
yourdomain.com.     A     your-server-ip
mail.yourdomain.com. A     your-server-ip
yourdomain.com.     MX    10 mail.yourdomain.com.
yourdomain.com.     TXT   "v=spf1 mx -all"
# ... and more records as shown in the control panel
```

### Email Client Setup

**IMAP Settings:**
- Server: `mail.yourdomain.com`
- Port: 993 (SSL/TLS)
- Username: `your-email@yourdomain.com`
- Password: `your-password`

**SMTP Settings:**
- Server: `mail.yourdomain.com`
- Port: 587 (STARTTLS)
- Authentication: Required
- Username: `your-email@yourdomain.com`
- Password: `your-password`

### Mobile Device Setup

The enhanced control panel provides:
- **Automatic configuration** for iOS and Android
- **QR codes** for easy setup
- **Step-by-step guides** for manual configuration

## 🔧 Enhanced Features Configuration

### User Management
- **Visual quota management** with progress bars
- **Bulk operations** for multiple users
- **Advanced search** and filtering
- **Domain-based organization**

### Mail Analytics
- **Email volume tracking** with charts
- **Spam statistics** and blocking data
- **User activity monitoring**
- **Performance metrics**

### System Monitoring
- **Real-time health indicators**
- **Service status monitoring**
- **Resource usage tracking**
- **Automated alerts**

## 🛡 Security Considerations

### Firewall Configuration
The installer automatically configures UFW firewall:
```bash
# Check firewall status
sudo ufw status

# Manually configure if needed
sudo ufw allow 22    # SSH
sudo ufw allow 25    # SMTP
sudo ufw allow 53    # DNS
sudo ufw allow 80    # HTTP
sudo ufw allow 443   # HTTPS
sudo ufw allow 587   # SMTP submission
sudo ufw allow 993   # IMAPS
sudo ufw allow 995   # POP3S
```

### SSL Certificates
- **Automatic Let's Encrypt** certificates
- **Auto-renewal** configured
- **HTTPS enforcement** for web interface

### Backup Configuration
- **Automated daily backups**
- **Cloud storage support** (S3, B2, etc.)
- **Encryption** of backup data
- **Easy restore** functionality

## 🔄 Maintenance & Updates

### Regular Maintenance
```bash
# Check system status
sudo /root/enhanced-mailinabox/tools/mail.py

# Update system packages
sudo apt update && sudo apt upgrade

# Restart services if needed
sudo systemctl restart postfix dovecot nginx
```

### Updating Enhanced Mail-in-a-Box
```bash
cd /root/enhanced-mailinabox
git pull
sudo setup/enhanced_start.sh
```

## 🆘 Troubleshooting

### Common Issues

**Port 25 Blocked:**
- Contact your ISP to unblock port 25
- Consider using a mail relay service

**DNS Propagation:**
- DNS changes can take 24-48 hours
- Use online DNS checkers to verify

**SSL Certificate Issues:**
- Ensure domain points to server
- Check firewall allows port 80/443
- Verify Let's Encrypt rate limits

**Email Delivery Problems:**
- Check spam folder settings
- Verify SPF, DKIM, DMARC records
- Monitor server reputation

### Getting Help

1. **Check the control panel** for status indicators
2. **Review system logs** in `/var/log/`
3. **Visit the documentation** at GitHub
4. **Ask the community** in discussions
5. **Report bugs** in the issue tracker

## 📊 Performance Optimization

### Server Resources
- **Monitor RAM usage** - upgrade if consistently high
- **Check disk space** - email storage grows over time
- **CPU monitoring** - ensure adequate processing power

### Email Performance
- **Regular cleanup** of old emails
- **Quota management** for users
- **Spam filter tuning** for accuracy

### Web Interface
- **Browser caching** enabled automatically
- **Gzip compression** for faster loading
- **CDN integration** for static assets (optional)

## 🎉 Success!

Once installation is complete, you'll have:

✅ **Complete email server** with all Mail-in-a-Box features  
✅ **Modern web interface** with enhanced management  
✅ **Mobile-responsive design** for on-the-go administration  
✅ **Advanced analytics** and monitoring capabilities  
✅ **Professional appearance** that impresses users  
✅ **Easy maintenance** with automated updates  

**Welcome to Enhanced Mail-in-a-Box - the future of self-hosted email!** 🚀

