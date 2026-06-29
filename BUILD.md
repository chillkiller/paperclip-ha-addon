# Build Instructions for Paperclip AI Add-on

## Table of Contents

- [Prerequisites](#prerequisites)
- [Local Build](#local-build)
- [GitHub Actions Build](#github-actions-build)
- [Testing](#testing)
- [Release](#release)
- [Troubleshooting](#troubleshooting)

## Prerequisites

### Required Tools

- Docker
- Git
- Home Assistant Supervisor (for testing)
- GitHub account (for GitHub Actions)

### System Requirements

- Minimum 4 GB RAM
- 20 GB free disk space
- Linux, macOS, or Windows with WSL2

## Local Build

### Step 1: Clone Repository

```bash
git clone https://github.com/chillkiller/paperclip-ha-addon.git
cd paperclip-ha-addon
```

### Step 2: Build for Specific Architecture

#### Build for aarch64 (ARM64)

```bash
docker build \
  --build-arg BUILD_FROM=ghcr.io/home-assistant/aarch64-base-debian:trixie \
  --build-arg PAPERCLIP_VERSION=v2026.416.0 \
  --tag paperclip-ha-addon:aarch64 \
  --file paperclip_ha_addon/Dockerfile \
  paperclip_ha_addon/
```

#### Build for amd64 (x86_64)

```bash
docker build \
  --build-arg BUILD_FROM=ghcr.io/home-assistant/amd64-base-debian:trixie \
  --build-arg PAPERCLIP_VERSION=v2026.416.0 \
  --tag paperclip-ha-addon:amd64 \
  --file paperclip_ha_addon/Dockerfile \
  paperclip_ha_addon/
```

### Step 3: Test Build

```bash
# Run the container
docker run -d \
  --name paperclip-test \
  -p 3100:3100 \
  -v $(pwd)/test-data:/share/paperclip \
  paperclip-ha-addon:amd64

# Check logs
docker logs -f paperclip-test

# Test health endpoint
curl http://localhost:3100/health

# Stop container
docker stop paperclip-test
docker rm paperclip-test
```

### Step 4: Multi-Architecture Build

```bash
# Build for both architectures
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  --build-arg BUILD_FROM=ghcr.io/home-assistant/amd64-base-debian:trixie \
  --build-arg PAPERCLIP_VERSION=v2026.416.0 \
  --tag paperclip-ha-addon:latest \
  --file paperclip_ha_addon/Dockerfile \
  paperclip_ha_addon/ \
  --push
```

## GitHub Actions Build

### Step 1: Fork Repository

1. Fork the repository on GitHub
2. Clone your fork:
   ```bash
   git clone https://github.com/YOUR_USERNAME/paperclip-ha-addon.git
   cd paperclip-ha-addon
   ```

### Step 2: Configure Secrets

Go to your repository settings → Secrets and variables → Actions → New repository secret

Add the following secrets:

- `CODENOTARY_API_KEY` - Your Codenotary API key (optional)
- `DOCKER_USERNAME` - Docker Hub username (optional)
- `DOCKER_PASSWORD` - Docker Hub password (optional)

### Step 3: Trigger Build

Push to trigger the build:

```bash
git add .
git commit -m "Build: Trigger GitHub Actions build"
git push origin main
```

### Step 4: Monitor Build

Go to the Actions tab in your repository to monitor the build progress.

## Testing

### Local Testing

#### Test 1: Container Startup

```bash
docker run -d \
  --name paperclip-startup-test \
  -p 3100:3100 \
  -v $(pwd)/test-data:/share/paperclip \
  paperclip-ha-addon:amd64

# Wait 60 seconds
sleep 60

# Check if container is running
docker ps | grep paperclip-startup-test

# Check logs
docker logs paperclip-startup-test

# Cleanup
docker stop paperclip-startup-test
docker rm paperclip-startup-test
```

#### Test 2: Health Check

```bash
docker run -d \
  --name paperclip-health-test \
  -p 3100:3100 \
  -v $(pwd)/test-data:/share/paperclip \
  paperclip-ha-addon:amd64

# Wait for startup
sleep 60

# Test health endpoint
curl -v http://localhost:3100/health

# Expected response: 200 OK

# Cleanup
docker stop paperclip-health-test
docker rm paperclip-health-test
```

#### Test 3: Web UI Access

```bash
docker run -d \
  --name paperclip-ui-test \
  -p 3100:3100 \
  -v $(pwd)/test-data:/share/paperclip \
  paperclip-ha-addon:amd64

# Wait for startup
sleep 60

# Test web UI
curl -I http://localhost:3100/

# Expected response: 200 OK

# Open in browser
# http://localhost:3100/

# Cleanup
docker stop paperclip-ui-test
docker rm paperclip-ui-test
```

#### Test 4: Database Creation

```bash
docker run -d \
  --name paperclip-db-test \
  -p 3100:3100 \
  -v $(pwd)/test-data:/share/paperclip \
  paperclip-ha-addon:amd64

# Wait for startup
sleep 60

# Check if database was created
ls -la test-data/

# Expected: paperclip.db file

# Cleanup
docker stop paperclip-db-test
docker rm paperclip-db-test
```

#### Test 5: Health Status Tracking

```bash
docker run -d \
  --name paperclip-status-test \
  -p 3100:3100 \
  -v $(pwd)/test-data:/share/paperclip \
  paperclip-ha-addon:amd64

# Wait for startup
sleep 60

# Check health status
cat test-data/health/status

# Expected: "running"

# Check start time
cat test-data/health/start_time

# Expected: Unix timestamp

# Cleanup
docker stop paperclip-status-test
docker rm paperclip-status-test
```

### Home Assistant Testing

#### Test 1: Add-on Installation

1. Add repository to Home Assistant
2. Install Paperclip AI add-on
3. Start the add-on
4. Check logs for errors

#### Test 2: Configuration

1. Configure with SQLite (default)
2. Start add-on
3. Verify database creation
4. Test web UI access

#### Test 3: PostgreSQL Integration

1. Install PostgreSQL add-on
2. Configure Paperclip with PostgreSQL
3. Start add-on
4. Verify connection
5. Test web UI access

#### Test 4: OpenClaw Integration

1. Configure OpenClaw URL and API key
2. Start add-on
3. Verify OpenClaw connection
4. Test agent execution

#### Test 5: Backup System

1. Enable backups
2. Run some operations
3. Check backup directory
4. Verify backup files

## Release

### Step 1: Update Version

Update version in `paperclip_ha_addon/config.yaml`:

```yaml
version: "1.0.1"
```

### Step 2: Update CHANGELOG

Add release notes to `CHANGELOG.md`:

```markdown
## [1.0.1] - 2026-04-22

### Fixed
- Fixed issue with XYZ
- Improved ABC

### Changed
- Updated DEF
```

### Step 3: Commit Changes

```bash
git add .
git commit -m "Release: v1.0.1"
git tag v1.0.1
git push origin main
git push origin v1.0.1
```

### Step 4: Create GitHub Release

1. Go to GitHub Releases
2. Click "Create a new release"
3. Select tag: v1.0.1
4. Add release notes
5. Click "Publish release"

### Step 5: Build and Publish

GitHub Actions will automatically build and publish the release.

## Troubleshooting

### Build Failures

#### Issue: BUILD_FROM not provided

**Error:**
```
ERROR: BuildKit failed with: error: failed to solve: no match for platform in manifest
```

**Solution:**
Ensure you're using an explicit `BUILD_FROM` argument:

```bash
docker build \
  --build-arg BUILD_FROM=ghcr.io/home-assistant/amd64-base-debian:trixie \
  ...
```

#### Issue: Paperclip build fails

**Error:**
```
ERROR: server build output missing
```

**Solution:**
1. Check Paperclip version is valid
2. Verify network connectivity
3. Check build logs for specific errors

### Runtime Failures

#### Issue: Container won't start

**Symptoms:**
- Container exits immediately
- Logs show errors

**Solution:**
1. Check logs: `docker logs <container-name>`
2. Verify configuration
3. Check file permissions
4. Ensure sufficient resources

#### Issue: Health check fails

**Symptoms:**
- Health check returns unhealthy
- Container marked as unhealthy

**Solution:**
1. Check health status: `cat /share/paperclip/health/status`
2. Verify process is running: `pgrep -f "node.*server/dist/index.js"`
3. Test HTTP endpoint: `curl http://localhost:3100/health`
4. Check logs for errors

#### Issue: Web UI not accessible

**Symptoms:**
- Cannot access http://localhost:3100
- Connection refused

**Solution:**
1. Verify container is running: `docker ps`
2. Check port mapping: `docker port <container-name>`
3. Verify firewall settings
4. Check logs for errors

#### Issue: Database connection fails

**Symptoms:**
- Database errors in logs
- Cannot save data

**Solution:**
1. Verify database configuration
2. Check database server is running
3. Test connection manually
4. Check file permissions

### Performance Issues

#### Issue: High memory usage

**Symptoms:**
- Container uses excessive memory
- System becomes slow

**Solution:**
1. Reduce `max_concurrent_runs`
2. Increase `run_timeout_minutes`
3. Monitor resource usage
4. Consider upgrading hardware

#### Issue: Slow response times

**Symptoms:**
- Web UI is slow
- API calls timeout

**Solution:**
1. Check system resources
2. Verify network connectivity
3. Optimize database
4. Reduce concurrent runs

## Build Optimization

### Reduce Image Size

#### Use Multi-Stage Build

The Dockerfile already uses multi-stage builds. Ensure you're not adding unnecessary layers.

#### Clean Up After Install

```dockerfile
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        package1 \
        package2 \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean
```

### Speed Up Build

#### Use BuildKit

```bash
export DOCKER_BUILDKIT=1
docker build ...
```

#### Use Cache Mounts

```dockerfile
RUN --mount=type=cache,target=/root/.npm \
    pnpm install --frozen-lockfile
```

## Continuous Integration

### GitHub Actions Workflow

The repository includes a GitHub Actions workflow for automated building and testing.

#### Workflow Features

- Multi-architecture builds (aarch64, amd64)
- Automated testing
- Image signing with Codenotary
- Automatic release publishing

#### Workflow Triggers

- Push to main branch
- Pull requests
- Manual trigger
- Release tags

## Security Best Practices

### Image Scanning

Scan images for vulnerabilities:

```bash
docker scan paperclip-ha-addon:amd64
```

### Sign Images

Sign images with Codenotary:

```bash
codenotary sign paperclip-ha-addon:amd64
```

### Verify Images

Verify image signatures:

```bash
codenotary verify paperclip-ha-addon:amd64
```

## Additional Resources

- [Home Assistant Add-on Documentation](https://developers.home-assistant.io/docs/add-ons/)
- [Docker Documentation](https://docs.docker.com/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Codenotary Documentation](https://docs.codenotary.com/)

---

**Last Updated**: 2026-04-21
**Version**: 1.0.0