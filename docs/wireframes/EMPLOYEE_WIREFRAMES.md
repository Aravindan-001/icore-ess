# ebaConnect / iCore ESS — Employee Wireframe Specifications

This document contains detailed wireframe specifications and ASCII layouts for all Employee and Shared screens in the **ebaConnect / iCore ESS** mobile application.

---

# Screen: Bootstrap Screen (SCR-001)

## Purpose
Initial application startup screen that verifies session status in secure storage and routes the user to either the Main Navigation Hub or the Login Screen.

## Role
Shared (Employee & HR)

## Route
`/` (`AppConstants.bootstrapRoute`)

## Entry Points
- Application launch

## Layout
Centered logo and branding text
↓
Indeterminate CircularProgressIndicator

## Components
| Component | Type | Behaviour |
| :--- | :--- | :--- |
| Brand Logo | Image | Displays `assets/images/ebaconnect_logo.png` |
| Loading Indicator | CircularProgressIndicator | Animates during `SessionManager.hasSession()` check |

## User Actions
None (Automated state check).

## States
- **Loading**: Displays branding logo and progress spinner while validating secure session.

## Navigation
- To `/main` if active session is present in secure storage.
- To `/login` if no session is present or session expired.

## Data Source
`SessionManager.hasSession()` / `SessionManager.getUserRole()`

## ASCII Wireframe
```
+--------------------------------+
|                                |
|          [ebaConnect]          |
|              LOGO              |
|                                |
|              ( o )             |
|       Restoring Session...     |
|                                |
+--------------------------------+
```

## Implementation Traceability
- **Flutter File**: `lib/features/auth/bootstrap_screen.dart`
- **Provider**: `authServiceProvider`
- **Service**: `AuthService`
- **Repository**: `SessionManager` (`FlutterSecureStorage`)
- **Route**: `/`

---

# Screen: Login Screen (SCR-002)

## Purpose
Authentication screen where employees and HR administrators enter credentials to access the application.

## Role
Shared (Employee & HR)

## Route
`/login` (`AppConstants.loginRoute`)

## Entry Points
- Bootstrap Screen (when unauthenticated)
- Profile Screen Logout action

## Layout
Header branding & title
↓
Employee ID text input
↓
Password text input (with visibility toggle)
↓
Remember Me checkbox & Forgot Password link
↓
Login Button
↓
Development Quick Fill Chips (`20140` / `HR001`)

## Components
| Component | Type | Behaviour |
| :--- | :--- | :--- |
| Employee ID Field | CustomTextField | Captures Employee ID |
| Password Field | CustomTextField | Captures password with obscure toggle icon |
| Remember Me | Checkbox | Toggles `remembered_id` secure storage persistence |
| Forgot Password | TextButton | Displays password reset dialog / notice |
| Login Button | ElevatedButton | Submits credentials to `AuthService.login()` |
| Demo Quick Fill Chips | ActionChip | Pre-fills credentials for test accounts (`20140` / `HR001`) |

## User Actions
| Action | Result |
| :--- | :--- |
| Enter Credentials & Tap Login | Validates inputs, authenticates via repository, saves session |
| Tap "Remember Me" | Persists or clears `remembered_id` in secure storage |
| Tap Demo Chip | Pre-populates form fields with demo credentials |

## States
- **Success**: Authenticates and navigates to `/main`.
- **Error**: Displays SnackBar with authentication failure message.
- **Loading**: Disables form inputs and displays button progress spinner.

## Navigation
- To `/main` on successful authentication.

## Data Source
`authServiceProvider` -> `AuthService` -> `AuthRepository`

## ASCII Wireframe
```
+--------------------------------+
|          ebaConnect            |
|   Employee Self-Service Portal |
+--------------------------------+
|  Employee ID                    |
|  [ 20140                     ] |
|                                |
|  Password                      |
|  [ ***********            (o) ]|
|                                |
|  [x] Remember Me   Forgot?     |
|                                |
|  +--------------------------+  |
|  |         LOGIN            |  |
|  +--------------------------+  |
|                                |
|  Quick Fill: [20140]  [HR001]  |
+--------------------------------+
```

