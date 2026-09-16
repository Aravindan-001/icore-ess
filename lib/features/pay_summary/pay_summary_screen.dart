import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/dependency_injection.dart';
import '../../models/pay_summary.dart';

class PaySummaryScreen extends StatelessWidget {
  const PaySummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      appBar: AppBar(title: const Text('Pay Summary')),
      body: FutureBuilder<PaySummary>(
        future: DependencyInjection.payrollService.getPaySummary(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading pay summary'));
          }
          
          final summary = snapshot.data!;
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.spacingXl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCard(
                  context, 
                  'Annual Gross Pay', 
                  '₹${summary.annualGrossPay.toStringAsFixed(0)}', 
                  Icons.account_balance_wallet
                ),
                const SizedBox(height: AppConstants.spacingLg),
                _buildSummaryCard(
                  context, 
                  'Total Deductions (YTD)', 
                  '₹${summary.totalDeductionsYtd.toStringAsFixed(0)}', 
                  Icons.money_off, 
                  color: colorScheme.error
                ),
                const SizedBox(height: AppConstants.spacingLg),
                _buildSummaryCard(
                  context, 
                  'Net Pay (YTD)', 
                  '₹${summary.netPayYtd.toStringAsFixed(0)}', 
                  Icons.payments, 
                  color: Colors.green
                ),
                const SizedBox(height: AppConstants.spacing2Xl),
                Text('Monthly Breakdown', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: AppConstants.spacingLg),
                ...summary.monthlyBreakdown.map((item) {
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: colorScheme.surfaceContainerHighest, 
                        child: Icon(Icons.calendar_month, color: colorScheme.primary)
                      ),
                      title: Text(item.month),
                      trailing: Text(
                        '₹${item.amount.toStringAsFixed(0)}', 
                        style: const TextStyle(fontWeight: FontWeight.bold)
                      ),
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, String title, String amount, IconData icon, {Color? color}) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingXl),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            decoration: BoxDecoration(
              color: (color ?? colorScheme.primary).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color ?? colorScheme.primary),
          ),
          const SizedBox(width: AppConstants.spacingLg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.labelLarge),
                Text(
                  amount, 
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold, 
                    color: color ?? colorScheme.primary
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
