import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/injection_providers.dart';
import '../../models/payslip.dart';

final payslipsProvider = FutureProvider<List<Payslip>>((ref) async {
  final service = ref.watch(payrollServiceProvider);
  return service.getPayslips();
});

final payslipDetailProvider = FutureProvider.family<PayslipDetail, ({String year, String month})>((ref, arg) async {
  final service = ref.watch(payrollServiceProvider);
  return service.getPayslipDetail(arg.year, arg.month);
});
