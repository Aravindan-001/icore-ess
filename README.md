# ebaConnect / iCore ESS

**Employee Self-Service (ESS) Mobile Application**

ebaConnect is a Flutter-based Employee Self-Service mobile application designed to provide employees and HR administrators with a centralized platform for workforce management, real-time location-based attendance tracking, leave applications, unified request tracking, payroll and payslip inspection, structured PDF generation, and workplace services.

The application features a complete mobile ESS experience operating default deterministic mock repositories, real device GPS integration, attendance geofencing rules, secure session handling, structured PDF payslip generation, Firebase Analytics and Crashlytics telemetry, and a clean layered architecture prepared for SOAP/XML backend integration.

---

## Key Features & Capabilities

- **Authentication & Security**: Secure encrypted session lifecycle (`FlutterSecureStorage`), Remember Me without storing plain-text passwords, role isolation (Employee vs. HR Admin), and password management.
- **Employee Dashboard**: Real-time attendance status card, quick shortcut tiles, unread notification counter badge, latest net pay summary, and pending request metrics.
- **GPS Attendance**: Real device GPS tracking via Geolocator, 50-meter office geofence distance calculation, 100-meter accuracy threshold validation, sequential state control (`notMarked` -> `checkedIn` -> `completed`), attendance history, and `attendance_marked` telemetry.
- **Notifications & Alerts**: Category filtering (System, Leave, Payroll, General), unread filtering, pull-to-refresh, mark single/all as read, and deep-link navigation to target feature modules with `notification_opened` telemetry.
- **Unified Request Center**: Centralized request hub aggregating workflows from 7 employee domains (Leave, Overtime, Airfare, Education, Profile Update, Medical Claims, Reimbursements), category & status filtering (Pending, Approved, Rejected), and metric summary cards.
- **Payroll & Payslips**: Annual payslip history list, year filtering, detailed breakdown (earnings, deductions, attendance hours, bank details), arithmetic verification (Net Pay = Total Earnings - Total Deductions), Pay Summary with YTD metrics & month selection, vector A4 PDF generation (`PdfGenerator`), local temporary storage, and file sharing/downloading (`share_plus`).
- **Profile & Documents**: Employee profile summary, employment details, Personal Information landing screen with 10 structured sub-sections (Basic, Family, Bank, Education, Education Docs, Skills, Identity, Work History, Certificates, Profile Requests), and My Documents screen with direct Payslip PDF deep-linking.
- **HR Administration**: HR Dashboard, Employee list & profile detail inspection, Leave request approvals/rejections, and HR Payslip management.

---

## Attendance & Geofencing Pipeline

The Attendance module calculates device distance from configured office location constants:

```text
Device GPS (Geolocator)
    |
    v
Location Service
    |
    v
GPS Accuracy Validation (<= 100m)
    |
    v
Distance Calculation (Haversine Formula)
    |
    v
Geofence Check (<= 50m)
    |
    v
Attendance State Rule Validation
    |
    v
Check-In / Check-Out Execution
```

---

## Application Architecture

The project follows a clean layered architecture separating presentation, state management, business rules, and repository data contracts:

```text
Flutter UI (Material 3 ConsumerWidgets)
    |
    v
Riverpod State Layer (Providers & StateNotifiers)
    |
    v
Application Services (Business Rules & Validation)
    |
    v
Repository Contracts (EssRepository Abstraction)
    |
    v
Mock Repository (Active Default) / SOAP Repository (Prepared Transport)
```

### Compile-Time Backend Toggle

The data source layer can be switched at build time using the `ESS_BACKEND` environment flag:

- **Mock Backend (Active Default)**: `flutter run --dart-define=ESS_BACKEND=mock`
- **SOAP Backend (Prepared Transport)**: `flutter run --dart-define=ESS_BACKEND=soap`

*Integration Status*: The application is fully prepared for SOAP/XML backend integration (`SoapClient`, `XmlUtils`, `SoapConfig`, `SoapEssRepository`). Real network requests to SOAP operations will throw an `IntegrationException` until the client provides the official WSDL and endpoint specifications.

---

## Quality Assurance & Verification

The application has been verified through automated test suites, static analysis, build compilation, and runtime checks.

| Quality Check | Result | Details |
| :--- | :---: | :--- |
| **Automated Unit & Widget Tests** | **99 / 99 PASSED** | 27 test files under `test/` (0 failures) |
| **Static Analysis** | **0 ISSUES** | Clean `flutter analyze` output |
| **Debug APK Build** | **PASSED** | Verified Gradle build |
| **Android Release Hardening** | **PASSED** | R8 minification & resource shrinking enabled |

### Verification Commands

```bash
flutter analyze
flutter test
flutter build apk --debug
```

---

## Development Demo Credentials

The application includes deterministic mock credentials for development and offline testing:

### Employee Demo
```text
Employee ID: 20140
Password: Employee@123
Role: Employee
```

### HR Admin Demo
```text
Employee ID: HR001
Password: HR@12345
Role: HR Admin
```

---

## Project Status

- **Phase 11A - Attendance Experience**: COMPLETE
- **Phase 11B - Notifications UX**: COMPLETE
- **Phase 11C - Request Center**: COMPLETE
- **Phase 11D - Payroll & Payslips**: COMPLETE
- **Phase 11E - Profile & Documents**: COMPLETE
- **Phase 11F - Production QA & Hardening**: COMPLETE

**Current Status**: Flutter mobile application QA and hardening complete. Prepared for client SOAP/WSDL contract integration.
