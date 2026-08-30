import '../../models/employee.dart';
import '../../models/leave.dart';
import '../../models/payslip.dart';

class MockDataService {
  static final Employee mockEmployee = Employee(
    id: 'EMP001',
    name: 'Aravind Kumar',
    email: 'aravind.kumar@icore.com',
    phone: '+91 9876543210',
    department: 'Information Technology',
    designation: 'Software Engineer',
    joiningDate: '15 Jan 2022',
    profileImageUrl: '', // Empty for tests
  );

  static final List<LeaveBalance> mockLeaveBalances = [
    LeaveBalance(type: 'Annual Leave', total: 20, used: 5, pending: 1),
    LeaveBalance(type: 'Sick Leave', total: 10, used: 2, pending: 0),
    LeaveBalance(type: 'Casual Leave', total: 5, used: 1, pending: 0),
  ];

  static final List<LeaveRequest> mockLeaveRequests = [
    LeaveRequest(
      id: 'LR001',
      type: 'Annual Leave',
      startDate: DateTime(2023, 10, 10),
      endDate: DateTime(2023, 10, 12),
      reason: 'Family function',
      status: LeaveStatus.approved,
      appliedDate: DateTime(2023, 10, 1),
    ),
    LeaveRequest(
      id: 'LR002',
      type: 'Sick Leave',
      startDate: DateTime(2023, 11, 5),
      endDate: DateTime(2023, 11, 5),
      reason: 'Fever',
      status: LeaveStatus.approved,
      appliedDate: DateTime(2023, 11, 4),
    ),
    LeaveRequest(
      id: 'LR003',
      type: 'Annual Leave',
      startDate: DateTime(2024, 1, 20),
      endDate: DateTime(2024, 1, 22),
      reason: 'Vacation',
      status: LeaveStatus.pending,
      appliedDate: DateTime(2024, 1, 10),
    ),
  ];

  static final List<Payslip> mockPayslips = [
    Payslip(month: 'January', year: '2024', basicSalary: 50000, allowances: 15000, deductions: 5000, netSalary: 60000),
    Payslip(month: 'December', year: '2023', basicSalary: 50000, allowances: 12000, deductions: 5000, netSalary: 57000),
    Payslip(month: 'November', year: '2023', basicSalary: 50000, allowances: 12000, deductions: 5000, netSalary: 57000),
  ];
}
