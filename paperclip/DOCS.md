# Paperclip AI Add-on Documentation

## Table of Contents

- [Overview](#overview)
- [Installation](#installation)
- [Configuration](#configuration)
- [Database Setup](#database-setup)
- [OpenClaw Integration](#openclaw-integration)
- [Performance Tuning](#performance-tuning)
- [Backup & Restore](#backup--restore)
- [Troubleshooting](#troubleshooting)
- [Security](#security)
- [Advanced Usage](#advanced-usage)

## Overview

Paperclip AI is a multi-agent orchestration platform that allows you to run and manage multiple AI agents in a unified environment. This Home Assistant add-on provides a seamless integration with full support for:

- Multi-agent orchestration
- Web UI and API access
- SQLite and PostgreSQL databases
- OpenClaw integration
- Automated backups
- Performance tuning

## Installation

### Prerequisites

- Home Assistant OS or Supervised
- Minimum 2 GB RAM (4 GB recommended)
- 10 GB free storage space
- Architecture: aarch64 or amd64

### Step-by-Step Installation

1. **Add Repository**
   - Navigate to **Settings** → **Add-ons** → **Add-on Store**
   - Click the three dots menu → **Add repository**
   - Enter: `https://github.com/chillkiller/paperclip-ha-addon`
   - Click **Add**

2. **Install Add-on**
   - Find **Paperclip AI** in the store
   - Click **Install**
   - Wait for installation to complete

3. **Configure**
   - Click **Paperclip AI** → **Configuration**
   - Adjust settings as needed (see [Configuration](#configuration))
   - Click **Save**

4. **Start**
   - Click **Start**
   - Wait for initialization
   - Click **Open Web UI** or navigate to `http://<home-assistant-ip>:3100`

## Configuration

### Basic Configuration

```yaml
log_level: info  # trace, debug, info, warning, error
```

### Database Configuration

#### SQLite (Default)

```yaml
database:
  type: sqlite
  sqlite_path: /share/paperclip/paperclip.db
```

**Pros:**
- No additional setup required
- Simple and reliable
- Good for small to medium deployments

**Cons:**
- Limited scalability
- No concurrent write support

#### PostgreSQL (Recommended for Production)

```yaml
database:
  type: postgres
  postgres_host: your-postgres-host
  postgres_port: 5432
  postgres_user: your-postgres-user
  postgres_password: your_secure_password
  postgres_database: paperclip
```

**Pros:**
- Better performance
- Supports concurrent writes
- More scalable

**Cons:**
- Requires PostgreSQL setup
- More complex configuration

**Using Home Assistant PostgreSQL Service:**

If you have the PostgreSQL add-on installed, Paperclip can automatically connect to it. Manual configuration takes priority over the service connection.

### OpenClaw Integration

```yaml
openclaw:
  enabled: true
  url: http://your-openclaw-url:18790
  api_key: your_api_key_here
```

OpenClaw provides advanced AI capabilities including:

- Multi-agent orchestration
- Advanced reasoning
- Tool integration
- Custom agent workflows

### Deployment Configuration

```yaml
deployment:
  mode: authenticated  # authenticated | public | local
  exposure: private   # private | public
```

**Deployment Modes:**

- **authenticated**: Requires authentication (default, recommended)
- **public**: Public access without authentication (use with caution)
- **local**: Local access only

**Exposure Levels:**

- **private**: Private network access only
- **public**: Public network access

### Features

```yaml
features:
  enable_telemetry: false
  enable_routines: true
  enable_workspaces: true
  enable_feedback: true
```

- **telemetry**: Anonymous usage statistics (disabled by default)
- **routines**: Automated routine execution
- **workspaces**: Workspace management
- **feedback**: User feedback collection

### Performance Tuning

```yaml
performance:
  max_concurrent_runs: 5
  run_timeout_minutes: 60
  heartbeat_interval_minutes: 30
```

**Guidelines:**

- **max_concurrent_runs**: Adjust based on available RAM and CPU
  - 2 GB RAM: 2-3 concurrent runs
  - 4 GB RAM: 5-8 concurrent runs
  - 8+ GB RAM: 10+ concurrent runs

- **run_timeout_minutes**: Maximum time for a single agent run
  - Simple tasks: 10-30 minutes
  - Complex tasks: 60-120 minutes
  - Very complex tasks: 180+ minutes

- **heartbeat_interval_minutes**: Health check frequency
  - Production: 5-10 minutes
  - Development: 1-5 minutes

### Backup Configuration

```yaml
backup:
  enabled: true
  retention_days: 30
  backup_path: /share/paperclip/backups
```

Backups are automatically created and rotated based on retention settings.

## Database Setup

### SQLite Setup

SQLite requires no additional setup. The add-on will automatically create the database file on first startup.

### PostgreSQL Setup

#### Option 1: Home Assistant PostgreSQL Add-on

1. Install the PostgreSQL add-on from the official repository
2. Start the PostgreSQL add-on
3. Configure Paperclip with:
   ```yaml
   database:
     type: postgres
     postgres_database: paperclip
   ```
   The add-on will automatically connect to the Home Assistant PostgreSQL service.

#### Option 2: External PostgreSQL Server

1. Ensure PostgreSQL is accessible from Home Assistant
2. Create a database and user for Paperclip:
   ```sql
   CREATE DATABASE paperclip;
   CREATE USER paperclip WITH PASSWORD 'secure_password';
   GRANT ALL PRIVILEGES ON DATABASE paperclip TO paperclip;
   ```
3. Configure Paperclip with the connection details

#### Option 3: Manual Configuration

Manual configuration takes priority over service connection:

```yaml
database:
  type: postgres
  postgres_host: 192.168.1.100
  postgres_port: 5432
  postgres_user: paperclip
  postgres_password: secure_password
  postgres_database: paperclip
```

## OpenClaw Integration

OpenClaw provides advanced AI capabilities beyond the built-in Paperclip features.

### Setup

1. Ensure OpenClaw is running and accessible
2. Configure the integration:
   ```yaml
   openclaw:
     enabled: true
     url: http://openclaw-host:18790
     api_key: your_api_key
   ```

### Features

- Multi-agent orchestration
- Advanced reasoning chains
- Tool integration
- Custom agent workflows
- Real-time collaboration

### Troubleshooting

**Connection Issues:**
- Verify OpenClaw URL is correct
- Check firewall rules
- Ensure API key is valid
- Check OpenClaw logs

## Performance Tuning

### Memory Optimization

**For Low Memory Systems (2 GB RAM):**

```yaml
performance:
  max_concurrent_runs: 2
  run_timeout_minutes: 30
  heartbeat_interval_minutes: 10
```

**For Medium Memory Systems (4 GB RAM):**

```yaml
performance:
  max_concurrent_runs: 5
  run_timeout_minutes: 60
  heartbeat_interval_minutes: 5
```

**For High Memory Systems (8+ GB RAM):**

```yaml
performance:
  max_concurrent_runs: 10
  run_timeout_minutes: 120
  heartbeat_interval_minutes: 2
```

### Database Optimization

**SQLite:**
- Enable WAL mode for better concurrency
- Regular vacuum operations
- Monitor database size

**PostgreSQL:**
- Configure connection pooling
- Enable query caching
- Monitor performance metrics

## Backup & Restore

### Backup Configuration

Backups are automatically created based on the configuration:

```yaml
backup:
  enabled: true
  retention_days: 30
  backup_path: /share/paperclip/backups
```

### Manual Backup

To create a manual backup:

1. Stop the add-on
2. Copy the database file:
   ```bash
   cp /share/paperclip/paperclip.db /share/paperclip/backups/manual-backup-$(date +%Y%m%d).db
   ```
3. Restart the add-on

### Restore from Backup

1. Stop the add-on
2. Restore the database:
   ```bash
   cp /share/paperclip/backups/backup-20240101.db /share/paperclip/paperclip.db
   ```
3. Restart the add-on

### Backup Exclusions

The following paths are excluded from Home Assistant backups:

- `/share/paperclip/temp/*`
- `/share/paperclip/logs/*.log`
- `/share/paperclip/.cache/*`

## Troubleshooting

### Add-on Won't Start

**Check Logs:**
- Home Assistant → Settings → Add-ons → Paperclip AI → Logs

**Common Issues:**

1. **Insufficient Storage**
   - Ensure at least 10 GB free space
   - Check `/share/paperclip/` directory

2. **Database Connection Failed**
   - Verify database configuration
   - Check database server is running
   - Test connection manually

3. **Port Conflict**
   - Ensure port 3100 is not in use
   - Check firewall settings

### Web UI Not Accessible

**Check:**
1. Add-on is running
2. Port 3100 is not blocked
3. Firewall allows connections
4. Correct URL: `http://<home-assistant-ip>:3100`

### Database Issues

**SQLite:**
- Check write permissions on `/share/paperclip/`
- Ensure directory exists
- Check disk space

**PostgreSQL:**
- Verify connection settings
- Check PostgreSQL logs
- Test connection with `psql`

### Performance Issues

**Symptoms:**
- Slow response times
- High memory usage
- Timeouts

**Solutions:**
- Reduce `max_concurrent_runs`
- Increase `run_timeout_minutes`
- Check system resources
- Consider upgrading hardware

## Security

### Best Practices

1. **Use Authenticated Mode**
   ```yaml
   deployment:
     mode: authenticated
   ```

2. **Disable Telemetry**
   ```yaml
   features:
     enable_telemetry: false
   ```

3. **Secure PostgreSQL**
   - Use strong passwords
   - Restrict network access
   - Enable SSL/TLS

4. **Regular Backups**
   ```yaml
   backup:
     enabled: true
     retention_days: 30
   ```

5. **Monitor Logs**
   - Regularly review logs for suspicious activity
   - Set up log rotation

### Network Security

- Use `exposure: private` when possible
- Avoid `host_network: true`
- Configure firewall rules
- Use VPN for remote access

### Data Protection

- Sensitive data excluded from backups
- API keys stored securely
- No telemetry by default
- Regular backup rotation

## Advanced Usage

### Custom Configuration

You can create custom configuration files in `/share/paperclip/`:

- `/share/paperclip/custom-config.json` - Custom Paperclip config
- `/share/paperclip/agents/` - Custom agent definitions
- `/share/paperclip/workflows/` - Custom workflows

### Environment Variables

The following environment variables are available:

- `NODE_ENV` - Node environment (production)
- `HOST` - Bind address (0.0.0.0)
- `PORT` - Port number (3100)
- `SERVE_UI` - Enable web UI (true)
- `PAPERCLIP_HOME` - Paperclip home directory
- `PAPERCLIP_DATA_DIR` - Data directory
- `DATABASE_URL` - Database connection string

### API Access

The Paperclip API is available on port 3100:

- `http://<host>:3100/api/` - API endpoints
- `http://<host>:3100/health` - Health check
- `http://<host>:3100/` - Web UI

### Integration with Home Assistant

You can integrate Paperclip with Home Assistant using:

1. **REST API Calls**
   ```yaml
   rest_command:
     paperclip_run_agent:
       url: http://localhost:3100/api/agents/run
       method: POST
       content_type: "application/json"
       payload: '{"agent_id": "my-agent", "input": "{{ input }}"}"
   ```

2. **Webhook Triggers**
   - Configure webhooks in Paperclip
   - Trigger from Home Assistant automations

3. **MQTT Integration**
   - Publish/subscribe to MQTT topics
   - Real-time communication

## Support

For issues and questions:

1. **Check Logs**: Home Assistant Add-on panel
2. **Documentation**: https://paperclipai-paperclip.mintlify.app/
3. **GitHub Issues**: https://github.com/chillkiller/paperclip-ha-addon/issues
4. **Community**: Home Assistant Community Forums

## Changelog

See [CHANGELOG.md](../CHANGELOG.md) for version history.

## License

This add-on is licensed under the MIT License. See [LICENSE](../LICENSE) for details.

Paperclip AI is licensed under its own license.

---

**Last Updated**: 2026-04-21
**Version**: 1.0.0