# Immich Server Setup - Ubuntu Server

> Setup completed: December 2024
> Server: Ubuntu Server (fresh install)

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                        Ubuntu Server                            │
├─────────────────────────────────────────────────────────────────┤
│  Immich (Docker Compose)                                        │
│  ├── immich_server        (port 2283)                          │
│  ├── immich_machine_learning                                    │
│  ├── immich_postgres                                            │
│  └── immich_redis                                               │
├─────────────────────────────────────────────────────────────────┤
│  Storage                                                        │
│  ├── /mnt/immich-data        (NVMe - 255GB) - uploads/db       │
│  ├── /mnt/external-hdd       (HDD - 4.5TB)  - external library │
│  └── /mnt/backup-hdd         (HDD - 4.5TB)  - borg backups     │
├─────────────────────────────────────────────────────────────────┤
│  Access                                                         │
│  └── Tailscale: http://100.112.19.6:2283 (or http://ubuntu:2283)│
└─────────────────────────────────────────────────────────────────┘
```

## Storage Layout

| Mount Point | Device | Filesystem | Size | Purpose |
|-------------|--------|------------|------|---------|
| `/mnt/immich-data` | `nvme0n1p8` | ext4 | ~255GB | Uploads, thumbnails, DB dumps |
| `/mnt/external-hdd` | `sdc2` | ext4 | 4.5TB | External photo library |
| `/mnt/backup-hdd` | `sdb2` | ntfs | 4.5TB | Borg backup repository |

## fstab Entries

```bash
# /etc/fstab additions for Immich

# NVMe partition for Immich uploads
UUID=c65cd6a3-3633-436a-a2ec-9c8f3bcb9b0c /mnt/immich-data ext4 defaults 0 2

# External HDD for photo library
UUID=dacd9580-f591-40c5-ad9d-06b0be1ed028 /mnt/external-hdd ext4 defaults,nofail 0 2

# Backup HDD (NTFS Seagate)
UUID=261438131437E509 /mnt/backup-hdd ntfs-3g defaults,nofail 0 0
```

## Docker Compose Location

```bash
~/immich-app/
├── docker-compose.yml
├── .env
└── hwaccel.transcoding.yml
```

### Key .env Settings

```bash
UPLOAD_LOCATION=/mnt/immich-data
DB_DATA_LOCATION=./postgres
DB_PASSWORD=<redacted>
DB_USERNAME=postgres
DB_DATABASE_NAME=immich
IMMICH_VERSION=v2
```

### External Library Volume (docker-compose.yml)

```yaml
# Under immich-server volumes:
volumes:
  - ${UPLOAD_LOCATION}:/data
  - /etc/localtime:/etc/localtime:ro
  - /mnt/external-hdd/immich-library:/mnt/external-library:ro
```

### Hardware Transcoding (VAAPI)

```yaml
# Under immich-server:
extends:
  file: hwaccel.transcoding.yml
  service: vaapi
```

## Backup System

### Borg Repository

```bash
/mnt/backup-hdd/immich-borg
```

### Backup Script

Location: `/usr/local/bin/immich-backup.sh`

```bash
#!/bin/bash

# ABOUTME: Immich backup script using Borg
# ABOUTME: Backs up database + assets to local HDD weekly

# Paths
UPLOAD_LOCATION="/mnt/immich-data"
BACKUP_PATH="/mnt/backup-hdd"

# Backup Immich database
docker exec -t immich_postgres pg_dumpall --clean --if-exists --username=postgres > "$UPLOAD_LOCATION"/database-backup/immich-database.sql

# Append to local Borg repository
borg create "$BACKUP_PATH/immich-borg::{now}" "$UPLOAD_LOCATION" \
    --exclude "$UPLOAD_LOCATION"/thumbs/ \
    --exclude "$UPLOAD_LOCATION"/encoded-video/

# Prune old backups (keep 4 weekly, 3 monthly)
borg prune --keep-weekly=4 --keep-monthly=3 "$BACKUP_PATH"/immich-borg

