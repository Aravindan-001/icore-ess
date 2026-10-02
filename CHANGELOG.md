# Changelog

All notable changes to the ESS Application (ebaConnect / iCore ESS) project are documented in this file.

## [1.0.0] - Production QA & Hardening Milestone

### Added
- **Phase 11A - Attendance Experience**:
  - Real device GPS location integration via Geolocator.
  - Client-side 50m office geofence distance calculation and max 100m GPS accuracy threshold validation.
  - Sequential attendance state management (`notMarked` -> `checkedIn` -> `completed`).
  - Attendance history viewing, location permission error handling, and `attendance_marked` telemetry logging.

- **Phase 11B - Notifications UX**:
  - Unread notification count badge on top navigation app bar.
  - Category filtering (System, Leave, Payroll, General) and unread filtering.
  - Pull-to-refresh and mark single/all as read actions.
  - Deep-link navigation to target modules upon tapping notification items with `notification_opened` telemetry logging.

- **Phase 11C - Request Center**:
  - Unified Request Center consolidating 7 employee domain workflows (Leave, Overtime, Airfare, Education, Profile Update, Medical Claims, Reimbursements).
  - Category and status filtering (Pending, Approved, Rejected).
  - Summary metric cards for quick request count tracking.

- **Phase 11D - Payroll & Payslips**:
  - Annual payslip history list and detailed earnings/deductions breakdown.
  - Pay Summary screen with YTD earnings metrics and month selector.
  - Net pay arithmetic consistency validation (Net Pay = Total Earnings - Total Deductions).
  - Vector A4 PDF generation via `PdfGenerator`, local temporary storage, and file sharing/downloading via `share_plus`.

- **Phase 11E - Profile & Documents**:
  - Employee profile and employment information display.
  - Personal Information landing screen with 10 structured sub-sections (Basic, Family, Bank, Education, Education Docs, Skills, Identity, Work History, Certificates, Profile Requests).
  - My Documents screen featuring direct Payslip PDF deep-linking.

- **Phase 11F - Production QA & Hardening**:
  - Complete automated test coverage across 27 test files (99/99 passing tests).
  - Clean static analysis (`flutter analyze` with 0 issues).
  - Verified debug APK build and Android release minification/shrinking (R8/Proguard).
  - Comprehensive technical architecture documentation (`ARCHITECTURE.md`).

- **Authentication & Session Lifecycle**:
  - Encrypted session storage via `FlutterSecureStorage` (`SessionManager`).
  - Remember Me functionality storing Employee ID securely without plain-text password persistence.
  - Role-based authorization and navigation routing (Employee vs. HR Admin).
  - Clean logout session clearing resetting root navigator to login screen.

- **HR Administration Modules**:
  - Dedicated HR Dashboard (`/hr/dashboard`).
  - HR Employee Management list and detailed profile inspection.
  - HR Leave Request management (approve/reject actions).
  - HR Payroll & Payslip inspection.

- **Firebase Infrastructure**:
  - `firebase_core` platform initialization.
  - `firebase_crashlytics` fatal error handling, async error dispatcher, and custom metadata keys.
  - `firebase_analytics` event tracking (`login_success`, `attendance_marked`, `request_submitted`, `notification_opened`).

- **SOAP/XML Transport Layer Preparation**:
  - Prepared repository abstraction layer (`EssRepository` interface contract).
  - Transport layer infrastructure (`SoapClient`, `XmlUtils`, `SoapConfig`).
  - Environment backend toggle (`--dart-define=ESS_BACKEND=mock` or `soap`).
  - `SoapEssRepository` implementation structured to throw `IntegrationException` until client WSDL and service contracts are provided.
