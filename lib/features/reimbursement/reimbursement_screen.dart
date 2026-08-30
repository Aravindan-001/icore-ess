import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/custom_text_field.dart';

class ReimbursementScreen extends StatefulWidget {
  const ReimbursementScreen({super.key});

  @override
  State<ReimbursementScreen> createState() => _ReimbursementScreenState();
}

class _ReimbursementScreenState extends State<ReimbursementScreen> {
  void _showAddReimbursement() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('New Reimbursement', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),
            CustomTextField(
              controller: TextEditingController(),
              label: 'Expense Title',
              hint: 'e.g. Internet Bill',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: TextEditingController(),
              label: 'Amount',
              hint: 'Enter amount',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Reimbursement request submitted')),
                );
                Navigator.pop(context);
              },
              child: const Text('Submit Request'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reimbursements')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 3,
        itemBuilder: (context, index) {
          final titles = ['Internet Allowance', 'Travel Expenses', 'Office Supplies'];
          final amounts = ['₹1,500', '₹3,200', '₹800'];
          final dates = ['20 May 2024', '15 May 2024', '10 May 2024'];
          final statuses = ['Pending', 'Approved', 'Rejected'];
          
          return Card(
            child: ListTile(
              title: Text(titles[index], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(dates[index]),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(amounts[index], style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(statuses[index], style: TextStyle(color: _getStatusColor(statuses[index]), fontSize: 12)),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddReimbursement,
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Color _getStatusColor(String status) {
    if (status == 'Approved') return AppTheme.success;
    if (status == 'Rejected') return AppTheme.error;
    return AppTheme.warning;
  }
}
