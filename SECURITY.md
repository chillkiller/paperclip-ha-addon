# Security Policy

## Supported Versions

| Version | Supported |
|---------|-----------|
| 1.0.x   | ✅ Yes     |

## Reporting a Vulnerability

If you discover a security vulnerability, please report it privately to avoid putting users at risk.

**How to Report:**

1. Send an email to: garon@example.com
2. Include:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if known)

**Response Time:**

We aim to respond within 48 hours and provide a fix within 7 days for critical vulnerabilities.

## Security Best Practices

### For Users

- Keep the add-on updated to the latest version
- Use strong passwords for database connections
- Enable authentication in production deployments
- Review logs regularly for suspicious activity
- Use PostgreSQL instead of SQLite for production

### For Developers

- Never commit secrets or API keys
- Use environment variables for sensitive data
- Follow the principle of least privilege
- Keep dependencies updated
- Review code changes for security implications

## Known Security Considerations

### Database Security

- SQLite databases are stored in `/share/paperclip/` with read/write access
- PostgreSQL credentials are stored in Home Assistant's encrypted configuration
- Database connections use TLS when available

### Network Security

- The add-on exposes port 3100 for the web UI
- By default, the deployment mode is "authenticated"
- Consider using a reverse proxy with SSL for production

### API Keys

- OpenClaw API keys are stored as password fields in the configuration
- Keys are never logged or exposed in error messages

## Dependency Updates

This add-on tracks security vulnerabilities in its dependencies:

- Node.js LTS (tracked via NodeSource)
- npm packages (tracked via npm audit)
- Debian packages (tracked via Debian Security Advisory)

## Security Audits

This add-on has been reviewed for Home Assistant compatibility and security best practices.

---

For questions about security, please contact: garon@example.com