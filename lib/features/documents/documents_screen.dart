import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';

class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> mockDocs = [
      {
        'name': 'Payslip - January 2025',
        'type': 'Payslip',
        'date': '31-Jan-2025',
        'year': '2025',
        'month': 'January',
      },
      {
        'name': 'Employment Contract',
        'type': 'Contract',
        'date': '01-Mar-2024',
      },
      {
        'name': 'Salary Certificate',
        'type': 'Certificate',
        'date': '10-Feb-2025',
      },
      {'name': 'Passport Copy', 'type': 'Identity ID', 'date': '01-Mar-2024'},
      {'name': 'Visa Page', 'type': 'Immigration', 'date': '05-Mar-2024'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'My Documents',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: mockDocs.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final doc = mockDocs[index];
          final isPayslip = doc['type'] == 'Payslip';

          return Card(
            color: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      isPayslip ? Icons.receipt_long : Icons.description,
                      color: AppTheme.primaryBlue,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doc['name']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: AppTheme.textMain,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Type: ${doc['type']} • Uploaded: ${doc['date']}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.visibility,
                          color: AppTheme.primaryBlue,
                          size: 20,
                        ),
                        tooltip: 'View Document',
                        onPressed: () {
                          if (isPayslip && doc['year'] != null && doc['month'] != null) {
                            Navigator.pushNamed(
                              context,
                              AppConstants.payslipDetailRoute,
                              arguments: {'year': doc['year']!, 'month': doc['month']!},
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Viewing ${doc['name']}...'),
                              ),
                            );
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.download,
                          color: AppTheme.success,
                          size: 20,
                        ),
                        tooltip: 'Download Document',
                        onPressed: () {
                          if (isPayslip && doc['year'] != null && doc['month'] != null) {
                            Navigator.pushNamed(
                              context,
                              AppConstants.payslipDetailRoute,
                              arguments: {'year': doc['year']!, 'month': doc['month']!},
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${doc['name']} downloaded successfully!',
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
