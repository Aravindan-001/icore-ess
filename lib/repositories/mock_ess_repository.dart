import '../models/employee.dart';
import '../models/leave.dart';
import '../models/payslip.dart';
import '../models/attendance.dart';
import '../models/claim.dart';
import '../models/reimbursement.dart';
import '../models/pay_summary.dart';
import '../models/notification.dart';
import '../models/product.dart';
import '../models/sales_order.dart';
import '../models/auth_result.dart';
import '../services/mock/mock_data_service.dart';
import 'ess_repository.dart';

class MockEssRepository implements EssRepository {
  static String _mockPassword = '123456';
  
  AttendanceRecord _todayAttendance = AttendanceRecord(
    date: DateTime.now(),
    status: AttendanceStatus.notMarked,
  );

  final List<MedicalClaim> _claims = [
    MedicalClaim(
      id: 'CLM001',
      employeeId: 'EMP001',
      type: 'General',
      description: 'Health Checkup',
      amount: 5000.0,
      date: DateTime.now().subtract(const Duration(days: 30)),
      status: 'Approved',
    ),
    MedicalClaim(
      id: 'CLM002',
      employeeId: 'EMP001',
      type: 'Dental',
      description: 'Dental Treatment',
      amount: 2500.0,
      date: DateTime.now().subtract(const Duration(days: 15)),
      status: 'Pending',
    ),
  ];

  final List<Reimbursement> _reimbursements = [
    Reimbursement(
      id: 'REI001',
      employeeId: 'EMP001',
      category: 'Utility',
      description: 'Internet Allowance',
      amount: 1500.0,
      date: DateTime.now().subtract(const Duration(days: 10)),
      status: 'Pending',
    ),
    Reimbursement(
      id: 'REI002',
      employeeId: 'EMP001',
      category: 'Travel',
      description: 'Travel Expenses',
      amount: 3200.0,
      date: DateTime.now().subtract(const Duration(days: 15)),
      status: 'Approved',
    ),
    Reimbursement(
      id: 'REI003',
      employeeId: 'EMP001',
      category: 'Supplies',
      description: 'Office Supplies',
      amount: 800.0,
      date: DateTime.now().subtract(const Duration(days: 20)),
      status: 'Rejected',
    ),
  ];

