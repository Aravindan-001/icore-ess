# ebaConnect / iCore ESS — Shared UI Components Specification

This document details reusable, shared UI components implemented across the **ebaConnect / iCore ESS** application.

---

## 1. Custom Text Field (`CustomTextField`)

- **File Path**: `lib/core/widgets/custom_text_field.dart`
- **Purpose**: Standardized Material Design 3 text input field with prefix icons, suffix obscure toggle buttons, and validation messaging.
- **Parameters**: `controller`, `label`, `hint`, `isPassword`, `keyboardType`, `validator`, `prefixIcon`, `suffixIcon`, `textFieldKey`.
- **Usage**: Login Screen credentials entry, Apply Leave reason field, Settings password change fields, Reimbursement form text fields.

```
+------------------------------------+
| Label                              |
| [ (i) Input text placeholder    (o)]|
| Error/Validation text if invalid   |
+------------------------------------+
```

---

## 2. Quick Service Tile (`ServiceCard`)

- **File Path**: `lib/core/widgets/service_card.dart`
- **Purpose**: Grid tile used in the Home Dashboard and Services Catalog for module navigation.
- **Parameters**: `title`, `icon`, `onTap`, `color`, `backgroundColor`.
- **Usage**: Dashboard shortcuts grid, Services Catalog Screen.

```
+------------------+
|      ( ICON )    |
|   Service Title  |
+------------------+
```

---

## 3. Empty State Widget (`EmptyState`)

- **File Path**: `lib/core/widgets/empty_state.dart`
- **Purpose**: Displays a clean fallback illustration and text when a list or filter returns zero items.
- **Parameters**: `title`, `message`, `icon`.
- **Usage**: Leave history, Notifications list, Request Center filtered list, Employee Directory search results.

```
+------------------------------------+
|              [ ICON ]              |
|           No Records Found         |
|   There are no items to display.   |
+------------------------------------+
```

---

## 4. Business Card Dialog (`BusinessCardDialog`)

- **File Path**: `lib/core/widgets/business_card_dialog.dart`
- **Purpose**: Modal pop-up dialog presenting employee contact information, department, designation, and contact details.
- **Parameters**: `employee`.
- **Usage**: Profile Screen "View Digital Business Card" button.

```
+------------------------------------+
| Business Card                      |
| +--------------------------------+ |
| | anitha k                       | |
| | 20140                          | |
| | EXECUTIVE - SALES              | |
| | (i) +971 50 123 4567           | |
| | (@) anitha.k@company.com       | |
| +--------------------------------+ |
|                          [CLOSE]   |
+------------------------------------+
```

---

## 5. Main Navigation Bar (`MainNavigation`)

- **File Path**: `lib/navigation/main_navigation.dart`
- **Purpose**: Role-aware bottom navigation bar switching between 5 primary tabs for Employee and HR roles.
- **Employee Tabs**: Home, Payslips, Leave, Pay Summary, Profile.
- **HR Admin Tabs**: Admin, Employees, Leaves, Payroll, Profile.

```
Employee Bottom Bar:
+-------------------------------------------------------+
|  [H] Home | [P] Payslips | [L] Leave | [S] Pay | [i] Profile |
+-------------------------------------------------------+

HR Bottom Bar:
+-------------------------------------------------------+
|  [A] Admin | [E] Employees | [L] Leaves | [$] Pay | [i] Profile |
+-------------------------------------------------------+
```

---

## 6. Status Badges & Chips

- **Purpose**: Standardized status indicator chips indicating workflow states across modules.
- **Color Mapping**:
  - **Approved / Success / Checked In**: Green container + Dark Green text
  - **Pending / In Review**: Amber container + Dark Amber text
  - **Rejected / Error / Outside Geofence**: Red container + Dark Red text
  - **Completed / Closed**: Blue container + Dark Blue text

```
+------------------+     +------------------+     +------------------+
|  [v] Approved    |     |  [!] Pending     |     |  [x] Rejected    |
+------------------+     +------------------+     +------------------+
```

---

## 7. Metric Summary Cards

- **Purpose**: Compact numerical metric summary cards displayed on top of Dashboards and Request Centers.
- **Usage**: Dashboard Pending Requests Card, Unified Request Center Metrics, HR Dashboard Summary.

```
+-------------------------------------------------------+
|  Pending: 3        |  Approved: 12       |  Rejected: 1|
+-------------------------------------------------------+
```
