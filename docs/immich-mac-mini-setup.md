# Immich Self-Hosted Photo Backup: Mac Mini Setup

**Migration completed:** 2026-01-11
**Migrated from:** Ubuntu Server (home network)
**Migrated to:** Mac Mini (Tailscale-accessible)

## Why This Migration?

Moved from Ubuntu Server to Mac Mini to:
- Simplify home infrastructure (one less server)
- Leverage Mac Mini's always-on reliability
- Better remote access via Tailscale mesh network

## Final Architecture

```
┌─────────────────┐     ┌──────────────────────────────────┐
│  Phone/Client   │────▶│  Mac Mini (mac-mini.tail39ab0b)  │
└─────────────────┘     │                                  │
         │              │  ┌─────────────────────────────┐ │
         │              │  │ Docker Compose Stack        │ │
         │              │  │  • immich_server (:2283)    │ │
         │              │  │  • immich_ml                │ │
         │              │  │  • postgres + redis         │ │
         │              │  │  • public_proxy (:3000)     │ │
         │              │  └──────────┬──────────────────┘ │
         │              │             │                    │
         │              │  ┌──────────▼──────────────────┐ │
         │              │  │ External HDD (5TB Seagate)  │ │
         │              │  │ /Volumes/ImmichHDD          │ │
         │              │  │ Currently: 200GB used       │ │
         │              │  └─────────────────────────────┘ │
         │              └──────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────┐
│  Access Methods                         │
│  • Tailscale: mac-mini.tail39ab0b.ts.net│
│  • Cloudflare: gallery.devfusion-hub.ro │
└─────────────────────────────────────────┘
```

## Configuration

### Key Paths on Mac Mini

| Path | Purpose |
|------|---------|
| `~/dev/immich/` | Docker Compose project directory |
| `~/dev/immich/.env` | Environment variables |
| `~/dev/immich/backup.sh` | Database backup script |
| `/Volumes/ImmichHDD/immich-data/` | Photo/video storage (external HDD) |
| `~/.cloudflared/config.yml` | Cloudflare tunnel config |

### Environment Variables (.env)

```bash
UPLOAD_LOCATION=/Volumes/ImmichHDD/immich-data
DB_PASSWORD=<stored in 1Password: "immich db password postgres mac mini">
IMMICH_SERVER_URL=https://photos.devfusion-hub.ro  # Required for share links to use public proxy
# Standard Immich vars for postgres, redis, etc.
```

**Note:** Without `IMMICH_SERVER_URL`, share links use whatever URL you accessed Immich from (e.g., Tailscale internal address). Setting it ensures all share links point to the public Cloudflare URL regardless of how you access the app.

### Access URLs

| URL | Port | Purpose |
|-----|------|---------|
| https://mac-mini.tail39ab0b.ts.net | 2283 | Private access (Tailscale) |
| https://gallery.devfusion-hub.ro | 2283 | Full Immich UI (authenticated users) |
| https://photos.devfusion-hub.ro | 3000 | Public sharing proxy (anonymous access) |

