# ebaConnect

Employee Self-Service (ESS) mobile application built with Flutter.

## Overview

ebaConnect is a mobile Employee Self-Service application designed to provide employees with a centralized platform for accessing HR and workplace services.

The application currently provides a complete frontend implementation with mock data, functional ESS workflows, GPS-based attendance, and a repository-based architecture prepared for SOAP/XML backend integration.

## Features

### Authentication

* Employee ID and password login
* Form validation
* Password visibility toggle
* Remember Me persistence
* Forgot Password flow
* Loading states
* Mock authentication
* Secure session management

### Dashboard

* Employee greeting
* Employee information
* Attendance summary
* ESS service shortcuts

### Attendance

* Check-In / Check-Out
* Real device GPS location
* 50-meter office geofence
* GPS accuracy handling
* Location permission handling
* Sequential attendance validation
* Daily attendance session control

**Attendance Flow**

`Not Marked → Check In → Checked In → Check Out → Completed`

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

## Location & Geofencing

The Attendance module uses device GPS to determine whether an employee is within the configured office radius.

```text
Device GPS
    ↓
Location Service
    ↓
Distance Calculation
    ↓
50m Geofence Check
    ↓
Check-In / Check-Out
```

The location layer is abstracted so it can be extended or replaced without affecting the Attendance UI.

## Architecture

The application follows a layered repository-based architecture:

```text
Flutter UI
    ↓
Feature Modules
    ↓
Repository Layer
    ↓
Service / Data Layer
    ↓
Mock Data / SOAP XML Backend
```

The repository abstraction allows `MockEssRepository` to be replaced with the production SOAP/XML implementation during backend integration.

## Technology Stack

* Flutter
* Dart
* Material 3
* Geolocator
* flutter_secure_storage
* Android GPS & Location Services
* Repository Pattern
* Mock Data Repository
* SOAP/XML — planned backend integration

## Quality Assurance

The application has been validated through automated functional, regression, and business-rule tests.

| Metric               |             Result |
| -------------------- | -----------------: |
| Automated Tests      |                 34 |
| Passed               |                 34 |
| Failed               |                  0 |
| Flutter Analyze      |          No issues |
| Release APK          | Successfully built |
| Runtime Verification |             Passed |

Test coverage includes:

* Authentication
* Login validation
* Remember Me persistence
* Forgot Password
* Dashboard
* Navigation
* Attendance
* GPS & Geofencing
* Leave Management
* Payslip
* Pay Summary
* Reimbursement
* Claims
* Pre Orders
* Sales Orders
* Notifications
* Profile
* Settings
* Logout
* Repository functionality
* Security & business rules

## Demo Credentials

```text
Employee ID: EMP001
Password: 123456
```

> These credentials are intended only for the current frontend/demo environment.

## Security

* Passwords are not stored for Remember Me functionality.
* Employee ID and Remember Me state are persisted using secure storage.
* Logout clears active session-related data while preserving remembered Employee ID when applicable.
* Repository abstraction separates UI from backend authentication implementation.

## Backend Integration

The current application uses `MockEssRepository` for frontend development and testing.

### Planned Production Architecture

```text
Flutter Application
        ↓
Repository Layer
        ↓
SOAP/XML Request
        ↓
Backend / HR System
        ↓
Employee & Attendance Data
```

### Production Attendance Flow

```text
Real GPS
    ↓
Client-side Geofence Check
    ↓
SOAP/XML Request
    ↓
Server-side 50m Validation
    ↓
Attendance Recorded
```

Server-side validation should remain the final authority for attendance verification.

## Project Structure

```text
lib/
├── core/
├── features/
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

## Running the Project

### Install Dependencies

```bash
flutter pub get
```

### Static Analysis

```bash
flutter analyze
```

### Run Tests

```bash
flutter test
```

### Run on Android Emulator / Device

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

## Current Status

### Phase 1 — Frontend & Functional Prototype

* [x] UI implementation
* [x] Production login screen
* [x] Mock authentication
* [x] Remember Me persistence
* [x] Secure session management
* [x] ESS modules
* [x] Attendance workflow
* [x] Real GPS integration
* [x] 50m geofencing
* [x] Navigation flows
* [x] Automated QA
* [x] Regression testing
* [x] Security/business-rule testing
* [x] Release APK build verification

### Phase 2 — SOAP/XML Backend Integration

**Status: Backend Integration Ready — Awaiting Client SOAP/WSDL Contract**

Planned work:

* [ ] SOAP service integration
* [ ] Real employee authentication
* [ ] Server-side attendance validation
* [ ] Real attendance persistence
* [ ] Live HR/ESS data synchronization
* [ ] Production API error handling

## License

This project is currently developed for client/project use.
