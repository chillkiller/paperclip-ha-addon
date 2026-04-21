# Paperclip AI Home Assistant Add-on

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Home Assistant](https://img.shields.io/badge/Home%20Assistant-Add%20on-blue.svg)](https://www.home-assistant.io/)
[![Platform](https://img.shields.io/badge/Platform-aarch64%20%7C%20amd64-green.svg)](https://github.com/chillkiller/paperclip-ha-addon)
[![Version](https://img.shields.io/badge/Version-1.0.0-orange.svg)](https://github.com/chillkiller/paperclip-ha-addon/releases)

A complete Home Assistant add-on for [Paperclip AI](https://github.com/paperclipai/paperclip) - a powerful multi-agent orchestration platform for AI agents.

## 🌟 Features

- **Multi-Agent Orchestration**: Run and manage multiple AI agents in a unified platform
- **Full Debian Trixie Build**: Optimized container based on Debian Trixie
- **Multiple Database Support**: SQLite (default) or PostgreSQL for production
- **OpenClaw Integration**: Seamless integration with OpenClaw for advanced AI capabilities
- **Web UI & API**: Built-in web interface accessible on port 3100
- **Flexible Deployment**: Support for authenticated, public, or local deployment modes
- **Performance Tuning**: Configurable concurrency, timeouts, and heartbeat intervals
- **Backup Support**: Automated database backups with configurable retention
- **Home Assistant Native**: Full integration with Home Assistant services and configuration

## 📋 Prerequisites

- Home Assistant OS or Supervised
- Minimum 2 GB RAM (4 GB recommended)
- 10 GB free storage space
- Architecture: aarch64 or amd64

## 🚀 Installation

### Step 1: Add Repository

1. Open Home Assistant
2. Go to **Settings** → **Add-ons** → **Add-on Store**
3. Click the three dots menu → **Add repository**
4. Enter: `https://github.com/chillkiller/paperclip-ha-addon`
5. Click **Add**

### Step 2: Install Add-on

1. In the Add-on Store, find **Paperclip AI**
2. Click **Install**
3. Wait for the installation to complete

### Step 3: Configure

1. Click **Paperclip AI** → **Configuration**
2. Adjust settings as needed (see [Configuration](#configuration) below)
3. Click **Save**

### Step 4: Start

1. Click **Start**
2. Wait for the add-on to initialize
3. Click **Open Web UI** or navigate to `http://<home-assistant-ip>:3100`

## ⚙️ Configuration

### Basic Configuration

```yaml
log_level: info  # trace, debug, info, warning, error
```

### Database Configuration

**SQLite (Default)**
```yaml
database:
  type: sqlite
  sqlite_path: /share/paperclip/paperclip.db
```

**PostgreSQL (Recommended for Production)**
```yaml
database:
  type: postgres
  postgres_host: your-postgres-host
  postgres_port: 5432
  postgres_user: your-postgres-user
  postgres_password: your_secure_password
  postgres_database: paperclip
```

**PostgreSQL via Home Assistant Service**

If you have the PostgreSQL add-on installed in Home Assistant, Paperclip can automatically connect to it. Manual configuration takes priority.

### OpenClaw Integration

```yaml
openclaw:
  enabled: true
  url: http://your-openclaw-url:18790
  api_key: your_api_key_here
```

### Deployment Mode

```yaml
deployment:
  mode: authenticated  # authenticated | public | local
  exposure: private   # private | public
```

- **authenticated**: Requires authentication (default)
- **public**: Public access without authentication
- **local**: Local access only

### Features

```yaml
features:
  enable_telemetry: false
  enable_routines: true
  enable_workspaces: true
  enable_feedback: true
```

### Performance Tuning

```yaml
performance:
  max_concurrent_runs: 5
  run_timeout_minutes: 60
  heartbeat_interval_minutes: 30
```

### Backup Configuration

```yaml
backup:
  enabled: true
  retention_days: 30
  backup_path: /share/paperclip/backups
```

## 🏗️ Architecture

### Add-on Structure

```
paperclip-ha-addon/
├── repository.yaml              # Repository manifest
├── README.md                    # This file
├── LICENSE                      # MIT License
├── SECURITY.md                  # Security policy
├── CONTRIBUTING.md              # Contribution guidelines
├── CODE_OF_CONDUCT.md           # Code of conduct
└── paperclip_ha_addon/          # Add-on directory
    ├── config.json              # Add-on manifest
    ├── build.json               # Build configuration
    ├── Dockerfile               # Container definition
    ├── run.sh                   # Entrypoint script
    └── HA-COMPATIBILITY-REVIEW.md  # Compatibility review
```

### Dockerfile Layers

The Dockerfile is optimized with minimal layers:

1. **System Dependencies**: ca-certificates, curl, gosu, git, wget, ripgrep, python3, openssh-client, jq, tzdata
2. **Node.js and pnpm**: Node.js LTS with corepack/pnpm
3. **User Setup**: paperclip user and directories
4. **Paperclip Build**: Full build from source (v2026.416.0)
5. **Installation**: Copy to /app
6. **Global CLI Tools**: claude-code, codex, opencode-ai
7. **Entrypoint**: run.sh script
8. **Environment**: Production environment variables
9. **Permissions**: Rights assignment
10. **Health Check**: /health endpoint
11. **Port Expose**: 3100
12. **Entrypoint**: /usr/local/bin/run.sh

### run.sh Phases

The entrypoint script is divided into 7 phases:

1. **Configuration Load & Validation**: Load all options via bashio, validate PostgreSQL config
2. **Environment Setup**: Create directories and set permissions
3. **Paperclip Configuration Generation**: Generate config.json from HA options
4. **Environment Variable Export**: Export all Paperclip environment variables
5. **Startup Information**: Output configuration summary
6. **Health Check Setup**: Create health check files
7. **Start Paperclip**: Start the Paperclip server with signal handling

## 📁 Directory Structure

```
/share/paperclip/
├── paperclip.db          # SQLite database (if used)
├── backups/              # Backup files
├── logs/                 # Log files
├── temp/                 # Temporary files
├── uploads/              # Upload files
└── health/               # Health check status
    ├── status            # running | starting | stopped
    └── start_time        # Unix timestamp
```

## 🔧 Troubleshooting

### Add-on Won't Start

1. **Check Logs**
   - Home Assistant → Settings → Add-ons → Paperclip AI → Logs

2. **Check Storage**
   - Ensure at least 10 GB free space

3. **Check Database Connection**
   - For PostgreSQL: Verify host, port, user, password
   - For SQLite: Verify write permissions on `/share/paperclip/`

### Web UI Not Accessible

1. **Check Port**
   - Ensure port 3100 is not blocked
   - Verify firewall settings

2. **Check Add-on Status**
   - Is the add-on running?
   - Any errors in the log?

### Database Issues

**SQLite**
- Check write permissions on `/share/paperclip/`
- Ensure the directory exists

**PostgreSQL**
- Verify connection settings
- Check PostgreSQL logs
- Test connection with `psql`

## 🔄 Updates

The add-on updates automatically when a new version is available. Paperclip itself is updated through the build process.

## 🔒 Security

- **Telemetry**: Disabled by default
- **Passwords**: Securely stored in Home Assistant configuration
- **API Keys**: Treated as password fields
- **Deployment**: Authenticated mode requires authentication
- **User**: Runs as non-root user (paperclip)

See [SECURITY.md](SECURITY.md) for detailed security information.

## 📚 Documentation

- [Paperclip Documentation](https://paperclipai-paperclip.mintlify.app/)
- [Home Assistant Add-on Documentation](https://developers.home-assistant.io/docs/add-ons/)
- [OpenClaw Documentation](https://github.com/openclaw/openclaw)

## 🤝 Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## 📄 License

This add-on is licensed under the MIT License. See [LICENSE](LICENSE) for details.

Paperclip AI is licensed under its own license.

## 🆘 Support

For issues and questions:

1. **Check Logs**: Home Assistant Add-on panel
2. **Documentation**: https://paperclipai-paperclip.mintlify.app/
3. **GitHub Issues**: https://github.com/chillkiller/paperclip-ha-addon/issues

## 📊 Version Information

- **Add-on Version**: 1.0.0
- **Paperclip Version**: v2026.416.0
- **Base Image**: Debian Trixie
- **Node.js**: LTS
- **Architectures**: aarch64, amd64

## 👥 Credits

- **Paperclip AI**: https://github.com/paperclipai/paperclip
- **OpenClaw Integration**: Forge (coding-main agent)
- **Debian Trixie Port**: GaRoN

## 📢 Changelog

### Version 1.0.0

- Initial release
- Full Debian Trixie build
- SQLite and PostgreSQL support
- OpenClaw integration
- Web UI and API
- Backup support
- Performance tuning options

---

Made with ❤️ by the Home Assistant community