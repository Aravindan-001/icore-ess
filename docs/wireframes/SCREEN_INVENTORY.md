# ebaConnect / iCore ESS — Screen Inventory

## Overview

This document catalogs every user-facing screen, navigation shell, and sub-screen in the **ebaConnect / iCore ESS** Flutter application. Every entry directly maps to an implemented Flutter widget, named route, or `onGenerateRoute` entry in `lib/app.dart` and `lib/core/constants/app_constants.dart`.

Total Cataloged Views: **45 Screens & Views**

---

## Screen Inventory Table

| ID | Screen Name | Role | Route | Entry Point | Flutter Implementation | Status |
| :--- | :--- | :--- | :--- | :--- | :--- | :---: |
| **SCR-001** | Bootstrap Screen | Shared | `/` | App Startup | `lib/features/auth/bootstrap_screen.dart` | **Active** |
| **SCR-002** | Login Screen | Shared | `/login` | Bootstrap (No Session) / Logout | `lib/features/auth/login_screen.dart` | **Active** |
| **SCR-003** | Change Password Screen | Shared | Push | Settings Screen | `lib/features/settings/change_password_screen.dart` | **Active** |
| **SCR-004** | Forgot Password Screen | Shared | Standalone Widget | Login Screen | `lib/features/auth/forgot_password_screen.dart` | **Active** |
| **SCR-005** | Main Navigation Hub | Shared Shell | `/main` | Login / Session Restore | `lib/navigation/main_navigation.dart` | **Active** |
| **SCR-006** | Home Dashboard | Employee | `/dashboard` | Tab 0 (MainNavigation) | `lib/features/dashboard/dashboard_screen.dart` | **Active** |
| **SCR-007** | Attendance Screen | Employee | `/attendance` | Dashboard Attendance Card / Tile | `lib/features/attendance/attendance_screen.dart` | **Active** |
| **SCR-008** | Leave Overview | Employee | `/leave` | Tab 2 (MainNavigation) / Tile | `lib/features/leave/leave_screen.dart` | **Active** |
| **SCR-009** | Apply Leave Screen | Employee | `/leave/apply` | Leave Screen FAB / Header Button | `lib/features/leave/apply_leave_screen.dart` | **Active** |
| **SCR-010** | Payslip History | Employee | `/payslip` | Tab 1 (MainNavigation) / Tile | `lib/features/payslip/payslip_screen.dart` | **Active** |
| **SCR-011** | Payslip Detail Screen | Shared | `/payslip/detail` | Payslip List / Documents Screen | `lib/features/payslip/payslip_detail_screen.dart` | **Active** |
| **SCR-012** | Pay Summary Screen | Employee | `/pay-summary` | Tab 3 (MainNavigation) / Tile | `lib/features/pay_summary/pay_summary_screen.dart` | **Active** |
| **SCR-013** | Salary & Benefits Screen | Employee | `/salary-benefits` | Profile / Dashboard Tile | `lib/features/salary_benefits/salary_benefits_screen.dart` | **Active** |
| **SCR-014** | Overtime List Screen | Employee | `/overtime` | Dashboard Services / Tile | `lib/features/overtime/overtime_list_screen.dart` | **Active** |
| **SCR-015** | Overtime Detail Screen | Employee | `/overtime/detail` | Overtime List Tile | `lib/features/overtime/overtime_detail_screen.dart` | **Active** |
| **SCR-016** | Airfare List Screen | Employee | `/airfare` | Dashboard Services / Tile | `lib/features/airfare/airfare_list_screen.dart` | **Active** |
| **SCR-017** | Airfare Detail Screen | Employee | `/airfare/detail` | Airfare List Tile | `lib/features/airfare/airfare_detail_screen.dart` | **Active** |
| **SCR-018** | Education List Screen | Employee | `/education-declaration` | Dashboard Services / Tile | `lib/features/education/education_list_screen.dart` | **Active** |
| **SCR-019** | Education Detail Screen | Employee | `/education-declaration/detail` | Education List Tile | `lib/features/education/education_detail_screen.dart` | **Active** |
| **SCR-020** | Reimbursement List Screen | Employee | `/reimbursement` | Dashboard Services / Tile | `lib/features/reimbursement/reimbursement_list_screen.dart` | **Active** |
| **SCR-021** | Reimbursement Form Screen | Employee | `/reimbursement/form` | Reimbursement List FAB | `lib/features/reimbursement/reimbursement_form_screen.dart` | **Active** |
| **SCR-022** | Medical Claims Screen | Employee | `/claims` | Dashboard Services / Tile | `lib/features/claims/claims_screen.dart` | **Active** |
| **SCR-023** | Pre-Order Screen | Employee | `/pre-order` | Dashboard Services / Tile | `lib/features/pre_order/pre_order_screen.dart` | **Active** |
| **SCR-024** | Sales Order Screen | Employee | `/sales-order` | Dashboard Services / Tile | `lib/features/sales_order/sales_order_screen.dart` | **Active** |
| **SCR-025** | Unified Request Center | Employee | `/requests` | Dashboard Request Card / Tile | `lib/features/requests/requests_screen.dart` | **Active** |
| **SCR-026** | Notifications Screen | Employee | `/notifications` | AppBar Notification Icon / Tile | `lib/features/notifications/notifications_screen.dart` | **Active** |
| **SCR-027** | My Documents Screen | Employee | `/documents` | Profile Tile | `lib/features/documents/documents_screen.dart` | **Active** |
| **SCR-028** | Settings Screen | Shared | `/settings` | Profile Settings Button / Tile | `lib/features/settings/settings_screen.dart` | **Active** |
| **SCR-029** | Services Catalog Screen | Shared | Standalone Widget | Dashboard "View All Services" | `lib/features/services/services_screen.dart` | **Active** |
| **SCR-030** | Profile Main Screen | Shared | `/profile` | Tab 4 (MainNavigation) | `lib/features/profile/profile_screen.dart` | **Active** |
| **SCR-031** | Personal Info Landing | Employee | `/profile/personal-info` | Profile Personal Info Tile | `lib/features/profile/personal_info_landing_screen.dart` | **Active** |
| **SCR-032** | Basic Information | Employee | `/profile/basic-info` | Personal Info Portal (1/10) | `lib/features/profile/basic_info_screen.dart` | **Active** |
| **SCR-033** | Family Information | Employee | `/profile/family` | Personal Info Portal (2/10) | `lib/features/profile/family_info_screen.dart` | **Active** |
| **SCR-034** | Bank Information | Employee | `/profile/bank` | Personal Info Portal (3/10) | `lib/features/profile/bank_info_screen.dart` | **Active** |
| **SCR-035** | Education History | Employee | `/profile/education` | Personal Info Portal (4/10) | `lib/features/profile/education_screen.dart` | **Active** |
| **SCR-036** | Education Documents | Employee | `/profile/education-docs` | Personal Info Portal (5/10) | `lib/features/profile/education_docs_screen.dart` | **Active** |
| **SCR-037** | Skills | Employee | `/profile/skills` | Personal Info Portal (6/10) | `lib/features/profile/skills_screen.dart` | **Active** |
| **SCR-038** | Identity Documents | Employee | `/profile/identity` | Personal Info Portal (7/10) | `lib/features/profile/identity_screen.dart` | **Active** |
| **SCR-039** | Work History | Employee | `/profile/work-history` | Personal Info Portal (8/10) | `lib/features/profile/work_history_screen.dart` | **Active** |
| **SCR-040** | Certificates | Employee | `/profile/certificates` | Personal Info Portal (9/10) | `lib/features/profile/certificates_screen.dart` | **Active** |
| **SCR-041** | Profile Update Requests | Employee | `/profile/requests` | Personal Info Portal (10/10) | `lib/features/profile/profile_requests_screen.dart` | **Active** |
| **SCR-042** | HR Admin Dashboard | HR | `/hr/dashboard` | Tab 0 (HR MainNavigation) | `lib/features/hr/hr_dashboard_screen.dart` | **Active** |
| **SCR-043** | HR Employee Roster | HR | `/hr/employees` | Tab 1 (HR MainNavigation) | `lib/features/hr/hr_employee_list_screen.dart` | **Active** |
| **SCR-044** | HR Leave Requests | HR | `/hr/leaves` | Tab 2 (HR MainNavigation) | `lib/features/hr/hr_leave_requests_screen.dart` | **Active** |
| **SCR-045** | HR Payroll Management | HR | `/hr/payslips` | Tab 3 (HR MainNavigation) | `lib/features/hr/hr_payslip_mgmt_screen.dart` | **Active** |

---

## Role & Module Summary

- **Shared / Authentication / Navigation Shells**: 5 Views (`SCR-001` to `SCR-005`)
- **Employee Core & Feature Modules**: 25 Views (`SCR-006` to `SCR-030`)
- **Personal Information 10-Subscreen Portal**: 11 Views (`SCR-031` to `SCR-041`)
- **HR Administration Portal**: 4 Views (`SCR-042` to `SCR-045`)
