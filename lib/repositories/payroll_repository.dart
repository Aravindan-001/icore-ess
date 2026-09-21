import '../models/payslip.dart';
import '../models/pay_summary.dart';

abstract class PayrollRepository {
  Future<List<Payslip>> getPayslips();
  Future<PaySummary> getPaySummary();
  Future<PayslipDetail> getPayslipDetail(String year, String month);
}
