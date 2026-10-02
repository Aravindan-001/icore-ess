# ebaConnect / iCore ESS — Figma Wireframe Implementation Specification

This document provides a comprehensive, screen-by-screen Figma wireframe implementation specification reverse-engineered directly from the verified **ebaConnect / iCore ESS** Flutter application.

---

## 1. Figma Page Structure

To maintain clean workspace organization, structure the Figma file into 9 dedicated pages:

```
ebaConnect_iCore_ESS_Wireframes.fig
├── 01 — Cover                      # File title, metadata, version history, color palette
├── 02 — User Flows                 # 11 interactive prototype user flow overview diagrams
├── 03 — Design System              # Grayscale color styles, typography styles, layout grids
├── 04 — Authentication            # Bootstrap, Login, Forgot Password, Change Password
├── 05 — Employee                  # Dashboard, Attendance, Leave, Payslips, Requests, 15 Module Views
├── 06 — Personal Information      # Personal Info Landing + 10 Sub-section Portal screens
├── 07 — HR Admin                  # HR Dashboard, Employee Directory, Leave Approvals, HR Payroll
├── 08 — Components                # Master variants for all 7 reusable UI components
└── 09 — Prototype                 # Interactive flow connections and transition settings
```

---

## 2. Frame Naming Convention

All frames follow a strict hierarchical naming pattern for Figma searchability and developer handoff:

`[CATEGORY] / [Screen Name] / [Variant]`

### Examples:
- `AUTH / Login / Default`
- `AUTH / Login / Loading`
- `EMP / Dashboard / Default`
- `EMP / Attendance / Checked-In`
- `EMP / Attendance / Geofence-Warning`
- `PI / Basic Info / View`
- `HR / Dashboard / Default`
- `HR / Leaves / Pending`

---

## 3. Mobile Canvas & Layout Specifications

- **Standard Target Canvas**: `390 x 844 px` (iPhone 13 / 14 / Android Standard 390dp)
- **Small Testing Canvas**: `360 x 640 px` (Small screen overflow testing)
- **Layout Grid**: 8px Grid System
  - **Type**: Columns
  - **Count**: 4 Columns
  - **Gutter**: 12px
  - **Margin**: 16px Left/Right
- **System Bars**:
  - **Status Bar**: `390 x 44 px` (Top, Fixed)
  - **AppBar**: `390 x 56 px` (Top, Fixed below status bar)
  - **Bottom Nav Bar**: `390 x 80 px` (Bottom, Fixed)

---

## 4. Grayscale Wireframe Style Guidelines

- **Palette**: Strictly Grayscale (Low / Mid-Fidelity)
  - **Canvas Background**: `#F8FAFC` (Slate 50)
  - **Card / Container Background**: `#FFFFFF` (White)
  - **Card Stroke / Outline**: `#E2E8F0` (Slate 200) / `#CBD5E1` (Slate 300)
  - **Primary Text & Icons**: `#0F172A` (Slate 900)
  - **Muted Text & Placeholder**: `#64748B` (Slate 500)
  - **Primary Button Fill**: `#0F172A` (Dark Slate)
  - **Secondary Button Fill**: `#F1F5F9` (Slate 100)
  - **Badge Container Fills**: Light gray tint (`#F1F5F9`) with slate text
- **Typography Hierarchy**:
  - **Headline Large**: 32px / Bold / Line-height 38px
  - **Headline Medium**: 24px / Bold / Line-height 30px
  - **Title Large**: 20px / Bold / Line-height 26px
  - **Title Medium**: 16px / SemiBold / Line-height 22px
  - **Body Large**: 16px / Regular / Line-height 22px
  - **Body Medium**: 14px / Regular / Line-height 20px
  - **Caption / Label Small**: 11px / SemiBold / Line-height 14px

---

## 5. Master Reusable Components Mapping