# Compact repository
borg compact "$BACKUP_PATH"/immich-borg

# Ping healthchecks.io on success
curl -fsS -m 10 --retry 5 https://hc-ping.com/06c2e6bd-d9d0-4737-a274-41c3fc540fd0
```

### Cron Schedule

```bash
# sudo crontab -e
# Runs every Sunday at 3AM
0 3 * * 0 /usr/local/bin/immich-backup.sh >> /var/log/immich-backup.log 2>&1
```

### Backup Monitoring

- **Service:** healthchecks.io
- **Check URL:** https://hc-ping.com/06c2e6bd-d9d0-4737-a274-41c3fc540fd0
- **Alert:** Will notify if backup doesn't run on schedule

## Network Access

### Tailscale

| Device | IP | Purpose |
|--------|-----|---------|
| ubuntu (this server) | 100.112.19.6 | Immich host |
| omarchy (laptop) | 100.126.105.102 | Main workstation |
| oppo-cph2371 | 100.96.6.23 | Phone (photo sync) |

### Access URLs

```
Local:     http://<local-ip>:2283
Tailscale: http://100.112.19.6:2283
MagicDNS:  http://ubuntu:2283
```

## Useful Commands

### Docker Management

```bash
# Start/stop Immich
cd ~/immich-app
docker compose up -d
docker compose down

# View logs
docker logs immich_server --tail 50
docker compose ps

# Restart after config changes
docker compose down && docker compose up -d
```

### Backup Management

```bash
# Manual backup
sudo /usr/local/bin/immich-backup.sh

# List backup snapshots
borg list /mnt/backup-hdd/immich-borg

# Check backup log
tail -50 /var/log/immich-backup.log

# Mount backup to browse/restore
mkdir /tmp/immich-restore
borg mount /mnt/backup-hdd/immich-borg /tmp/immich-restore
# Browse snapshots in /tmp/immich-restore
borg umount /tmp/immich-restore
```

### Storage Checks

```bash
# Check mounts
df -h /mnt/immich-data /mnt/external-hdd /mnt/backup-hdd

# Check Immich folder structure
ls -la /mnt/immich-data/
```

## Maintenance Checklist

### Weekly (automated)
- [x] Borg backup runs Sunday 3AM
- [x] healthchecks.io monitors backup success

### Monthly (manual)
- [ ] Check backup log: `tail -100 /var/log/immich-backup.log`
- [ ] Verify backup size: `borg info /mnt/backup-hdd/immich-borg`
- [ ] Check disk space: `df -h`

### Quarterly (manual)
- [ ] Test restore from backup
- [ ] Update Immich: `docker compose pull && docker compose up -d`
- [ ] Check HDD health: `sudo smartctl -a /dev/sdb` and `/dev/sdc`

## Future Improvements (TODO)

- [ ] Offsite backup (Backblaze B2 or similar)
- [ ] SMART disk monitoring with alerts
- [ ] UPS for power protection
- [ ] HTTPS certificate via Tailscale (optional, traffic already encrypted)

## Restore Procedure

### Full Restore from Backup

```bash
# 1. Mount backup
mkdir /tmp/immich-restore
borg mount /mnt/backup-hdd/immich-borg /tmp/immich-restore

# 2. List available snapshots
ls /tmp/immich-restore

# 3. Copy files from desired snapshot
cp -r /tmp/immich-restore/<snapshot>/mnt/immich-data/* /mnt/immich-data/

# 4. Restore database
docker compose down
docker compose up -d database
sleep 10
cat /mnt/immich-data/database-backup/immich-database.sql \
  | sed "s/SELECT pg_catalog.set_config('search_path', '', false);/SELECT pg_catalog.set_config('search_path', 'public, pg_catalog', true);/g" \
  | docker exec -i immich_postgres psql --dbname=postgres --username=postgres
docker compose up -d

# 5. Unmount backup
borg umount /tmp/immich-restore
```

---

*Generated from chat session with Claude - December 2024*
