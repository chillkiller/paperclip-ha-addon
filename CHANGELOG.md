# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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