## Implementation Traceability
- **Flutter File**: `lib/features/auth/login_screen.dart`
- **Provider**: `authServiceProvider`, `analyticsServiceProvider`
- **Service**: `AuthService`, `AnalyticsService`
- **Repository**: `EssRepository` / `MockEssRepository`
- **Route**: `/login`

---

# Screen: Home Dashboard (SCR-006)

## Purpose
Main landing page for employees presenting real-time attendance status, quick feature shortcuts, unread notification counter, latest net pay card, and pending request metrics.

## Role
Employee

## Route
`/dashboard` (Tab 0 of `MainNavigation`)

## Entry Points
- Successful Employee login
- MainNavigation Tab 0 selection

## Layout
AppBar (Title: ebaConnect / Employee Portal, Notification Bell with Badge, Profile CircleAvatar)
↓
Greeting Header ("Good Morning,", Employee Name)
↓
Employee Primary Information Card (ID, Dept, Designation, Location, Currency, Divider, Latest Net Pay, Pay Period, "View Latest Payslip" button)
↓
Pending Requests Summary Card
↓
Quick Services 3-Column Grid (My Payslips, Leave, Pay Summary, Documents, Profile, Attendance, Overtime, Airfare, Education, Reimbursement, Claims, Orders)

## Components
| Component | Type | Behaviour |
| :--- | :--- | :--- |
| Notification Icon | IconButton + Badge | Displays unread badge count; navigates to `/notifications` |
| Employee Info Card | Card | Displays ID, department, designation, location, currency, net pay, pay period; contains View Latest Payslip button |
| Pending Requests Card | Card | Displays pending workflow count; navigates to `/requests` |
| Quick Actions Grid | GridView (3 cols) | 12 feature shortcuts navigating to corresponding module routes |

## User Actions
| Action | Result |
| :--- | :--- |
| Tap View Latest Payslip | Navigates to `/payslip/detail` with year/month arguments |
| Tap Notification Bell | Navigates to `/notifications` |
| Tap Pending Requests Card | Navigates to `/requests` |
| Tap Quick Action Tile | Navigates to corresponding feature module route |

## States
- **Loading**: Displays CircularProgressIndicator while loading dashboard data.
- **Success**: Displays active employee metrics, payslip summary, and quick action grid.

## Navigation
- To `/payslip/detail`, `/notifications`, `/profile`, `/requests`, `/payslip`, `/leave`, `/pay-summary`, `/documents`, `/attendance`, `/overtime`, `/airfare`, `/education-declaration`, `/reimbursement`, `/claims`, `/sales-order`.

## Data Source
`dashboardProvider`, `unreadNotificationCountProvider`

## ASCII Wireframe
```
+--------------------------------+
| [logo] ebaConnect         (3)[!]|
+--------------------------------+
| Good Morning,                  |
| ANITHA K                       |
+--------------------------------+
| Employee ID: 20140             |
| Department: RETAIL | DUBAI     |
| ------------------------------ |
| Latest Net Pay: AED 12,450.00  |
| Pay Period: OCT-2026           |
| [   VIEW LATEST PAYSLIP      ] |
+--------------------------------+
| [!] Pending Requests       [>] |
| 3 pending requests awaiting    |
+--------------------------------+
| QUICK ACTIONS                  |
| [Payslips]  [ Leave ]  [PaySum]|
| [Documents] [Profile]  [Attndn]|
| [Overtime]  [Airfare]  [Educat]|
| [Reimburs]  [Claims]   [Orders]|
+--------------------------------+
| Home | Payslips | Leave | Profile|
+--------------------------------+
```

## Implementation Traceability
- **Flutter File**: `lib/features/dashboard/dashboard_screen.dart`
- **Provider**: `dashboardProvider`, `unreadNotificationCountProvider`
- **Service**: `AttendanceService`, `NotificationService`, `PayrollService`
- **Repository**: `EssRepository`
- **Route**: `/dashboard`

