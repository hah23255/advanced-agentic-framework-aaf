#!/bin/bash
# Git utility functions for scripts

# Check if there are uncommitted changes in the repository
# Returns 0 if clean, 1 if there are changes
# Note: Uses git status --porcelain to catch all types of changes:
#   - Modified files, staged changes, and untracked files
# Usage: check_uncommitted_changes
check_uncommitted_changes() {
    if [[ -n $(git status --porcelain) ]]; then
        return 1
    fi
    return 0
}

# Verify clean git state before proceeding
# Exits with error if uncommitted changes detected unless --force flag is set
# Usage: verify_clean_state [--force]
verify_clean_state() {
    local force=false
    
    # Check for --force flag
    for arg in "$@"; do
        if [[ "$arg" == "--force" ]]; then
            force=true
            break
        fi
    done
    
    # Check for uncommitted changes
    if ! check_uncommitted_changes; then
        echo "⚠️  Uncommitted changes detected:"
        echo ""
        git status --short
        echo ""
        
        if [[ "$force" == "true" ]]; then
            echo "⚡ Proceeding with --force flag..."
            return 0
        else
            echo "❌ Error: Cannot proceed with uncommitted changes."
            echo "   Please commit or stash your changes first."
            echo "   Or use --force flag to override this check."
            return 1
        fi
    fi
    
    echo "✅ Repository is clean"
    return 0
}
