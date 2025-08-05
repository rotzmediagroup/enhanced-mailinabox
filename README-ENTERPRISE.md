# Enhanced Mail-in-a-Box - Enterprise Edition

🚀 **Complete Enterprise Email Server with Modern UI and SOGo Webmail**

This is an enterprise-enhanced version of [Mail-in-a-Box](https://github.com/mail-in-a-box/mailinabox) that provides everything the original offers PLUS a professional, Plesk-like web interface and SOGo enterprise webmail with contacts and calendar management.

## ✨ Enterprise Enhancements

### 🎨 Professional Control Panel
- **Plesk-inspired design** with clean, enterprise-grade interface
- **Dark sidebar navigation** with organized sections
- **Professional color scheme** using corporate blues and grays
- **Responsive design** optimized for desktop and mobile
- **Advanced data tables** with sorting, filtering, and bulk operations

### 📧 SOGo Enterprise Webmail
- **Modern webmail interface** replacing Roundcube
- **Integrated calendar and contacts** stored in IMAP
- **Microsoft ActiveSync** support for mobile devices
- **CardDAV and CalDAV** for desktop client synchronization
- **Enterprise collaboration** features for teams

### 📊 Advanced Management Features
- **Visual quota management** with progress bars and color coding
- **Bulk user operations** for efficient administration
- **Advanced search and filtering** across all interfaces
- **Real-time system monitoring** with health indicators
- **Professional data presentation** with enterprise-grade tables

## 🚀 Installation (Fresh Ubuntu Server)

### Requirements
- **Fresh Ubuntu 22.04 LTS** server (same as original Mail-in-a-Box)
- **Minimum 2GB RAM** (recommended for SOGo)
- **20GB+ disk space** (more for email and calendar storage)
- **Root access** to the server
- **Domain name** pointed to your server's IP address

### One-Line Installation
Install the complete enterprise mail server on a fresh Ubuntu 22.04 server:

```bash
curl -s https://raw.githubusercontent.com/rotzmediagroup/enhanced-mailinabox/main/setup/enhanced_start.sh | sudo bash
```

### Manual Installation
If you prefer to review the code first:

```bash
git clone https://github.com/rotzmediagroup/enhanced-mailinabox.git
cd enhanced-mailinabox
sudo setup/enhanced_start.sh
```

## 📱 What You Get

### Complete Email Server (Original Features)
- ✅ **SMTP, IMAP, POP3** email services
- ✅ **DNS server** with automatic configuration
- ✅ **TLS/SSL certificates** (Let's Encrypt)
- ✅ **Spam filtering** and security features
- ✅ **Backup system** with cloud storage support
- ✅ **Firewall and security** hardening

### Enterprise Webmail & Collaboration
- ✅ **SOGo webmail** with modern interface
- ✅ **Integrated calendar** with meeting scheduling
- ✅ **Contact management** with address books
- ✅ **Mobile synchronization** via ActiveSync
- ✅ **Desktop client support** via CalDAV/CardDAV
- ✅ **Team collaboration** features

### Professional Management Interface
- ✅ **Enterprise control panel** with Plesk-like design
- ✅ **Advanced user management** with visual quota displays
- ✅ **System monitoring** with real-time health indicators
- ✅ **Professional data tables** with sorting and filtering
- ✅ **Bulk operations** for efficient administration
- ✅ **Mobile-responsive** design for all devices

## 🎯 Perfect For

### Small to Medium Businesses
- **Professional email** with custom domain
- **Team collaboration** with shared calendars and contacts
- **Mobile device management** with ActiveSync
- **Enterprise-grade interface** for IT administrators

### IT Professionals & MSPs
- **Multiple domain management** with professional tools
- **Advanced monitoring** and reporting capabilities
- **Bulk user operations** for efficient management
- **Professional appearance** for client presentations

### Organizations & Institutions
- **Complete email infrastructure** with collaboration tools
- **GDPR compliance** with self-hosted solution
- **Cost-effective** alternative to hosted email services
- **Full control** over email and collaboration data

## 🔧 Post-Installation

After installation completes:

1. **Access the control panel** at `https://your-domain.com/admin`
2. **Create your first user** (this becomes the admin)
3. **Configure DNS** records as instructed
4. **Access SOGo webmail** at `https://your-domain.com/SOGo/`
5. **Set up mobile devices** using ActiveSync or IMAP/CalDAV

## 📊 Enterprise Features in Detail

### Professional Control Panel
- **Plesk-inspired design** with dark sidebar and clean layout
- **Advanced user management** with visual quota bars and status indicators
- **Bulk operations** for password resets, quota changes, and user management
- **Professional data tables** with sorting, filtering, and search
- **Real-time monitoring** with system health indicators
- **Responsive design** optimized for all screen sizes

### SOGo Enterprise Webmail
- **Modern web interface** with professional design
- **Integrated email, calendar, and contacts** in one platform
- **Microsoft ActiveSync** for seamless mobile synchronization
- **CalDAV and CardDAV** for desktop client integration
- **Shared calendars and address books** for team collaboration
- **Advanced email features** with filters, signatures, and vacation messages

### Advanced User Management
- **Visual quota management** with progress bars and color coding
- **Domain-based organization** with tabbed filtering
- **Advanced search** by email, domain, or usage patterns
- **Bulk operations** for efficient user administration
- **User activity tracking** with login history and statistics
- **Storage analytics** with detailed usage breakdowns

### System Monitoring & Analytics
- **Real-time health overview** with color-coded status indicators
- **Service monitoring** for mail, web, DNS, and security services
- **Resource usage tracking** for storage, memory, and CPU
- **Performance metrics** with historical data and trends
- **Alert system** for critical issues and maintenance needs
- **Professional reporting** with export capabilities

## 🔄 SOGo vs Nextcloud Comparison

| Feature | Nextcloud | SOGo Enterprise |
|---------|-----------|-----------------|
| **Primary Focus** | File sharing + extras | Email collaboration |
| **Email Integration** | Basic webmail | Native IMAP integration |
| **Calendar Storage** | Database | IMAP folders |
| **Contact Storage** | Database | IMAP/CardDAV |
| **Mobile Sync** | Custom apps | Native ActiveSync |
| **Resource Usage** | High (full stack) | Optimized for email |
| **Enterprise Features** | File-focused | Email-focused |
| **Mail Server Integration** | External | Native |

### Why SOGo is Better for Mail Servers
- **Native IMAP integration** - calendars and contacts stored in mail folders
- **Lower resource usage** - optimized specifically for email collaboration
- **Better mobile support** - native ActiveSync and CalDAV/CardDAV
- **Enterprise focus** - designed for business email environments
- **Seamless integration** - works directly with mail server infrastructure

## 🛠 Advanced Configuration

### SOGo Customization
- **Branding** - customize logos, colors, and themes
- **Authentication** - integrate with LDAP or Active Directory
- **Mobile policies** - configure device management and security
- **Backup integration** - automatic backup of calendars and contacts

### Control Panel Customization
- **Custom styling** - modify CSS for corporate branding
- **Additional modules** - extend functionality with custom features
- **API integration** - connect with external management systems
- **Monitoring integration** - connect with enterprise monitoring tools

### Enterprise Integration
- **LDAP/Active Directory** - centralized user management
- **Single Sign-On (SSO)** - integrate with enterprise authentication
- **Monitoring systems** - SNMP and API endpoints for monitoring
- **Backup systems** - integration with enterprise backup solutions

## 🔒 Security & Compliance

### Enhanced Security Features
- **Enterprise-grade SSL/TLS** with perfect forward secrecy
- **Advanced spam filtering** with machine learning
- **Intrusion detection** with fail2ban and custom rules
- **Audit logging** for compliance and security monitoring
- **Role-based access control** for administrative functions

### Compliance Support
- **GDPR compliance** with data protection features
- **Email archiving** with retention policies
- **Audit trails** for administrative actions
- **Data export** capabilities for compliance requests
- **Encryption** for data at rest and in transit

## 📱 Mobile Device Support

### Native ActiveSync
- **Email synchronization** with push notifications
- **Calendar synchronization** with meeting invitations
- **Contact synchronization** with global address lists
- **Device policies** for security and management
- **Remote wipe** capabilities for lost devices

### Alternative Protocols
- **IMAP/SMTP** for email clients
- **CalDAV** for calendar applications
- **CardDAV** for contact management
- **WebDAV** for file access (if needed)

## 🆘 Support & Documentation

### Getting Help
- **Enterprise documentation** with detailed guides
- **Community support** through GitHub discussions
- **Professional support** options available
- **Migration guides** from other email systems

### Professional Services
- **Installation assistance** for complex environments
- **Custom development** for specific requirements
- **Training services** for administrators
- **Ongoing support** and maintenance contracts

## 📄 License & Credits

### License
Same as original Mail-in-a-Box - see [LICENSE](LICENSE) file.

### Credits
- **[Mail-in-a-Box Team](https://github.com/mail-in-a-box/mailinabox)** - Excellent foundation
- **[SOGo Team](https://sogo.nu/)** - Enterprise webmail and collaboration
- **Enterprise UI Development** - Professional interface and advanced features
- **Community Contributors** - Feedback, testing, and improvements

## 🆚 Comparison with Original

| Feature | Original Mail-in-a-Box | Enhanced Enterprise |
|---------|----------------------|-------------------|
| **Installation** | ✅ One-line install | ✅ One-line install |
| **Email Services** | ✅ Complete | ✅ Complete + Enhanced |
| **Webmail** | ✅ Roundcube | ✅ SOGo Enterprise |
| **Calendar/Contacts** | ✅ Nextcloud | ✅ SOGo (IMAP-based) |
| **Web Interface** | ✅ Basic | ✅ Enterprise Plesk-like |
| **User Management** | ✅ Basic | ✅ Advanced with Analytics |
| **System Monitoring** | ✅ Basic status | ✅ Real-time Dashboard |
| **Mobile Support** | ⚠️ Limited | ✅ Native ActiveSync |
| **Enterprise Features** | ❌ None | ✅ Comprehensive |
| **Professional Design** | ⚠️ Functional | ✅ Enterprise-grade |

## 🚀 Get Started Today

Ready to set up your enterprise mail server?

```bash
curl -s https://raw.githubusercontent.com/rotzmediagroup/enhanced-mailinabox/main/setup/enhanced_start.sh | sudo bash
```

**Transform your email infrastructure with enterprise-grade features, professional design, and SOGo collaboration tools!** 🎉

---

*Enhanced Mail-in-a-Box Enterprise Edition - Professional email server with SOGo webmail, enterprise control panel, and advanced collaboration features.*

