import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/empty_state.dart';
import '../../models/pay_summary.dart';
import '../../models/payslip.dart';
import '../payslip/payslip_provider.dart';

class PaySummaryScreen extends ConsumerStatefulWidget {
  const PaySummaryScreen({super.key});

  @override
  ConsumerState<PaySummaryScreen> createState() => _PaySummaryScreenState();
}

class _PaySummaryScreenState extends ConsumerState<PaySummaryScreen> {
  String _selectedYear = '2025';
  String _selectedMonth = 'January';

  final List<String> _years = ['2025', '2024'];
  final List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  Widget build(BuildContext context) {
    final paySummaryAsync = ref.watch(paySummaryProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Pay Summary',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: paySummaryAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Unable to load Pay Summary.', style: TextStyle(color: AppTheme.error)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(paySummaryProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (paySummary) {
          final monthlyData = _findMonthlyPay(paySummary);

          return RefreshIndicator(
            onRefresh: () async => ref.refresh(paySummaryProvider),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  // YTD Summary Metrics Card
                  Container(
                    width: double.infinity,
                    color: AppTheme.primaryBlue,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'YTD SUMMARY',
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildYtdMetric('Annual Gross', 'AED ${paySummary.annualGrossPay.toStringAsFixed(0)}'),
                            _buildYtdMetric('YTD Deductions', 'AED ${paySummary.totalDeductionsYtd.toStringAsFixed(0)}'),
                            _buildYtdMetric('YTD Net Pay', 'AED ${paySummary.netPayYtd.toStringAsFixed(0)}'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Year Selection Header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Payroll Year',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: AppTheme.textMain,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButton<String>(
                            value: _selectedYear,
                            underline: const SizedBox(),
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: AppTheme.primaryBlue,
                            ),
                            items: _years.map((String y) {
                              return DropdownMenuItem<String>(
                                value: y,
                                child: Text(
                                  y,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryBlue,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedYear = val);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Horizontal Month Selector
                  Container(
                    height: 56,
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _months.length,
                      itemBuilder: (context, idx) {
                        final m = _months[idx];
                        final isSelected = _selectedMonth.toLowerCase() == m.toLowerCase();
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: InkWell(
                            onTap: () => setState(() => _selectedMonth = m),
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppTheme.primaryBlue
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? AppTheme.primaryBlue
                                      : Colors.grey.shade300,
                                ),
                              ),
                              child: Text(
                                m,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : AppTheme.textMuted,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(height: 1),

                  // Breakdown Content for Selected Month
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: monthlyData == null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: EmptyState(
                              title: 'No Data for $_selectedMonth $_selectedYear',
                              message: 'Payroll details for this period are not available.',
                              icon: Icons.receipt_long_outlined,
                            ),
                          )
                        : _buildMonthlyBreakdown(monthlyData),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  MonthlyPay? _findMonthlyPay(PaySummary summary) {
    for (final item in summary.monthlyBreakdown) {
      if (item.month.toLowerCase() == _selectedMonth.toLowerCase()) {
        if (item.year == null || item.year == _selectedYear) {
          return item;
        }
      }
    }
    return null;
  }

  Widget _buildYtdMetric(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyBreakdown(MonthlyPay data) {
    final earningsList = data.earnings ?? [
      SalaryComponent(name: 'Basic Salary', amount: 975.00),
      SalaryComponent(name: 'Housing Allowance', amount: 300.00),
      SalaryComponent(name: 'Transportation Allowance', amount: 150.00),
      SalaryComponent(name: 'Other Allowance', amount: 75.00),
    ];
    final deductionsList = data.deductions ?? [];

    final double totalEarnings = data.grossPay ?? earningsList.fold(0.0, (sum, e) => sum + e.amount);
    final double totalDeductions = data.totalDeductions ?? deductionsList.fold(0.0, (sum, d) => sum + d.amount);
    final double netPay = data.amount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Payroll Components',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 16,
                color: AppTheme.textMain,
              ),
            ),
            Text(
              '$_selectedMonth $_selectedYear',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: AppTheme.primaryBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Earnings Section
        _buildSectionHeader('EARNINGS'),
        ...earningsList.map((e) => _buildComponentCard(e.name, e.amount)),
        _buildSummaryRow('Total Gross Earnings', totalEarnings),
        const SizedBox(height: 20),

        // Deductions Section
        _buildSectionHeader('DEDUCTIONS'),
        if (deductionsList.isEmpty)
          const Card(
            color: Colors.white,
            elevation: 0,
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'No deductions for this period',
                style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
              ),
            ),
          )
        else
          ...deductionsList.map((d) => _buildComponentCard(d.name, d.amount, isDeduction: true)),
        _buildSummaryRow('Total Deductions', totalDeductions, isDeduction: true),
        const SizedBox(height: 24),

        // Grand Total Net Pay Block
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Net Pay',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              Text(
                'AED ${netPay.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppTheme.textMuted,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildComponentCard(
    String label,
    double val, {
    bool isDeduction = false,
  }) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.textMain,
              ),
            ),
            Text(
              '${isDeduction ? "-" : ""}AED ${val.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDeduction ? Colors.red.shade700 : AppTheme.textMain,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double val, {bool isDeduction = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppTheme.textMuted,
            ),
          ),
          Text(
            'AED ${val.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isDeduction && val > 0 ? Colors.red.shade700 : AppTheme.textMain,
            ),
          ),
        ],
      ),
    );
  }
}