---

# Screen: Attendance Management (SCR-007)

## Purpose
Enables location-verified check-in and check-out tracking, enforces 50m geofence rules, displays live GPS accuracy status, and shows attendance logs.

## Role
Employee

## Route
`/attendance` (`AppConstants.attendanceRoute`)

## Entry Points
- Home Dashboard Quick Service Grid / Tile

## Layout
AppBar (Title: Attendance, Refresh Button)
↓
Today's Attendance Status Card (Status Icon, Working Hours, Check-In & Check-Out Times)
↓
Live GPS Location Card (Office Location Verification, Distance to Office, Accuracy Indicator, Geofence Distance)
↓
CHECK IN / CHECK OUT Action Button
↓
Attendance History Section
  - Custom Segmented Filter Chips ("All", "Current Month", "Previous Month")
  - Attendance History Cards List

## Components
| Component | Type | Behaviour |
| :--- | :--- | :--- |
| Status Card | Card | Displays today status (`notMarked`, `checkedIn`, `checkedOut`) and working duration |
| Location Card | Card | Displays distance to office, accuracy in meters, and geofence status |
| Action Button | ElevatedButton | Triggers `checkIn` or `checkOut` after passing 50m geofence check |
| History Filter | FilterChips | Filters history list by All, Current Month, or Previous Month |
| History List | ListView | Renders date, check-in time, check-out time, status, and duration |

## User Actions
| Action | Result |
| :--- | :--- |
| Tap Check In / Out | Fetches GPS, verifies 50m geofence & accuracy <= 100m, executes check-in/out |
| Pull to Refresh / Tap Refresh | Re-fetches device GPS position, today record, and history |
| Select Filter Chip | Filters history list by selected time range |

## States
- **Loading**: Circular progress indicator while resolving GPS coordinates or attendance data.
- **Success**: Geofence valid; Check In / Check Out enabled.
- **Geofence Warning**: Distance > 50m; Check In button disabled with warning text.
- **GPS Error**: Displays location disabled, permission required, or settings prompt.

## Navigation
- Back to Dashboard.

## Data Source
`attendanceLocationProvider`, `todayAttendanceProvider`, `attendanceActionProvider`, `attendanceHistoryProvider`

## ASCII Wireframe
```
+--------------------------------+
| < Back       Attendance    (R) |
+--------------------------------+
| TODAY'S ATTENDANCE             |
| Status: Checked In             |
| Working Hours: 04h 15m         |
| Check In: 08:45 AM | Out: --:--|
+--------------------------------+
| OFFICE LOCATION VERIFIED       |
| Distance: 12.0 m               |
| Accuracy: 15.0 m               |
| Within 50m allowed radius      |
+--------------------------------+
| [       CHECK OUT NOW        ] |
+--------------------------------+
| ATTENDANCE HISTORY             |
| [All] [Current Month] [Prev]   |
| 01 Oct 2026 | 08:45 AM-05:30 PM|
| Present | 08h 45m              |
+--------------------------------+
```

## Implementation Traceability
- **Flutter File**: `lib/features/attendance/attendance_screen.dart`
- **Provider**: `attendanceActionProvider`, `attendanceLocationProvider`, `todayAttendanceProvider`, `attendanceHistoryProvider`
- **Service**: `AttendanceService`, `LocationService`
- **Repository**: `AttendanceRepository` / `EssRepository`
- **Route**: `/attendance`

---

# Screen: Leave Management (SCR-008)

## Purpose
Enables employees to review leave entitlement balances and fill out embedded leave application forms.

## Role
Employee

## Route
`/leave` (`AppConstants.leaveRoute` / Tab 2 of `MainNavigation`)

## Entry Points
- MainNavigation Tab 2 selection
- Dashboard Leave Shortcut

## Layout
AppBar (Title: Leave)
↓
Compensatory Leave Balance Card (Available, Used, Pending, Approved, Balance metrics)
↓
Leave Request Form Card (Document No., Leave Type Dropdown, From/To Dates, Half Day Checkboxes, Air Ticket / Advance Salary Toggles)
↓
Leave Summary Card (Calendar Days, Leave Days)
↓
Form Action Buttons (Reset, Submit Leave Request)

