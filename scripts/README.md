# Scripts

This directory contains operational scripts for the Cognitive Parliament project.

## Directory Structure

- `deployment/` - Deployment scripts for staging and production
- `monitoring/` - Monitoring and health check scripts
- `lib/` - Shared utility functions

## Deployment Scripts

### Production Deployment

Deploy to production environment:

```bash
./scripts/deployment/deploy_production.sh
```

The script will:
1. Check for uncommitted changes
2. Verify repository is in a clean state
3. Execute deployment steps

To force deployment with uncommitted changes (not recommended):

```bash
./scripts/deployment/deploy_production.sh --force
```

### Staging Deployment

Deploy to staging environment:

```bash
./scripts/deployment/deploy_staging.sh
```

Same behavior as production deployment with `--force` flag support.

## Backup Script

Create a backup of the current repository state:

```bash
./scripts/backup_state.sh
```

The backup script will:
1. Check for uncommitted changes
2. Create a timestamped backup in `data/backups/`
3. Exclude build artifacts and dependencies

To force backup with uncommitted changes:

```bash
./scripts/backup_state.sh --force
```

## Utility Functions

### Git Utilities (`lib/git_utils.sh`)

Shared functions for git operations:

- `check_uncommitted_changes()` - Returns 0 if repo is clean, 1 otherwise
- `verify_clean_state [--force]` - Verifies clean git state, exits on error unless --force is provided

## Usage in Custom Scripts

To use the git utilities in your own scripts:

```bash
#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/git_utils.sh"

# Verify clean state before proceeding
if ! verify_clean_state "$@"; then
    exit 1
fi

# Your script logic here
```

## Best Practices

1. Always check for uncommitted changes before deployments
2. Use `--force` flag sparingly and only when necessary
3. Commit or stash changes before running deployment scripts
4. Review the changes shown before deciding to proceed
