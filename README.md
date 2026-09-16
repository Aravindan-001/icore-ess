# ebaConnect

**Employee Self-Service (ESS) Mobile Application**

ebaConnect is a Flutter-based Employee Self-Service mobile application designed to provide employees with a centralized platform for accessing HR, attendance, payroll, leave, reimbursement, and workplace services.

The current release focuses on a functional frontend prototype with mock data, real device GPS integration, attendance business rules, secure session handling, and a layered architecture prepared for SOAP/XML backend integration.

---

## Overview

The application provides a mobile-first ESS experience with:

* Employee authentication
* Dashboard and employee information
* GPS-based attendance
* Leave management
* Payroll and payslip access
* Reimbursement and claims workflows
* Sales and pre-order modules
* Notifications
* Profile and account settings

The application currently operates with mock repositories. Production integration will be completed after receiving the client's SOAP/WSDL contract and backend specifications.

---

## Features

### Authentication

* Employee ID and password login
* Form validation
* Password visibility toggle
* Remember Me functionality
* Forgot Password flow
* Loading and error states
* Mock authentication
* Secure session lifecycle management
* Logout and session cleanup

> Passwords are not stored as part of Remember Me functionality.

### Dashboard

* Employee greeting
* Employee information
* Attendance summary
* ESS service shortcuts
* Payroll summary presentation
* Navigation to major ESS modules

### Attendance

* Check-In and Check-Out workflow
* Real device GPS location
* Configurable 50-meter office geofence
* GPS accuracy validation
* Location permission handling
* Location service abstraction
* Sequential attendance state validation
* Daily attendance session control

#### Attendance State Flow

```text
Not Marked
    ↓
Check In
    ↓
Checked In
    ↓
Check Out
    ↓
Completed
```

The current client-side implementation validates the attendance flow and geofence rules locally. Final attendance authorization and persistence are planned to be enforced by the production backend.

### ESS Modules

* Attendance
* Leave Management
* Payslips
* Pay Summary
* Reimbursement
* Claims
* Pre Orders
* Sales Orders
* Notifications
* Employee Profile
* Settings
* Change Password
* Logout

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

The location functionality is abstracted behind a service interface so that the implementation can be changed or extended without coupling GPS-specific logic to the Attendance UI.

### Important Production Consideration

Client-side geofencing improves user feedback, but it should not be treated as the final security boundary. The production backend should independently validate:

* Employee identity
* Attendance state
* Request timestamp
* Latitude and longitude
* GPS accuracy, where supported
* Office geofence distance
* Duplicate or invalid attendance requests

---

## Architecture

ebaConnect follows a layered architecture that separates presentation, application logic, business rules, and data access.

```text
Flutter UI
    ↓
Feature Screens and Widgets
    ↓
Application Services
    ↓
Repository Contracts
    ↓
Mock Repository / SOAP Repository
    ↓
Mock Data / SOAP XML Backend
```

### Architectural Responsibilities

| Layer            | Responsibility                                                            |
| ---------------- | ------------------------------------------------------------------------- |
| UI Layer         | Screens, widgets, user interaction, and presentation                      |
| Service Layer    | Application workflows, orchestration, and business rules                  |
| Repository Layer | Data-access contracts and backend abstraction                             |
| Mock Repository  | Local development and testing data                                        |
| SOAP Repository  | Planned production XML communication                                      |
| Core Layer       | Shared constants, errors, utilities, session handling, and infrastructure |

### Repository Contracts

The application uses feature-oriented repository contracts rather than depending on one large repository interface.

Current repository areas include:

* Authentication
* Attendance
* Leave
* Payroll
* Profile
* Expenses
* Orders
* Notifications

This design allows the mock data implementation to be replaced progressively with production SOAP/XML services.

---

## Technology Stack

### Frontend

* Flutter
* Dart
* Material 3
* Responsive mobile UI
* Android platform integration

### Device and Security

* Geolocator
* Android GPS and Location Services
* `flutter_secure_storage`
* Runtime permission handling
* Session lifecycle management

### Architecture and Engineering

* Layered architecture
* Repository Pattern
* Application Service Layer
* Dependency Injection
* Domain-specific validation and exceptions
* Mock data repositories
* Automated regression testing

### Backend Integration

* SOAP/XML — planned
* WSDL-based service integration — pending client contract

---

## Quality Assurance

The application has been validated through automated tests, static analysis, build verification, and runtime checks.

| Validation           | Result |
| -------------------- | -----: |
| Automated test cases |     41 |
| Test failures        |      0 |
| Flutter Analyze      | Passed |
| Release APK build    | Passed |
| Runtime verification | Passed |

### Tested Areas

* Authentication
* Login validation
* Remember Me persistence
* Forgot Password
* Dashboard
* Navigation
* Attendance workflow
* GPS and geofencing rules
* Attendance state transitions
* Leave Management
* Payslips
* Pay Summary
* Reimbursement
* Claims
* Pre Orders
* Sales Orders
* Notifications
* Employee Profile
* Settings
* Logout
* Repository functionality
* Security rules
* Business-rule validation

### Verification Commands

```bash
flutter analyze
flutter test
flutter build apk --release
```

---

## Demo Credentials

The current frontend prototype includes demo authentication credentials:

```text
Employee ID: EMP001
Password: 123456
```

