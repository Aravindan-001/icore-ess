# ESS Application - Security, QA, and Release Security Audit

This document summarizes the application security status, implemented client-side controls, and pending backend security prerequisites for the ESS Application (ebaConnect / iCore ESS).

---

## 1. Audit Summary
- **Current Audit Snapshot Date**: October 2026
- **Historical Audit Baseline Date**: 30-Aug-2026
- **Flutter Client-Side Security**: Verified & Hardened
- **Backend Security**: Pending Client SOAP WSDL & UAT Endpoint Access

---

## 2. Verified Flutter-Side Security Controls

### 2.1 Secrets & Credentials
- **Repository Audit**: Scanned repository for hardcoded production secrets, API tokens, and private client credentials.
- **Development Demo Credentials**: Development demo accounts (`20140` / `Employee@123` for Employee, `HR001` / `HR@12345` for HR Admin) are isolated in `MockEssRepository` for offline sandbox testing and must not be used in production.
- **Status**: **PASS**

### 2.2 Secure Storage & Session Lifecycle
- **Implementation**: Utilizes `flutter_secure_storage: ^9.2.4` via `SessionManager` to store session tokens (`auth_token`, `session_id`), employee identifier, and user role in encrypted keystore/keychain storage.
- **Remember Me Handling**: Persists preferred Employee ID securely. Passwords are **never** persisted to disk or secure storage for Remember Me functionality.
- **Session Termination (Logout)**: Invoking `AuthService.logout` explicitly executes `SessionManager.clearSession()`, deleting active tokens, session IDs, employee IDs, and role markers, resetting the root navigator to `/login`.
- **Status**: **PASS** (Resolved historical finding)

### 2.3 Role Isolation & Navigation Security
- **Role Control**: Distinguishes `EmployeeRole.employee` and `EmployeeRole.hrAdmin` during authentication.
- **Routing Isolation**: Bootstrap and login routing isolate HR administration screens (`/hr/dashboard`, `/hr/employees`, `/hr/leaves`, `/hr/payslips`) from unauthorized employee view states.
- **Status**: **PASS**

### 2.4 Attendance GPS & Geofence Security
- **Client-Side UX Validation**: Attendance check-in and check-out enforce dual-layer UX validation:
  1. GPS accuracy threshold check (<= 100.0 meters).
  2. Haversine distance calculation against office coordinates (<= 50.0 meters).
- **Spoofing Detection**: Captures `isMocked` flag from `Geolocator` device telemetry and passes it in `AttendanceRequest`.
- **Architectural Requirement**: Client-side geofencing is provided for user guidance and state control. Authoritative geofence validation **must** be executed independently on the backend server upon receiving the location payload.
- **Status**: **PASS** (Application side)

### 2.5 Android Hardening
- **Manifest Restrictions**: `allowBackup` and `fullBackupContent` are set to `false` in `android/app/src/main/AndroidManifest.xml` to prevent unauthorized extraction of application storage via ADB backup utilities.
- **Code Shrinking & Minification**: Production release build configuration (`android/app/build.gradle.kts`) enables R8 code minification (`isMinifyEnabled = true`) and resource shrinking (`isShrinkResources = true`) with custom Proguard rules (`proguard-rules.pro`).
- **Status**: **PASS**

### 2.6 iOS Privacy Configuration
- **Privacy Declarations**: `ios/Runner/Info.plist` includes explicit privacy usage descriptions (`NSLocationWhenInUseUsageDescription` and `NSLocationAlwaysUsageDescription`) required for GPS location access.
- **Status**: **PASS**

### 2.7 Sensitive Logging & Telemetry Audit
- **Log Sanitation**: Core business logging is routed through `AppLogger` and `AnalyticsService`. Sensitive payloads (such as credentials, session tokens, and personal identify details) are excluded from telemetry event parameters.
- **Firebase Analytics & Crashlytics**: Analytics tracks 4 business lifecycle events (`login_success`, `attendance_marked`, `request_submitted`, `notification_opened`). Crashlytics captures fatal framework errors and uncaught asynchronous exceptions with non-sensitive platform metadata.
- **HTTPS Enforcement**: Prospective SOAP backend configuration (`SoapConfig`) enforces HTTPS scheme (`https://`).
- **Status**: **PASS**

### 2.8 Dependency Security
- **Package Audit**: Audited `pubspec.yaml` dependencies (`flutter_secure_storage`, `geolocator`, `firebase_core`, `firebase_crashlytics`, `firebase_analytics`, `pdf`, `printing`). All packages are set to supported stable versions with zero static lint errors (`flutter analyze`).
- **Status**: **PASS**

---

## 3. Historical Risk Resolution Summary

| Item | Severity | Historical Finding | Current Status |
| :--- | :--- | :--- | :--- |
| **Local Session Persistence** | High | Session data previously persisted past logout | **RESOLVED** - Explicit `clearSession()` implemented in `SessionManager` |
| **iOS Privacy Strings** | Medium | Missing location usage keys in `Info.plist` | **RESOLVED** - Privacy strings configured |
| **Android ADB Backup** | Medium | ADB backup enabled by default | **RESOLVED** - `allowBackup="false"` enforced in Manifest |
| **HTTP Transport** | High | Potential unencrypted HTTP endpoints | **RESOLVED** - HTTPS enforced in `SoapConfig` |

---

## 4. Backend-Dependent Security Prerequisites (Pending Client WSDL / UAT Access)

The following security controls cannot be verified on the Flutter client in isolation and must be audited once the client provides backend access:

1. **WSDL & XML Schema Validation**: Validating that SOAP request envelopes and response payloads comply with enterprise XML schemas.
2. **Server-Side Authorization**: Enforcing role-based access control (RBAC) on all backend SOAP operations independent of client UI routes.
3. **Server-Side Geofencing**: Independent backend distance calculation and GPS spoofing validation before recording attendance state.
4. **SSL Certificate Pinning**: Evaluating corporate certificate requirements and configuring pinning if required by client security policy.
5. **Session Fault Handling**: Handling SOAP session faults (`401 Unauthorized` / invalid token envelope) by invalidating `FlutterSecureStorage` and redirecting to login.
6. **Production Signing & Keys**: Configuring Android production `.jks` keystore and `key.properties` for production release build pipeline.

---

## 5. Security Audit Conclusion

The client-side Flutter application is **hardened and verified** across session security, role isolation, GPS validation, Android manifest configuration, sensitive log handling, and static analysis. Final end-to-end security compliance will be completed during live SOAP backend integration testing.
