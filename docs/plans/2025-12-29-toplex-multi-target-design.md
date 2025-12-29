# toplex Multi-Target Support Design

## Overview

Extend toplex to support two Plex destinations:
- **ubuntu** (remote): SSH + rsync transfer to remote Plex server
- **local** (omarchy): Local move to Plex media directory on this machine

## Configuration

```bash
# Targets
TARGETS=("ubuntu" "local")

# Remote (ubuntu)
REMOTE_HOST="ubuntu"
REMOTE_BASE="/mnt/external-hdd/plex-media"
REMOTE_PLEX_TOKEN="<token>"

# Local (omarchy)
LOCAL_BASE="/usr/lib/plexmediaserver"
LOCAL_PLEX_TOKEN="<token>"

# Shared
LOCAL_DEFAULT="$HOME/qbit"
STATE_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/toplex/last-target"
```

Directory structure (both targets):
```
{base}/
├── tv/
└── movies/
```

## Interactive Prompt

Every transfer command prompts for target selection:

```
$ toplex -t "Show.Name.S01/"

Transfer to:
  1) ubuntu (remote - SSH/rsync)
  2) local (this machine - move)

Choice [1-2]: _
```

## Transfer Logic

| Target | Method | Command |
|--------|--------|---------|
| ubuntu | rsync over SSH | `rsync -avz --progress "$src" "${REMOTE_HOST}:${dest}/"` then `ssh -t sudo chown -R plex:plex` |
| local | sudo move | `sudo mv "$src" "${dest}/"` |

Path resolution:
1. Check if source exists as given
2. If not, try `${LOCAL_DEFAULT}/${source}` (~/qbit)
3. Error if neither exists

Post-transfer:
- Write chosen target to state file (`~/.cache/toplex/last-target`)
- Show tip to run `toplex --scan`

## Scan Logic

`--scan` reads the last-used target from state file:
- If state file exists: scan that target's Plex instance
- If missing: prompt for which to scan

Scan commands:
- **ubuntu**: `ssh "$REMOTE_HOST" "curl -s -X POST 'http://localhost:32400/library/sections/all/refresh?X-Plex-Token=${REMOTE_PLEX_TOKEN}'"`
- **local**: `curl -s -X POST "http://localhost:32400/library/sections/all/refresh?X-Plex-Token=${LOCAL_PLEX_TOKEN}"`

Getting local Plex token:
```bash
sudo grep -oP 'PlexOnlineToken="\K[^"]+' '/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Preferences.xml'
```

## List Command

`-l` / `--list` also prompts for target:

```
$ toplex -l tv

List from:
  1) ubuntu (remote)
  2) local

Choice [1-2]: _
```

Commands:
- **ubuntu**: `ssh "$REMOTE_HOST" "ls -lh '${REMOTE_BASE}/tv'"`
- **local**: `ls -lh "${LOCAL_BASE}/tv"`

## Updated Usage

```
toplex - Transfer media to Plex server

Usage:
  toplex <file_or_folder>              Transfer (prompts for target)
  toplex -t <file_or_folder>           Transfer to tv/ (prompts for target)
  toplex -m <file_or_folder>           Transfer to movies/ (prompts for target)
  toplex -d <subdir> <file_or_folder>  Transfer to <subdir>/ (prompts for target)
  toplex --scan                        Trigger Plex library scan (last target)
  toplex -l [subdir]                   List remote contents (prompts for target)
  toplex --dry-run <args>              Preview transfer (remote only)

Targets:
  ubuntu    Remote Plex server via SSH/rsync
  local     This machine (/usr/lib/plexmediaserver)
```

## Notes

- `--dry-run` only applies to remote (rsync); for local, echo what would happen
- Local directories (`tv/`, `movies/`) created on first use with `sudo mkdir -p`
- State file enables `--scan` to remember last-used target