> These credentials are intended only for the current mock/demo environment. They must not be used for production authentication.

---

## Security Considerations

The current implementation includes:

* Passwords are not stored for Remember Me functionality.
* Employee ID and Remember Me state are persisted using secure storage.
* Active session-related data is cleared during logout.
* Remembered Employee ID can be preserved according to the user's Remember Me preference.
* UI components are separated from repository and backend implementation details.
* Attendance business rules are centralized in the application service layer.

### Production Security Requirements

Before production deployment, the backend integration should additionally define and enforce:

* Secure authentication and token/session handling
* Transport security
* SOAP fault handling
* Server-side authorization
* Server-side attendance validation
* Request replay protection
* Audit logging
* Credential and secret management
* Production environment configuration

---

## Backend Integration

The current application uses `MockEssRepository` and related mock repository implementations for frontend development and testing.

### Current Data Flow

```text
Flutter Application
        ↓
Application Services
        ↓
Repository Contracts
        ↓
Mock Repository
        ↓
Mock Data
```

### Planned Production Data Flow

```text
Flutter Application
        ↓
Application Services
        ↓
Repository Contracts
        ↓
SOAP/XML Repository
        ↓
SOAP Request
        ↓
Client HR / Backend System
        ↓
SOAP XML Response
        ↓
Application Models
        ↓
Flutter UI
```

### Planned Production Attendance Flow

```text
Real Device GPS
        ↓
Client-Side Geofence Check
        ↓
Attendance Service
        ↓
SOAP/XML Request
        ↓
Server-Side Identity and Geofence Validation
        ↓
Attendance Persistence
        ↓
SOAP/XML Response
        ↓
Updated Attendance State
```

The backend should remain the final authority for attendance verification and persistence.

### SOAP Integration Prerequisites

Production integration requires the following information from the client:

* WSDL file or SOAP service documentation
* Service endpoint URLs
* SOAP namespaces
* Authentication mechanism
* SOAP action names
* Request and response XML schemas
* Employee authentication contract
* Attendance request and response contract
* Employee profile contract
* Leave and payroll contracts
* SOAP fault/error format
* Network and VPN requirements
* Production and testing environment details

---

## Project Structure

```text
lib/
├── core/
│   ├── constants/
│   ├── errors/
│   ├── session/
│   └── utilities/
├── features/
│   ├── attendance/
│   ├── authentication/
│   ├── dashboard/
│   ├── expenses/
│   ├── leave/
│   ├── notifications/
│   ├── orders/
│   ├── payroll/
│   └── profile/
├── models/
├── navigation/
├── repositories/
└── services/

test/
├── attendance_test.dart
├── attendance_permission_test.dart
├── auth_test.dart
├── complete_regression_test.dart
├── dashboard_test.dart
├── expenses_test.dart
├── leave_test.dart
├── navigation_test.dart
├── orders_test.dart
├── payroll_test.dart
├── profile_settings_test.dart
├── repository_test.dart
├── security_rules_test.dart
└── widget_test.dart
```

---

## Getting Started

### Prerequisites

Install the following before running the project:

* Flutter SDK
* Dart SDK included with Flutter
* Android Studio
* Android SDK
* Android emulator or physical Android device

Verify the Flutter installation:

```bash
flutter doctor
```

### Install Dependencies

```bash
flutter pub get
```

### Run Static Analysis

```bash
flutter analyze
```

### Run Automated Tests

```bash
flutter test
```

### Run the Application

```bash
flutter run
```

### Build Debug APK

```bash
flutter build apk --debug
```

### Build Release APK

```bash
flutter build apk --release
```

---

## Development Status

### Phase 1 — Frontend and Functional Prototype

* [x] Flutter UI implementation
* [x] Production-style login screen
* [x] Mock authentication
* [x] Remember Me persistence
* [x] Secure session management
* [x] ESS module navigation
* [x] Attendance workflow
* [x] Real GPS integration
* [x] Client-side 50-meter geofencing
* [x] Attendance state validation
* [x] Location permission handling
* [x] Application service layer
* [x] Repository contracts
* [x] Mock repositories
* [x] Automated testing
* [x] Regression testing
* [x] Security and business-rule testing
* [x] Static analysis
* [x] Release APK build verification

### Phase 2 — SOAP/XML Backend Integration

**Status: Ready for SOAP/WSDL Integration**

* [ ] Receive client SOAP/WSDL contract
* [ ] Configure service endpoints
* [ ] Implement SOAP/XML transport
* [ ] Implement production authentication
* [ ] Map SOAP responses to application models
* [ ] Integrate real employee data
* [ ] Integrate real attendance persistence
* [ ] Implement server-side attendance validation
* [ ] Integrate leave and payroll services
* [ ] Implement production SOAP fault handling
* [ ] Add integration and end-to-end tests
* [ ] Validate production security requirements

---

## Current Limitations

The current release is a frontend prototype and has the following limitations:

* ESS data is currently mock data.
* Authentication is not connected to the production HR system.
* SOAP/XML integration is pending the client contract.
* Attendance is not yet persisted to the production backend.
* Server-side geofence validation is not yet implemented.
* Some advanced form fields and attachment workflows require final backend contract mapping.
* Production deployment configuration is not yet finalized.

---

## License

This project is currently developed for client/project use.

All rights reserved unless otherwise specified by the project owner or client agreement.
