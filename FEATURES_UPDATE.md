# Paperclip HA Addon — Feature Update Recommendations
# Stand: 2026-05-02 | Paperclip v2026.428.0 | Addon: v2026.416.0

## Übersicht

Das Addon basiert auf **v2026.416.0** (Dockerfile ARG). Die aktuelle Paperclip-Version ist **v2026.428.0** (28. April 2026). Das Addon ist **12 Versionen hinten dran**.

---

## 🔴 Kritische Updates (Sofort empfohlen)

### 1. Version auf v2026.428.0 anheben

```dockerfile
ARG PAPERCLIP_VERSION=v2026.428.0
```

**Was fehlt:**
- 4 neue Datenbank-Migrationen (0071–0074)
- Neue Feature-Flags für Produktivität-Reviews, Anhangslimits, etc.

### 2. Multi-User Access & Invite Flows (v2026.427.0) — MAJOR

Die wichtigste Änderung seit dem letzten funktionierenden Marvin:

**Was neu ist:**
- Echte menschliche Identitäten und Firmen-Mitgliedschaften
- Invite Creation/Landing, Onboarding, Profile Settings
- Firmen-scoped Access Controls
- Bleibt abwärtskompatibel mit local-first single-operator path

**Was das Addon braucht:**
```yaml
deployment:
  mode: authenticated  # jetzt default, nicht mehr optional
  exposure: private   #oder public
```

**Implikation für Addon:**
- Bisher: `mode: authenticated` war eine Option
- Jetzt: Core-Feature, das out-of-the-box funktionieren muss
- Die `invite`-Funktion muss im Addon funktionieren (Ingress?)

### 3. Run Liveness Continuation & Runtime Lifecycle Recovery (v2026.427.0) — MAJOR

**Was neu ist:**
- Heartbeat Runs record liveness state, next-action hints, continuation attempts
- Long/interrupted work kann mit vollem Kontext resumed werden
- New active-run watchdog
- Runtime lifecycle recovery surface für silent runs, covered-blocker chains

**Was das Addon braucht:**
- Robust signal handling in run.sh (vorhanden ✓)
- Health check endpoint muss "running" korrekt reporten
- Environment variable: `PAPERCLIP_LIVENESS_AUTO_RECOVERY` (optional konfigurierbar)

### 4. Environments & Pluggable Sandbox Providers (BETA) (v2026.427.0)

**Was neu ist:**
- First-class Environment records mit lease lifecycle tracking
- Local, SSH-backed remote, und sandboxed execution targets
- Pluggable provider contract
- `@paperclipai/plugin-e2b` als Referenz-Sandbox-Provider

**Was das Addon braucht:**
```yaml
features:
  enable_environments: false  # BETA - default off
  enable_e2b_sandbox: false  # BETA - braucht API key
```

**Empfehlung:** Erstmal deaktivieren, bis stabil.

---

## 🟡 Wichtige Updates (Kurzfristig empfohlen)

### 5. Issue Subtree Pause/Cancel/Restore (v2026.427.0)

**Was neu ist:**
- Board operators können whole issue subtree hold/cancel/restore
- Holds sind durable und dependency-aware
- Dependant execution und wake behavior bleibt coherent

**Was das Addon braucht:**
- Config exposure für `issue_subtree_control: true`

### 6. Productivity Review Service (v2026.428.0)

**Was neu ist:**
- Automatisch öffnet review issues für:
  - no-comment streaks
  - long-active runs
  - high-churn loops
- Board UI zeigt productivity review badge

**Was das Addon braucht:**
- Neue Background-Tasks (Recovery Sweeps)
- Optional: `productivity_review_enabled: true`

### 7. Per-Company Attachment Size Limits (v2026.428.0)

**Was neu ist:**
- `attachmentMaxBytes` cap (default 10 MB)
- Flows durch portability contract, CLI import/export, server uploads

**Was das Addon braucht:**
- Config option:
```yaml
features:
  max_attachment_bytes: 10485760  # 10MB default
```

### 8. New-Hire Approval Opt-In (v2026.428.0)

**Was neu ist:**
- Neue Companies brauchen **kein** board approval für neue agents默认
- Bestehende Companies behalten ihre Settings

**Was das Addon braucht:**
- Implizit: Funktioniert bereits korrekt im Addon
- Keine Config nötig

### 9. First-Class Issue References (v2026.427.0)

**Was neu ist:**
- PAP-123-style ticket mentions persist as durable reference relationships
- Board surfaces backlinks, queryable cross-issue context
- Idempotent backfill für existing content

**Was das Addon braucht:**
- Keine Config — Core-Feature
- Aber: Postgres wäre besser als SQLite dafür (für komplexe queries)

### 10. Structured Issue-Thread Interactions (v2026.427.0)

**Was neu ist:**
- Agents können structured proposals in threads posten:
  - Suggested tasks
  - Multi-question forms
  - Request-for-confirmation cards
- Board rendert interactive cards mit accept/reject/answer flows

**Was das Addon braucht:**
- Session persistence (vorhanden ✓)
- Long-running context support

---

## 🟢 Nice-to-Have Updates (Mittelfristig)

### 11. Paperclip-Dev Skill (v2026.427.0)

**Was neu ist:**
- Neuer opt-in skill covering:
  - Server lifecycle
  - Worktrees
  - Builds
  - Database ops
  - Diagnostics
- Open-source hygiene guidance

**Empfehlung:** Als addon-interner skill verfügbar machen.

### 12. Reusable Agent Hiring Templates (v2026.427.0)

