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

abstract class EssRepository {
  Future<bool> login(String employeeId, String password);
  Future<bool> forgotPassword(String employeeIdOrEmail);
  Future<bool> changePassword(String employeeId, String currentPassword, String newPassword);
  Future<Employee> getEmployeeProfile();
  Future<List<LeaveBalance>> getLeaveBalances();
  Future<List<LeaveRequest>> getLeaveRequests();
  Future<List<Payslip>> getPayslips();
  Future<PaySummary> getPaySummary();
  Future<List<AppNotification>> getNotifications();
  Future<List<Product>> getProducts();
  Future<List<SalesOrder>> getSalesOrders();
  Future<bool> placeOrder(Map<String, int> cart);
  Future<bool> applyLeave(LeaveRequest request);
  
  // Attendance methods
  Future<AttendanceRecord> getTodayAttendance();
  Future<bool> checkIn(AttendanceRequest request);
  Future<bool> checkOut(AttendanceRequest request);

  // Medical Claims
  Future<List<MedicalClaim>> getMedicalClaims();
  Future<bool> submitMedicalClaim(MedicalClaim claim);

  // Reimbursements
  Future<List<Reimbursement>> getReimbursements();
  Future<bool> submitReimbursement(Reimbursement reimbursement);
}
