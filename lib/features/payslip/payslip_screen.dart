import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/dependency_injection.dart';
import '../../core/widgets/empty_state.dart';
import '../../models/payslip.dart';

class PayslipScreen extends StatelessWidget {
  const PayslipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payslips')),
      body: FutureBuilder<List<Payslip>>(
        future: DependencyInjection.payrollService.getPayslips(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading payslips'));
          }
          final payslips = snapshot.data!;
          if (payslips.isEmpty) {
            return const EmptyState(
              title: 'No Payslips',
              message: 'Your payslips will appear here once they are generated.',
              icon: Icons.receipt_long_outlined,
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            itemCount: payslips.length,
            itemBuilder: (context, index) {
              final payslip = payslips[index];
              return Card(
                child: ExpansionTile(
                  title: Text('${payslip.month} ${payslip.year}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Net Salary: ₹${payslip.netSalary.toStringAsFixed(0)}'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(AppConstants.spacingLg),
                      child: Column(
                        children: [
                          _buildSalaryRow(context, 'Basic Salary', payslip.basicSalary),
                          _buildSalaryRow(context, 'Allowances', payslip.allowances),
                          _buildSalaryRow(context, 'Deductions', -payslip.deductions, isNegative: true),
                          const Divider(),
                          _buildSalaryRow(context, 'Net Salary', payslip.netSalary, isTotal: true),
                          const SizedBox(height: AppConstants.spacingLg),
                          OutlinedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('PDF download will be available when the payslip service is integrated.'),
                                ),
                              );
                            },
                            icon: const Icon(Icons.download),
                            label: const Text('Download PDF'),
                            style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 45)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSalaryRow(BuildContext context, String label, double amount, {bool isNegative = false, bool isTotal = false}) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, fontSize: isTotal ? 16 : 14)),
          Text(
            '₹${amount.abs().toStringAsFixed(0)}',
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
              color: isNegative ? colorScheme.error : (isTotal ? colorScheme.primary : colorScheme.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}