## Components
| Component | Type | Behaviour |
| :--- | :--- | :--- |
| Balance Card | Card | Displays leave balance breakdown metrics |
| Document Field | TextFormField | Displays generated document reference number |
| Leave Type Selector | DropdownButtonFormField | Selects Annual, Sick, Casual, Compensatory |
| Date Fields | TextFormField + Calendar Icon | Displays start and end dates |
| Options Checkboxes | Checkbox | Toggles Half Day, Air Ticket, Advance Salary options |
| Summary Box | Container | Displays calculated Calendar Days and Leave Days |
| Action Buttons | OutlinedButton / ElevatedButton | Resets form or submits leave request |

## User Actions
| Action | Result |
| :--- | :--- |
| Select Leave Type | Updates selected leave category |
| Tap Reset | Resets form input fields |
| Tap Submit Leave Request | Submits leave application, logs analytics, shows SnackBar |

## States
- **Success**: Form pre-filled; submitting shows success SnackBar and logs telemetry.
- **Validation**: Ensures required fields are provided before submission.

## Navigation
- Within main shell navigation stack.

## Data Source
`analyticsServiceProvider` -> `AnalyticsService` -> `EssRepository`

## ASCII Wireframe
```
+--------------------------------+
| Leave Management       [Apply] |
+--------------------------------+
| BALANCES                       |
| Annual: 18/22 | Sick: 10/10    |
+--------------------------------+
| [All] [Pending] [Approved]     |
+--------------------------------+
| Annual Leave                   |
| 12 Oct 2026 - 15 Oct 2026      |
| 4 Days | Status: Approved      |
+--------------------------------+
| Casual Leave                   |
| 02 Nov 2026 - 02 Nov 2026      |
| 1 Day  | Status: Pending       |
+--------------------------------+
| Home | Payslips | Leave | Profile|
+--------------------------------+
```

## Implementation Traceability
- **Flutter File**: `lib/features/leave/leave_screen.dart`
- **Provider**: `leaveServiceProvider`
- **Service**: `LeaveService`
- **Repository**: `EssRepository`
- **Route**: `/leave`

---

# Screen: Apply Leave Screen (SCR-009)

## Purpose
Form interface allowing employees to select leave types, pick date ranges, attach reasons, and submit leave applications.

## Role
Employee

## Route
`/leave/apply` (`AppConstants.leaveApplyRoute`)

## Entry Points
- Leave Overview Screen Apply button / FAB

## Layout
AppBar (Title: Apply Leave)
↓
Leave Type Dropdown
↓
Start Date & End Date Pickers
↓
Total Days Calculation Banner
↓
Reason Text Input Field
↓
Submit Application Button

## Components
| Component | Type | Behaviour |
| :--- | :--- | :--- |
| Leave Type Selector | DropdownButtonFormField | Selects Annual, Sick, Casual, Unpaid |
| Start / End Date | TextFormField + DatePicker | Selects date range; calculates business days |
| Reason Field | CustomTextField | Captures text explanation for leave request |
| Submit Button | ElevatedButton | Validates form and invokes `LeaveService.applyLeave()` |

## User Actions
| Action | Result |
| :--- | :--- |
| Select Dates | Calculates and displays total leave days |
| Tap Submit | Submits leave application, logs analytics, pops back to LeaveScreen |

## States
- **Success**: Submits leave, shows success SnackBar, pops screen.
- **Validation Error**: Displays inline date or required field error messages.

## Navigation
- Pops back to `/leave`.

## Data Source
`leaveServiceProvider` -> `LeaveService`

