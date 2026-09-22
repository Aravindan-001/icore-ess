import '../models/employee.dart';
import '../models/employment.dart';
import '../models/leave.dart';
import '../models/payslip.dart';
import '../models/attendance.dart';
import '../models/claim.dart';
import '../models/reimbursement.dart';
import '../models/reimbursement_models.dart';
import '../models/pay_summary.dart';
import '../models/notification.dart';
import '../models/product.dart';
import '../models/sales_order.dart';
import '../models/auth_result.dart';
import '../models/overtime.dart';
import '../models/personal_info.dart';
import '../models/family.dart';
import '../models/bank.dart';
import '../models/education.dart';
import '../models/skill.dart';
import '../models/identity.dart';
import '../models/work_history.dart';
import '../models/certificate.dart';
import '../models/pending_request.dart';
import '../models/airfare.dart';
import '../models/education_declaration.dart';
import '../services/mock/mock_data_service.dart';
import 'ess_repository.dart';

class MockEssRepository implements EssRepository {
  String _mockPassword = 'Employee@123';
  Employee? _currentUser;
  
  AttendanceRecord _todayAttendance = AttendanceRecord(
    date: DateTime.now(),
    status: AttendanceStatus.notMarked,
  );

  final List<AttendanceRecord> _attendanceHistory = [
    AttendanceRecord(
      date: DateTime.now().subtract(const Duration(days: 1)),
      checkInTime: DateTime.now().subtract(const Duration(days: 1, hours: 9, minutes: 15)),
      checkOutTime: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
      status: AttendanceStatus.checkedOut,
    ),
    AttendanceRecord(
      date: DateTime.now().subtract(const Duration(days: 2)),
      checkInTime: DateTime.now().subtract(const Duration(days: 2, hours: 8, minutes: 55)),
      checkOutTime: DateTime.now().subtract(const Duration(days: 2, hours: 0, minutes: 30)),
      status: AttendanceStatus.checkedOut,
    ),
    AttendanceRecord(
      date: DateTime.now().subtract(const Duration(days: 3)),
      checkInTime: DateTime.now().subtract(const Duration(days: 3, hours: 9, minutes: 0)),
      checkOutTime: DateTime.now().subtract(const Duration(days: 3, hours: 0, minutes: 45)),
      status: AttendanceStatus.checkedOut,
    ),
    AttendanceRecord(
      date: DateTime.now().subtract(const Duration(days: 4)),
      checkInTime: DateTime.now().subtract(const Duration(days: 4, hours: 9, minutes: 5)),
      checkOutTime: DateTime.now().subtract(const Duration(days: 4, hours: 1, minutes: 15)),
      status: AttendanceStatus.checkedOut,
    ),
    AttendanceRecord(
      date: DateTime.now().subtract(const Duration(days: 5)),
      checkInTime: DateTime.now().subtract(const Duration(days: 5, hours: 8, minutes: 45)),
      checkOutTime: DateTime.now().subtract(const Duration(days: 5, hours: 0, minutes: 10)),
      status: AttendanceStatus.checkedOut,
    ),
  ];

