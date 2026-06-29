# Audit Request - paperclip-ha-addon Repository Perfection

## Context
This audit request is for the paperclip-ha-addon repository optimization project.
Date: 2026-04-21
Agent: Forge (coding-main)
Task: Perfect the repository according to Home Assistant best practices

## Identified Issues

### 1. File Naming Convention Violations (HIGH PRIORITY)
**Problem:** Home Assistant add-ons use `.yaml` extension, not `.json`
- `config.json` → should be `config.yaml`
- `build.json` → should be `build.yaml`

**Impact:** May cause compatibility issues with Home Assistant Supervisor
**Reference:** https://developers.home-assistant.io/docs/add-ons/configuration/

### 2. Dockerfile Security Issues (HIGH PRIORITY)

#### 2.1 Incorrect User Switch Tool
**Problem:** Using `gosu` which is not available in HA base images
- HA base images use `su-exec` instead
- Current Dockerfile uses `gosu` in Layer 3

**Impact:** Build will fail or user switch won't work properly
**Fix:** Replace `gosu` with `su-exec`

#### 2.2 Missing Health Check
**Problem:** No HEALTHCHECK instruction in Dockerfile
**Impact:** Supervisor cannot properly monitor add-on health
**Fix:** Add HEALTHCHECK for port 3100

#### 2.3 Unnecessary Global CLI Tools (MEDIUM PRIORITY)
**Problem:** Installing global CLI tools that may not be needed:
- `@anthropic-ai/claude-code@latest`
- `@openai/codex@latest`
- `opencode-ai`

**Impact:** Increases attack surface, larger image size, potential security risks
**Fix:** Remove or make optional

#### 2.4 Missing AppArmor Profile Reference
**Problem:** No explicit AppArmor profile reference in Dockerfile
**Impact:** Security posture unclear
**Fix:** Add LABEL for AppArmor profile

### 3. repository.yaml Issues (MEDIUM PRIORITY)

#### 3.1 Maintainer Format
**Problem:** `maintainer` field contains only name, not email
- Current: `maintainer: GaRoN`
- Should be: `maintainer: GaRoN <email@example.com>`

**Impact:** Users cannot contact maintainer for support
**Fix:** Add email address

### 4. Missing Security Features (MEDIUM PRIORITY)

#### 4.1 No Codenotary Signature
**Problem:** No `codenotary` configuration in build.yaml
**Impact:** No image signature verification
**Fix:** Add codenotary configuration

#### 4.2 No Watchdog URL
**Problem:** No `watchdog` URL in config.yaml
**Impact:** Supervisor cannot monitor add-on health
**Fix:** Add watchdog URL pointing to health endpoint

#### 4.3 No Backup Exclusion
**Problem:** No `backup_exclude` in config.yaml
**Impact:** Sensitive data may be included in backups
**Fix:** Add backup_exclude for temporary files, logs, etc.

### 5. Additional Observations

#### 5.1 Good Practices Already Implemented
- ✅ `host_network: false`
- ✅ `apparmor: "default"`
- ✅ `full_access: false`
- ✅ `privileged: []`
- ✅ Non-root user in Dockerfile
- ✅ `ingress: true`

#### 5.2 Potential Improvements
- Consider adding `init: false` if using custom init system
- Consider adding `stage: stable` (currently defaults to stable)
- Consider adding `timeout` for startup

## Questions for Audit

1. **Are all identified issues correct?**
   - Please validate each issue and confirm if it's a real problem

2. **Are there additional issues?**
   - Please review the entire repository for any other problems

3. **Priority ranking:**
   - Please rank the issues by priority (Critical, High, Medium, Low)

4. **Implementation guidance:**
   - Please provide specific implementation guidance for each fix

## Files to Review

- `/share/projekte/github/paperclip-ha-addon/repository.yaml`
- `/share/projekte/github/paperclip-ha-addon/paperclip_ha_addon/config.json`
- `/share/projekte/github/paperclip-ha-addon/paperclip_ha_addon/build.json`
- `/share/projekte/github/paperclip-ha-addon/paperclip_ha_addon/Dockerfile`
- `/share/projekte/github/paperclip-ha-addon/paperclip_ha_addon/run.sh`
- `/share/projekte/github/paperclip-ha-addon/README.md`

## References

- Home Assistant Add-on Configuration: https://developers.home-assistant.io/docs/add-ons/configuration/
- Home Assistant Add-on Security: https://developers.home-assistant.io/docs/add-ons/security.md
- Home Assistant Base Images: https://github.com/home-assistant/docker-base