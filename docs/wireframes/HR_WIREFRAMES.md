# ebaConnect / iCore ESS — HR Administrator Wireframe Specifications

This document contains wireframe specifications and ASCII layouts for all HR Administration screens in the **ebaConnect / iCore ESS** application.

---

# Screen: HR Admin Dashboard (SCR-042)

## Purpose
Administrative dashboard for HR Manager presenting organization-wide metrics, quick navigation shortcuts to employee rosters, leave approvals, and payroll management.

## Role
HR Administrator

## Route
`/hr/dashboard` (`AppConstants.hrDashboardRoute` / Tab 0 of HR `MainNavigation`)

## Entry Points
- HR Administrator login
- HR MainNavigation Tab 0 selection

## Layout
AppBar (Title: HR Administration)
↓
HR Manager Profile Header Card
↓
High-Level HR Metrics Summary Grid (Total Staff, Pending Leaves, Active Payrolls)
↓
Administrative Workflow Action Cards (Employee Roster, Leave Approvals, Payroll Mgmt)

## Components
| Component | Type | Behaviour |
| :--- | :--- | :--- |
| Metric Card | Card | Displays headcount, pending approvals, and active payroll count |
| Workflow Tile | Card / ListTile | Navigates to target HR administrative screen |

## User Actions
| Action | Result |
| :--- | :--- |
| Tap Employee Roster | Navigates to `/hr/employees` |
| Tap Leave Approvals | Navigates to `/hr/leaves` |
| Tap Payroll Overview | Navigates to `/hr/payslips` |

## States
- **Success**: Displays administrative overview metrics and shortcut tiles.

## Navigation
- To `/hr/employees`, `/hr/leaves`, `/hr/payslips`, `/profile`.

## Data Source
`Riverpod` providers -> `MockEssRepository`

## ASCII Wireframe
```
+--------------------------------+
| HR Administration        [CTO] |
+--------------------------------+
| HR MANAGER DASHBOARD           |
| Staff: 142 | Pending Leaves: 5 |
+--------------------------------+
| ADMINISTRATIVE WORKFLOWS       |
|                                |
| [ Employees Roster        >]   |
| [ Pending Leave Approvals >]   |
| [ HR Payroll & Payslips   >]   |
+--------------------------------+
| Admin | Employees | Leaves | Pay|
+--------------------------------+
```

## Implementation Traceability
- **Flutter File**: `lib/features/hr/hr_dashboard_screen.dart`
- **Provider**: `Riverpod`
- **Service**: `AuthService`, `LeaveService`, `PayrollService`
- **Repository**: `EssRepository`
- **Route**: `/hr/dashboard`

---

# Screen: HR Employee Roster (SCR-043)

## Purpose
Provides HR administrators with a list of active employees, staff search capability, and detailed employee profile inspection.

## Role
HR Administrator

## Route
`/hr/employees` (`AppConstants.hrEmployeesRoute` / Tab 1 of HR `MainNavigation`)

## Entry Points
- HR MainNavigation Tab 1 selection
- HR Dashboard Employee Roster tile

## Layout
AppBar (Title: Employee Directory)
↓
Employee Search Bar
↓
Employee Roster Card List (Avatar, Name, ID, Designation, Department)

## Components
| Component | Type | Behaviour |
| :--- | :--- | :--- |
| Search Bar | TextField | Filters employee roster list dynamically |
| Employee Tile | Card | Renders employee avatar, ID, name, designation, and department |

## User Actions
| Action | Result |
| :--- | :--- |
| Type in Search Bar | Filters employee roster by name or ID |
| Tap Employee Tile | Displays employee profile inspection modal |

## States
- **Success**: Displays full list of organization employees.
- **Empty**: Displays empty search state when no staff match search query.

## Navigation
- Within HR Portal navigation stack.

## Data Source
`EssRepository.getEmployee()` / `MockEssRepository`

## ASCII Wireframe
```
+--------------------------------+
| Employee Directory             |
+--------------------------------+
| [ Search employee name/ID... ] |
+--------------------------------+
| (A) ANITHA K (20140)           |
| Executive - Sales | RETAIL [>] |
+--------------------------------+
| (M) MOHAMMED ALI (20141)       |
| Senior Developer | IT     [>] |
+--------------------------------+
| Admin | Employees | Leaves | Pay|
+--------------------------------+
```