## ASCII Wireframe
```
+--------------------------------+
| < Back       Apply Leave       |
+--------------------------------+
| Leave Type                     |
| [ Annual Leave             v ] |
|                                |
| Start Date          End Date   |
| [ 2026-10-12 ]    [ 2026-10-15]|
|                                |
| Total Duration: 4 Days         |
|                                |
| Reason for Leave               |
| [ Family Event               ] |
|                                |
| +----------------------------+ |
| |     SUBMIT APPLICATION     | |
| +----------------------------+ |
+--------------------------------+
```

## Implementation Traceability
- **Flutter File**: `lib/features/leave/apply_leave_screen.dart`
- **Provider**: `leaveServiceProvider`, `analyticsServiceProvider`
- **Service**: `LeaveService`
- **Repository**: `EssRepository`
- **Route**: `/leave/apply`

---

# Screen: Payslip History (SCR-010)

## Purpose
Displays historical annual payslip statements with year filtering and net pay previews.

## Role
Employee

## Route
`/payslip` (`AppConstants.payslipRoute` / Tab 1 of `MainNavigation`)

## Entry Points
- MainNavigation Tab 1 selection
- Dashboard Payslip shortcut

## Layout
AppBar (Title: Payslips)
↓
Year Selector Dropdown (e.g. 2026, 2025)
↓
Annual Payslip Item List

## Components
| Component | Type | Behaviour |
| :--- | :--- | :--- |
| Year Dropdown | DropdownButton | Filters payslip list by calendar year |
| Payslip Tile | Card | Displays month, net pay figure, pay date; opens `/payslip/detail` |

## User Actions
| Action | Result |
| :--- | :--- |
| Tap Payslip Tile | Navigates to `PayslipDetailScreen` for selected year/month |
| Change Year | Updates list to show statements for selected year |

## States
- **Loading**: Displays loading progress spinner.
- **Success**: Renders payslip cards list.

## Navigation
- To `/payslip/detail` with `{year, month}` arguments.

## Data Source
`payslipsProvider` -> `PayrollService` -> `EssRepository`

## ASCII Wireframe
```
+--------------------------------+
| Payslips              [ 2026 v]|
+--------------------------------+
| October 2026 Payslip           |
| Net Pay: AED 12,450.00         |
| Pay Date: 31 Oct 2026     [>]  |
+--------------------------------+
| September 2026 Payslip         |
| Net Pay: AED 12,450.00         |
| Pay Date: 30 Sep 2026     [>]  |
+--------------------------------+
| Home | Payslips | Leave | Profile|
+--------------------------------+
```

## Implementation Traceability
- **Flutter File**: `lib/features/payslip/payslip_screen.dart`
- **Provider**: `payslipsProvider`
- **Service**: `PayrollService`
- **Repository**: `PayrollRepository` / `EssRepository`
- **Route**: `/payslip`

---

# Screen: Payslip Detail Screen (SCR-011)

## Purpose
Provides granular breakdown of earnings, deductions, working days, and arithmetic verification, with vector PDF generation and sharing options.

## Role
Shared (Employee & HR)

## Route
`/payslip/detail` (`AppConstants.payslipDetailRoute`)

## Entry Points
- Payslip History List item tap
- Documents Screen direct link
- HR Payslip Management item tap

## Layout
AppBar (Title: Payslip Detail)
↓
Employee & Period Header Card
↓
Attendance Breakdown Summary (Paid Days, LOP, OT Hours)
↓
Earnings & Deductions Dual-Column Breakdown Table
↓
Net Salary Highlight Card
↓
PDF Download & Share Action Buttons

## Components
| Component | Type | Behaviour |
| :--- | :--- | :--- |
| Employee Header Card | Card | Renders ID, Name, Department, Designation, Bank Details |
| Breakdown Table | Table | Itemizes Basic, HRA, Allowances vs Tax, LOP, Insurance |
| Net Pay Banner | Card | Displays Net Pay = Total Earnings - Total Deductions |
| Download PDF | ElevatedButton | Generates vector A4 PDF via `PdfGenerator` |
| Share PDF | OutlinedButton | Opens native OS share sheet using `share_plus` |

## User Actions
| Action | Result |
| :--- | :--- |
| Tap Download / Share PDF | Generates PDF, writes to temp storage, triggers share sheet |

