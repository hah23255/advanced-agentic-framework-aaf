# Contributing to Cognitive Parliament

Thank you for your interest in contributing!

## Development Setup

```bash
# Clone repository
git clone https://github.com/user/cognitive-parliament.git
cd cognitive-parliament

# Install in development mode
make install

# Run tests
make test
```

## Code Standards

- Python 3.9+ required
- Follow PEP 8 (enforced by ruff)
- Type hints required (checked by mypy)
- Test coverage > 80% for new code
- All tests must pass before PR merge

## Pull Request Process

1. Create feature branch from `main`
2. Write tests for new functionality
3. Ensure all tests pass: `make test`
4. Run linters: `make lint`
5. Format code: `make format`
6. Update documentation if needed
7. Submit PR with clear description

## Code Review

- All PRs require at least 1 approval
- CI must pass (tests, linting, security scans)
- No merge of your own PRs
- Address all review comments

## Commit Message Format

```
type(scope): brief description

Detailed explanation if needed.

Fixes #123
```

Types: feat, fix, docs, style, refactor, test, chore
