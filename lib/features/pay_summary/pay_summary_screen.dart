import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class PaySummaryScreen extends StatelessWidget {
  const PaySummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pay Summary')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCard(context, 'Annual Gross Pay', '₹7,80,000', Icons.account_balance_wallet),
            const SizedBox(height: 16),
            _buildSummaryCard(context, 'Total Deductions (YTD)', '₹60,000', Icons.money_off, color: AppTheme.error),
            const SizedBox(height: 16),
            _buildSummaryCard(context, 'Net Pay (YTD)', '₹7,20,000', Icons.payments, color: AppTheme.success),
            const SizedBox(height: 24),
            Text('Monthly Breakdown', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            // Placeholder for a chart or list
            ...List.generate(5, (index) {
              final months = ['May', 'April', 'March', 'February', 'January'];
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(backgroundColor: AppTheme.backgroundLight, child: Icon(Icons.calendar_month, color: AppTheme.primaryBlue)),
                  title: Text(months[index]),
                  trailing: const Text('₹65,000', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, String title, String amount, IconData icon, {Color? color}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: (color ?? AppTheme.primaryBlue).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color ?? AppTheme.primaryBlue),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.labelLarge),
              Text(amount, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: color ?? AppTheme.primaryBlue)),
            ],
          ),
        ],
      ),
    );
  }
}
