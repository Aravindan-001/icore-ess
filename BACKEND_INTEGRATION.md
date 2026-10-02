# ESS Application - Backend Integration Guide (SOAP/XML)

This document outlines the technical requirements for integrating the ESS Application (ebaConnect / iCore ESS) Flutter mobile application with the client's enterprise HR/ESS SOAP backend.

---

## 1. Technical Requirements Checklist

To connect the application to the live backend, the client engineering team must provide:

1. **WSDL File or WSDL URL**: Web Service Description Language definition covering all ESS operations.
2. **Environment Endpoint URLs**:
   - **Development**: (e.g., `https://dev-ess.example.com/services` - *Placeholder Example*)
   - **UAT**: (e.g., `https://uat-ess.example.com/services` - *Placeholder Example*)
   - **Production**: (e.g., `https://ess.example.com/services` - *Placeholder Example*)
3. **SOAP Specification**:
   - Target XML namespaces used in SOAP request/response envelopes.
   - SOAP protocol version (SOAP 1.1 or SOAP 1.2).
4. **Authentication Contract**:
   - Authentication mechanism (Basic Auth, NTLM, Custom SOAP Headers, Session Token).
   - Sample request/response XML envelopes for login and token refresh.
   - Session termination / logout request XML format.
5. **Network & SSL Requirements**:
   - HTTPS enforcement across all endpoints.
   - SSL Certificate Pinning details or custom CA certificates (if required).
   - Enterprise VPN or IP whitelisting specifications (if endpoints are internal).

---

## 2. Implemented Client Architecture

The Flutter application provides a fully prepared transport and repository layer for SOAP integration:

- **`EssRepository` Contract**: Abstract interface (`lib/repositories/ess_repository.dart`) declaring all data operations.
- **`SoapEssRepository` Implementation**: Backend repository (`lib/repositories/soap_ess_repository.dart`) bound to the SOAP client layer.
- **`SoapClient` Infrastructure**: Low-level HTTP transport helper (`lib/services/soap/soap_client.dart`) handling XML headers, envelope construction (`wrapInEnvelope`), and SOAP Fault detection (`handleSoapFault`).
- **`XmlUtils` Utility**: Lightweight XML parsing and tag extraction helper (`lib/services/soap/xml_utils.dart`).
- **`SoapConfig` Factory**: Environment configuration factory (`lib/services/soap/soap_config.dart`) supporting Dev, UAT, and Production base URLs.
- **Compile-Time Backend Switch**: Enabled using `--dart-define=ESS_BACKEND=soap`.

*Note*: Real network requests executed against `SoapEssRepository` currently throw an `IntegrationException` until the client provides the official WSDL definition and operation schemas.

---

## 3. Application Integration Surface

The client SOAP backend must provide service operations covering the following application domains. *Note: All operation names, parameters, and XML element tags listed below are illustrative placeholders. The actual operation names and XML schema must be derived from the client's official WSDL.*

### 3.1 Authentication & Session
- **Login / Authenticate**: Validates employee credentials and returns session tokens or auth headers.
- **Logout**: Invalidate active session tokens.
- **Change / Forgot Password**: Credentials update handling.

### 3.2 Employee Profile & Personal Information
- **Get Employee Profile**: Summary details (ID, name, designation, department, email, photo URL).
- **Get Employment Summary**: Job title, grade, manager, joining date, work location.
- **Get Personal Information**: Detailed records across 10 sub-sections (Basic Info, Family, Bank, Education, Education Docs, Skills, Identity Documents, Work Experience, Certificates, Profile Update Requests).

### 3.3 Attendance & GPS Tracking
- **Check-In / Check-Out Action**: Accepts employee ID, action type (`CHECK_IN` / `CHECK_OUT`), latitude, longitude, GPS accuracy, `isMocked` flag, and device timestamp.
- **Get Today Attendance**: Current day check-in/out timestamps and status (`notMarked`, `checkedIn`, `completed`).
- **Get Attendance History**: Historical attendance records.
- **Critical Security Requirement**: The mobile app performs a client-side UX geofence check (50m radius, 100m accuracy threshold). The backend **must** perform independent server-side coordinate and geofence validation before writing attendance records to the database.

### 3.4 Leave Management
- **Get Leave Balances**: Balance days for Annual, Sick, Casual, LOP, etc.
- **Get Leave Requests**: Historical and pending leave applications.
- **Apply Leave**: Submit new leave application with dates, type, and reason.

### 3.5 Unified Requests Center
- **Aggregated Requests**: Services supporting Overtime Requests, Airfare Declarations, Education Declarations, Profile Update Requests, Medical Claims, and Reimbursement Requests.

### 3.6 Payroll & Payslips
- **Get Payslips**: Annual list of payslips with summary earnings and net pay.
- **Get Payslip Detail**: Itemized earnings, deductions, LOP, attendance hours, and bank account details for a specific year/month.
- **Get Pay Summary**: YTD earnings, YTD deductions, and net pay breakdown.

### 3.7 Notifications
- **Get Notifications**: Notification feed with category badges and deep-link target parameters.
- **Mark Read / Mark All Read**: Update unread status.

### 3.8 HR Administration (HR Admin Role)
- **HR Employee List**: Fetch full employee directory.
- **HR Leave Management**: Pending leave applications with Approve and Reject operations.
- **HR Payslip Inspection**: HR access to employee payslip records.

---

## 4. Error & SOAP Fault Contract

The backend must return standard SOAP Fault envelopes for errors:

```xml
<!-- Example SOAP Fault Structure (Placeholder Example) -->
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <soap:Fault>
      <faultcode>soap:Client.AuthenticationFailed</faultcode>
      <faultstring>Invalid credentials or expired session token.</faultstring>
      <detail>
        <errorCode>ERR_AUTH_INVALID_CREDENTIALS</errorCode>
      </detail>
    </soap:Fault>
  </soap:Body>
</soap:Envelope>
```

---

## 5. Client Integration Deliverables Checklist

Please provide the following items to finalize the SOAP backend integration:

- [ ] **WSDL File or WSDL URL**
- [ ] **UAT SOAP Endpoint URL**
- [ ] **Production SOAP Endpoint URL**
- [ ] **List of SOAP Operations** (Login, CheckIn, GetProfile, GetLeaveBalances, GetPayslipDetail, etc.)
- [ ] **XML Target Namespaces** used in SOAP request/response envelopes
- [ ] **Authentication Mechanism & SOAP Headers**
- [ ] **Sample Login Request & Response XML**
- [ ] **Sample Attendance Check-In Request & Response XML**
- [ ] **Sample Leave Request & Response XML**
- [ ] **Sample Payslip Detail Request & Response XML**
- [ ] **Sample Profile & Personal Information Request & Response XML**
- [ ] **Sample SOAP Fault XML Envelopes** for error cases
- [ ] **UAT Test Credentials** (Employee and HR Admin test accounts)
- [ ] **Network / VPN Requirements** (if endpoints are internal)
- [ ] **SSL / Custom CA Certificate Requirements** (if certificate pinning is required)
- [ ] **Server-Side Office Coordinates & Geofence Validation Rules**
