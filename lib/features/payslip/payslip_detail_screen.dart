import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/pdf_generator.dart';
import '../../models/payslip.dart';
import 'payslip_provider.dart';

class PayslipDetailScreen extends ConsumerWidget {
  final String year;
  final String month;

  const PayslipDetailScreen({
    super.key,
    required this.year,
    required this.month,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(payslipDetailProvider((year: year, month: month)));

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Payslip Details', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          detailAsync.when(
            data: (detail) => IconButton(
              icon: const Icon(Icons.share),
              tooltip: 'Share Payslip',
              onPressed: () async {
                try {
                  final file = await PdfGenerator.generatePayslipPdf(detail);
                  await PdfGenerator.shareFile(file);
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to share payslip: $e')),
                    );
                  }
                }
              },
            ),
            loading: () => const SizedBox.shrink(),
            error: (err, stack) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Unable to load payslip details.', style: TextStyle(color: AppTheme.error)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(payslipDetailProvider((year: year, month: month))),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (detail) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNetPayHeaderCard(detail),
              const SizedBox(height: 16),
              _buildSectionCard(
                title: 'Employee Information',
                icon: Icons.person_outline,
                children: [
                  _buildDetailRow('Employee ID', detail.employeeId),
                  _buildDetailRow('Employee Name', detail.employeeName),
                  _buildDetailRow('Department', detail.department),
                  _buildDetailRow('Designation', detail.designation),
                  _buildDetailRow('Location', detail.location),
                  _buildDetailRow('Currency', detail.currency),
                ],
              ),
              const SizedBox(height: 16),
              _buildSectionCard(
                title: 'Payment Information',
                icon: Icons.account_balance_outlined,
                children: [
                  _buildDetailRow('Pay Period', detail.payPeriod),
                  _buildDetailRow('Pay Mode', detail.payMode),
                  _buildDetailRow('Date of Joining', detail.dateOfJoining),
                  if (detail.bankName != null && detail.bankName!.isNotEmpty)
                    _buildDetailRow('Bank Name', detail.bankName!),
                  if (detail.accountNumber != null && detail.accountNumber!.isNotEmpty)
                    _buildDetailRow('Account Number', detail.accountNumber!),
                ],
              ),
              const SizedBox(height: 16),
              _buildSectionCard(
                title: 'Hours & Attendance Breakdown',
                icon: Icons.access_time_outlined,
                children: [
                  _buildDetailRow('Work Days', '${detail.workDays} days'),
                  _buildDetailRow('Paid Leave', '${detail.paidLeave.toStringAsFixed(2)} days'),
                  _buildDetailRow('Overtime Hours', '${detail.otHours.toStringAsFixed(1)} hrs'),
                  _buildDetailRow('Loss of Pay (LOP)', '${detail.lop.toStringAsFixed(2)} days'),
                ],
              ),
              const SizedBox(height: 16),
              _buildFinancialBreakdownCard(detail),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      final messenger = ScaffoldMessenger.of(context);
                      final file = await PdfGenerator.generatePayslipPdf(detail);
                      messenger.showSnackBar(
                        SnackBar(content: Text('Payslip downloaded: ${file.path}')),
                      );
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to download payslip: $e')),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('Download Payslip PDF', style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    try {
                      final file = await PdfGenerator.generatePayslipPdf(detail);
                      await PdfGenerator.shareFile(file);
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to share payslip: $e')),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.share),
                  label: const Text('Share Payslip PDF', style: TextStyle(fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryBlue,
                    side: const BorderSide(color: AppTheme.primaryBlue),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNetPayHeaderCard(PayslipDetail detail) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                detail.payPeriod,
                style: const TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'PAID',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Net Transfer Amount',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              '${detail.currency} ${detail.netPay.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppTheme.primaryBlue, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textMain,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 20, thickness: 1),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textMuted,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 5,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.textMain,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialBreakdownCard(PayslipDetail detail) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.account_balance_wallet_outlined, color: AppTheme.primaryBlue, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Earnings & Deductions',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textMain,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 20, thickness: 1),
            // Earnings Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'EARNINGS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryBlue,
                ),
              ),
            ),
            const SizedBox(height: 6),
            ...detail.earnings.map((e) => _buildAmountRow(e.name, e.amount, detail.currency)),
            const Divider(height: 12),
            _buildAmountRow('Total Earnings', detail.totalEarnings, detail.currency, isBold: true),
            const SizedBox(height: 16),
            // Deductions Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'DEDUCTIONS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
            const SizedBox(height: 6),
            if (detail.deductions.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                child: Text('No deductions for this period', style: TextStyle(fontSize: 13, color: AppTheme.textMuted)),
              )
            else
              ...detail.deductions.map((d) => _buildAmountRow(d.name, d.amount, detail.currency, isDeduction: true)),
            const Divider(height: 12),
            _buildAmountRow('Total Deductions', detail.totalDeductions, detail.currency, isBold: true, isDeduction: detail.totalDeductions > 0),
            const Divider(height: 24, thickness: 1.5),
            // Net Pay Row
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Net Pay',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                        Text(
                          'Earnings - Deductions',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${detail.currency} ${detail.netPay.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountRow(String label, double amount, String currency, {bool isBold = false, bool isDeduction = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: AppTheme.textMain,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${isDeduction && amount > 0 ? "-" : ""}$currency ${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: isDeduction && amount > 0 ? Colors.red.shade700 : AppTheme.textMain,
            ),
          ),
        ],
      ),
    );
  }
}
