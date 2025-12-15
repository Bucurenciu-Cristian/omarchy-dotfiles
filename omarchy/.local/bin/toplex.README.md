# toplex

Transfer media files to Plex server via rsync over SSH (Tailscale).

## Requirements

- SSH access to Plex server (hostname: `ubuntu` via Tailscale magic DNS)
- rsync installed on both local and remote
- Plex Media Server running on remote

## Configuration

Edit these variables in the script if needed:

```bash
REMOTE_HOST="ubuntu"                        # SSH hostname
REMOTE_BASE="/mnt/external-hdd/plex-media"  # Plex media directory
PLEX_TOKEN="your_token_here"                # For library scan API
```

### Getting your Plex token

```bash
ssh ubuntu "sudo grep -oP 'PlexOnlineToken=\"\K[^\"]+' '/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Preferences.xml'"
```

## Usage

```bash
# Transfer to plex-media root
toplex <file_or_folder>

# Transfer to tv/ subdirectory
toplex -t <file_or_folder>

# Transfer to movies/ subdirectory
toplex -m <file_or_folder>

# Transfer to custom subdirectory
toplex -d <subdir> <file_or_folder>

# Dry run (preview without transferring)
toplex --dry-run -t <file_or_folder>

# List remote contents
toplex -l           # List root
toplex -l tv        # List tv/
toplex -l movies    # List movies/

# Trigger Plex library scan
toplex --scan
```

## Examples

```bash
# Transfer a TV show season
toplex -t "Breaking.Bad.S01.1080p.BluRay/"

# Transfer a movie
toplex -m "Inception.2010.2160p.UHD.BluRay.mkv"

# Transfer to custom folder
toplex -d "documentaries" "Planet.Earth.S01/"

# Preview transfer first
toplex --dry-run -t "Show.Name.S01/"

# After transfer, scan library
toplex --scan
```

## Directory structure

```
/mnt/external-hdd/plex-media/
├── tv/
│   └── Show.Name.S01/
│       ├── Show.Name.S01E01.mkv
│       └── Show.Name.S01E02.mkv
└── movies/
    └── Movie.Name.2024.mkv
```

## Initial setup

1. Ensure remote directory exists and is owned by plex:
   ```bash
   ssh -t ubuntu "sudo mkdir -p /mnt/external-hdd/plex-media/{tv,movies}"
   ssh -t ubuntu "sudo chown -R plex:plex /mnt/external-hdd/plex-media"
   ```

2. Make plex-media writable by your user (for rsync):
   ```bash
   ssh -t ubuntu "sudo chmod 775 /mnt/external-hdd/plex-media"
   ssh -t ubuntu "sudo usermod -aG plex \$(whoami)"
   ```

   Or allow your user to write, then chown to plex after (script does this automatically).

3. Add the Plex library path in Plex UI:
   - Go to Settings > Libraries
   - Add `/mnt/external-hdd/plex-media/tv` as TV Shows
   - Add `/mnt/external-hdd/plex-media/movies` as Movies

## Troubleshooting

**Permission denied on remote:**
```bash
ssh -t ubuntu "sudo chown -R plex:plex /mnt/external-hdd/plex-media"
```

**Scan returns 401:**
Update `PLEX_TOKEN` in the script (token may have changed).

**Files not appearing in Plex:**
- Check ownership: `ssh ubuntu "ls -la /mnt/external-hdd/plex-media/"`
- Files should be owned by `plex:plex`
- Trigger manual scan: `toplex --scan`
