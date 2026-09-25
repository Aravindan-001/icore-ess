import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/pdf_generator.dart';
import '../../core/widgets/empty_state.dart';
import '../../models/payslip.dart';
import 'payslip_provider.dart';

class PayslipScreen extends ConsumerStatefulWidget {
  const PayslipScreen({super.key});

  @override
  ConsumerState<PayslipScreen> createState() => _PayslipScreenState();
}

class _PayslipScreenState extends ConsumerState<PayslipScreen> {
  String _selectedYear = 'All';

  @override
  Widget build(BuildContext context) {
    final payslipsAsync = ref.watch(payslipsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Payslips', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_month, size: 16, color: Colors.white),
                const SizedBox(width: 4),
                DropdownButton<String>(
                  value: _selectedYear,
                  dropdownColor: AppTheme.primaryBlue,
                  underline: const SizedBox(),
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  items: ['All', '2025', '2024'].map((String val) {
                    return DropdownMenuItem<String>(
                      value: val,
                      child: Text(val),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _selectedYear = val);
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: payslipsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Error loading payslips', style: TextStyle(color: AppTheme.error)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(payslipsProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (allPayslips) {
          final filteredPayslips = _selectedYear == 'All'
              ? allPayslips
              : allPayslips.where((p) => p.year == _selectedYear).toList();

          if (filteredPayslips.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async => ref.refresh(payslipsProvider),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 100),
                  EmptyState(
                    title: 'No Payslips',
                    message: 'No payslips found for the selected period.',
                    icon: Icons.receipt_long_outlined,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => ref.refresh(payslipsProvider),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: filteredPayslips.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final payslip = filteredPayslips[index];
                return _buildPayslipCard(context, ref, payslip);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildPayslipCard(BuildContext context, WidgetRef ref, Payslip payslip) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            payslip.payPeriod,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.primaryBlue,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.success.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Paid',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.success,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Net Pay: ${payslip.currency} ${payslip.netSalary.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textMuted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.share, color: AppTheme.primaryBlue, size: 20),
                  tooltip: 'Share Payslip',
                  onPressed: () async {
                    try {
                      final detail = await ref.read(payslipDetailProvider((year: payslip.year, month: payslip.month)).future);
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
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppConstants.payslipDetailRoute,
                        arguments: {'year': payslip.year, 'month': payslip.month},
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: const Text('View', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      try {
                        final messenger = ScaffoldMessenger.of(context);
                        final detail = await ref.read(payslipDetailProvider((year: payslip.year, month: payslip.month)).future);
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
                    icon: const Icon(Icons.download, size: 16),
                    label: const Text('Download', style: TextStyle(fontWeight: FontWeight.bold)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryBlue,
                      side: const BorderSide(color: AppTheme.primaryBlue),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