**Public sharing setup:** The `photos` subdomain uses [immich-public-proxy](https://github.com/alangrainger/immich-public-proxy) - a lightweight proxy that allows anonymous access to shared albums without exposing the Immich login page or UI. Visitors see only the shared content.

### Docker Containers

| Container | Purpose |
|-----------|---------|
| immich_server | Main application |
| immich_machine_learning | Face/object detection |
| immich_postgres | Database |
| immich_redis | Cache |
| immich_public_proxy | Anonymous access to shared albums ([GitHub](https://github.com/alangrainger/immich-public-proxy)) |

### Cloudflare Tunnel

| Setting | Value |
|---------|-------|
| Tunnel name | `immich-v2` |
| Tunnel ID | `28c36456-6264-46c4-96a9-f3a8a9038bf1` |
| Config file | `~/.cloudflared/config.yml` |
| Credentials | `~/.cloudflared/28c36456-6264-46c4-96a9-f3a8a9038bf1.json` |
| Domain | `devfusion-hub.ro` (managed in Cloudflare) |

**Routes configured:**
- `gallery.devfusion-hub.ro` → `localhost:2283` (full Immich app)
- `photos.devfusion-hub.ro` → `localhost:3000` (public sharing proxy)

## Operations

### Starting Everything

```bash
# SSH into Mac Mini
ssh mac-mini

# Start Immich stack
cd ~/dev/immich && docker compose up -d

# Start Cloudflare tunnel (runs in background)
nohup cloudflared tunnel run immich-v2 > ~/dev/immich/cloudflared.log 2>&1 &

# Enable Tailscale access
tailscale serve --bg 2283
tailscale funnel --bg 3000
```

### Stopping Everything

```bash
cd ~/dev/immich && docker compose down
pkill cloudflared
tailscale serve off
tailscale funnel off
```

### Checking Status

```bash
# Container health
docker ps --format "table {{.Names}}\t{{.Status}}"

# Cloudflare tunnel
pgrep -f "cloudflared tunnel" && echo "Tunnel running"

# Disk usage
df -h /Volumes/ImmichHDD
```

### Database Backup

```bash
~/dev/immich/backup.sh
```

## Troubleshooting

### HDD I/O Errors (Upload Fails with 500)

**Symptoms:**
- Phone uploads fail with 500 error
- Logs show: `ENOENT: no such file or directory, mkdir '/data/upload/...'`
- `diskutil verifyVolume` returns: `Input/output error`

**Cause:** External USB HDD loses connection or enters sleep mode. Common with consumer-grade drives (Seagate Expansion) under 24/7 Docker workloads.

**Fix:**
```bash
# 1. Stop Immich
cd ~/dev/immich && docker compose down

# 2. Quit Docker Desktop
osascript -e 'quit app "Docker Desktop"'

# 3. Unplug HDD, wait 30 seconds

# 4. Plug into DIFFERENT USB port

# 5. Verify disk mounts and is writable
ls /Volumes/ImmichHDD
touch /Volumes/ImmichHDD/test && rm /Volumes/ImmichHDD/test

# 6. Restart Docker Desktop, then Immich
open -a "Docker Desktop"
# Wait for Docker to be ready (~30 seconds)
cd ~/dev/immich && docker compose up -d
```

**Prevention:**
- Use a powered USB hub
- Consider NAS-grade drives for 24/7 use
- Keep Mac Mini from sleeping: `caffeinate -d -i -s`

### Containers Won't Start

```bash
# Check logs
docker compose logs --tail 50

# Common fix: restart Docker Desktop
osascript -e 'quit app "Docker Desktop"'
open -a "Docker Desktop"
```

## Lessons Learned

### What Went Well
- Database backup/restore with `pg_dump`/`pg_restore` preserved all metadata
- Docker volume mapping (`/data` → external HDD) worked seamlessly
- Tailscale + Cloudflare tunnels = zero port forwarding needed
- All 182GB transferred successfully, faces/albums intact

### What Went Wrong
- External HDD had I/O errors after a few days of operation
- Root cause: USB power management + consumer-grade drive
- Fix was simple (reconnect to different port) but required Docker to be stopped first

### Recommendations for Future
1. **Use powered USB hub** for external drives on Mac Mini
2. **Test writes after reconnecting drives** before starting Docker
3. **Keep Ubuntu backup** until confident Mac Mini is stable (done: `/mnt/backup-hdd/saved-from-external/`)

## Quick Reference

| What | Where/Command |
|------|---------------|
| SSH in | `ssh mac-mini` |
| Start Immich | `cd ~/dev/immich && docker compose up -d` |
| Start tunnel | `nohup cloudflared tunnel run immich-v2 &` |
| Web UI | https://mac-mini.tail39ab0b.ts.net |
| Public URL | https://gallery.devfusion-hub.ro |
| Storage | `/Volumes/ImmichHDD` (5TB, ~200GB used) |
| DB password | 1Password → "immich db password postgres mac mini" |
| Backup script | `~/dev/immich/backup.sh` |

## Data Still on Ubuntu (cleanup pending)

Located at `/mnt/backup-hdd/saved-from-external/`:
- vacanta_turcia_parinti (1.6GB)
- pune pe HDD (50GB)
- videos_car (28GB)

Once confirmed stable, clean up Ubuntu:
```bash
ssh ubuntu "cd ~/immich-app && docker compose down"
```