  @override
  Future<AuthResult> login(String employeeId, String password) async {
    await Future.delayed(const Duration(milliseconds: 10));
    if (employeeId == 'EMP001' && password == _mockPassword) {
      return AuthResult.success(
        token: 'mock_token_123',
        employee: MockDataService.mockEmployee,
      );
    }
    return AuthResult.failure(AuthStatus.invalidCredentials, 'Invalid Employee ID or password.');
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 10));
  }

  @override
  Future<bool> forgotPassword(String employeeIdOrEmail) async {
    await Future.delayed(const Duration(milliseconds: 10));
    return employeeIdOrEmail == 'EMP001' || employeeIdOrEmail == 'aravind.kumar@ebaconnect.com';
  }

  @override
  Future<bool> changePassword(String employeeId, String currentPassword, String newPassword) async {
    await Future.delayed(const Duration(milliseconds: 10));
    if (employeeId == 'EMP001' && currentPassword == _mockPassword) {
      _mockPassword = newPassword;
      return true;
    }
    return false;
  }

  void reset() {
    _mockPassword = '123456';
    _claims.clear();
    _claims.addAll([
      MedicalClaim(
        id: 'CLM001',
        employeeId: 'EMP001',
        type: 'General',
        description: 'Health Checkup',
        amount: 5000.0,
        date: DateTime.now().subtract(const Duration(days: 30)),
        status: 'Approved',
      ),
      MedicalClaim(
        id: 'CLM002',
        employeeId: 'EMP001',
        type: 'Dental',
        description: 'Dental Treatment',
        amount: 2500.0,
        date: DateTime.now().subtract(const Duration(days: 15)),
        status: 'Pending',
      ),
    ]);
    _reimbursements.clear();
    _reimbursements.addAll([
      Reimbursement(
        id: 'REI001',
        employeeId: 'EMP001',
        category: 'Utility',
        description: 'Internet Allowance',
        amount: 1500.0,
        date: DateTime.now().subtract(const Duration(days: 10)),
        status: 'Pending',
      ),
      Reimbursement(
        id: 'REI002',
        employeeId: 'EMP001',
        category: 'Travel',
        description: 'Travel Expenses',
        amount: 3200.0,
        date: DateTime.now().subtract(const Duration(days: 15)),
        status: 'Approved',
      ),
      Reimbursement(
        id: 'REI003',
        employeeId: 'EMP001',
        category: 'Supplies',
        description: 'Office Supplies',
        amount: 800.0,
        date: DateTime.now().subtract(const Duration(days: 20)),
        status: 'Rejected',
      ),
    ]);
    _todayAttendance = AttendanceRecord(
      date: DateTime.now(),
      status: AttendanceStatus.notMarked,
    );
  }

  @override
  Future<Employee> getEmployeeProfile() async {
    await Future.delayed(const Duration(milliseconds: 10));
    return MockDataService.mockEmployee;
  }

  @override
  Future<List<LeaveBalance>> getLeaveBalances() async {
    await Future.delayed(const Duration(milliseconds: 10));
    return MockDataService.mockLeaveBalances;
  }

  @override
  Future<List<LeaveRequest>> getLeaveRequests() async {
    await Future.delayed(const Duration(milliseconds: 10));
    return MockDataService.mockLeaveRequests;
  }

  @override
  Future<List<Payslip>> getPayslips() async {
    await Future.delayed(const Duration(milliseconds: 10));
    return MockDataService.mockPayslips;
  }

  @override
  Future<PaySummary> getPaySummary() async {
    await Future.delayed(const Duration(milliseconds: 10));
    return PaySummary(
      annualGrossPay: 780000,
      totalDeductionsYtd: 60000,
      netPayYtd: 720000,
      monthlyBreakdown: [
        MonthlyPay(month: 'May', amount: 65000),
        MonthlyPay(month: 'April', amount: 65000),
        MonthlyPay(month: 'March', amount: 65000),
        MonthlyPay(month: 'February', amount: 65000),
        MonthlyPay(month: 'January', amount: 65000),
      ],
    );
  }

  @override
  Future<List<AppNotification>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 10));
    return [
      AppNotification(
        id: '1',
        title: 'Leave Approved',
        message: 'Your leave request for 20th Jan has been approved.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      AppNotification(
        id: '2',
        title: 'Payslip Available',
        message: 'Your payslip for May 2024 is now available for download.',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      AppNotification(
        id: '3',
        title: 'Reimbursement Paid',
        message: 'Reimbursement of ₹1,500 has been processed.',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
      ),
      AppNotification(
        id: '4',
        title: 'Policy Update',
        message: 'New insurance policy details have been uploaded.',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        isRead: true,
      ),
      AppNotification(
        id: '5',
        title: 'Holiday Reminder',
        message: 'Coming up: Eid-ul-Adha holiday on 17th June.',
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        isRead: true,
      ),
    ];
  }

  @override
  Future<List<Product>> getProducts() async {
    await Future.delayed(const Duration(milliseconds: 10));
    return [
      Product(id: 'P1', name: 'Company Hoodie', price: 1200),
      Product(id: 'P2', name: 'Water Bottle', price: 450),
      Product(id: 'P3', name: 'Notebook', price: 200),
      Product(id: 'P4', name: 'Backpack', price: 1500),
    ];
  }

  @override
  Future<List<SalesOrder>> getSalesOrders() async {
    await Future.delayed(const Duration(milliseconds: 10));
    return [
      SalesOrder(orderNumber: 'SO-005', date: DateTime(2024, 5, 15), amount: 4500, status: 'Delivered'),
      SalesOrder(orderNumber: 'SO-004', date: DateTime(2024, 5, 10), amount: 1200, status: 'Processing'),
      SalesOrder(orderNumber: 'SO-003', date: DateTime(2024, 4, 25), amount: 800, status: 'Delivered'),
      SalesOrder(orderNumber: 'SO-002', date: DateTime(2024, 4, 12), amount: 2500, status: 'Delivered'),
      SalesOrder(orderNumber: 'SO-001', date: DateTime(2024, 3, 30), amount: 1500, status: 'Cancelled'),
    ];
  }

  @override
  Future<bool> placeOrder(Map<String, int> cart) async {
    await Future.delayed(const Duration(milliseconds: 10));
    return true;
  }

  @override
  Future<bool> applyLeave(LeaveRequest request) async {
    await Future.delayed(const Duration(milliseconds: 10));
    return true;
  }

  @override
  Future<AttendanceRecord> getTodayAttendance() async {
    await Future.delayed(const Duration(milliseconds: 10));
    return _todayAttendance;
  }

  @override
  Future<bool> checkIn(AttendanceRequest request) async {
    await Future.delayed(const Duration(milliseconds: 10));
    if (_todayAttendance.status != AttendanceStatus.notMarked) return false;
    
    _todayAttendance = _todayAttendance.copyWith(
      checkInTime: request.deviceTime,
      status: AttendanceStatus.checkedIn,
    );
    return true;
  }

  @override
  Future<bool> checkOut(AttendanceRequest request) async {
    await Future.delayed(const Duration(milliseconds: 10));
    if (_todayAttendance.status != AttendanceStatus.checkedIn) return false;
    
    _todayAttendance = _todayAttendance.copyWith(
      checkOutTime: request.deviceTime,
      status: AttendanceStatus.checkedOut,
    );
    return true;
  }

  @override
  Future<List<MedicalClaim>> getMedicalClaims() async {
    await Future.delayed(const Duration(milliseconds: 10));
    return List.from(_claims);
  }

  @override
  Future<bool> submitMedicalClaim(MedicalClaim claim) async {
    await Future.delayed(const Duration(milliseconds: 10));
    _claims.insert(0, claim);
    return true;
  }

  @override
  Future<List<Reimbursement>> getReimbursements() async {
    await Future.delayed(const Duration(milliseconds: 10));
    return List.from(_reimbursements);
  }

  @override
  Future<bool> submitReimbursement(Reimbursement reimbursement) async {
    await Future.delayed(const Duration(milliseconds: 10));
    _reimbursements.insert(0, reimbursement);
    return true;
  }
}
