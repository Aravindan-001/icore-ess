# ebaConnect / iCore ESS — User Flows & Navigation Diagrams

This document contains Mermaid diagrams illustrating the primary user navigation flows, session handling, business operations, and role-based routing implemented in the application.

---

## 1. Authentication & Session Flow

```mermaid
flowchart TD
    START([App Launch]) --> BOOT["BootstrapScreen (SCR-001)"]
    BOOT --> CHECK_SESS{"SessionManager.hasSession()"}
    
    CHECK_SESS -->|No Active Session| LOGIN["LoginScreen (SCR-002)"]
    CHECK_SESS -->|Active Session Found| FETCH_ROLE["SessionManager.getUserRole()"]
    
    LOGIN --> INPUT["User enters Employee ID & Password"]
    INPUT --> REM_CHK{"Remember Me Enabled?"}
    REM_CHK -->|Yes| SAVE_REM["Save remembered_id to Secure Storage"]
    REM_CHK -->|No| CLEAR_REM["Clear remembered_id"]
    
    SAVE_REM --> SUBMIT["AuthService.login()"]
    CLEAR_REM --> SUBMIT
    SUBMIT --> AUTH_VAL{"Credentials Valid?"}
    
    AUTH_VAL -->|Invalid| ERR["Show Error SnackBar"] --> LOGIN
    AUTH_VAL -->|Valid| SAVE_SESS["Save Token, SessionId, Role to SecureStorage"]
    
    SAVE_SESS --> ROLE_CHK{"User Role?"}
    FETCH_ROLE --> ROLE_CHK
    ROLE_CHK -->|Employee| EMP_NAV["MainNavigation Hub (/main) -> Employee Tabs"]
    ROLE_CHK -->|HR Admin| HR_NAV["MainNavigation Hub (/main) -> HR Tabs"]
```

---

## 2. Employee Main Navigation Flow

```mermaid
flowchart TD
    NAV_HUB["MainNavigation (SCR-005)"] --> BOTTOM_BAR["Material 3 NavigationBar"]
    
    BOTTOM_BAR -->|Tab 0: Home| DASH["DashboardScreen (SCR-006)"]
    BOTTOM_BAR -->|Tab 1: Payslips| PAY["PayslipScreen (SCR-010)"]
    BOTTOM_BAR -->|Tab 2: Leave| LEAVE["LeaveScreen (SCR-008)"]
    BOTTOM_BAR -->|Tab 3: Pay Summary| SUM["PaySummaryScreen (SCR-012)"]
    BOTTOM_BAR -->|Tab 4: Profile| PROF["ProfileScreen (SCR-030)"]
    
    DASH -->|Tap Attendance Card| ATT["AttendanceScreen (SCR-007)"]
    DASH -->|Tap Pending Requests| REQ["RequestsScreen (SCR-025)"]
    DASH -->|Tap Notification Icon| NOTIF["NotificationsScreen (SCR-026)"]
    DASH -->|Tap Quick Service Tile| SVC_GRID["Service Module Routes"]
```

---

## 3. Location-Based GPS Attendance Flow

```mermaid
flowchart TD
    ATT_SCR["AttendanceScreen (SCR-007)"] --> TAP_ACT["User taps Check In / Check Out"]
    TAP_ACT --> GPS_REQ["GeolocatorLocationService.getLocationDetails()"]
    
    GPS_REQ --> PERM_CHK{"GPS Permitted & Enabled?"}
    PERM_CHK -->|No| ERR_PERM["Display Location Error Banner / Retry"]
    
    PERM_CHK -->|Yes| ACC_CHK{"GPS Accuracy <= 100 meters?"}
    ACC_CHK -->|No| ERR_ACC["Display GPS Accuracy Warning"]
    
    ACC_CHK -->|Yes| GEO_CHK{"Distance to Office <= 50 meters?"}
    GEO_CHK -->|No| ERR_GEO["Display Office Geofence Warning (Outside 50m)"]
    
    GEO_CHK -->|Yes| STATE_MACHINE{"Current State?"}
    STATE_MACHINE -->|Not Marked| CHECK_IN["AttendanceService.checkIn()"]
    STATE_MACHINE -->|Checked In| CHECK_OUT["AttendanceService.checkOut()"]
    
    CHECK_IN --> EXEC_REPO["EssRepository Boundary"]
    CHECK_OUT --> EXEC_REPO["EssRepository Boundary"]
    EXEC_REPO -->|Current| MOCK["MockEssRepository"]
    EXEC_REPO -.->|Target| SOAP["SoapEssRepository"]
    
    EXEC_REPO --> SUCCESS["Update Today State & Refresh UI"]
    SUCCESS --> LOG_ANALYTICS["AnalyticsService: attendance_marked"]
```