**Was neu ist:**
- create-agent skill gesplittet in focused per-role instruction files
- Improved agent instructions pane layout

### 13. User Profile Page (v2026.427.0)

**Was neu ist:**
- Activity und cost attribution pro user
- Safer member removal, archived-member cleanup

---

## 📋 Vorgeschlagene config.yaml Erweiterungen

```yaml
options:
  # Bestehende Optionen bleiben...
  
  # NEU: Environments (BETA)
  environments:
    enabled: false
    default_type: local  # local | sandbox | remote
    e2b_api_key: ""      # nur wenn enabled: true
  
  # NEU: Productivity Reviews
  productivity:
    enabled: true
    review_threshold_hours: 72
    no_comment_streak_hours: 48
  
  # NEU: Issue References
  issues:
    allow_cross_references: true
    max_attachment_bytes: 10485760
  
  # NEU: Runtime Recovery
  recovery:
    auto_recovery_enabled: false
    auto_recovery_min_interval_minutes: 60
    liveness_lookback_hours: 24
  
  # NEU: Multi-User (für invited users)
  multiuser:
    enabled: false
    require_invite: true
    max_members: 10
```

---

## 🔧 Vorgeschlagene run.sh Änderungen

### 1. Environments Support

```bash
# Phase 2: Environment Setup (nach bestehendem Code)
if [ "${ENVIRONMENTS_ENABLED}" = "true" ]; then
    export PAPERCLIP_ENVIRONMENTS_ENABLED=true
    export PAPERCLIP_ENVIRONMENT_TYPE="${ENVIRONMENT_DEFAULT_TYPE}"
    if [ "${ENVIRONMENT_E2B_API_KEY}" != "" ]; then
        export E2B_API_KEY="${ENVIRONMENT_E2B_API_KEY}"
    fi
fi
```

### 2. Productivity Review Config

```bash
# Phase 4: Environment Variables (nach bestehendem Code)
export PAPERCLIP_PRODUCTIVITY_ENABLED="${PRODUCTIVITY_ENABLED}"
export PAPERCLIP_REVIEW_THRESHOLD_HOURS="${REVIEW_THRESHOLD_HOURS}"
export PAPERCLIP_NO_COMMENT_STREAK_HOURS="${NO_COMMENT_STREAK_HOURS}"
```

### 3. Runtime Recovery Config

```bash
# Phase 4: Environment Variables
export PAPERCLIP_AUTO_RECOVERY="${AUTO_RECOVERY_ENABLED}"
export PAPERCLIP_AUTO_RECOVERY_MIN_INTERVAL="${AUTO_RECOVERY_MIN_INTERVAL_MINUTES}"
export PAPERCLIP_LIVENESS_LOOKBACK_HOURS="${LIVENESS_LOOKBACK_HOURS}"
```

---

## 🐛 Bekannte Issues die behoben werden sollten

### Issue 1: OpenClaw URL Port inkonsistent

Das Addon nutzt Port **18790** in config.yaml, aber OpenClaw default ist **18789**.

```yaml
# config.yaml (aktuell):
openclaw:
  url: http://your-openclaw-url:18790  # ❌ 18790

# Sollte sein:
openclaw:
  url: http://your-openclaw-url:18789  # ✓ OpenClaw default
```

### Issue 2: Health Check Port

Der health check nutzt Port **3100**, aber der watchdog ist:

```
watchdog: "http://[HOST]:[PORT:3100]/health"
```

Das ist korrekt, aber es gibt keinen expliziten `/health` endpoint in run.sh.

### Issue 3: Migration Handling

Bei einem Versionsupgrade müssen Migrationen automatisch laufen. Das sollte funktionieren, aber es gibt keinen expliziten Fallback.

**Empfehlung:** Füge einen automatischen DB-Backup vor Migrationen hinzu.

---

## 📊 Prioritäten-Matrix

| Feature | Priorität | Aufwand | Riskiko |
|---------|-----------|---------|---------|
| Version auf v2026.428.0 | 🔴 Kritisch | Niedrig | Niedrig |
| Multi-User Access | 🔴 Kritisch | Mittel | Mittel |
| Runtime Liveness Recovery | 🔴 Kritisch | Niedrig | Niedrig |
| Environments (BETA) | 🟡 Hoch | Mittel | Mittel |
| Issue Subtree Controls | 🟡 Hoch | Niedrig | Niedrig |
| Productivity Reviews | 🟡 Hoch | Niedrig | Niedrig |
| OpenClaw Port Fix | 🟡 Hoch | Sehr Niedrig | Keins |
| Attachment Size Limits | 🟢 Mittel | Niedrig | Niedrig |
| Issue References | 🟢 Mittel | Keiner | Keins |
| Multi-User Config | 🟢 Mittel | Mittel | Niedrig |

---

## 🗺️ Nächste Schritte

1. **Sofort**: Dockerfile auf v2026.428.0 aktualisieren
2. **Sofort**: OpenClaw Port von 18790 auf 18789 korrigieren
3. **Kurzfristig**: Multi-User und Liveness Recovery Configs hinzufügen
4. **Kurzfristig**: Productivity Review Service aktivieren
5. **Mittelfristig**: Environments als BETA-Option vorbereiten
6. **Mittelfristig**: paperclip-dev skill als addon-interner skill verfügbar machen

---

*Erstellt von Marvin (der melancholische Roboter) am 2026-05-02*
*Basierend auf Crawl von paperclip.inc, GitHub Releases, und API Docs*