  final List<AppNotification> _notifications = [
    AppNotification(
      id: '1',
      title: 'Leave Approved',
      message: 'Your leave request for 20th Jan has been approved.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      category: NotificationCategory.leave,
      route: '/leave',
    ),
    AppNotification(
      id: '2',
      title: 'Payslip Available',
      message: 'Your payslip for May 2024 is now available for download.',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      category: NotificationCategory.payroll,
      route: '/payslip',
    ),
    AppNotification(
      id: '3',
      title: 'Reimbursement Paid',
      message: 'Reimbursement of ₹1,500 has been processed.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      category: NotificationCategory.request,
      route: '/reimbursement',
    ),
    AppNotification(
      id: '4',
      title: 'Attendance Reminder',
      message: 'Don\'t forget to check out today!',
      timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      category: NotificationCategory.attendance,
      route: '/attendance',
    ),
    AppNotification(
      id: '5',
      title: 'Holiday Reminder',
      message: 'Coming up: Eid-ul-Adha holiday on 17th June.',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
      category: NotificationCategory.system,
    ),
    AppNotification(
      id: '6',
      title: 'Policy Update',
      message: 'New insurance policy details have been uploaded.',
      timestamp: DateTime.now().subtract(const Duration(days: 4)),
      isRead: true,
      category: NotificationCategory.system,
    ),
    AppNotification(
      id: '7',
      title: 'Public Holiday',
      message: 'Tomorrow is a public holiday for Islamic New Year.',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      category: NotificationCategory.general,
    ),
    AppNotification(
      id: '8',
      title: 'Clock-in Missing',
      message: 'You missed clock-in for 15th June. Please regularize.',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      isRead: false,
      category: NotificationCategory.attendance,
      route: '/attendance',
    ),
    AppNotification(
      id: '9',
      title: 'Salary Revision',
      message: 'Your salary has been revised effective from July.',
      timestamp: DateTime.now().subtract(const Duration(days: 10)),
      isRead: true,
      category: NotificationCategory.payroll,
      route: '/pay-summary',
    ),
    AppNotification(
      id: '10',
      title: 'Expense Approved',
      message: 'Your travel expense claim (TX-992) has been approved.',
      timestamp: DateTime.now().subtract(const Duration(hours: 12)),
      isRead: false,
      category: NotificationCategory.request,
      route: '/reimbursement',
    ),
  ];

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

  final List<ReimbursementRequest> _reimbursementRequests = [
    ReimbursementRequest(
      documentNumber: 'CR-24100000',
      date: DateTime(2024, 10, 25),
      documentType: DocumentType.fuel,
      status: ReimbursementStatus.cancelled,
      notes: 'Cancelled fuel request',
      totalBillAmount: 1000.0,
      totalClaimAmount: 1000.0,
      totalReimbursedAmount: 0.0,
      lineItems: [
        ReimbursementLineItem(
          id: 'item_1',
          type: 'FUEL',
          costCenter: 'Canadian - Cost Center',
          description: 'Fuel expenses',
          billRefNo: '5451',
          date: DateTime(2024, 10, 25),
          billAmount: 1000.0,
          claimAmount: 1000.0,
          attachment: const ReimbursementAttachment(fileName: 'receipt1.jpg', status: AttachmentStatus.uploaded),
        )
      ],
    ),
    ReimbursementRequest(
      documentNumber: 'CR-24100001',
      date: DateTime(2024, 10, 25),
      documentType: DocumentType.fuel,
      status: ReimbursementStatus.cancelled,
      notes: 'Cancelled draft',
      totalBillAmount: 1500.0,
      totalClaimAmount: 1500.0,
      totalReimbursedAmount: 0.0,
      lineItems: [
        ReimbursementLineItem(
          id: 'item_2',
          type: 'FUEL',
          costCenter: 'Chang Jiang - Cost Center',
          description: 'Fuel storage',
          billRefNo: '5452',
          date: DateTime(2024, 10, 25),
          billAmount: 1500.0,
          claimAmount: 1500.0,
        )
      ],
    ),
    ReimbursementRequest(
      documentNumber: 'CR-24100002',
      date: DateTime(2024, 10, 25),
      documentType: DocumentType.fuel,
      status: ReimbursementStatus.approved,
      notes: 'Approved trip info',
      totalBillAmount: 500.0,
      totalClaimAmount: 500.0,
      totalReimbursedAmount: 500.0,
      lineItems: [
        ReimbursementLineItem(
          id: 'item_3',
          type: 'FUEL',
          costCenter: 'Chenab - Cost Center',
          description: 'Client visit fuel',
          billRefNo: '5453',
          date: DateTime(2024, 10, 25),
          billAmount: 500.0,
          claimAmount: 500.0,
        )
      ],
    ),
    ReimbursementRequest(
      documentNumber: 'CR-24100003',
      date: DateTime(2024, 10, 25),
      documentType: DocumentType.fuel,
      status: ReimbursementStatus.submitted,
      notes: 'Submitted for verification',
      totalBillAmount: 750.0,
      totalClaimAmount: 750.0,
      totalReimbursedAmount: 0.0,
      lineItems: [
        ReimbursementLineItem(
          id: 'item_4',
          type: 'FUEL',
          costCenter: 'Chindwin - Cost Center',
          description: 'Site operations fuel',
          billRefNo: '5454',
          date: DateTime(2024, 10, 25),
          billAmount: 750.0,
          claimAmount: 750.0,
        )
      ],
    ),
  ];

