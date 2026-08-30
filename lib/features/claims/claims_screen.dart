import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/custom_text_field.dart';

class ClaimsScreen extends StatefulWidget {
  const ClaimsScreen({super.key});

  @override
  State<ClaimsScreen> createState() => _ClaimsScreenState();
}

class _ClaimsScreenState extends State<ClaimsScreen> {
  void _showCreateClaim() {
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
            Text('Create Medical Claim', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),
            CustomTextField(
              controller: TextEditingController(),
              label: 'Claim Description',
              hint: 'e.g. Dental checkup',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: TextEditingController(),
              label: 'Amount',
              hint: 'Enter claim amount',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Medical claim submitted successfully')),
                );
                Navigator.pop(context);
              },
              child: const Text('Submit Claim'),
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
      appBar: AppBar(title: const Text('Medical Claims')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 2,
        itemBuilder: (context, index) {
          final titles = ['Health Checkup', 'Dental Treatment'];
          final amounts = ['₹5,000', '₹2,500'];
          final statuses = ['Approved', 'Pending'];
          
          return Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.medical_services)),
              title: Text(titles[index], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Policy: HDFC ERGO'),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(amounts[index], style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(statuses[index], style: TextStyle(color: statuses[index] == 'Approved' ? AppTheme.success : AppTheme.warning, fontSize: 12)),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateClaim,
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
