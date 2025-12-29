# toplex

Transfer media files to Plex server — supports both remote (SSH/rsync) and local transfers.

## Targets

| Target | Method | Destination |
|--------|--------|-------------|
| `ubuntu` (remote) | rsync over SSH | `/mnt/external-hdd/plex-media/` |
| `local` (omarchy) | sudo mv | `/usr/lib/plexmediaserver/` |

## Requirements

- **Remote**: SSH access to Plex server (hostname: `ubuntu` via Tailscale magic DNS), rsync
- **Local**: Plex Media Server running locally, sudo access

## Configuration

Create `~/.config/toplex/config` with your Plex tokens:

```bash
mkdir -p ~/.config/toplex
cat > ~/.config/toplex/config << 'EOF'
REMOTE_PLEX_TOKEN="your_remote_token_here"
LOCAL_PLEX_TOKEN="your_local_token_here"
EOF
```

### Getting your Plex tokens

**Remote (ubuntu):**
```bash
ssh ubuntu "sudo grep -oP 'PlexOnlineToken=\"\K[^\"]+' '/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Preferences.xml'"
```

**Local (omarchy):**
```bash
sudo grep -oP 'PlexOnlineToken="\K[^"]+' '/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Preferences.xml'
```

## Usage

### Target Selection

toplex remembers your last used target (sticky selection):

```bash
# First run: prompts for target, then remembers
toplex -t show.mkv

# Use remembered target (no prompt)
toplex -t another-show.mkv

# Override with explicit flags
toplex -r -t show.mkv     # Force remote (ubuntu), save as default
toplex -L -t show.mkv     # Force local, save as default
toplex --pick -t show.mkv # Force prompt, save choice as default
```

### Transfer Commands

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
```

### Other Commands

```bash
# List contents (uses last target)
toplex -l           # List root
toplex -l tv        # List tv/
toplex -l movies    # List movies/

# Trigger Plex library scan (uses last target)
toplex --scan
```

### Flags Summary

| Flag | Description |
|------|-------------|
| `-t, --tv` | Transfer to tv/ subdirectory |
| `-m, --movies` | Transfer to movies/ subdirectory |
| `-d, --dir` | Transfer to custom subdirectory |
| `-r, --remote` | Use ubuntu (remote) target, save as default |
| `-L, --local` | Use local target, save as default |
| `--pick` | Force interactive target prompt |
| `-l, --list` | List contents |
| `--scan` | Trigger Plex library scan |
| `--dry-run` | Preview without transferring |
| `-h, --help` | Show help |

## Examples

```bash
# Set local as default, transfer a movie
toplex -L -m "Inception.2010.2160p.UHD.BluRay.mkv"

# Transfer TV show (uses last target - local)
toplex -t "Breaking.Bad.S01.1080p.BluRay/"

# Switch to remote for this transfer
toplex -r -t "Show.Name.S02/"

# Preview what would be transferred
toplex --dry-run -m "Movie.Name.2024.mkv"

# List what's on the current target
toplex -l movies

# After transfers, scan the library
toplex --scan
```

## Directory Structure

Both targets use the same structure:

```
{base}/
├── tv/
│   └── Show.Name.S01/
│       ├── Show.Name.S01E01.mkv
│       └── Show.Name.S01E02.mkv
└── movies/
    └── Movie.Name.2024.mkv
```

## Initial Setup

### Remote (ubuntu)

1. Create directories:
   ```bash
   ssh -t ubuntu "sudo mkdir -p /mnt/external-hdd/plex-media/{tv,movies}"
   ssh -t ubuntu "sudo chown -R plex:plex /mnt/external-hdd/plex-media"
   ssh -t ubuntu "sudo chmod 775 /mnt/external-hdd/plex-media"
   ```

2. Add library paths in Plex UI (Settings > Libraries)

### Local (omarchy)

1. Create directories:
   ```bash
   sudo mkdir -p /usr/lib/plexmediaserver/{tv,movies}
   sudo chown -R plex:plex /usr/lib/plexmediaserver
   ```

2. Add library paths in Plex UI (Settings > Libraries)

## State Files

- **Last target**: `~/.cache/toplex/last-target`
- **Config**: `~/.config/toplex/config`

## Troubleshooting

**Permission denied on remote:**
```bash
ssh -t ubuntu "sudo chown -R plex:plex /mnt/external-hdd/plex-media"
```

**Scan returns 401:**
Update tokens in `~/.config/toplex/config`

**Files not appearing in Plex:**
- Check ownership: files should be owned by `plex:plex`
- Trigger manual scan: `toplex --scan`

**"Cannot prompt for target - stdin is not a terminal":**
Use explicit target flags (`-r` or `-L`) when running non-interactively.