  @override
  Future<AuthResult> login(String employeeId, String password) async {
    await Future.delayed(const Duration(milliseconds: 10));
    
    final trimmedId = employeeId.trim();
    final trimmedPassword = password.trim();

    // Employee Dummy Account
    if (trimmedId == '20140' && trimmedPassword == _mockPassword) {
      _currentUser = MockDataService.mockEmployee;
      return AuthResult.success(
        token: 'mock_employee_token',
        employee: _currentUser,
      );
    }
    
    // HR Dummy Account
    if (trimmedId == 'HR001' && trimmedPassword == 'HR@12345') {
      _currentUser = MockDataService.mockHrEmployee;
      return AuthResult.success(
        token: 'mock_hr_token',
        employee: _currentUser,
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
    if ((employeeId == 'EMP001' || employeeId == '20140') && currentPassword == _mockPassword) {
      _mockPassword = newPassword;
      return true;
    }
    return false;
  }

  void reset() {
    _mockPassword = 'Employee@123';
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
    return _currentUser ?? MockDataService.mockEmployee;
  }

  @override
  Future<EmployeeEmployment> getEmploymentSummary() async {
    await Future.delayed(const Duration(milliseconds: 10));
    return MockDataService.mockEmployment;
  }

  @override
  Future<PersonalInformation> getPersonalInformation() async {
    await Future.delayed(const Duration(milliseconds: 10));
    return MockDataService.mockPersonalInformation;
  }

  @override
  Future<List<FamilyMember>> getFamilyInformation() async {
    await Future.delayed(const Duration(milliseconds: 10));
    return MockDataService.mockFamily;
  }

  @override
  Future<BankInformation> getBankInformation() async {
    await Future.delayed(const Duration(milliseconds: 10));
    return MockDataService.mockBank;
  }

  @override
  Future<List<EducationRecord>> getEducationHistory() async {
    await Future.delayed(const Duration(milliseconds: 10));
    return MockDataService.mockEducation;
  }

  @override
  Future<List<EducationDocument>> getEducationDocuments() async {
    await Future.delayed(const Duration(milliseconds: 10));
    return MockDataService.mockEducationDocuments;
  }

  @override
  Future<List<Skill>> getSkills() async {
    await Future.delayed(const Duration(milliseconds: 10));
    return MockDataService.mockSkills;
  }

  @override
  Future<List<IdentityDocument>> getIdentityDocuments() async {
    await Future.delayed(const Duration(milliseconds: 10));
    return MockDataService.mockIdentities;
  }

  @override
  Future<List<WorkExperience>> getWorkHistory() async {
    await Future.delayed(const Duration(milliseconds: 10));
    return MockDataService.mockWorkHistory;
  }

  @override
  Future<List<Certificate>> getCertificates() async {
    await Future.delayed(const Duration(milliseconds: 10));
    return MockDataService.mockCertificates;
  }

  @override
  Future<List<PendingRequest>> getProfileUpdateRequests() async {
    await Future.delayed(const Duration(milliseconds: 10));
    return MockDataService.mockProfileRequests;
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
  Future<PayslipDetail> getPayslipDetail(String year, String month) async {
    await Future.delayed(const Duration(milliseconds: 10));
    return MockDataService.getMockPayslipDetail(year, month);
  }

  @override
  Future<List<OvertimeRequest>> getOvertimeRequests() async {
    await Future.delayed(const Duration(milliseconds: 10));
    return MockDataService.mockOvertimeRequests;
  }

  @override
  Future<OvertimeRequest> getOvertimeRequestDetail(String id) async {
    await Future.delayed(const Duration(milliseconds: 10));
    return MockDataService.mockOvertimeRequests.firstWhere((r) => r.id == id);
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
    return List.from(_notifications);
  }

  @override
  Future<void> markAsRead(String id) async {
    await Future.delayed(const Duration(milliseconds: 10));
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
    }
  }

  @override
  Future<void> markAllAsRead() async {
    await Future.delayed(const Duration(milliseconds: 10));
    for (int i = 0; i < _notifications.length; i++) {
      if (!_notifications[i].isRead) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
      }
    }
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
    MockDataService.mockLeaveRequests.insert(0, request);
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
  Future<List<AttendanceRecord>> getAttendanceHistory() async {
    await Future.delayed(const Duration(milliseconds: 10));
    return List.from(_attendanceHistory);
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

  @override
  Future<List<ReimbursementRequest>> getReimbursementRequests() async {
    await Future.delayed(const Duration(milliseconds: 10));
    return List.from(_reimbursementRequests);
  }

  @override
  Future<ReimbursementRequest?> getReimbursementRequestDetails(String documentNumber) async {
    await Future.delayed(const Duration(milliseconds: 10));
    for (var r in _reimbursementRequests) {
      if (r.documentNumber == documentNumber) return r;
    }
    return null;
  }

  @override
  Future<bool> saveReimbursementDraft(ReimbursementRequest request) async {
    await Future.delayed(const Duration(milliseconds: 10));
    final index = _reimbursementRequests.indexWhere((r) => r.documentNumber == request.documentNumber);
    if (index >= 0) {
      _reimbursementRequests[index] = request;
    } else {
      _reimbursementRequests.insert(0, request);
    }
    return true;
  }

  @override
  Future<bool> submitReimbursementRequest(ReimbursementRequest request) async {
    await Future.delayed(const Duration(milliseconds: 10));
    final index = _reimbursementRequests.indexWhere((r) => r.documentNumber == request.documentNumber);
    final updated = request.copyWith(status: ReimbursementStatus.submitted);
    if (index >= 0) {
      _reimbursementRequests[index] = updated;
    } else {
      _reimbursementRequests.insert(0, updated);
    }
    return true;
  }

  @override
  Future<bool> cancelReimbursementRequest(String documentNumber) async {
    await Future.delayed(const Duration(milliseconds: 10));
    final index = _reimbursementRequests.indexWhere((r) => r.documentNumber == documentNumber);
    if (index >= 0) {
      _reimbursementRequests[index] = _reimbursementRequests[index].copyWith(status: ReimbursementStatus.cancelled);
      return true;
    }
    return false;
  }

  @override
  Future<List<AirfareDeclaration>> getAirfareDeclarations() async {
    await Future.delayed(const Duration(milliseconds: 10));
    return MockDataService.mockAirfareDeclarations;
  }

  @override
  Future<AirfareDeclaration> getAirfareDeclarationDetail(String id) async {
    await Future.delayed(const Duration(milliseconds: 10));
    return MockDataService.mockAirfareDeclarations.firstWhere((r) => r.id == id);
  }

  @override
  Future<List<EducationDeclaration>> getEducationDeclarations() async {
    await Future.delayed(const Duration(milliseconds: 10));
    return MockDataService.mockEducationDeclarations;
  }

  @override
  Future<EducationDeclaration> getEducationDeclarationDetail(String id) async {
    await Future.delayed(const Duration(milliseconds: 10));
    return MockDataService.mockEducationDeclarations.firstWhere((r) => r.id == id);
  }
}
