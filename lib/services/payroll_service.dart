import '../models/payslip.dart';
import '../models/pay_summary.dart';
import '../repositories/payroll_repository.dart';

class PayrollService {
  final PayrollRepository _payrollRepo;

  PayrollService(this._payrollRepo);

  Future<List<Payslip>> getPayslips() => _payrollRepo.getPayslips();
  Future<PaySummary> getPaySummary() => _payrollRepo.getPaySummary();
  Future<PayslipDetail> getPayslipDetail(String year, String month) => 
      _payrollRepo.getPayslipDetail(year, month);
}
