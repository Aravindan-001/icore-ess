# Security Policy

## Current Client-Side Security Controls

The ESS Application (ebaConnect / iCore ESS) implements the following verified client-side security measures:

### Session & Credential Security
- **Encrypted Local Storage**: Active auth tokens (`auth_token`), session IDs (`session_id`), employee IDs (`employee_id`), and user roles (`user_role`) are stored securely using `FlutterSecureStorage` via `SessionManager`.
- **Remember Me Functionality**: Persists preferred Employee ID in encrypted secure storage. Passwords are **never** persisted to disk or local storage for Remember Me support.
- **Session Termination**: Invoking logout (`AuthService.logout`) explicitly executes `SessionManager.clearSession()`, purging tokens and session identifiers from secure storage and resetting the root navigation state.
- **Role Isolation**: Authorization logic distinguishes Employee (`employee`) and HR Admin (`hrAdmin`) roles, restricting access to HR management screens (`/hr/dashboard`, `/hr/employees`, `/hr/leaves`, `/hr/payslips`).

### Code & Communication Hardening
- **Sensitive Log Avoidance**: Console logging is routed through `AppLogger` and `AnalyticsService`. Sensitive payloads (passwords, tokens, personal identifiers) are sanitized and excluded from telemetry log parameters.
- **HTTPS Enforced**: Prospective SOAP backend endpoint configurations (`SoapConfig`) enforce HTTPS (`https://`) encrypted transport.
- **Android Manifest Restrictions**: ADB backup flags (`allowBackup` and `fullBackupContent`) are set to `false` in `AndroidManifest.xml` to prevent local data extraction.
- **Code Minification & Obfuscation**: Android release build configuration enables R8 minification (`isMinifyEnabled = true`) and resource shrinking (`isShrinkResources = true`).

---

## Production & Backend Security Requirements

Before production deployment with a live SOAP backend, the following backend-dependent security controls must be verified:

1. **Server-Side Authorization**: Enforcing role-based access control (RBAC) on all backend SOAP operations independent of client UI navigation.
2. **Server-Side Geofence Validation**: Authoritative backend validation of GPS coordinates and timestamp freshness for attendance check-ins.
3. **SSL Certificate Pinning**: Evaluating corporate certificate requirements and configuring pinning if required by enterprise policy.
4. **SOAP Fault & Error Handling**: Graceful invalidation of local sessions upon receiving SOAP auth faults (`401 Unauthorized`).
5. **Secure Secret Management**: Configuring Android release `.jks` keystore and `key.properties` for production release build pipelines.

---

## Reporting a Vulnerability

Please do not disclose security vulnerabilities publicly.

Report suspected security vulnerabilities privately to the project maintainers or authorized enterprise contact with:

- Description of the issue
- Steps to reproduce
- Expected vs. actual behavior
- Relevant platform or environment details
- Suggested mitigation (if available)
