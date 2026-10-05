<p align="center">
  <img src="assets/images/ebaconnect_logo.png" alt="ebaConnect Logo" width="120"/>
</p>

<h1 align="center">ebaConnect</h1>

<p align="center">
  <b>Employee Self-Service (ESS) Mobile Application</b>
</p>

<p align="center">
  Flutter • Riverpod • SOAP/XML Ready • Firebase
</p>

<p align="center">
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-%5E3.12.1-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter"/></a>
  <a href="https://dart.dev"><img src="https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart"/></a>
  <a href="https://github.com/Aravindan-001/icore-ess/actions"><img src="https://img.shields.io/badge/CI-Passing-2088FF?style=for-the-badge&logo=githubactions&logoColor=white" alt="CI Status"/></a>
  <a href="#quality--ci"><img src="https://img.shields.io/badge/Tests-148%2F148%20Passing-2ea44f?style=for-the-badge&logo=flutter&logoColor=white" alt="Tests Passed"/></a>
  <a href="#quality--ci"><img src="https://img.shields.io/badge/Analyze-0%20Issues-2ea44f?style=for-the-badge&logo=dart&logoColor=white" alt="Analysis Clean"/></a>
</p>

---

## Quick Navigation

- [Overview](#overview)
- [Product Snapshot](#product-snapshot)
- [Features](#features)
- [Architecture](#architecture)
- [Attendance Flow](#attendance-flow)
- [Backend Integration Status](#backend-integration-status)
- [Quality & CI](#quality--ci)
- [Project Progress](#project-progress)
- [Demo Accounts](#demo-accounts)
- [Repository Structure](#repository-structure)
- [Next Integration Milestone](#next-integration-milestone)
- [Tech Stack](#tech-stack)
- [Documentation](#documentation)
- [Current Status](#current-status)

---

## Overview

**ebaConnect (iCore ESS)** is an enterprise Employee Self-Service (ESS) mobile application built with **Flutter** and **Dart**. The system streamlines workforce operations including location-based GPS attendance, leave applications, unified request management, payroll and payslip inspection, structured PDF document generation, and HR administration.

The mobile application is fully developed, security hardened, and verified operating against a deterministic mock repository. The system is architecturally prepared for client SOAP/XML web service integration via `--dart-define=ESS_BACKEND=soap`.

---

## Product Snapshot

| Area | Status |
| :--- | :--- |
| **Mobile Platform** | Flutter (SDK `^3.12.1` / Dart 3.x) |
| **Role Support** | Employee & HR Administrator Roles |
| **Current Backend** | Deterministic Mock Repository (Active) |
| **SOAP/XML Integration** | Prepared Transport Layer (`ESS_BACKEND=soap`) |
| **Security Hardening** | Client-Side Hardening Complete (9 Audit Findings Resolved) |
| **Firebase Services** | Analytics + Crashlytics Configured |
| **Automated Tests** | 148 / 148 Tests Passing (0 Failures) |
| **Static Analysis** | `flutter analyze` — 0 Issues |
| **Debug APK Build** | Successful Gradle Compilation |
| **Client WSDL** | Pending Client Delivery |
| **UAT Environment** | Pending Client Delivery |

---

## Features

### Employee Experience

- **Home Dashboard**: Real-time attendance status card, quick navigation shortcuts, unread notification badge, latest net pay summary, and pending request metrics.
- **Personal Information**: Employee profile summary leading to a 10-section structured information portal (Basic, Family, Bank, Education, Education Docs, Skills, Identity, Work History, Certificates, Profile Requests).
- **Salary & Benefits**: Breakdown of compensation structures, allowances, basic pay, and benefits overview.
- **Leave Management**: Leave balance indicators, leave application form with date validation, and request history tracking.
- **Attendance**: GPS check-in/out with live geofence status indicator, accuracy checking, and attendance history logs.
- **Unified Request Center**: Centralized request hub aggregating workflows from 7 employee domains (Leave, Overtime, Airfare, Education, Profile Update, Medical Claims, Reimbursements) with category and status filter chips.
- **Notifications & Alerts**: Category filtering (System, Leave, Payroll, General), unread filtering, mark as read, and deep-link navigation.
- **Payslips & Pay Summary**: Annual payslip history, detailed earnings/deductions breakdown, YTD metric calculations, and vector A4 PDF generation and sharing (`PdfGenerator`).
- **Documents**: Centralized document view with direct deep links to payslip PDFs.
- **Profile**: Comprehensive employee identity card and account management.

### HR Experience

- **HR Dashboard**: High-level administrative metrics and workforce management shortcut tiles.
- **Employee Management**: Roster view of employees with profile inspection capability.
- **Leave Management**: Approval/rejection workflow for pending employee leave applications.
- **Payroll & Payslip Management**: Organization-wide employee payslips inspection and earnings review.
- **Role Isolation**: Role-based route guard (`HrRouteGuard`) protecting HR workflows from general employee accounts.

---

## Architecture

The application enforces a **Clean Layered Architecture** separating presentation, state management, business rules, and repository contracts:

```mermaid
flowchart TD
    subgraph PRESENTATION ["Presentation Layer"]
        UI["Flutter Material 3 UI Widgets & ConsumerWidgets"]
    end

    subgraph STATE ["State Management Layer"]
        RIVERPOD["Riverpod Providers & StateNotifiers"]
    end

    subgraph SERVICE ["Service Layer"]
        BIZ["Business Services & Validation Logic"]
    end

    subgraph CONTRACTS ["Repository Boundary Contract"]
        REPO["EssRepository Abstract Interface"]
    end

    subgraph CURRENT ["CURRENT BACKEND (ACTIVE)"]
        MOCK["MockEssRepository (Deterministic Local Data)"]
    end

    subgraph TARGET ["TARGET BACKEND (PREPARED)"]
        SOAP["SoapEssRepository (Prepared Transport Layer)"]
        BACKEND["Client HR SOAP Backend"]
    end

    UI --> RIVERPOD
    RIVERPOD --> BIZ
    BIZ --> REPO
    REPO -->|Active Default| MOCK
    REPO -.->|ESS_BACKEND=soap| SOAP
    SOAP -.->|Pending WSDL & Endpoints| BACKEND
```

### Repository Boundary Rationale

The abstract repository boundary (`EssRepository`) decouples presentation and business service layers from underlying data providers. This architecture allows swapping the active deterministic `MockEssRepository` for the prepared `SoapEssRepository` without altering UI widgets, state providers, or domain services.

---

## Attendance Flow

```mermaid
flowchart TD
    TAP["User Taps Check In / Check Out"] --> GPS["Request Hardware GPS Coordinates"]
    GPS --> PERM{"GPS Enabled & Permitted?"}
    PERM -->|No| ERR1["Display Location Error Message"]
    PERM -->|Yes| ACC{"Accuracy <= 100 meters?"}
    ACC -->|No| ERR2["Display GPS Accuracy Warning"]
    ACC -->|Yes| GEO{"Distance <= 50m to Office?"}
    GEO -->|No| ERR3["Display Geofence Warning"]
    GEO -->|Yes| SVC["AttendanceService Rules Validation"]
    SVC --> REPO["EssRepository Execution"]
    REPO -->|Current| MOCK["Mock Backend"]
    REPO -.->|Target| SOAP["SOAP Backend"]
```

> **Client vs. Server Geofencing Note**
>
> The 50-meter geofence and 100-meter accuracy validations are currently enforced on the Flutter client side to provide immediate user feedback. Authoritative server-side validation will be executed by the client backend upon SOAP service integration.

---

## Backend Integration Status

| Integration Area | Current State | Notes |
| :--- | :--- | :--- |
| **Mock Repository** | **Active** | Full app functionality available offline using mock data |
| **SOAP Client Layer** | **Prepared** | `SoapClient` HTTP transport and fault handling ready |
| **SOAP Repository** | **Prepared** | `SoapEssRepository` implementation structure bound |
| **XML Utilities** | **Prepared** | `XmlUtils` envelope builder and tag parser ready |
| **Client WSDL File** | **Awaiting Client** | Pending delivery from client technical team |
| **SOAP Operation Names** | **Awaiting Client** | Pending official API contract documentation |
| **XML Request/Response Schemas**| **Awaiting Client** | Pending payload structure definition |
| **Endpoint URLs** | **Awaiting Client** | UAT and Production endpoints pending |
| **Authentication Specification** | **Awaiting Client** | XML Header / Token contract pending |
| **UAT Credentials** | **Awaiting Client** | Credentials pending for integration testing |
| **End-to-End Integration** | **Not Started** | Blocked until client inputs are delivered |

> **Integration Callout**
>
> The Flutter application is architecturally prepared for SOAP/XML integration. The real HR backend cannot be connected until the client's WSDL, endpoint URLs, SOAP operations, schemas, and UAT credentials are available.

---

## Quality & CI

| Check | Result | Specification / Details |
| :--- | :---: | :--- |
| **Static Analysis** | **0 Issues** | Verified via `flutter analyze` |
| **Automated Tests** | **148 / 148 Passed** | Unit, widget, provider, route guard, PDF, and security tests |
| **Debug APK Build** | **Success** | Compiled via `flutter build apk --debug` |
| **GitHub Actions CI** | **Passing** | Automated workflow on Ubuntu 24.04 with Java 17 |
| **Crashlytics** | **Configured** | Fatal and non-fatal error telemetry handler attached |
| **Analytics** | **Configured** | Safe business telemetry mapped to Firebase Analytics |

---

## Demo Accounts

<details>
<summary><b>Employee Demo Account</b> (Click to expand)</summary>

- **Employee ID**: `20140`
- **Password**: `Employee@123`
- **Role**: Employee
- **Name**: ANITHA K
- **Department**: RETAIL
- **Designation**: EXECUTIVE-SALES-ELIFE
- **Location**: DUBAI
- **Currency**: AED

</details>

<details>
<summary><b>HR Admin Demo Account</b> (Click to expand)</summary>

- **Employee ID**: `HR001`
- **Password**: `HR@12345`
- **Role**: HR Admin
- **Designation**: HR Manager
- **Department**: Management
- **Title**: CTO

</details>

*Note: These credentials operate against deterministic mock data for development and demonstration purposes.*

---

## Tech Stack

| Layer | Technology | Version / Details |
| :--- | :--- | :--- |
| **Framework** | Flutter | SDK `^3.12.1` |
| **Language** | Dart | 3.x |
| **UI Framework** | Material Design 3 | Light Theme, Google Fonts `^8.2.1`, Cupertino Icons `^1.0.9` |
| **State Management** | Riverpod | `flutter_riverpod: ^2.6.1` |
| **Backend Architecture** | Repository Pattern | Toggleable via `--dart-define=ESS_BACKEND` |
| **Session & Storage** | Flutter Secure Storage | `flutter_secure_storage: ^9.2.4` via `SessionManager` |
| **Location & GPS** | Geolocator | `geolocator: ^13.0.4` |
| **PDF Generation** | PDF & Printing | `pdf: ^3.11.1`, `printing: ^5.11.1`, `share_plus: ^10.1.3` |
| **Telemetry** | Firebase | Analytics (`firebase_analytics`) & Crashlytics (`firebase_crashlytics`) |
| **Target OS** | Android | Gradle KTS, Java JVM 17 |

---

## Documentation

- [`ARCHITECTURE.md`](ARCHITECTURE.md) — System architecture, state management, and data flow specifications
- [`BACKEND_INTEGRATION.md`](BACKEND_INTEGRATION.md) — SOAP/XML integration roadmap, transport layer, and WSDL readiness
- [`PRODUCTION_READINESS.md`](PRODUCTION_READINESS.md) — Production hardening checklist, security audit, and build details
- [`SECURITY.md`](SECURITY.md) — Security policy, data protection, and disclosure guidelines
- [`SECURITY_AUDIT.md`](SECURITY_AUDIT.md) — Security controls, session storage rules, and threat review
- [`CHANGELOG.md`](CHANGELOG.md) — Complete project release and phase history

---

## Current Status

> **Current Status**
>
> Flutter application QA and security hardening complete.
> The application operates against the active deterministic mock repository and is architecturally prepared for SOAP/XML integration.
>
> **Next Blocker**: Client WSDL, SOAP operation contracts, endpoint configuration, XML schemas, and UAT credentials.