---

## 4. Leave Application & Unified Request Flow

```mermaid
flowchart TD
    LEAVE_SCR["LeaveScreen (SCR-008)"] --> TAP_APPLY["Tap Apply Leave Button / FAB"]
    TAP_APPLY --> APPLY_SCR["ApplyLeaveScreen (SCR-009)"]
    
    APPLY_SCR --> FORM["Fill Type, Start Date, End Date, Reason"]
    FORM --> SUBMIT["Tap Submit Request"]
    SUBMIT --> VAL{"Form Valid & Dates Legal?"}
    
    VAL -->|No| SHOW_VAL_ERR["Display Inline Validation Errors"]
    VAL -->|Yes| SVC["LeaveService.applyLeave()"]
    
    SVC --> REPO["EssRepository Boundary"]
    REPO -->|Current| MOCK["MockEssRepository"]
    MOCK --> LOG_EVENT["AnalyticsService: request_submitted"]
    LOG_EVENT --> NAV_BACK["Navigate back to LeaveScreen & Show SnackBar"]
    
    LEAVE_SCR --> VIEW_REQ["Tap View Requests"]
    VIEW_REQ --> REQ_CENTER["Unified Request Center (SCR-025)"]
    REQ_CENTER --> AGG["RequestsService Aggregates 7 Modules"]
    AGG --> FILTER["Apply Category & Status Chips Filter"]
```

---

## 5. Payroll, Payslip & Vector PDF Generation Flow

```mermaid
flowchart TD
    PAY_SCR["PayslipScreen (SCR-010)"] --> SELECT_YEAR["Select Year Filter Dropdown"]
    SELECT_YEAR --> FETCH_LIST["payslipsProvider Fetches Annual History"]
    FETCH_LIST --> TAP_ITEM["Tap Payslip List Item"]
    
    TAP_ITEM --> DET_SCR["PayslipDetailScreen (SCR-011)"]
    DET_SCR --> FETCH_DET["payslipDetailProvider Fetches Earnings & Deductions"]
    FETCH_DET --> ARITH_CHK["Verify: Net Pay = Total Earnings - Total Deductions"]
    
    DET_SCR --> TAP_PDF["User taps Download / Share PDF"]
    TAP_PDF --> PDF_ENGINE["PdfGenerator.generatePayslipPdf()"]
    
    PDF_ENGINE --> BUILD_A4["Build pw.Document A4 Page Format"]
    BUILD_A4 --> HEADER["Header: Employee Info, Dept, Designation, Period"]
    HEADER --> TABLES["Earnings vs Deductions Dual-Column Table"]
    TABLES --> SAVE_TEMP["Save to path_provider getTemporaryDirectory()"]
    SAVE_TEMP --> SHARE["Invoke Share.shareXFiles via share_plus"]
```

---

## 6. Notifications & Deep-Link Routing Flow

```mermaid
flowchart TD
    APP_BAR["AppBar Notification Bell"] --> NOTIF_SCR["NotificationsScreen (SCR-026)"]
    NOTIF_SCR --> FETCH_NOTIF["notificationsProvider Fetches List"]
    FETCH_NOTIF --> UNREAD_BADGE["unreadNotificationCountProvider Computes Badge"]
    
    NOTIF_SCR --> FILTER["Filter by Category: All, System, Leave, Payroll, General"]
    NOTIF_SCR --> TAP_ITEM["User taps Notification Item"]
    
    TAP_ITEM --> LOG_TELEMETRY["AnalyticsService: notification_opened"]
    LOG_TELEMETRY --> MARK_READ["NotificationService.markAsRead()"]
    MARK_READ --> TARGET_DISPATCH{"Notification Category / Deep Link Target?"}
    
    TARGET_DISPATCH -->|Leave| ROUTE_LV["Navigator.pushNamed('/leave')"]
    TARGET_DISPATCH -->|Payroll| ROUTE_PAY["Navigator.pushNamed('/payslip')"]
    TARGET_DISPATCH -->|General| ROUTE_DASH["Navigator.pushNamed('/dashboard')"]
```

---

## 7. Personal Information Portal Flow

