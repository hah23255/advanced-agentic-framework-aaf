#!/bin/bash
# Backup repository state

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Source git utilities
source "$SCRIPT_DIR/lib/git_utils.sh"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "================================================"
echo "💾 State Backup"
echo "================================================"
echo ""

# Change to project root
cd "$PROJECT_ROOT"

# Verify clean git state
echo "Checking repository status..."
if ! verify_clean_state "$@"; then
    exit 1
fi

echo ""
echo "================================================"
echo "Starting state backup..."
echo "================================================"

# Create backup directory
BACKUP_DIR="$PROJECT_ROOT/data/backups"
mkdir -p "$BACKUP_DIR"

# Generate timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="$BACKUP_DIR/state_backup_$TIMESTAMP.tar.gz"

# Create backup
echo "Creating backup: $BACKUP_FILE"
tar -czf "$BACKUP_FILE" \
    --exclude='data/backups' \
    --exclude='__pycache__' \
    --exclude='*.pyc' \
    --exclude='.git' \
    --exclude='node_modules' \
    --exclude='dist' \
    --exclude='build' \
    .

echo ""
echo "✅ State backup completed successfully!"
echo "   Backup location: $BACKUP_FILE"