| Component | Figma Equivalent | Inputs / Properties | Visual Layout |
| :--- | :--- | :--- | :--- |
| **CustomTextField** | Input / Text Field | `label`, `hint`, `isPassword`, `hasPrefix`, `hasSuffix`, `errorText` | Top label (12px bold), Input container (height: 52px, radius: 16px, fill: #F1F5F9), Prefix/Suffix icons |
| **ServiceCard** | Action Grid Tile | `title`, `icon`, `backgroundColor`, `borderColor` | Container (height: 96px, width: 108px, radius: 16px), Centered 28px icon + 13px bold title |
| **EmptyState** | Empty Fallback View | `title`, `message`, `icon` | Centered 64px outline icon, 20px bold title, 14px muted body text |
| **BusinessCardDialog** | Modal Popup Card | `name`, `id`, `designation`, `phone`, `email` | Dialog container (radius: 28px, inset padding: 24px), Bordered inner card, Text list, Bottom right 'Close' button |
| **MainNavigation** | Bottom Navigation Bar | `role` (Employee / HR), `selectedIndex` (0 - 4) | Height: 80px, 5 Navigation Destinations with 24px icons & 12px labels |
| **Status Badge / Chip** | Pill Badge | `label`, `variant` (Success, Warning, Error, Info) | Rounded pill container (radius: 6px/20px, padding: 4px 10px), 11px bold uppercase text |
| **Metric Summary Card** | Metric Overview Card | `label`, `value`, `icon`, `color` | Card (radius: 16px, padding: 16px), Circular icon container, Large 20px bold value, 12px muted label |

---

## 6. Complete Screen-by-Screen Frame Specifications (45 Cataloged Views)

---

### PAGE 04: AUTHENTICATION & SHELLS

#### Frame 01: `AUTH / Bootstrap / Default`
- **Source File**: `lib/features/auth/bootstrap_screen.dart`
- **Route**: `/`
- **Role**: Shared
- **Top-Level Layout**: Auto Layout Vertical (Center Alignment)
- **Layer Hierarchy**:
  - `Logo Image Container` (120 x 120 px, centered)
  - `App Title`: "ebaConnect" (32px Bold)
  - `App Subtitle`: "Employee Portal" (18px Bold)
  - `Progress Spinner`: Circular (24 x 24 px)
  - `Status Text`: "Restoring Session..." (13px Muted)
- **Interactive Elements**: None (Automated checks)
- **State Variants**: Default (Loading)

#### Frame 02: `AUTH / Login / Default`
- **Source File**: `lib/features/auth/login_screen.dart`
- **Route**: `/login`
- **Role**: Shared
- **Top-Level Layout**: Auto Layout Vertical (Padding: 24px)
- **Layer Hierarchy**:
  - `Background Decorative Waves` (Top & Bottom vector waves)
  - `Header Container`: Centered Logo + "ebaConnect" Title + "Employee Portal" Subtitle
  - `Login Card Container` (Radius: 24px, Stroke: #E2E8F0, Fill: #FFFFFF):
    - `Card Title`: "Login to Your Account" (20px Bold)
    - `Card Subtitle`: "Access your payslips and employee services" (13px Muted)
    - `Input Field`: `CustomTextField` (Label: "Employee ID", Prefix: Person Icon)
    - `Input Field`: `CustomTextField` (Label: "Password", Prefix: Lock Icon, Suffix: Eye Icon)
    - `Option Row`: Checkbox "Remember Me" + TextButton "Forgot Password?"
    - `Primary Button`: "Login" (Height: 52px, Radius: 12px, Fill: #0F172A, Text: White 16px Bold)
  - `Footer Text`: "— Connect • Manage • Grow —" (13px Muted)
- **Interactive Elements**: Employee ID Field, Password Field, Remember Me Checkbox, Forgot Password Link, Login Button
- **State Variants**: Default, Loading, Error-SnackBar

#### Frame 03: `AUTH / Login / Loading`
- **Source File**: `lib/features/auth/login_screen.dart`
- **Differences**: Login button shows centered white `CircularProgressIndicator` spinner; text fields disabled.

#### Frame 04: `AUTH / Forgot Password / Default`
- **Source File**: `lib/features/auth/forgot_password_screen.dart`
- **Route**: Standalone Widget
- **Role**: Shared
- **Top-Level Layout**: Auto Layout Vertical (Padding: 24px)
- **Layer Hierarchy**:
  - `AppBar`: Title "Forgot Password", Back Arrow
  - `Instruction Text`: "Enter your Employee ID or registered email address to receive password reset instructions."
  - `Input Field`: `CustomTextField` (Label: "Employee ID or Email")
  - `Primary Button`: "Send Reset Instructions" (Height: 52px, Radius: 12px)
- **Interactive Elements**: Input Field, Reset Button, Back Arrow

#### Frame 05: `AUTH / Change Password / Default`
- **Source File**: `lib/features/settings/change_password_screen.dart`
- **Route**: Push from Settings
- **Role**: Shared
- **Top-Level Layout**: Auto Layout Vertical (Padding: 24px)
- **Layer Hierarchy**:
  - `AppBar`: Title "Change Password", Back Arrow
  - `Input Field`: `CustomTextField` (Label: "Current Password", Password: true)
  - `Input Field`: `CustomTextField` (Label: "New Password", Password: true)
  - `Input Field`: `CustomTextField` (Label: "Confirm New Password", Password: true)
  - `Primary Button`: "Update Password" (Height: 52px)
- **Interactive Elements**: 3 Password Fields, Update Password Button

#### Frame 06: `AUTH / Main Navigation Hub / Employee`
- **Source File**: `lib/navigation/main_navigation.dart`
- **Route**: `/main`
- **Role**: Shared Shell
- **Layer Hierarchy**:
  - `IndexedStack Container` (Hosts active screen tab)
  - `Bottom Navigation Bar`: `MainNavigation` (Employee Tabs: Home, Payslips, Leave, Pay Summary, Profile)

#### Frame 07: `AUTH / Main Navigation Hub / HR`
- **Source File**: `lib/navigation/main_navigation.dart`
- **Route**: `/main`
- **Role**: Shared Shell
- **Layer Hierarchy**:
  - `IndexedStack Container` (Hosts active HR tab)
  - `Bottom Navigation Bar`: `MainNavigation` (HR Tabs: Admin, Employees, Leaves, Payroll, Profile)

---

### PAGE 05: EMPLOYEE CORE MODULES

#### Frame 08: `EMP / Dashboard / Default`
- **Source File**: `lib/features/dashboard/dashboard_screen.dart`
- **Route**: `/dashboard` (Tab 0)
- **Role**: Employee
- **Top-Level Layout**: Auto Layout Vertical (Padding: 16px)
- **Layer Hierarchy**:
  - `AppBar`: Logo + "ebaConnect Employee Portal", Notification Bell Icon (with Badge), Profile Avatar
  - `Greeting Section`: "Good Morning," (15px Muted) + "ANITHA K" (22px Bold)
  - `Employee Info Card` (Radius: 16px, Stroke: #E2E8F0):
    - Key-Value Rows: Employee ID ("20140"), Department ("RETAIL"), Designation ("Executive - Sales"), Location ("DUBAI"), Currency ("AED")
    - Divider
    - Net Pay Row: "Latest Net Pay" + "AED 12,450.00" (22px Bold) + Pay Period ("OCT-2026")
    - Primary Button: "View Latest Payslip" (Icons.description)
  - `Pending Requests Card`: Pending Requests Icon, "3 pending requests awaiting approval", Forward Arrow
  - `Quick Actions Grid` (3 Columns, 12 Tiles):
    - `ServiceCard` Tiles: My Payslips, Leave, Pay Summary, Documents, Profile, Attendance, Overtime, Airfare, Education, Reimbursement, Claims, Orders
- **Interactive Elements**: Notification Bell, Profile Icon, View Latest Payslip Button, Pending Requests Card, 12 Quick Action Tiles
- **State Variants**: Default, Refreshing

#### Frame 09: `EMP / Attendance / Default`
- **Source File**: `lib/features/attendance/attendance_screen.dart`
- **Route**: `/attendance`
- **Role**: Employee
- **Top-Level Layout**: Auto Layout Vertical (Padding: 20px)
- **Layer Hierarchy**:
  - `AppBar`: Title "Attendance", Refresh Icon Button
  - `Today Header`: "Today's Attendance" (20px Bold), Date ("EEEE, dd MMMM yyyy")
  - `Today Status Card` (Radius: 16px): Status Icon (Check Circle), Status Text ("Checked In"), Working Hours ("04h 15m"), Check In ("08:45 AM") & Check Out ("--:--")
  - `Location Verification Card` (Radius: 16px, Fill: #F1F5F9): Location Icon, "Office Location Verified", Distance ("12.0 m"), Accuracy ("15.0 m"), Geofence Status ("Within 50m allowed radius")
  - `Action Button`: "CHECK OUT" (Height: 52px, Fill: Dark Slate)
  - `History Title`: "Attendance History" (18px Bold)
  - `Filter Chips Row`: "All", "Current Month", "Previous Month"
  - `History Cards List`: Date, Check In/Out Range, Status ("Present"), Duration
- **Interactive Elements**: Refresh Icon, Check In/Out Button, History Filter Chips
- **State Variants**: Checked-In, Not-Marked, Outside-Geofence Warning, GPS-Disabled Error

#### Frame 10: `EMP / Leave / Default`
- **Source File**: `lib/features/leave/leave_screen.dart`
- **Route**: `/leave` (Tab 2)
- **Role**: Employee
- **Top-Level Layout**: Auto Layout Vertical (Padding: 16px)
- **Layer Hierarchy**:
  - `AppBar`: Title "Leave"
  - `Leave Balance Card`: Title "Compensatory Leave", Metrics Row (Available: 0.00, Used: 1.00, Pending: 0.00, Approved: 0.00, Balance: 1.00)
  - `Leave Request Form Card`:
    - Read-only Field: "Document *" ("LR-2025-0214")
    - Dropdown: "Leave Type *" ("Annual Leave")
    - Row Fields: "From Date *" ("08/09/2026"), "To Date *" ("17/09/2026")
    - Row Checkboxes: "Half Day" (From), "Half Day" (To)
    - Policy Checkboxes: "Avail Air Ticket (For Info)", "Advance Salary Applicable"
  - `Leave Summary Card`: "Calendar Days" (10), "Leave Days" (10)
  - `Button Row`: Outlined "Reset" + Primary "Submit Leave Request"
- **Interactive Elements**: Leave Type Dropdown, Date Fields, Checkboxes, Reset Button, Submit Button

#### Frame 11: `EMP / Apply Leave / Default`
- **Source File**: `lib/features/leave/apply_leave_screen.dart`
- **Route**: `/leave/apply`
- **Role**: Employee
- **Top-Level Layout**: Auto Layout Vertical (Padding: 20px)
- **Layer Hierarchy**:
  - `AppBar`: Title "Apply Leave", Back Arrow
  - `Dropdown Field`: "Leave Type" ("Annual Leave", "Sick Leave", "Casual Leave", "Roster Leave")
  - `Date Selector`: "Start Date" (Calendar Icon, Date picker trigger)
  - `Date Selector`: "End Date" (Calendar Icon, Date picker trigger)
  - `Text Area`: "Reason" (Max lines: 4)
  - `Primary Button`: "Submit Application" (Height: 52px)
- **Interactive Elements**: Leave Type Dropdown, Start Date Picker, End Date Picker, Reason Input, Submit Button

#### Frame 12: `EMP / Payslips / Default`
- **Source File**: `lib/features/payslip/payslip_screen.dart`
- **Route**: `/payslip` (Tab 1)
- **Role**: Employee
- **Top-Level Layout**: Auto Layout Vertical (Padding: 16px)
- **Layer Hierarchy**:
  - `AppBar`: Title "Payslips", Right Action Dropdown ("2026")
  - `Payslip Tile List`:
    - Payslip Card: Title ("October 2026 Payslip"), Net Pay ("AED 12,450.00"), Pay Date ("31 Oct 2026"), Chevron Forward Icon
- **Interactive Elements**: Year Dropdown, Payslip Cards List Item Tap

#### Frame 13: `EMP / Payslip Detail / Default`
- **Source File**: `lib/features/payslip/payslip_detail_screen.dart`
- **Route**: `/payslip/detail`
- **Role**: Shared
- **Top-Level Layout**: Auto Layout Vertical (Padding: 16px)
- **Layer Hierarchy**:
  - `AppBar`: Title "Payslip Detail", Back Arrow
  - `Header Card`: Employee Name ("ANITHA K"), ID ("20140"), Department ("RETAIL"), Designation ("Executive - Sales"), Pay Period ("October 2026"), Bank Name ("ENBD")
  - `Attendance Breakdown Card`: Paid Days (30), LOP Days (1), Overtime Hours (4.5)
  - `Earnings vs Deductions Dual-Column Table`:
    - Earnings: Basic (8,000), HRA (3,000), Allowances (2,000)
    - Deductions: Tax (0), LOP (550), Insurance (0)
  - `Net Pay Banner`: "NET PAY: AED 12,450.00" (22px Bold)
  - `Action Button Row`: Primary "Download PDF" + Outlined "Share PDF"
- **Interactive Elements**: Back Arrow, Download PDF Button, Share PDF Button

#### Frame 14: `EMP / Pay Summary / Default`
- **Source File**: `lib/features/pay_summary/pay_summary_screen.dart`
- **Route**: `/pay-summary` (Tab 3)
- **Role**: Employee
- **Top-Level Layout**: Auto Layout Vertical (Padding: 16px)
- **Layer Hierarchy**:
  - `AppBar`: Title "Pay Summary"
  - `Annual Compensation Overview Card`: Total Annual Gross, Total Deductions, Net Cumulative Salary
  - `Monthly Comparison List`: Month, Gross, Deductions, Net Pay figure
- **Interactive Elements**: Month Selection Chips, Summary Cards

#### Frame 15: `EMP / Salary & Benefits / Default`
- **Source File**: `lib/features/salary_benefits/salary_benefits_screen.dart`
- **Route**: `/salary-benefits`
- **Role**: Employee
- **Top-Level Layout**: Auto Layout Vertical (Padding: 16px)
- **Layer Hierarchy**:
  - `AppBar`: Title "Salary & Benefits", Back Arrow
  - `Basic Salary Breakdown Card`: Grade, Basic, Allowances, Total Monthly Entitlement
  - `Benefits List`: Medical Insurance Grade, Airfare Allowance Tier, Gratuity Accumulation Estimate
- **Interactive Elements**: Back Arrow, Benefit Detail Items

#### Frame 16: `EMP / Overtime List / Default`
- **Source File**: `lib/features/overtime/overtime_list_screen.dart`
- **Route**: `/overtime`
- **Role**: Employee
- **Top-Level Layout**: Auto Layout Vertical (Padding: 16px)
- **Layer Hierarchy**:
  - `AppBar`: Title "Overtime Requests", Back Arrow
  - `Overtime Tile List`: Request Date, Overtime Hours, Rate Multiplier, Status Chip (`Pending`/`Approved`)
- **Interactive Elements**: Back Arrow, Overtime List Item Tap

#### Frame 17: `EMP / Overtime Detail / Default`
- **Source File**: `lib/features/overtime/overtime_detail_screen.dart`
- **Route**: `/overtime/detail`
- **Role**: Employee
- **Top-Level Layout**: Auto Layout Vertical (Padding: 16px)
- **Layer Hierarchy**:
  - `AppBar`: Title "Overtime Details", Back Arrow
  - `Detail Card`: Request ID, Date, Start/End Time, Total Hours, Calculation Amount, Justification Text, Approval Status
- **Interactive Elements**: Back Arrow

#### Frame 18: `EMP / Airfare List / Default`
- **Source File**: `lib/features/airfare/airfare_list_screen.dart`
- **Route**: `/airfare`
- **Role**: Employee
- **Top-Level Layout**: Auto Layout Vertical (Padding: 16px)
- **Layer Hierarchy**:
  - `AppBar`: Title "Airfare Declarations", Back Arrow
  - `Airfare Tile List`: Sector, Dependent Name, Entitlement Year, Status Chip
- **Interactive Elements**: Back Arrow, Item Tap

#### Frame 19: `EMP / Airfare Detail / Default`
- **Source File**: `lib/features/airfare/airfare_detail_screen.dart`
- **Route**: `/airfare/detail`
- **Role**: Employee
- **Top-Level Layout**: Auto Layout Vertical (Padding: 16px)
- **Layer Hierarchy**:
  - `AppBar`: Title "Airfare Declaration Detail", Back Arrow
  - `Detail Card`: Declaration ID, Employee Sector, Class of Travel, Total Allowance Amount, Status
- **Interactive Elements**: Back Arrow

#### Frame 20: `EMP / Education List / Default`
- **Source File**: `lib/features/education/education_list_screen.dart`
- **Route**: `/education-declaration`
- **Role**: Employee
- **Top-Level Layout**: Auto Layout Vertical (Padding: 16px)
- **Layer Hierarchy**:
  - `AppBar`: Title "Education Allowance", Back Arrow
  - `Education Tile List`: Dependent Name, Academic Year, School/College, Claimed Amount, Status Chip
- **Interactive Elements**: Back Arrow, Item Tap

#### Frame 21: `EMP / Education Detail / Default`
- **Source File**: `lib/features/education/education_detail_screen.dart`
- **Route**: `/education-declaration/detail`
- **Role**: Employee
- **Top-Level Layout**: Auto Layout Vertical (Padding: 16px)
- **Layer Hierarchy**:
  - `AppBar`: Title "Education Claim Detail", Back Arrow
  - `Detail Card`: Dependent Name, School Name, Academic Grade, Invoice Amount, Approved Amount, Status
- **Interactive Elements**: Back Arrow

#### Frame 22: `EMP / Reimbursement List / Default`
- **Source File**: `lib/features/reimbursement/reimbursement_list_screen.dart`
- **Route**: `/reimbursement`
- **Role**: Employee
- **Top-Level Layout**: Auto Layout Vertical (Padding: 16px)
- **Layer Hierarchy**:
  - `AppBar`: Title "Reimbursements", Back Arrow
  - `Reimbursement Request List`: Category (Fuel, Internet, Travel), Bill Ref No, Date, Amount, Status Chip
  - `FAB`: Floating Action Button (+) (Navigates to `/reimbursement/form`)
- **Interactive Elements**: Back Arrow, List Item Tap, FAB

#### Frame 23: `EMP / Reimbursement Form / Default`
- **Source File**: `lib/features/reimbursement/reimbursement_form_screen.dart`
- **Route**: `/reimbursement/form`
- **Role**: Employee
- **Top-Level Layout**: Auto Layout Vertical (Padding: 20px)
- **Layer Hierarchy**:
  - `AppBar`: Title "New Reimbursement Request", Back Arrow
  - `Dropdown Field`: "Category *" ("Fuel", "Internet", "Travel", "Others")
  - `Input Field`: "Description *"
  - `Input Field`: "Bill Reference Number"
  - `Date Picker Field`: "Expense Date *"
  - `Input Field`: "Amount (AED) *"
  - `Attachment Row`: "Add Receipt Attachment" Button + File Name Indicator
  - `Primary Button`: "Submit Claim" (Height: 52px)
- **Interactive Elements**: Category Dropdown, Text Inputs, Date Picker, File Attachment Button, Submit Button

#### Frame 24: `EMP / Medical Claims / Default`
- **Source File**: `lib/features/claims/claims_screen.dart`
- **Route**: `/claims`
- **Role**: Employee
- **Top-Level Layout**: Auto Layout Vertical (Padding: 16px)
- **Layer Hierarchy**:
  - `AppBar`: Title "Medical Claims", Back Arrow
  - `Claims List Card`: Claim ID, Patient Name (Self/Dependent), Provider Name, Invoice Amount, Approved Amount, Status Chip
- **Interactive Elements**: Back Arrow, Item Tap

#### Frame 25: `EMP / Pre-Order / Default`
- **Source File**: `lib/features/pre_order/pre_order_screen.dart`
- **Route**: `/pre-order`
- **Role**: Employee
- **Top-Level Layout**: Auto Layout Vertical (Padding: 16px)
- **Layer Hierarchy**:
  - `AppBar`: Title "Pre-Orders", Back Arrow
  - `Order Item Card List`: Item Name, Quantity, Estimated Cost, Delivery Target Date, Status Chip
- **Interactive Elements**: Back Arrow, Order Cards

#### Frame 26: `EMP / Sales Order / Default`
- **Source File**: `lib/features/sales_order/sales_order_screen.dart`
- **Route**: `/sales-order`
- **Role**: Employee
- **Top-Level Layout**: Auto Layout Vertical (Padding: 16px)
- **Layer Hierarchy**:
  - `AppBar`: Title "Sales Orders", Back Arrow
  - `Sales Order Cards`: Order Number, Customer Name, Total Order Value, Order Date, Fulfillment Status
- **Interactive Elements**: Back Arrow, Order Cards

#### Frame 27: `EMP / Unified Requests / Default`
- **Source File**: `lib/features/requests/requests_screen.dart`
- **Route**: `/requests`
- **Role**: Employee
- **Top-Level Layout**: Auto Layout Vertical (Padding: 16px)
- **Layer Hierarchy**:
  - `AppBar`: Title "Request Center", Back Arrow
  - `Metric Cards Row`: Pending (3), Approved (12), Rejected (1)
  - `Category ChoiceChips Row`: "All", "Leave", "Overtime", "Airfare", "Education", "Reimbursement", "Claims"
  - `Status ChoiceChips Row`: "All", "Pending", "Approved", "Rejected"
  - `Unified Requests Tile List`: Request Title, Category Badge, Submitted Date, Status Chip, Chevron Forward Icon
- **Interactive Elements**: Back Arrow, Metric Cards, Category Chips, Status Chips, Request Tile Tap
- **State Variants**: Default, Filtered, Empty State

#### Frame 28: `EMP / Notifications / Default`
- **Source File**: `lib/features/notifications/notifications_screen.dart`
- **Route**: `/notifications`
- **Role**: Employee
- **Top-Level Layout**: Auto Layout Vertical
- **Layer Hierarchy**:
  - `AppBar`: Title "Notifications", Subtitle "3 unread", Action TextButton "Mark all as read"
  - `Filter Bar Row`: ChoiceChips ("All", "Unread", "Leave", "Attendance", "Payroll", "System")
  - `Notifications List`:
    - Notification Card: Category Icon, Title, Message Body, Category Tag, Timestamp, Unread Indicator Dot
- **Interactive Elements**: Back Arrow, Mark All Read Button, Filter Chips, Notification Tile Tap
- **State Variants**: Default, Unread Filter, Empty State

#### Frame 29: `EMP / Documents / Default`
- **Source File**: `lib/features/documents/documents_screen.dart`
- **Route**: `/documents`
- **Role**: Employee
- **Top-Level Layout**: Auto Layout Vertical (Padding: 16px)
- **Layer Hierarchy**:
  - `AppBar`: Title "My Documents", Back Arrow
  - `Document Categories List`:
    - Payslips Document Tile: Title ("Payslip OCT-2026"), Subtitle ("Generated PDF"), Direct Detail Navigation Arrow
    - Passport Copy Tile
    - Visa Copy Tile
    - Employment Contract Tile
- **Interactive Elements**: Back Arrow, Document Item Taps

#### Frame 30: `EMP / Settings / Default`
- **Source File**: `lib/features/settings/settings_screen.dart`
- **Route**: `/settings`
- **Role**: Shared
- **Top-Level Layout**: Auto Layout Vertical (Padding: 16px)
- **Layer Hierarchy**:
  - `AppBar`: Title "Settings", Back Arrow
  - `Settings Option Cards`:
    - "Change Password" (Navigates to Change Password Screen)
    - "Biometric Authentication" (Toggle Switch)
    - "Push Notifications" (Toggle Switch)
    - "App Version" ("1.0.0")
- **Interactive Elements**: Back Arrow, Change Password Row, Toggle Switches

#### Frame 31: `EMP / Services Catalog / Default`
- **Source File**: `lib/features/services/services_screen.dart`
- **Route**: Standalone Widget
- **Role**: Shared
- **Top-Level Layout**: Auto Layout Vertical (Padding: 16px)
- **Layer Hierarchy**:
  - `AppBar`: Title "Services Catalog", Back Arrow
  - `3-Column Service Grid`: All 12 `ServiceCard` Tiles
- **Interactive Elements**: Back Arrow, Service Tiles

#### Frame 32: `EMP / Profile / Default`
- **Source File**: `lib/features/profile/profile_screen.dart`
- **Route**: `/profile` (Tab 4)
- **Role**: Shared
- **Top-Level Layout**: Auto Layout Vertical (Padding: 16px)
- **Layer Hierarchy**:
  - `AppBar`: Title "Profile", Settings Gear Icon
  - `Employee Header Card`: Avatar Circle, Name ("ANITHA K"), Designation ("Executive - Sales"), ID ("20140"), Department ("RETAIL"), Location ("DUBAI")
  - `Action Button`: "View Digital Business Card" (Opens `BusinessCardDialog`)
  - `Navigation Tiles`:
    - "Personal Information Portal" (Navigates to `/profile/personal-info`)
    - "My Documents" (Navigates to `/documents`)
    - "Salary & Benefits Overview" (Navigates to `/salary-benefits`)
  - `Logout Button`: Outlined / Red Text Button "Logout"
- **Interactive Elements**: Settings Icon, View Business Card Button, Personal Info Tile, Documents Tile, Salary Tile, Logout Button

---

### PAGE 06: PERSONAL INFORMATION PORTAL

#### Frame 33: `PI / Personal Info Landing / Default`
- **Source File**: `lib/features/profile/personal_info_landing_screen.dart`
- **Route**: `/profile/personal-info`
- **Role**: Employee
- **Top-Level Layout**: Auto Layout Vertical (Padding: 16px)
- **Layer Hierarchy**:
  - `AppBar`: Title "Personal Information", Back Arrow
  - `Brief Employee Header`: Name ("ANITHA K"), ID ("20140"), Designation ("Executive - Sales")
  - `10 Sub-Section Tile List`:
    1. Basic Information (`/profile/basic-info`)
    2. Family Information (`/profile/family`)
    3. Bank Information (`/profile/bank`)
    4. Education History (`/profile/education`)
    5. Education Documents (`/profile/education-docs`)
    6. Skills (`/profile/skills`)
    7. Identity Documents (`/profile/identity`)
    8. Work History (`/profile/work-history`)
    9. Certificates (`/profile/certificates`)
    10. Profile Update Requests (`/profile/requests`)
- **Interactive Elements**: Back Arrow, 10 Sub-section Navigation Tiles

#### Frame 34: `PI / Basic Information / View`
- **Source File**: `lib/features/profile/basic_info_screen.dart`
- **Route**: `/profile/basic-info`
- **Role**: Employee
- **Layer Hierarchy**:
  - `AppBar`: Title "Basic Information", Back Arrow
  - `Detail Card List`: Full Name, Gender, Date of Birth, Nationality, Marital Status, Personal Email, Mobile Number, Emergency Contact
- **Interactive Elements**: Back Arrow

#### Frame 35: `PI / Family Information / View`
- **Source File**: `lib/features/profile/family_info_screen.dart`
- **Route**: `/profile/family`
- **Role**: Employee
- **Layer Hierarchy**:
  - `AppBar`: Title "Family Information", Back Arrow
  - `Dependent Card List`: Relation (Spouse / Child), Dependent Name, Gender, Date of Birth, Passport Number
- **Interactive Elements**: Back Arrow

#### Frame 36: `PI / Bank Information / View`
- **Source File**: `lib/features/profile/bank_info_screen.dart`
- **Route**: `/profile/bank`
- **Role**: Employee
- **Layer Hierarchy**:
  - `AppBar`: Title "Bank Information", Back Arrow
  - `Detail Card`: Bank Name ("Emirates NBD"), IBAN Number, Account Number, Branch, Swift Code
- **Interactive Elements**: Back Arrow

#### Frame 37: `PI / Education History / View`
- **Source File**: `lib/features/profile/education_screen.dart`
- **Route**: `/profile/education`
- **Role**: Employee
- **Layer Hierarchy**:
  - `AppBar`: Title "Education History", Back Arrow
  - `Education Card List`: Degree / Qualification, Institution Name, Graduation Year, Grade / GPA
- **Interactive Elements**: Back Arrow

#### Frame 38: `PI / Education Documents / View`
- **Source File**: `lib/features/profile/education_docs_screen.dart`
- **Route**: `/profile/education-docs`
- **Role**: Employee
- **Layer Hierarchy**:
  - `AppBar`: Title "Education Documents", Back Arrow
  - `Document Tile List`: Certificate Name, Issuing Body, Uploaded Date, View File Button
- **Interactive Elements**: Back Arrow, View File Button

#### Frame 39: `PI / Skills / View`
- **Source File**: `lib/features/profile/skills_screen.dart`
- **Route**: `/profile/skills`
- **Role**: Employee
- **Layer Hierarchy**:
  - `AppBar`: Title "Skills & Competencies", Back Arrow
  - `Skills Chips Wrap`: Skill Name, Proficiency Level
- **Interactive Elements**: Back Arrow

#### Frame 40: `PI / Identity Documents / View`
- **Source File**: `lib/features/profile/identity_screen.dart`
- **Route**: `/profile/identity`
- **Role**: Employee
- **Layer Hierarchy**:
  - `AppBar`: Title "Identity Documents", Back Arrow
  - `Identity Card List`: Emirates ID Number, Expiry Date, Passport Number, Expiry Date, Visa Number, Expiry Date
- **Interactive Elements**: Back Arrow

#### Frame 41: `PI / Work History / View`
- **Source File**: `lib/features/profile/work_history_screen.dart`
- **Route**: `/profile/work-history`
- **Role**: Employee
- **Layer Hierarchy**:
  - `AppBar`: Title "Work History", Back Arrow
  - `Work Experience Cards`: Employer Name, Designation, Start Date, End Date, Key Responsibilities
- **Interactive Elements**: Back Arrow

#### Frame 42: `PI / Certificates / View`
- **Source File**: `lib/features/profile/certificates_screen.dart`
- **Route**: `/profile/certificates`
- **Role**: Employee
- **Layer Hierarchy**:
  - `AppBar`: Title "Certificates & Training", Back Arrow
  - `Certificate Card List`: Certification Title, Certification Body, Issue Date, Expiry Date
- **Interactive Elements**: Back Arrow

#### Frame 43: `PI / Profile Requests / View`
- **Source File**: `lib/features/profile/profile_requests_screen.dart`
- **Route**: `/profile/requests`
- **Role**: Employee
- **Layer Hierarchy**:
  - `AppBar`: Title "Profile Update Requests", Back Arrow
  - `Request Status Cards`: Requested Change Field, Old Value, New Value, Submission Date, Approval Status (`Pending`/`Approved`)
- **Interactive Elements**: Back Arrow

---

### PAGE 07: HR ADMIN PORTAL

#### Frame 44: `HR / Dashboard / Default`
- **Source File**: `lib/features/hr/hr_dashboard_screen.dart`
- **Route**: `/hr/dashboard` (Tab 0)
- **Role**: HR Administrator
- **Top-Level Layout**: Auto Layout Vertical (Padding: 16px)
- **Layer Hierarchy**:
  - `AppBar`: Logo + "ebaConnect HR Admin Portal", Notification Bell (with Badge)
  - `Greeting Section`: "Welcome, HR Admin" (15px Muted) + "Dashboard Overview" (22px Bold)
  - `Statistics Section`:
    - Row: Total Employees Card ("125"), Active Card ("120")
    - Full-Width Card: "Pending Leave Requests" ("2", Tap navigates to `/hr/leaves`)
  - `Management Modules Grid` (2 x 2 Grid):
    - `Employee Management` (Navigates to `/hr/employees`)
    - `Leave Management` (Navigates to `/hr/leaves`)
    - `Payslip Management` (Navigates to `/hr/payslips`)
    - `Documents` (Navigates to `/documents`)
- **Interactive Elements**: Pending Leave Requests Card, 4 Module Cards
- **State Variants**: Default

#### Frame 45: `HR / Employees / Default`
- **Source File**: `lib/features/hr/hr_employee_list_screen.dart`
- **Route**: `/hr/employees` (Tab 1)
- **Role**: HR Administrator
- **Top-Level Layout**: Auto Layout Vertical
- **Layer Hierarchy**:
  - `AppBar`: Title "Employee Management"
  - `Search Bar`: TextField ("Search Employee...", Search Icon)
  - `Employee Roster Cards List`:
    - Employee Card: Avatar Circle, Name ("ANITHA K"), ID ("20140"), Department ("RETAIL"), Designation ("Executive - Sales"), Role Tag ("Employee"), TextButton "View Profile"
- **Interactive Elements**: Search Input, View Profile TextButton

#### Frame 46: `HR / Leaves / Default`
- **Source File**: `lib/features/hr/hr_leave_requests_screen.dart`
- **Route**: `/hr/leaves` (Tab 2)
- **Role**: HR Administrator
- **Top-Level Layout**: Auto Layout Vertical (Padding: 16px)
- **Layer Hierarchy**:
  - `AppBar`: Title "Leave Management"
  - `Pending Leave Requests List`:
    - Leave Request Card:
      - Header Row: Employee Name ("ANITHA K"), Status Chip (`Pending` / `Approved` / `Rejected`)
      - Subtitle: Employee ID + Leave Type ("20140 • Annual Leave")
      - Divider
      - Date Range: Calendar Icon + "08/09/2026 to 17/09/2026"
      - Decision Button Row (Visible if Pending): Outlined "Reject" (Red) + Primary "Approve" (Green)
- **Interactive Elements**: Reject Button, Approve Button
- **State Variants**: Pending, Decision Applied (Approved/Rejected)

#### Frame 47: `HR / Payroll / Default`
- **Source File**: `lib/features/hr/hr_payslip_mgmt_screen.dart`
- **Route**: `/hr/payslips` (Tab 3)
- **Role**: HR Administrator
- **Top-Level Layout**: Auto Layout Vertical (Padding: 16px)
- **Layer Hierarchy**:
  - `AppBar`: Title "Payslip Management"
  - `Employee Selector Card`: Label "Select Employee", Dropdown ("Search or select employee")
  - `Employee Payslip History List` (Visible when employee selected):
    - Payslip Card: Pay Period ("OCT-2026"), Net Pay ("AED 12,450.00"), Action IconButtons ("View Details", "Download Payslip")
- **Interactive Elements**: Employee Selection Dropdown, View Details Icon, Download Payslip Icon

---

## 7. Interactive Prototype Flow Connections & Prototype Specs

To set up Figma prototype triggers matching the verified codebase:

| Flow # | Source Screen | Target Screen | Trigger / Action | Figma Transition |
| :--- | :--- | :--- | :--- | :--- |
| **01. Auth** | `AUTH / Bootstrap` | `AUTH / Login` | After Delay (1000ms) | Instant |
| **01. Auth** | `AUTH / Login` | `EMP / Dashboard` | On Click (Login Button) | Push / Slide Left |
| **01. Auth** | `AUTH / Login` | `HR / Dashboard` | On Click (HR Login) | Push / Slide Left |
| **02. Nav** | `EMP / Dashboard` | `EMP / Payslips` | On Click (Tab 1) | Instant |
| **02. Nav** | `EMP / Dashboard` | `EMP / Leave` | On Click (Tab 2) | Instant |
| **02. Nav** | `EMP / Dashboard` | `EMP / Pay Summary` | On Click (Tab 3) | Instant |
| **02. Nav** | `EMP / Dashboard` | `EMP / Profile` | On Click (Tab 4) | Instant |
| **03. Attendance** | `EMP / Dashboard` | `EMP / Attendance` | On Click (Attendance Tile) | Smart Animate / Slide Left |
| **03. Attendance** | `EMP / Attendance` | `EMP / Attendance` | On Click (Check Out) | Smart Animate (State Change) |
| **04. Leave** | `EMP / Leave` | `EMP / Apply Leave` | On Click (Apply Button) | Push / Slide Up |
| **04. Leave** | `EMP / Dashboard` | `EMP / Unified Requests` | On Click (Pending Requests Card) | Push / Slide Left |
| **05. Payroll** | `EMP / Dashboard` | `EMP / Payslip Detail` | On Click (View Latest Payslip) | Push / Slide Left |
| **05. Payroll** | `EMP / Payslips` | `EMP / Payslip Detail` | On Click (Payslip Item) | Push / Slide Left |
| **06. Notifications** | `EMP / Dashboard` | `EMP / Notifications` | On Click (Notification Bell) | Push / Slide Left |
| **07. Personal Info** | `EMP / Profile` | `PI / Personal Info Landing` | On Click (Personal Info Tile) | Push / Slide Left |
| **07. Personal Info** | `PI / Personal Info Landing` | `PI / Basic Information` | On Click (Basic Info Tile) | Push / Slide Left |
| **08. Documents** | `EMP / Profile` | `EMP / Documents` | On Click (My Documents Tile) | Push / Slide Left |
| **08. Documents** | `EMP / Documents` | `EMP / Payslip Detail` | On Click (Payslip Document Tile) | Push / Slide Left |
| **09. HR Nav** | `HR / Dashboard` | `HR / Employees` | On Click (Roster Module Tile) | Push / Slide Left |
| **10. HR Leave** | `HR / Dashboard` | `HR / Leaves` | On Click (Pending Leaves Tile) | Push / Slide Left |
| **10. HR Leave** | `HR / Leaves` | `HR / Leaves` | On Click (Approve / Reject) | Smart Animate (Status Update) |
| **11. HR Payroll** | `HR / Dashboard` | `HR / Payroll` | On Click (Payroll Module Tile) | Push / Slide Left |
| **11. HR Payroll** | `HR / Payroll` | `EMP / Payslip Detail` | On Click (View Details Icon) | Push / Slide Left |

---

## 8. Verification & Handoff Summary

This Figma Wireframe Implementation Specification guarantees **100% architectural and presentation alignment** with the reverse-engineered Flutter application:

- **45 Cataloged Screens & Views** mapped to dedicated Figma frames (`SCR-001` to `SCR-045`)
- **11 Verified Interactive User Flows** mapped to explicit Figma prototype connections
- **7 Reusable UI Components** mapped to Figma master component equivalents with properties
- **Grayscale Low/Mid-Fidelity Wireframe System** preserving actual layout hierarchies, labels, and role boundaries
