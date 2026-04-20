# Paperclip AI Home Assistant Add-on

Home Assistant Add-on für Paperclip AI - Multi-Agent Orchestration Platform.

## Übersicht

Dies ist ein vollständiges Home Assistant Add-on, das Paperclip AI auf Debian Trixie Basis bereitstellt. Paperclip ist eine Open-Source-Plattform für die Orchestrierung von KI-Agenten.

## Add-on Struktur

Dieses Add-on folgt der Standard-Home Assistant Add-on Struktur:

```
paperclip-ha-addon/
├── config.json          # Add-on Manifest (UI-Konfiguration)
├── Dockerfile           # Container-Definition (Debian Trixie)
├── run.sh              # Entrypoint-Script (bashio-basiert)
├── build.json          # Build-Konfiguration
└── README.md           # Dokumentation
```

## Installation

### Voraussetzungen

- Home Assistant OS oder Supervised
- Mindestens 2 GB RAM (4 GB empfohlen)
- 10 GB freier Speicherplatz
- Architektur: aarch64 oder amd64

### Schritte

1. **Repository hinzufügen**
   
   Füge dieses Repository zu Home Assistant hinzu:
   ```
   https://github.com/chillkiller/paperclip-ha-addon
   ```

2. **Add-on installieren**
   
   Öffne Home Assistant → Einstellungen → Add-ons → Add-on Store → Installiere "Paperclip AI"

3. **Konfigurieren**
   
   Klicke auf "Paperclip AI" → Konfiguration und passe die Einstellungen an

4. **Starten**
   
   Klicke auf "Starten"

5. **Web UI öffnen**
   
   Öffne `http://<home-assistant-ip>:3100` im Browser

## Konfiguration

### Add-on Manifest (config.json)

Das Add-on Manifest definiert alle verfügbaren Konfigurationsoptionen, die in der Home Assistant UI angezeigt werden.

#### Struktur

```json
{
  "name": "Paperclip AI",
  "version": "1.0.0",
  "slug": "paperclip",
  "arch": ["aarch64", "amd64"],
  "ports": {
    "3100/tcp": 3100
  },
  "map": ["share:rw"],
  "services": ["mysql:want", "postgresql:want"],
  "options": { ... },
  "schema": { ... }
}
```

#### Wichtige Felder

- **slug**: Eindeutiger Bezeichner für das Add-on
- **arch**: Unterstützte Architekturen
- **ports**: Exponierte Ports
- **map**: Gemountete Verzeichnisse (share:rw für Daten)
- **services**: Optionale Home Assistant Services (PostgreSQL)
- **options**: Standardwerte für Konfiguration
- **schema**: Validierung und Typen für Konfigurationsfelder

### Konfigurationsoptionen

#### Log Level
```yaml
log_level: info  # trace, debug, info, warning, error
```

#### Datenbank-Konfiguration

**SQLite (Standard)**
```yaml
database:
  type: sqlite
  sqlite_path: /share/paperclip/paperclip.db
```

**PostgreSQL (Empfohlen für Produktion)**
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
Wenn der PostgreSQL-Add-on in Home Assistant installiert ist, kann das Paperclip Add-on automatisch darauf zugreifen. Die manuelle Konfiguration hat Priorität.

#### OpenClaw Integration
```yaml
openclaw:
  enabled: true
  url: http://your-openclaw-url:18790
  api_key: your_api_key_here
```

#### Deployment-Modus
```yaml
deployment:
  mode: authenticated  # authenticated | public | local
  exposure: private   # private | public
```

- **authenticated**: Erfordert Authentifizierung (Standard)
- **public**: Öffentlicher Zugriff ohne Authentifizierung
- **local**: Nur lokaler Zugriff

#### Features
```yaml
features:
  enable_telemetry: false
  enable_routines: true
  enable_workspaces: true
  enable_feedback: true
```

#### Performance-Tuning
```yaml
performance:
  max_concurrent_runs: 5
  run_timeout_minutes: 60
  heartbeat_interval_minutes: 30
```

#### Backup-Konfiguration
```yaml
backup:
  enabled: true
  retention_days: 30
  backup_path: /share/paperclip/backups
```

## Dockerfile (Debian Trixie)

### Layer-Struktur

Das Dockerfile ist in optimierte Layer unterteilt:

1. **System Dependencies**: ca-certificates, curl, gosu, git, wget, ripgrep, python3, openssh-client, jq, tzdata
2. **Node.js und pnpm**: Node.js LTS mit corepack/pnpm
3. **User Setup**: paperclip Benutzer und Verzeichnisse
4. **Paperclip Build**: Vollständiger Build aus Source (v2026.416.0)
5. **Installation**: Kopieren nach /app
6. **Global CLI Tools**: claude-code, codex, opencode-ai
7. **Entrypoint**: run.sh Script
8. **Environment**: Produktions-Environment-Variablen
9. **Permissions**: Rechte-Zuweisung
10. **Health Check**: /health Endpoint
11. **Port Expose**: 3100
12. **Entrypoint**: /usr/local/bin/run.sh