## States
- **Loading**: Displays loading indicator while fetching payslip breakdown.
- **Success**: Displays full earnings/deductions breakdown and PDF action controls.

## Navigation
- Back to Payslip History or Documents screen.

## Data Source
`payslipDetailProvider(year, month)` -> `PayrollService` -> `PdfGenerator`

## ASCII Wireframe
```
+--------------------------------+
| < Back       Payslip Detail    |
+--------------------------------+
| ANITHA K (20140)               |
| Period: October 2026           |
| Dept: RETAIL | Bank: ENBD      |
+--------------------------------+
| EARNINGS          DEDUCTIONS   |
| Basic:  8,000     Tax:       0 |
| HRA:    3,000     LOP:     550 |
| Allow:  2,000                  |
+--------------------------------+
| TOTAL: 13,000     TOTAL:   550 |
| NET PAY: AED 12,450.00         |
+--------------------------------+
| [DOWNLOAD PDF]   [SHARE PDF]   |
+--------------------------------+
```

## Implementation Traceability
- **Flutter File**: `lib/features/payslip/payslip_detail_screen.dart`
- **Provider**: `payslipDetailProvider`
- **Service**: `PayrollService`, `PdfGenerator`
- **Repository**: `PayrollRepository` / `EssRepository`
- **Route**: `/payslip/detail`

---

# Screen: Unified Request Center (SCR-025)

## Purpose
Consolidates request workflows from 7 distinct domains into a unified interface with category and status filter chips and metric summaries.

## Role
Employee

## Route
`/requests` (`AppConstants.requestsRoute`)

## Entry Points
- Home Dashboard Request Metrics Card / Tile

## Layout
AppBar (Title: Unified Requests)
↓
Metrics Overview Cards (Pending, Approved, Rejected)
↓
Category Filter Chips (All, Leave, Overtime, Airfare, Education, Reimbursement, Claims)
↓
Status Filter Chips (All, Pending, Approved, Rejected)
↓
Unified Request Tile List

## Components
| Component | Type | Behaviour |
| :--- | :--- | :--- |
| Metrics Cards | Row | Displays summary counts |
| Category Chips | SingleSelect ChoiceChips | Filters list by module type |
| Status Chips | SingleSelect ChoiceChips | Filters list by request status |
| Request Tile | Card | Renders title, domain badge, date, status chip, and details |

## User Actions
| Action | Result |
| :--- | :--- |
| Select Category / Status Chip | Re-computes filtered requests list via `filteredRequestsProvider` |

## States
- **Loading**: Displays loading indicator.
- **Success**: Renders request metrics and filtered request tile list.
- **Empty**: Displays `EmptyState` widget when no requests match filters.

## Navigation
- Back to Dashboard.

## Data Source
`filteredRequestsProvider`, `requestsFilterProvider` -> `RequestsService`

## ASCII Wireframe
```
+--------------------------------+
| < Back       Request Center    |
+--------------------------------+
| [Pending: 3] [Approved: 12]    |
+--------------------------------+
| CATEGORIES                     |
| [All] [Leave] [Overtime] [More]|
+--------------------------------+
| STATUS                         |
| [All] [Pending] [Approved]     |
+--------------------------------+
| Annual Leave Request           |
| Category: Leave | 12 Oct 2026  |
| Status: Approved          [>]  |
+--------------------------------+
| Overtime Claim (4 Hrs)         |
| Category: Overtime | 05 Oct    |
| Status: Pending           [>]  |
+--------------------------------+
```

## Implementation Traceability
- **Flutter File**: `lib/features/requests/requests_screen.dart`
- **Provider**: `filteredRequestsProvider`, `requestsFilterProvider`
- **Service**: `RequestsService`
- **Repository**: `EssRepository`
- **Route**: `/requests`

---

# Screen: Notifications Screen (SCR-026)

## Purpose
Displays notification items with category filtering, unread badge counters, mark-as-read actions, and deep-link navigation.

## Role
Employee

