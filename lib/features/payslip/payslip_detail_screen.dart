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
      appBar: AppBar(
        title: const Text('Payslip Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          detailAsync.when(
            data: (detail) => IconButton(
              icon: const Icon(Icons.share),
              onPressed: () async {
                final file = await PdfGenerator.generatePayslipPdf(detail);
                await PdfGenerator.shareFile(file);
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
              const Text('Unable to load payslip.', style: TextStyle(color: AppTheme.error)),
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
            children: [
              _buildReferenceStyleTable(context, detail),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    final file = await PdfGenerator.generatePayslipPdf(detail);
                    messenger.showSnackBar(
                      SnackBar(content: Text('Payslip downloaded successfully: ${file.path}')),
                    );
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('Download Payslip'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final file = await PdfGenerator.generatePayslipPdf(detail);
                    await PdfGenerator.shareFile(file);
                  },
                  icon: const Icon(Icons.share),
                  label: const Text('Share Payslip'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReferenceStyleTable(BuildContext context, PayslipDetail detail) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Column(
        children: [
          // Header Row 1
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeaderCell('Employee ID & Name', '${detail.employeeId}\n${detail.employeeName}', flex: 1),
                _buildHeaderCell('Department & Designation', '${detail.department}\n${detail.designation}', flex: 1),
                _buildHeaderCell('Location & Currency', '${detail.location}\n${detail.currency}', flex: 1),
                _buildHeaderCell('Pay Period', detail.payPeriod, flex: 1),
              ],
            ),
          ),
          // Header Row 2
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeaderCell('Pay Mode & D.O.J', '${detail.payMode}\n${detail.dateOfJoining}', flex: 1),
                _buildHeaderCell('Bank & Account No', '${detail.bankName ?? ''}\n${detail.accountNumber ?? ''}', flex: 1),
                _buildHeaderCell('Hours Breakup', 'Work Days: ${detail.workDays}\nPaid Leave: ${detail.paidLeave.toStringAsFixed(2)}\nOT Hrs: ${detail.otHours.toStringAsFixed(0)}\nLOP: ${detail.lop.toStringAsFixed(2)}', flex: 1),
              ],
            ),
          ),
          // Earnings & Deductions Headers
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      border: Border(
                        right: BorderSide(color: Colors.grey.shade400),
                        bottom: BorderSide(color: Colors.grey.shade400),
                      ),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Earnings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        Text('Amount', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade400),
                      ),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Deductions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        Text('Amount', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Earnings & Deductions Body
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Earnings Column
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(right: BorderSide(color: Colors.grey.shade400)),
                    ),
                    child: Column(
                      children: [
                        ...detail.earnings.map((e) => _buildBodyRow(e.name, e.amount.toStringAsFixed(2))),
                        // Fill empty space if deductions are more
                        if (detail.deductions.length > detail.earnings.length)
                          ...List.generate(detail.deductions.length - detail.earnings.length, (_) => _buildBodyRow('', '')),
                        // Total Earnings
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            border: Border(top: BorderSide(color: Colors.grey.shade400)),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total Earnings :', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              Text(detail.totalEarnings.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Deductions Column
                Expanded(
                  child: Column(
                    children: [
                      ...detail.deductions.map((d) => _buildBodyRow(d.name, d.amount.toStringAsFixed(2))),
                      // Fill empty space if earnings are more
                      if (detail.earnings.length > detail.deductions.length)
                        ...List.generate(detail.earnings.length - detail.deductions.length, (_) => _buildBodyRow('', '')),
                      // Total Deductions
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          border: Border(top: BorderSide(color: Colors.grey.shade400)),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total Deductions :', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            Text(detail.totalDeductions.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Net Pay
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              border: Border(top: BorderSide(color: Colors.grey.shade400)),
            ),
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Net Pay :', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Text('${detail.netPay.toStringAsFixed(2)} ${detail.currency}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String title, String value, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(color: Colors.grey.shade400),
            bottom: BorderSide(color: Colors.grey.shade400),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: Colors.grey.shade300,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(value, style: const TextStyle(fontSize: 10)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyRow(String label, String value) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 11)),
          Text(value, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }
}
