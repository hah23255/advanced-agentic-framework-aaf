# Script Tests

This directory contains tests for shell scripts.

## Running Tests

### All Script Tests

Run all script tests:

```bash
bash tests/scripts/test_git_utils.sh
```

### Individual Tests

Run specific test files:

```bash
bash tests/scripts/test_git_utils.sh
```

## Test Structure

Tests are written in bash and use a simple assertion framework. Each test:

1. Sets up a temporary git repository
2. Runs the function under test
3. Asserts the expected behavior
4. Cleans up the temporary repository

## Adding New Tests

To add new tests for shell scripts:

1. Create a new test file: `test_<script_name>.sh`
2. Make it executable: `chmod +x test_<script_name>.sh`
3. Follow the existing test structure
4. Use the assertion helpers for consistency

Example test structure:

```bash
#!/bin/bash
set -e

# Source the script being tested
source "$PROJECT_ROOT/scripts/your_script.sh"

# Define test functions
test_your_function() {
    # Setup
    # Test
    # Assert
    # Cleanup
}

# Run tests and report results
```
