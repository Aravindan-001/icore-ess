# Security Policy

## Current Security Practices

- Passwords are not stored for Remember Me functionality.
- Employee ID and Remember Me state are stored using secure storage.
- Logout clears active session-related data.
- Attendance rules are centralized in the application service layer.
- Production backend integration is designed to remain separate from the Flutter UI.

## Production Security Requirements

Before production deployment, the following must be finalized:

- Secure authentication and session handling
- HTTPS/TLS transport security
- Server-side authorization
- Server-side attendance and geofence validation
- SOAP fault and error handling
- Audit logging
- Secure secret management
- Production environment configuration

## Reporting a Vulnerability

Do not disclose security vulnerabilities publicly.

Report suspected vulnerabilities privately to the project owner or the authorized client contact with:

- A clear description
- Steps to reproduce
- Expected and actual behavior
- Relevant logs or screenshots
- Suggested mitigation, if available
