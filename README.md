# iCore ESS

Employee Self-Service (ESS) mobile application built with Flutter.

## Overview

iCore ESS is a mobile Employee Self-Service application designed to provide employees with a centralized platform for accessing HR and workplace services.

The application currently contains a complete frontend prototype with mock data and a repository-based architecture prepared for future SOAP/XML backend integration.

## Features

### Authentication

- Employee login
- Input validation
- Loading states
- Mock authentication flow
- Repository-based authentication architecture

### Dashboard

- Employee greeting
- Employee information
- Attendance summary
- Quick access to ESS services

### Attendance

- Employee Check-In and Check-Out
- Real device GPS location
- 50-meter office geofence
- GPS accuracy indication
- Location permission handling
- Daily attendance session control

Attendance flow:

Not Marked -> Check In -> Checked In -> Check Out -> Completed

### ESS Modules

- Attendance
- Leave Management
- Payslips
- Pay Summary
- Reimbursement
- Claims
- Pre Orders
- Sales Orders
- Notifications
- Employee Profile
- Settings

## Location and Geofencing

Attendance uses the device GPS location to determine whether the employee is within the configured office radius.

Location flow:

Device GPS
-> Location Service
-> Distance Calculation
-> 50m Geofence Check
-> Check-In or Check-Out

The location layer is abstracted so that the current implementation can be replaced or extended without changing the Attendance UI.

## Architecture

The application follows a layered architecture.

Flutter UI
-> Features
-> Repository Layer
-> Services
-> Mock Data / Future SOAP XML API

The repository abstraction allows the current mock implementation to be replaced with a SOAP/XML implementation during backend integration.

## Technology Stack

- Flutter
- Dart
- Material 3
- Geolocator
- Android GPS and Location Services
- Repository Pattern
- Mock Data Services
- SOAP/XML for planned backend integration

## Quality Assurance

The application has been verified through automated regression testing.

| Metric | Result |
|---|---|
| Total Test Cases | 40 |
| Passed | 40 |
| Failed | 0 |
| Skipped | 0 |
| Flutter Analyze | No issues |
| Debug APK Build | Successful |

Automated coverage includes:

- Authentication
- Dashboard
- Navigation
- Services
- Attendance
- GPS and Geofencing
- Leave
- Payslip
- Pay Summary
- Reimbursement
- Claims
- Pre Orders
- Sales Orders
- Notifications
- Profile
- Settings
- Repository business rules

## Demo Credentials

Employee ID: EMP001

Password: 123456

These credentials are for the current frontend/demo environment only.

## Backend Integration

The current application uses MockEssRepository for frontend development and testing.

Future production architecture:

Flutter Application
-> Repository Layer
-> SOAP/XML Request
-> Backend / HR System
-> Employee and Attendance Data

Attendance integration:

Real GPS
-> Client-side Geofence Check
-> SOAP/XML Request
-> Server-side 50m Validation
-> Attendance Recorded

Server-side validation should remain the final authority for attendance location verification.

## Project Structure

lib/
- core/
- features/
- models/
- navigation/
- repositories/
- services/

test/
- attendance_test.dart
- auth_test.dart
- complete_regression_test.dart
- geofence_test.dart
- navigation_test.dart
- repository_test.dart
- Other module tests

## Running the Project

Install dependencies:

flutter pub get

Run static analysis:

flutter analyze

Run tests:

flutter test

Run on an Android emulator or connected device:

flutter run

Build a debug APK:

flutter build apk --debug

## Current Status

### Phase 1 - Frontend and Functional Prototype

- UI implementation completed
- Mock authentication completed
- ESS modules implemented
- Attendance workflow implemented
- Real GPS integration completed
- 50m geofencing implemented
- Automated QA completed
- Debug APK build verified

### Phase 2 - SOAP/XML Backend Integration

- SOAP service integration
- Real employee authentication
- Server-side attendance validation
- Real attendance persistence
- Live HR/ESS data synchronization

## License

This project is currently developed for client/project use.