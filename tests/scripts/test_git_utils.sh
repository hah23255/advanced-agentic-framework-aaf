#!/bin/bash
# Test suite for git_utils.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Test counter
TESTS_RUN=0
TESTS_PASSED=0

# Source the utilities
source "$PROJECT_ROOT/scripts/lib/git_utils.sh"

# Helper function for test assertions
assert_equals() {
    local expected="$1"
    local actual="$2"
    local message="$3"
    
    TESTS_RUN=$((TESTS_RUN + 1))
    if [[ "$expected" == "$actual" ]]; then
        echo -e "${GREEN}✓${NC} $message"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "${RED}✗${NC} $message"
        echo "  Expected: $expected"
        echo "  Actual: $actual"
    fi
}

# Test 1: check_uncommitted_changes returns 0 for clean repo
test_clean_repo() {
    echo ""
    echo "Test: check_uncommitted_changes with clean repository"
    
    # Create a temporary git repo
    local test_dir=$(mktemp -d)
    cd "$test_dir"
    git init -q
    git config user.email "test@example.com"
    git config user.name "Test User"
    echo "test" > test.txt
    git add test.txt
    git commit -q -m "Initial commit"
    
    # Test clean repo
    check_uncommitted_changes
    local result=$?
    assert_equals "0" "$result" "Clean repository should return 0"
    
    cd "$PROJECT_ROOT"
    if [[ -n "$test_dir" && -d "$test_dir" && "$test_dir" == /tmp/* ]]; then
        rm -rf "$test_dir"
    fi
}

# Test 2: check_uncommitted_changes returns 1 for dirty repo
test_dirty_repo() {
    echo ""
    echo "Test: check_uncommitted_changes with uncommitted changes"
    
    # Create a temporary git repo
    local test_dir=$(mktemp -d)
    cd "$test_dir"
    git init -q
    git config user.email "test@example.com"
    git config user.name "Test User"
    echo "test" > test.txt
    git add test.txt
    git commit -q -m "Initial commit"
    
    # Make uncommitted change
    echo "modified" >> test.txt
    
    # Test dirty repo (disable set -e temporarily since we expect non-zero)
    set +e
    check_uncommitted_changes
    local result=$?
    set -e
    assert_equals "1" "$result" "Dirty repository should return 1"
    
    cd "$PROJECT_ROOT"
    if [[ -n "$test_dir" && -d "$test_dir" && "$test_dir" == /tmp/* ]]; then
        rm -rf "$test_dir"
    fi
}

# Test 3: verify_clean_state without --force exits on dirty repo
test_verify_without_force() {
    echo ""
    echo "Test: verify_clean_state without --force on dirty repo"
    
    # Create a temporary git repo
    local test_dir=$(mktemp -d)
    cd "$test_dir"
    git init -q
    git config user.email "test@example.com"
    git config user.name "Test User"
    echo "test" > test.txt
    git add test.txt
    git commit -q -m "Initial commit"
    
    # Make uncommitted change
    echo "modified" >> test.txt
    
    # Test verify_clean_state without force (disable set -e temporarily)
    set +e
    verify_clean_state > /dev/null 2>&1
    local result=$?
    set -e
    assert_equals "1" "$result" "verify_clean_state should fail without --force on dirty repo"
    
    cd "$PROJECT_ROOT"
    if [[ -n "$test_dir" && -d "$test_dir" && "$test_dir" == /tmp/* ]]; then
        rm -rf "$test_dir"
    fi
}

# Test 4: verify_clean_state with --force succeeds on dirty repo
test_verify_with_force() {
    echo ""
    echo "Test: verify_clean_state with --force on dirty repo"
    
    # Create a temporary git repo
    local test_dir=$(mktemp -d)
    cd "$test_dir"
    git init -q
    git config user.email "test@example.com"
    git config user.name "Test User"
    echo "test" > test.txt
    git add test.txt
    git commit -q -m "Initial commit"
    
    # Make uncommitted change
    echo "modified" >> test.txt
    
    # Test verify_clean_state with force
    verify_clean_state --force > /dev/null 2>&1
    local result=$?
    assert_equals "0" "$result" "verify_clean_state should succeed with --force on dirty repo"
    
    cd "$PROJECT_ROOT"
    if [[ -n "$test_dir" && -d "$test_dir" && "$test_dir" == /tmp/* ]]; then
        rm -rf "$test_dir"
    fi
}

# Run all tests
echo "=========================================="
echo "Running git_utils.sh tests"
echo "=========================================="

test_clean_repo
test_dirty_repo
test_verify_without_force
test_verify_with_force

# Summary
echo ""
echo "=========================================="
echo "Test Summary"
echo "=========================================="
echo "Tests run: $TESTS_RUN"
echo "Tests passed: $TESTS_PASSED"

if [[ $TESTS_RUN -eq $TESTS_PASSED ]]; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed!${NC}"
    exit 1
fi
