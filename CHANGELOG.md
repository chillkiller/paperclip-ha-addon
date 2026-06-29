# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Custom AppArmor profile for enhanced security
- Health check script with status tracking
- Translation support (English)
- Comprehensive documentation (DOCS.md)
- Asset guidelines (ASSETS.md)
- SQLite3 and libsqlite3-dev for database support
- Web UI URL configuration
- Health status tracking in `/share/paperclip/health/`

### Changed
- Fixed BUILD_FROM argument for Supervisor 2026.04.0+ compatibility
- Enhanced startup sequence with health monitoring
- Improved signal handling for graceful shutdown
- Updated health check start period to 60s

### Security
- Added custom AppArmor profile
- Enhanced health check with process verification
- Improved startup validation

## [1.0.0] - 2026-04-21

### Added
- Initial release of Paperclip AI Home Assistant Add-on
- Multi-Agent Orchestration Platform for AI Agents
- Full Debian Trixie build environment
- Web UI and API endpoint (port 3100)
- Ingress integration for Home Assistant panel access
- SQLite and PostgreSQL database support
- OpenClaw integration for agent management
- Configurable deployment modes (authenticated, public, local)
- Comprehensive backup and retention system

### Features
- Multi-agent orchestration platform
- Support for aarch64 and amd64 architectures
- Application-based startup with auto-boot
- Ingress panel integration with robot icon
- Configurable log levels (trace, debug, info, warning, error)
- Database type selection (SQLite or PostgreSQL)
- OpenClaw URL and API key configuration
- Deployment exposure control (private or public)
- Feature toggles for telemetry, routines, workspaces, and feedback
- Performance tuning (max concurrent runs, timeout, heartbeat interval)
- Automated backup system with configurable retention

### Configuration
- Log level configuration
- Database settings (type, SQLite path, PostgreSQL connection details)
- OpenClaw integration (enabled/disabled, URL, API key)
- Deployment mode (authenticated, public, local)
- Exposure settings (private, public)
- Feature flags (telemetry, routines, workspaces, feedback)
- Performance settings (max concurrent runs, timeout, heartbeat interval)
- Backup configuration (enabled, retention days, backup path)

### Security
- Non-root user execution (paperclip user)
- AppArmor enabled (default profile)
- No host network
- No full access
- No privileged access
- Health monitoring via watchdog
- Backup exclusions for sensitive data
- Image signing configuration (Codenotary)

### Documentation
- Comprehensive README with installation and configuration
- Security policy
- Contributing guidelines
- Code of conduct
- License information

### Dockerfile
- Multi-stage build for optimization
- Minimal system dependencies
- Node.js LTS with pnpm
- Health check endpoint
- Proper user permissions
- Security labels

### Build Configuration
- Support for aarch64 and amd64
- Pinned Paperclip version (v2026.416.0)
- Codenotary image signing

### Repository
- Repository manifest for Home Assistant Add-on Store
- Maintainer contact information
- Project description and URL

## [0.1.0] - 2026-04-20

### Added
- Initial project structure
- Basic Dockerfile
- Configuration files
- Repository manifest

---

[Unreleased]: https://github.com/chillkiller/paperclip-ha-addon/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/chillkiller/paperclip-ha-addon/releases/tag/v1.0.0
[0.1.0]: https://github.com/chillkiller/paperclip-ha-addon/releases/tag/v0.1.0