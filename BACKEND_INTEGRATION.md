# ebaConnect - Backend Integration Guide (SOAP/XML)

This document outlines the technical requirements for integrating the ebaConnect Flutter application with the client's HR/ESS SOAP backend.

## 1. Required Technical Information
The integration process requires the following from the backend team:

- **WSDL File or URL**: The Web Service Description Language definition for the ESS services.
- **Service Endpoints**:
  - **Development**: (e.g., `https://dev-ess.ebaconnect.com/services`)
  - **UAT**: (e.g., `https://uat-ess.ebaconnect.com/services`)
  - **Production**: (e.g., `https://ess.ebaconnect.com/services`)
- **XML Namespaces**: All target namespaces used in the SOAP envelopes.
- **SOAP Version**: Specify if SOAP 1.1 or 1.2 is used.

## 2. Authentication Contract
- **Mechanism**: (e.g., Basic Auth, NTLM, Custom SOAP Headers, Session ID).
- **Request Format**: Example XML for the authentication request.
- **Response Format**: Example XML for a successful login, including session tokens or IDs.
- **Error Format**: Example XML for failed authentication (SOAP Faults).

## 3. Core Functional APIs
For each of the following, provide Request/Response XML examples:

### Attendance
- **Check-In/Out**: API must accept:
  - `employeeId`
  - `action` (CHECK_IN/CHECK_OUT)
  - `latitude` (Double)
  - `longitude` (Double)
  - `accuracy` (Double)
  - `isMocked` (Boolean) - *Application reports if GPS is being spoofed.*
  - `deviceTimestamp`
- **Security Note**: The backend MUST independently validate the coordinates against the office geofence. The app performs a UX-only check.

### Leave Management
- **GetBalances**: Available days for Annual, Sick, etc.
- **GetRequests**: History of leave applications.
- **SubmitRequest**: Apply for new leave.

### Payroll
- **GetPayslips**: List of available payslips.
- **GetPayslipPDF**: Binary or Base64 data for the specific payslip file.

## 4. Error Handling
- List of application-level error codes (e.g., `ERR_OUTSIDE_GEOFENCE`, `ERR_SESSION_EXPIRED`).
- Standardized SOAP Fault structure.

## 5. Security & Connectivity
- **HTTPS**: All communication must be encrypted.
- **Certificate Pinning**: Specify if custom SSL certificates are required.
- **VPN**: Specify if a corporate VPN is required for the app to reach the endpoints.

---
**Current Status**: Backend Integration Ready — Awaiting Client SOAP/WSDL Contract.

## 6. Client Backend Requirements Checklist
Please provide the following to proceed with the integration:

- [ ] **WSDL file or WSDL URL**
- [ ] **UAT SOAP endpoint URL**
- [ ] **Production SOAP endpoint URL**
- [ ] **Available SOAP operations** (Login, CheckIn, GetProfile, etc.)
- [ ] **XML Namespaces** used in SOAP envelopes
- [ ] **SOAP Headers** required for authentication/session
- [ ] **Authentication mechanism** (Basic, Token, Session ID)
- [ ] **Sample Login request/response XML**
- [ ] **Sample Attendance request/response XML**
- [ ] **Sample Leave request/response XML**
- [ ] **Sample Payslip request/response XML**
- [ ] **Sample Employee/Profile request/response XML**
- [ ] **SOAP Fault examples** for various error cases
- [ ] **Test/UAT credentials** (Employee ID and Password)
- [ ] **VPN/Network requirements** (if services are internal)
- [ ] **SSL/Certificate requirements** (Custom CA or pinning)
- [ ] **Server-side attendance/geofence rules**
- [ ] **Office coordinates and allowed radius** for server validation
