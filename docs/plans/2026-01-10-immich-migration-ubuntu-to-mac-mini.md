# Immich Migration: Ubuntu Server → Mac Mini

> Created: 2026-01-10
> Status: Ready to execute

## Overview

Migrate ~200GB Immich instance from Ubuntu server to Mac Mini, preserving all photos, albums, metadata, and face recognition data.

## Source & Destination

| | Ubuntu Server (Source) | Mac Mini (Destination) |
|---|---|---|
| **Tailscale** | `ubuntu` / `100.112.19.6` | `mac-mini.tail39ab0b.ts.net` |
| **Immich data** | `/mnt/immich-data` (~200GB) | External HDD (e.g., `/Volumes/ImmichHDD`) |
| **Docker path** | `~/immich-app/` | `~/dev/immich/` |
| **Status** | Running, full | Fresh install, empty |

## Migration Steps

### Phase 0: Format External HDD

**On Mac Mini — connect the HDD and format it:**

```bash
ssh mac-mini

# List all disks to identify your HDD
diskutil list

# Look for your external HDD (e.g., /dev/disk2)
# VERIFY THE DISK NUMBER - wrong disk = data loss!

# Option A: APFS (recommended - native Mac, best performance)
diskutil eraseDisk APFS ImmichHDD /dev/diskX

# Option B: exFAT (if you want cross-platform Linux/Windows access)
diskutil eraseDisk ExFAT ImmichHDD /dev/diskX
```

**After formatting:**
- HDD auto-mounts at `/Volumes/ImmichHDD`
- Verify: `ls /Volumes/ImmichHDD`
- Check space: `df -h /Volumes/ImmichHDD`

### Phase 1: Pre-Flight Checks

```bash
# On Ubuntu - verify data size
ssh ubuntu
docker ps | grep immich
du -sh /mnt/immich-data

# On Mac Mini - verify space available
ssh mac-mini
df -h ~
docker ps | grep immich

# Test connectivity
ping -c 3 ubuntu

# Safety backup on Ubuntu
sudo /usr/local/bin/immich-backup.sh
```

### Phase 2: Database Export

```bash
# On Ubuntu
ssh ubuntu
cd ~/immich-app

# Stop Immich (keep postgres running)
docker compose stop immich_server immich_machine_learning

# Dump database
docker exec -t immich_postgres pg_dumpall \
  --clean --if-exists --username=postgres \
  > /mnt/immich-data/database-backup/immich-database.sql

# Verify dump
ls -lh /mnt/immich-data/database-backup/immich-database.sql
```

### Phase 2.5: Mount External HDD

```bash
# On Mac Mini - connect and mount your external HDD
ssh mac-mini
diskutil list  # Find your HDD

# Create mount point if needed (adjust path as needed)
# Example: /Volumes/ImmichHDD

# Verify it's mounted and has space
df -h /Volumes/ImmichHDD
```

### Phase 3: File Transfer

```bash
# From Mac Mini - pull files from Ubuntu directly to external HDD
ssh mac-mini

# Adjust /Volumes/ImmichHDD to your actual mount point
rsync -avzP --stats \
  ubuntu:/mnt/immich-data/ \
  /Volumes/ImmichHDD/immich-data/
```

Expected time: 30-60 minutes for 200GB over Tailscale.

### Phase 4: Database Restore

```bash
# On Mac Mini
ssh mac-mini
cd ~/dev/immich

# Stop and reset database
docker compose down
rm -rf ./postgres

# Start only postgres
docker compose up -d immich_postgres
sleep 10

# Restore database (SQL file is on external HDD)
cat /Volumes/ImmichHDD/immich-data/database-backup/immich-database.sql \
  | sed "s/SELECT pg_catalog.set_config('search_path', '', false);/SELECT pg_catalog.set_config('search_path', 'public, pg_catalog', true);/g" \
  | docker exec -i immich_postgres psql --dbname=postgres --username=postgres

# Update .env to point to external HDD
# Edit ~/dev/immich/.env:
#   UPLOAD_LOCATION=/Volumes/ImmichHDD/immich-data

# Start full stack
docker compose up -d
```

### Phase 5: Verification

**Web UI checks:**
- [ ] Access https://mac-mini.tail39ab0b.ts.net
- [ ] Log in with existing credentials
- [ ] Photos appear in timeline
- [ ] Albums are intact
- [ ] People/faces recognized
- [ ] Metadata (dates, locations) correct

**CLI checks:**
```bash
# Container health
docker compose ps
docker logs immich_server --tail 50

# File count comparison
# Ubuntu:
ssh ubuntu "find /mnt/immich-data/upload -type f | wc -l"
# Mac Mini:
find /Volumes/ImmichHDD/immich-data/upload -type f | wc -l
```

**Troubleshooting:**
- Database issues → re-run restore step
- Missing files → re-run rsync (idempotent)
- Permission issues → `sudo chown -R $(whoami) /Volumes/ImmichHDD/immich-data`

### Phase 6: HDD Persistence

Since all photos live on the external HDD, ensure it auto-mounts on boot:

```bash
# Check current mount info
diskutil info /Volumes/ImmichHDD

# Add to /etc/fstab for auto-mount (get UUID from diskutil)
# UUID=YOUR-UUID-HERE /Volumes/ImmichHDD apfs rw,auto 0 0

# Or simply: macOS usually auto-mounts drives on boot if they were mounted before
```

**Important:** Immich won't start properly if the HDD isn't mounted. Consider adding a check to the startup script.

### Phase 7: Backup Automation

**Create backup script** at `~/dev/immich/backup.sh`:
```bash
#!/bin/bash
BACKUP_DIR="/Volumes/YourHDD/immich-backups"
mkdir -p "$BACKUP_DIR"

docker exec -t immich_postgres pg_dumpall \
  --clean --if-exists --username=postgres \
  > "$BACKUP_DIR/immich-$(date +%Y%m%d).sql"

# Keep only last 7 backups
ls -t "$BACKUP_DIR"/immich-*.sql | tail -n +8 | xargs rm -f 2>/dev/null

echo "Backup complete: $(date)"
```

**Set up weekly automation:**
```bash
chmod +x ~/dev/immich/backup.sh

cat > ~/Library/LaunchAgents/com.immich.backup.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.immich.backup</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>/Users/YOUR_USER/dev/immich/backup.sh</string>
    </array>
    <key>StartCalendarInterval</key>
    <dict>
        <key>Weekday</key>
        <integer>0</integer>
        <key>Hour</key>
        <integer>3</integer>
    </dict>
</dict>
</plist>
EOF

launchctl load ~/Library/LaunchAgents/com.immich.backup.plist
```

### Phase 8: Cleanup

```bash
# On Ubuntu - stop Immich permanently
ssh ubuntu
cd ~/immich-app
docker compose down

# Keep data as cold backup for 1-2 months
# Or archive it:
tar -czvf /mnt/backup-hdd/immich-final-backup.tar.gz /mnt/immich-data
```

## Final State

| Component | Status |
|-----------|--------|
| Immich | Running on Mac Mini |
| Photos | External HDD only (no internal SSD usage) |
| Database | PostgreSQL on internal SSD, weekly backups to HDD |
| Private access | Tailscale |
| Public sharing | Cloudflare Tunnel |
| Ubuntu server | Archived, can be repurposed |

## Rollback Plan

If migration fails, Ubuntu server remains intact with Borg backups:
```bash
ssh ubuntu
cd ~/immich-app
docker compose up -d
```
