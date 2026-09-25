# ebaConnect / iCore ESS

**Employee Self-Service (ESS) Mobile Application**

ebaConnect is a Flutter-based Employee Self-Service mobile application designed to provide employees with a centralized platform for accessing HR, attendance, payroll, leave, reimbursement, request management, and workplace services.

The application features a complete Employee Self-Service experience operating with deterministic mock repositories, real device GPS integration, attendance geofencing rules, secure session handling, structured PDF payslip generation, and a layered architecture prepared for SOAP/XML backend integration.

---

## Overview

The application provides a mobile-first ESS and HR management experience:

* **Authentication & Security**: Secure session lifecycle, Remember Me, role isolation (Employee vs. HR), password change.
* **Employee Dashboard**: Attendance summary, quick shortcuts, unread notification counter, latest net pay card, unified pending request metrics.
* **Attendance**: Real GPS location, 50-meter office geofence, accuracy validation, sequential state control (Not Marked → Checked In → Completed).
* **Notifications & Alerts**: Category filtering (System, Leave, Payroll, General), unread filters, mark as read, mark all read, deep-link navigation.
* **Request Center & Workflow**: Centralized unified request center, category filters (Leave, Overtime, Airfare, Education, Reimbursement, Claims), status filters (Pending, Approved, Rejected), unified request metrics.
* **Payroll & Payslips**: Payslip list, year filtering, detailed breakdown (earnings, deductions, attendance hours, bank details), arithmetic verification (Net Pay = Earnings - Deductions), Pay Summary with YTD metrics and month selection, structured PDF generation, download, and sharing.
* **Profile & Documents**: Profile summary, Employment details, Personal Information landing screen with 10 structured sub-sections, My Documents list with direct Payslip PDF deep-linking.
* **HR Management**: HR Dashboard, Employee list, Leave request approvals/rejections, HR Payslip management.

---

## Location and Geofencing

The Attendance module uses the device's GPS location to calculate the employee's distance from the configured office coordinates.

```text
Device GPS
    ↓
Location Service
    ↓
GPS Accuracy Validation
    ↓
Distance Calculation
    ↓
50m Geofence Check
    ↓
Attendance State Validation
    ↓
Check-In / Check-Out
```

---

## Architecture

ebaConnect follows a clean layered architecture separating presentation, application logic, business rules, and data access.

```text
Flutter UI (Riverpod ConsumerWidgets)
    ↓
Feature Screens and Widgets
    ↓
Application Services (Service Layer)
    ↓
Repository Contracts (Abstract Interfaces)
    ↓
Mock Repository / SOAP Repository
    ↓
Mock Data / SOAP XML Backend
```

### Backend Switching

The backend can be selected at build time using the `ESS_BACKEND` environment variable:

- **Mock (Default)**: `flutter run --dart-define=ESS_BACKEND=mock`
- **SOAP**: `flutter run --dart-define=ESS_BACKEND=soap`

---

## Quality Assurance

The application has been validated through automated test suites, static analysis, build verification, and runtime checks.

| Validation           | Result |
| -------------------- | -----: |
| Automated test cases |     99 |
| Test failures        |      0 |
| Flutter Analyze      | Passed |
| Debug APK build      | Passed |
| Runtime verification | Passed |

---

## Verification Commands

```bash
flutter analyze
flutter test
flutter build apk --debug
```

---

## Demo Credentials

### Employee
```text
Employee ID: 20140
Password: Employee@123
Name: ANITHA K
```

### HR Admin
```text
Employee ID: HR001
Password: HR@12345
```

---

## Development Status

- **Phase 11A — Attendance**: COMPLETE
- **Phase 11B — Notifications**: COMPLETE
- **Phase 11C — Request Center**: COMPLETE
- **Phase 11D — Payroll & Payslips**: COMPLETE
- **Phase 11E — Profile & Documents**: COMPLETE
- **Phase 11F — Production QA & Hardening**: COMPLETE

**Current Status**: Production QA & Hardening Complete. Ready for client SOAP/WSDL contract integration.