```mermaid
flowchart TD
    PROF_SCR["ProfileScreen (SCR-030)"] --> TAP_PERSONAL["Tap Personal Information Tile"]
    TAP_PERSONAL --> LANDING["PersonalInformationLandingScreen (SCR-031)"]
    
    LANDING --> SUB_1["1. Basic Information (SCR-032)"]
    LANDING --> SUB_2["2. Family Information (SCR-033)"]
    LANDING --> SUB_3["3. Bank Information (SCR-034)"]
    LANDING --> SUB_4["4. Education History (SCR-035)"]
    LANDING --> SUB_5["5. Education Documents (SCR-036)"]
    LANDING --> SUB_6["6. Skills (SCR-037)"]
    LANDING --> SUB_7["7. Identity Documents (SCR-038)"]
    LANDING --> SUB_8["8. Work History (SCR-039)"]
    LANDING --> SUB_9["9. Certificates (SCR-040)"]
    LANDING --> SUB_10["10. Profile Requests (SCR-041)"]
```

---

## 8. My Documents Navigation Flow

```mermaid
flowchart TD
    PROF_SCR["ProfileScreen (SCR-030)"] --> TAP_DOCS["Tap My Documents Tile"]
    TAP_DOCS --> DOCS_SCR["DocumentsScreen (SCR-027)"]
    
    DOCS_SCR --> DOC_LIST["Render Document Category List"]
    DOC_LIST --> TAP_PAYSLIP_DOC["Tap Payslip Document Tile"]
    
    TAP_PAYSLIP_DOC --> NAV_PAY_DET["Navigator.pushNamed('/payslip/detail', {year, month})"]
    NAV_PAY_DET --> DET_SCR["PayslipDetailScreen (SCR-011)"]
```

---

## 9. HR Administrator Navigation Flow

```mermaid
flowchart TD
    HR_NAV_HUB["MainNavigation (SCR-005) - Role: hr"] --> HR_BOTTOM_BAR["HR NavigationBar"]
    
    HR_BOTTOM_BAR -->|Tab 0: Admin| HR_DASH["HrDashboardScreen (SCR-042)"]
    HR_BOTTOM_BAR -->|Tab 1: Employees| HR_EMP["HrEmployeeListScreen (SCR-043)"]
    HR_BOTTOM_BAR -->|Tab 2: Leaves| HR_LV["HrLeaveRequestsScreen (SCR-044)"]
    HR_BOTTOM_BAR -->|Tab 3: Payroll| HR_PAY["HrPayslipMgmtScreen (SCR-045)"]
    HR_BOTTOM_BAR -->|Tab 4: Profile| PROF["ProfileScreen (SCR-030)"]
    
    HR_DASH --> TILE_1["Tap Employee Roster Card"] --> HR_EMP
    HR_DASH --> TILE_2["Tap Leave Approvals Card"] --> HR_LV
    HR_DASH --> TILE_3["Tap Payroll Overview Card"] --> HR_PAY
```

---

## 10. HR Leave Management & Approval Flow

```mermaid
flowchart TD
    HR_LV_SCR["HrLeaveRequestsScreen (SCR-044)"] --> FETCH_PENDING["Fetch Pending Leave Applications"]
    FETCH_PENDING --> RENDER_CARDS["Render Leave Request Cards with Actions"]
    
    RENDER_CARDS --> TAP_APP["Tap Approve Button"]
    RENDER_CARDS --> TAP_REJ["Tap Reject Button"]
    
    TAP_APP --> EXEC_APP["Update Application Status to Approved"]
    TAP_REJ --> EXEC_REJ["Update Application Status to Rejected"]
    
    EXEC_APP --> SHOW_SNACK["Show Action Result SnackBar"]
    EXEC_REJ --> SHOW_SNACK["Show Action Result SnackBar"]
    SHOW_SNACK --> REFRESH["Refresh Pending Leaves List"]
```

---

## 11. HR Payroll & Payslip Inspection Flow

```mermaid
flowchart TD
    HR_PAY_SCR["HrPayslipMgmtScreen (SCR-045)"] --> SELECT_EMP["Select Employee from Dropdown / Roster"]
    SELECT_EMP --> SELECT_PERIOD["Select Year / Month Period"]
    
    SELECT_PERIOD --> FETCH_EMP_PAY["Fetch Employee Payslip Record"]
    FETCH_EMP_PAY --> RENDER_BREAKDOWN["Display Earnings, Deductions & Net Pay Card"]
    
    RENDER_BREAKDOWN --> INSPECT_PDF["Tap Inspect / View Payslip Detail"]
    INSPECT_PDF --> PAY_DET_SCR["PayslipDetailScreen (SCR-011)"]
```
