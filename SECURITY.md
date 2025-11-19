# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

**DO NOT** create public GitHub issues for security vulnerabilities.

Instead:
1. Email security@example.com with details
2. Include "SECURITY" in the subject line
3. Provide detailed description and reproduction steps
4. We will respond within 48 hours

## Security Measures

- Secrets stored in external vault (HashiCorp Vault recommended)
- All API keys encrypted at rest
- Audit logging for all agent decisions
- Rate limiting on all endpoints
- Regular dependency security scans
- ISO 27001 aligned controls

## Compliance

- SOC 2 Type II
- ISO 27001
- GDPR compliant data handling
