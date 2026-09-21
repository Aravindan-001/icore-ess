import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';

class PaySummaryScreen extends ConsumerStatefulWidget {
  const PaySummaryScreen({super.key});

  @override
  ConsumerState<PaySummaryScreen> createState() => _PaySummaryScreenState();
}

class _PaySummaryScreenState extends ConsumerState<PaySummaryScreen> {
  String _selectedYear = '2025';
  String _selectedMonth = 'January';

  final List<String> _years = ['2025', '2024', '2023'];
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

  // Mock data for the payroll components mapping
  Map<String, double> _getMonthlyComponents(String month) {
    // Proportional mock data from references
    return {
      'Basic Salary': 52750.00,
      'Housing Allowance': 37000.00,
      'Transportation Allowance': 33500.00,
      'Other Allowance': 31750.00,
      'Pension Fund - Employee': 6330.00,
      'Total': 148670.00,
    };
  }

  @override
  Widget build(BuildContext context) {
    final components = _getMonthlyComponents(_selectedMonth);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Pay Summary',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Year Selection Card
          Container(
            padding: const EdgeInsets.all(16),
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
            height: 60,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _months.length,
              itemBuilder: (context, idx) {
                final m = _months[idx];
                final isSelected = _selectedMonth == m;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: InkWell(
                    onTap: () => setState(() => _selectedMonth = m),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
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

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Payroll Components breakdown list
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Payroll Components',
                        style: const TextStyle(
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
                  _buildSectionHeader('Earnings'),
                  _buildComponentCard(
                    'Basic Salary',
                    components['Basic Salary']!,
                  ),
                  _buildComponentCard(
                    'Housing Allowance',
                    components['Housing Allowance']!,
                  ),
                  _buildComponentCard(
                    'Transportation Allowance',
                    components['Transportation Allowance']!,
                  ),
                  _buildComponentCard(
                    'Other Allowance',
                    components['Other Allowance']!,
                  ),
                  const SizedBox(height: 16),

                  // Deductions Section
                  _buildSectionHeader('Deductions'),
                  _buildComponentCard(
                    'Pension Fund - Employee',
                    components['Pension Fund - Employee']!,
                    isDeduction: true,
                  ),
                  const SizedBox(height: 24),

                  // Grand Total Summary Block
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
                          'AED ${components['Total']!.toStringAsFixed(2)}',
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
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
        side: BorderSide(color: Colors.grey.shade100),
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
              '${isDeduction ? "-" : ""} ${val.toStringAsFixed(2)}',
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
}
