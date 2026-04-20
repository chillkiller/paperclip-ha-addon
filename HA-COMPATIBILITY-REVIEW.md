# HA-Add-on Kompatibilitäts-Checkliste (Paperclip AI)

## 🚨 Kritische Blokker (Build bricht sofort ab)

- [ ] **config.json** → Entferne `map`, füge `ingress: true` hinzu
- [ ] **Dockerfile** → Füge `BUILD_FROM` Validierung hinzu
- [ ] **run.sh** → Ersetze `bashio::config.equals` durch `[ "$(bashio::config 'key')" = 'value' ]`

## 🟠 Architektonische Korrektheit (Build läuft, aber Instabilität)

- [ ] **Dockerfile HEALTHCHECK** → Entferne oder implementiere `/health`-Route in Paperclip
- [ ] **run.sh PostgreSQL** → Prüfe Manual-Config **vor** HA-Service
- [ ] **run.sh Signal Handling** → Füge `trap cleanup SIGTERM` hinzu

## 🟡 Best Practices (Nicht-brichend, aber Wartbarkeit)

- [ ] **Dockerfile pnpm** → Pinne Version (`pnpm@9.15.2`)
- [ ] **config.json** → Füge `full_access: false` hinzu
- [ ] **run.sh PAPERCLIP_HOME** → Einheitlich `/share/paperclip` statt `/paperclip`

## 📊 Status

- **Bislang identifizierte Fehler:** 8
- **Kritische (Build-breaker):** 3
- **Architektonische (Laufzeitfehler):** 5

---

## 🔧 Fix-Liste (Reihenfolge)

1. **config.json**
   ```json
   {
     "ingress": true,
     "panel_icon": "mdi:robot-outline",
     // Entferne "map": ["share:rw"]
   }
   ```

2. **Dockerfile**
   ```dockerfile
   ARG BUILD_FROM
   RUN if [ -z "$BUILD_FROM" ]; then echo "BUILD_FROM must be set" && exit 1; fi
   FROM ${BUILD_FROM}
   # ...
   RUN corepack prepare pnpm@9.15.2 --activate
   # Entferne HEALTHCHECK
   ```

3. **run.sh**
   ```bash
   # Ersetze bashio::config.equals
   if [ "$(bashio::config 'log_level')" = "debug" ]; then
       set -x
       bashio::log.info "Debug mode enabled"
   fi

   # PostgreSQL-Prüfung neu ordnen (Manual vor HA-Service)
   if [ -n "$(bashio::config 'database.postgres_host')" ]; then
       # Manual config
   elif bashio::services.available "postgres"; then
       # HA-Service
   else
       bashio::log.error "No PostgreSQL configuration available"
       exit 1
   fi

   # Vor exec node
   cleanup() {
       bashio::log.info "Shutting down Paperclip..."
       exit 0
   }
   trap cleanup SIGTERM SIGINT
   ```

---

*Review durch Audit • Logische Inquisition • 2026-04-20*
