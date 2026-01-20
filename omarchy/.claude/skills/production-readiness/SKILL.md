---
name: production-readiness
description: Use when setting up a project for production deployment, creating local development environments, implementing backup strategies, or adding database environment switching with safety guards. Triggers on "production ready", "local dev setup", "backup strategy", "disaster recovery", "environment switching", "db safety".
---

# Production Readiness Setup

## Overview

This skill guides the implementation of a robust local-to-production workflow with proper safeguards. It covers local development environment setup, migration strategies, environment switching with safety guards, backup procedures, and disaster recovery documentation.

**Announce at start:** "I'm using the production-readiness skill to set up your project for production."

## Phase 1: Analyze Project

Before implementing, detect the tech stack:

```
- Database: Supabase / PostgreSQL / MySQL / MongoDB / etc.
- Hosting: Vercel / Railway / Fly.io / Netlify / etc.
- Framework: Next.js / Remix / SvelteKit / Nuxt / etc.
- Package manager: bun / pnpm / npm / yarn
- ORM: Prisma / Drizzle / TypeORM / none
```

## Phase 2: Implementation Checklist

### 2.1 Local Development Environment

Set up a local environment that mirrors production:

- [ ] Configure local database (Docker containers or CLI tools)
- [ ] Create `.env.local.example` template with local credentials
- [ ] Set up seed data (`seed.sql` or `seed.ts`) with realistic test data
- [ ] Document startup commands in README/CLAUDE.md

**For Supabase projects:**
```bash
supabase init
supabase start
# Creates local PostgreSQL, Auth, Storage, Studio
```

**Directory structure:**
```
supabase/
├── config.toml          # Local configuration
├── migrations/          # SQL migrations (version controlled)
├── seed.sql             # Test data
└── .gitignore           # Ignore local secrets
```

### 2.2 Migration Strategy

Establish schema migration workflow:

- [ ] Export current schema as baseline migration
- [ ] Set up migration directory structure
- [ ] Create migration generation commands
- [ ] Document deployment process

**Baseline migration:**
```bash
# Supabase
supabase db dump --schema public > supabase/migrations/00000000000000_baseline.sql

# Prisma
npx prisma migrate dev --name baseline
```

### 2.3 Environment Switching with Safety Guards

**CRITICAL:** Create Makefile with protection macros:

```makefile
# State file for environment persistence
DB_ENV_FILE := .db-environment
DB_ENV := $(shell cat $(DB_ENV_FILE) 2>/dev/null || echo "LOCAL")

# Guard macro - blocks command if in REMOTE mode
define REQUIRE_LOCAL
	@if [ "$(DB_ENV)" = "REMOTE" ]; then \
		echo ""; \
		echo "\033[1;31m╔══════════════════════════════════════════════════════════════╗\033[0m"; \
		echo "\033[1;31m║  ⛔ BLOCKED: This command is disabled in REMOTE mode         ║\033[0m"; \
		echo "\033[1;31m║  Run 'make db-local' first to switch to local environment    ║\033[0m"; \
		echo "\033[1;31m╚══════════════════════════════════════════════════════════════╝\033[0m"; \
		echo ""; \
		exit 1; \
	fi
endef

# Safe commands
db-local: ## Switch to local environment (safe mode)
	@echo "LOCAL" > $(DB_ENV_FILE)
	@cp .env.local .env 2>/dev/null || cp .env.local.example .env
	@echo "✅ Switched to LOCAL environment"

db-remote: ## Switch to production (WARNING: restricted mode)
	@echo ""
	@echo "\033[1;31m╔══════════════════════════════════════════════════════════════╗\033[0m"
	@echo "\033[1;31m║  ⚠️  WARNING: Switching to PRODUCTION database               ║\033[0m"
	@echo "\033[1;31m║  Destructive commands will be BLOCKED                        ║\033[0m"
	@echo "\033[1;31m╚══════════════════════════════════════════════════════════════╝\033[0m"
	@echo ""
	@echo "REMOTE" > $(DB_ENV_FILE)
	@cp .env.production .env 2>/dev/null || cp .env.remote .env
	@echo "⚠️  Switched to REMOTE environment (restricted mode)"

db-status: ## Show current database environment
	@echo "Current environment: $(DB_ENV)"

# Protected commands (LOCAL only)
db-reset: ## Reset database (LOCAL only - WARNING: destructive)
	$(REQUIRE_LOCAL)
	npx prisma migrate reset

db-push: ## Push schema changes (LOCAL only)
	$(REQUIRE_LOCAL)
	npx prisma db push

db-seed: ## Seed database (LOCAL only)
	$(REQUIRE_LOCAL)
	npx prisma db seed
```