### Optimierungen

- **Minimale Layer**: Reduziert Image-Größe
- **Cache-Friendly**: Unveränderliche Layer zuerst
- **Clean-up**: apt-get clean und rm -rf /var/lib/apt/lists/*
- **User Switch**: Sicherheit durch Nicht-Root-Benutzer

## run.sh (Entrypoint-Script)

### Phasen

Das run.sh Script ist in 7 Phasen unterteilt:

#### Phase 1: Konfigurations-Ladung und -Validierung
- Laden aller Konfigurationsoptionen via bashio
- Validierung von PostgreSQL-Konfiguration
- Service-Discovery für Home Assistant PostgreSQL

#### Phase 2: Environment-Setup
- Erstellung aller notwendigen Verzeichnisse
- Setzen von Berechtigungen

#### Phase 3: Paperclip-Konfigurations-Generierung
- Generierung von config.json aus HA-Options
- Validierung der generierten Konfiguration

#### Phase 4: Environment-Variable-Export
- Export aller Paperclip-Environment-Variablen
- Telemetrie-Deaktivierung wenn gewünscht

#### Phase 5: Startup-Informationen
- Ausgabe der Konfigurations-Zusammenfassung
- Logging aller wichtigen Parameter

#### Phase 6: Health-Check-Setup
- Erstellung von Health-Check-Dateien
- Initialer Status-Set

#### Phase 7: Start von Paperclip
- Start des Paperclip-Servers
- Signal-Handling via exec

### bashio Integration

Das Script verwendet die Home Assistant bashio Bibliothek:

- `bashio::config 'key'`: Lesen von Konfigurationsoptionen
- `bashio::log.info "message"`: Logging
- `bashio::services.available "service"`: Service-Discovery
- `bashio::services "service" "key"`: Service-Konfiguration lesen

## Ports

- **3100/tcp**: Paperclip Web UI & API

## Verzeichnisstruktur

```
/share/paperclip/
├── paperclip.db          # SQLite Datenbank (falls verwendet)
├── backups/              # Backup-Dateien
├── logs/                 # Log-Dateien
├── temp/                 # Temporäre Dateien
├── uploads/              # Upload-Dateien
└── health/               # Health-Check-Status
    ├── status            # running | starting | stopped
    └── start_time        # Unix-Timestamp
```

## Fehlersuche

### Add-on startet nicht

1. **Logs prüfen**
   - Home Assistant → Einstellungen → Add-ons → Paperclip AI → Logs

2. **Speicherplatz prüfen**
   - Mindestens 10 GB freier Speicherplatz erforderlich

3. **Datenbank-Verbindung prüfen**
   - Bei PostgreSQL: Host, Port, User, Password korrekt?
   - Bei SQLite: Schreibrechte auf /share/paperclip/?

### Web UI nicht erreichbar

1. **Port prüfen**
   - Port 3100 nicht blockiert?
   - Firewall-Einstellungen korrekt?

2. **Add-on Status prüfen**
   - Läuft das Add-on?
   - Keine Fehler im Log?

### Datenbank-Probleme

**SQLite**
- Prüfe Schreibrechte auf `/share/paperclip/`
- Stelle sicher, dass das Verzeichnis existiert

**PostgreSQL**
- Verifiziere Verbindungseinstellungen
- Prüfe PostgreSQL-Logs
- Teste Verbindung mit `psql`

## Updates

Das Add-on wird automatisch aktualisiert, wenn eine neue Version verfügbar ist. Paperclip selbst wird über den Build-Prozess aktualisiert.

## Sicherheit

- **Telemetrie**: Standardmäßig deaktiviert
- **Passwörter**: Sicher in HA-Konfiguration gespeichert
- **API-Keys**: Als password-Felder behandelt
- **Deployment**: authenticated-Modus erfordert Authentifizierung
- **User**: Läuft als Nicht-Root-Benutzer (paperclip)

## Credits

- **Paperclip AI**: https://github.com/paperclipai/paperclip
- **OpenClaw Integration**: Forge (coding-main agent)
- **Debian Trixie Port**: GaRoN

## Lizenz

Dieses Add-on steht unter der MIT License. Paperclip AI steht unter seiner eigenen Lizenz.

## Support

Für Probleme und Fragen:

1. **Logs prüfen**: Home Assistant Add-on Panel
2. **Dokumentation**: https://paperclipai-paperclip.mintlify.app/
3. **GitHub Issues**: https://github.com/chillkiller/paperclip-ha-addon/issues

## Version

- **Add-on Version**: 1.0.0
- **Paperclip Version**: v2026.416.0
- **Base Image**: Debian Trixie
- **Node.js**: LTS
- **Architekturen**: aarch64, amd64