## Route
`/notifications` (`AppConstants.notificationsRoute`)

## Entry Points
- AppBar Notification Bell Icon

## Layout
AppBar (Title, Mark All Read Button)
↓
Category Filter Chips (All, System, Leave, Payroll, General)
↓
Unread Only Switch
↓
Notification Tile List

## Components
| Component | Type | Behaviour |
| :--- | :--- | :--- |
| Mark All Read | TextButton | Marks all items read; clears unread badge |
| Category Chips | ChoiceChips | Filters notifications list by category |
| Notification Tile | ListTile | Shows title, timestamp, unread dot; taps deep link |

## User Actions
| Action | Result |
| :--- | :--- |
| Tap Notification Tile | Marks notification read, logs `notification_opened`, deep-links to module |
| Tap Mark All Read | Updates all notifications to read state |

## States
- **Loading**: Displays loading spinner.
- **Success**: Renders filtered notification tile list.
- **Empty**: Displays `EmptyState` widget.

## Navigation
- Deep links to `/leave`, `/payslip`, `/dashboard`, or target feature module.

## Data Source
`notificationsProvider`, `unreadNotificationCountProvider` -> `NotificationService`

## ASCII Wireframe
```
+--------------------------------+
| < Back  Notifications [Mark All]|
+--------------------------------+
| [All] [System] [Leave] [Payroll]|
+--------------------------------+
| (*) Leave Approved             |
| Your annual leave is approved. |
| 10 mins ago          [Leave >] |
+--------------------------------+
| ( ) Payslip Released           |
| October 2026 payslip available |
| 2 hours ago        [Payslip >] |
+--------------------------------+
```

## Implementation Traceability
- **Flutter File**: `lib/features/notifications/notifications_screen.dart`
- **Provider**: `notificationsProvider`, `unreadNotificationCountProvider`
- **Service**: `NotificationService`
- **Repository**: `NotificationRepository` / `EssRepository`
- **Route**: `/notifications`

---

# Screen: Personal Information Landing (SCR-031)

## Purpose
Main landing portal for employee personal records, organizing employee information into 10 structured sub-sections.

## Role
Employee

## Route
`/profile/personal-info` (`AppConstants.personalInfoLandingRoute`)

## Entry Points
- Profile Screen Personal Information Tile

## Layout
AppBar (Title: Personal Information)
↓
Employee Brief Header Card
↓
10 Structured Navigation Tiles

## Components
| Component | Type | Behaviour |
| :--- | :--- | :--- |
| Sub-section Tile | ListTile | Navigates to corresponding profile sub-screen |

## User Actions
| Action | Result |
| :--- | :--- |
| Tap Sub-section Tile | Navigates to sub-screen (Basic, Family, Bank, Education, etc.) |

## States
- **Success**: Displays list of 10 personal information sub-sections.

## Navigation
- To `/profile/basic-info`, `/profile/family`, `/profile/bank`, `/profile/education`, `/profile/education-docs`, `/profile/skills`, `/profile/identity`, `/profile/work-history`, `/profile/certificates`, `/profile/requests`.

## Data Source
`profileProvider` -> `ProfileService` -> `EssRepository`

## ASCII Wireframe
```
+--------------------------------+
| < Back     Personal Information|
+--------------------------------+
| ANITHA K (20140)               |
| Executive - Sales              |
+--------------------------------+
| 1. Basic Information       [>] |
| 2. Family Information      [>] |
| 3. Bank Information        [>] |
| 4. Education History       [>] |
| 5. Education Documents     [>] |
| 6. Skills                  [>] |
| 7. Identity Documents      [>] |
| 8. Work History            [>] |
| 9. Certificates            [>] |
| 10. Profile Update Requests[>] |
+--------------------------------+
```

## Implementation Traceability
- **Flutter File**: `lib/features/profile/personal_info_landing_screen.dart`
- **Provider**: `profileProvider`
- **Service**: `ProfileService`
- **Repository**: `ProfileRepository` / `EssRepository`
- **Route**: `/profile/personal-info`