**Add to .gitignore:**
```
.db-environment
```

### 2.4 Backup & Disaster Recovery

Create backup script at `scripts/backup-production.sh`:

```bash
#!/bin/bash
set -e

# Load environment
if [ -f .env.remote ]; then
  export $(grep DIRECT_URL .env.remote | xargs)
fi

if [ -z "$DIRECT_URL" ]; then
  echo "❌ DIRECT_URL not set. Export it or create .env.remote"
  exit 1
fi

# Create backups directory
mkdir -p backups

# Generate filename with timestamp
BACKUP_FILE="backups/backup_$(date +%Y-%m-%d_%H%M%S).sql"

echo "📦 Creating backup..."
pg_dump "$DIRECT_URL" > "$BACKUP_FILE"

# Compress
gzip "$BACKUP_FILE"

echo "✅ Backup created: ${BACKUP_FILE}.gz"
echo "📊 Size: $(du -h ${BACKUP_FILE}.gz | cut -f1)"
```

Create `docs/DISASTER_RECOVERY.md`:

```markdown
# Disaster Recovery Guide

## Backup Procedure

### Manual Backup (Before migrations or weekly)
./scripts/backup-production.sh

### Backup Schedule
| Event | Action |
|-------|--------|
| Before any migration | Full backup |
| Weekly (if active) | Full backup |
| Before major releases | Full backup |

## Restore Procedures

### Scenario 1: Restore to Same Project
gunzip backups/backup_YYYY-MM-DD_HHMMSS.sql.gz
psql "$DIRECT_URL" < backups/backup_YYYY-MM-DD_HHMMSS.sql

### Scenario 2: Restore to New Project
1. Create new database project
2. Apply migrations from git
3. Restore data from backup

### Scenario 3: Schema-Only Recovery
Schema is always recoverable from git (migrations/).

## Verification Checklist
After any restore:
- [ ] Application loads without errors
- [ ] Users can log in
- [ ] Critical flows work (test manually)
- [ ] Run type checks: `bun run check` or `npm run check`
```

### 2.5 Environment Templates

Create `.env.local.example`:
```env
# Local Development (Docker/CLI)
DATABASE_URL="postgresql://postgres:postgres@localhost:54322/postgres"
DIRECT_URL="postgresql://postgres:postgres@localhost:54322/postgres"

# Local Supabase (if applicable)
NEXT_PUBLIC_SUPABASE_URL="http://localhost:54321"
NEXT_PUBLIC_SUPABASE_ANON_KEY="<from-supabase-start-output>"

# Feature flags (usually enabled for local dev)
NEXT_PUBLIC_ENABLE_DEBUG="true"
```

Create `.env.production.example`:
```env
# Production Database (pooler connection)
DATABASE_URL="postgresql://user:pass@host:6543/db?pgbouncer=true"
DIRECT_URL="postgresql://user:pass@host:5432/db"

# Production Services
NEXT_PUBLIC_APP_URL="https://your-app.com"

# Feature flags
NEXT_PUBLIC_ENABLE_DEBUG="false"
```

### 2.6 Documentation Updates

Update `CLAUDE.md` or `README.md` with:

```markdown
## Local Development

### Quick Start
make db-local      # Switch to local environment
make db-start      # Start local database (Docker)
bun dev            # Start dev server

### Database Commands
| Command | Description |
|---------|-------------|
| make db-local | Switch to LOCAL (safe mode) |
| make db-remote | Switch to PRODUCTION (restricted) |
| make db-status | Show current environment |
| make db-reset | Reset database (LOCAL only) |
| make db-backup | Backup production database |

### Backup Schedule
- Before any migration: Full backup
- Weekly (if production active): Full backup
- Before major releases: Full backup
```

## Phase 3: Verification

After implementation, verify:

- [ ] `make db-local` switches environment correctly
- [ ] `make db-remote` shows warning and blocks destructive commands
- [ ] `make db-reset` is blocked in REMOTE mode
- [ ] Backup script works: `./scripts/backup-production.sh`
- [ ] Seed data creates realistic test environment
- [ ] DISASTER_RECOVERY.md is comprehensive

## Constraints

- Keep it simple - no over-engineering
- Free tier friendly (Supabase Free, Vercel Hobby, etc.)
- Git-based schema versioning (migrations in repo)
- Manual backups acceptable for early stage
- No staging environment needed initially

## Reference Implementation

See Florentin Fitness (flux_app) for a complete example:
- `Makefile` - Full database commands with guards
- `supabase/` - Local Supabase setup
- `scripts/backup-production.sh` - Backup script
- `docs/DISASTER_RECOVERY.md` - Recovery procedures