## Implementation Traceability
- **Flutter File**: `lib/features/hr/hr_employee_list_screen.dart`
- **Provider**: `Riverpod`
- **Service**: `ProfileService`
- **Repository**: `ProfileRepository` / `EssRepository`
- **Route**: `/hr/employees`

---

# Screen: HR Leave Requests (SCR-044)

## Purpose
Allows HR administrators to inspect pending leave applications submitted by employees and execute mock approval or rejection decisions.

## Role
HR Administrator

## Route
`/hr/leaves` (`AppConstants.hrLeavesRoute` / Tab 2 of HR `MainNavigation`)

## Entry Points
- HR MainNavigation Tab 2 selection
- HR Dashboard Leave Approvals tile

## Layout
AppBar (Title: Leave Request Approvals)
↓
Pending Applications List
↓
Leave Request Card (Employee Name, Type, Dates, Reason, Approve/Reject Actions)

## Components
| Component | Type | Behaviour |
| :--- | :--- | :--- |
| Approve Button | ElevatedButton | Sets request status to Approved; shows SnackBar |
| Reject Button | OutlinedButton | Sets request status to Rejected; shows SnackBar |

## User Actions
| Action | Result |
| :--- | :--- |
| Tap Approve | Updates application status to Approved |
| Tap Reject | Updates application status to Rejected |

## States
- **Success**: Renders pending leave cards with decision buttons.
- **Empty**: Displays empty state when zero leave requests are pending.

## Navigation
- Within HR Portal.

## Data Source
`LeaveService` -> `LeaveRepository` / `MockEssRepository`

## ASCII Wireframe
```
+--------------------------------+
| Leave Approvals                |
+--------------------------------+
| ANITHA K (20140)               |
| Annual Leave: 12 Oct - 15 Oct  |
| Reason: Family Event           |
|                                |
| [ APPROVE ]     [ REJECT ]     |
+--------------------------------+
| Admin | Employees | Leaves | Pay|
+--------------------------------+
```

## Implementation Traceability
- **Flutter File**: `lib/features/hr/hr_leave_requests_screen.dart`
- **Provider**: `leaveServiceProvider`
- **Service**: `LeaveService`
- **Repository**: `LeaveRepository` / `EssRepository`
- **Route**: `/hr/leaves`

---

# Screen: HR Payroll Management (SCR-045)

## Purpose
Enables HR administrators to select employees, inspect historical payslips, and review organization-wide compensation breakdowns.

## Role
HR Administrator

## Route
`/hr/payslips` (`AppConstants.hrPayslipsRoute` / Tab 3 of HR `MainNavigation`)

## Entry Points
- HR MainNavigation Tab 3 selection
- HR Dashboard Payroll Management tile

## Layout
AppBar (Title: HR Payroll Management)
↓
Employee Selection Dropdown
↓
Pay Period / Year Selector
↓
Payslip Summary Breakdown Card (Earnings, Deductions, Net Salary)
↓
Inspect Payslip Detail Button

## Components
| Component | Type | Behaviour |
| :--- | :--- | :--- |
| Employee Selector | DropdownButton | Chooses target employee record |
| Inspect Button | ElevatedButton | Opens `PayslipDetailScreen` for selected employee and period |

## User Actions
| Action | Result |
| :--- | :--- |
| Select Employee | Fetches target employee payslip data |
| Tap Inspect | Opens `PayslipDetailScreen` for detailed view |

## States
- **Success**: Renders employee payroll selection and breakdown details.

## Navigation
- To `/payslip/detail` with target `{year, month}`.

## Data Source
`PayrollService` -> `PayrollRepository` / `EssRepository`

## ASCII Wireframe
```
+--------------------------------+
| HR Payroll Management          |
+--------------------------------+
| Select Employee:               |
| [ ANITHA K (20140)         v ] |
|                                |
| Pay Period:                    |
| [ October 2026             v ] |
+--------------------------------+
| SUMMARY                        |
| Total Earnings: AED 13,000.00  |
| Total Deductions: AED 550.00   |
| Net Pay: AED 12,450.00         |
|                                |
| [   INSPECT PAYSLIP DETAIL   ] |
+--------------------------------+
| Admin | Employees | Leaves | Pay|
+--------------------------------+
```

## Implementation Traceability
- **Flutter File**: `lib/features/hr/hr_payslip_mgmt_screen.dart`
- **Provider**: `payslipsProvider`
- **Service**: `PayrollService`
- **Repository**: `PayrollRepository` / `EssRepository`
- **Route**: `/hr/payslips`
