import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/pdf_generator.dart';
import '../../models/employee.dart';
import '../../services/mock/mock_data_service.dart';

class HrPayslipMgmtScreen extends StatefulWidget {
  const HrPayslipMgmtScreen({super.key});

  @override
  State<HrPayslipMgmtScreen> createState() => _HrPayslipMgmtScreenState();
}

class _HrPayslipMgmtScreenState extends State<HrPayslipMgmtScreen> {
  Employee? _selectedEmployee;

  @override
  Widget build(BuildContext context) {
    final employees = MockDataService.mockAllEmployees;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Payslip Management', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Select Employee', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Employee>(
                      isExpanded: true,
                      value: _selectedEmployee,
                      hint: const Text('Search or select employee'),
                      items: employees.map((e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Text('${e.name} (${e.id})'),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => _selectedEmployee = val),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_selectedEmployee != null)
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: MockDataService.mockPayslips.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final payslip = MockDataService.mockPayslips[index];
                  return Card(
                    color: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: ListTile(
                      title: Text(
                        payslip.payPeriod,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                      ),
                      subtitle: Text('Net Pay: ${payslip.currency} ${payslip.netSalary.toStringAsFixed(2)}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.visibility_outlined, size: 20, color: AppTheme.primaryBlue),
                            tooltip: 'View Details',
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                AppConstants.payslipDetailRoute,
                                arguments: {'year': payslip.year, 'month': payslip.month},
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.download_outlined, size: 20, color: AppTheme.primaryBlue),
                            tooltip: 'Download Payslip',
                            onPressed: () async {
                              try {
                                final detail = MockDataService.getMockPayslipDetail(payslip.year, payslip.month);
                                final file = await PdfGenerator.generatePayslipPdf(detail);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Payslip downloaded: ${file.path}')),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Failed to download payslip: $e')),
                                  );
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          else
            const Expanded(
              child: Center(
                child: Text('Select an employee to view payslips', style: TextStyle(color: AppTheme.textMuted)),
              ),
            ),
        ],
      ),
    );
  }
}
