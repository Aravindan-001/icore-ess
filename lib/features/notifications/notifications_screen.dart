import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView.separated(
        itemCount: 5,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final titles = [
            'Leave Approved',
            'Payslip Available',
            'Reimbursement Paid',
            'Policy Update',
            'Holiday Reminder'
          ];
          final messages = [
            'Your leave request for 20th Jan has been approved.',
            'Your payslip for May 2024 is now available for download.',
            'Reimbursement of ₹1,500 has been processed.',
            'New insurance policy details have been uploaded.',
            'Coming up: Eid-ul-Adha holiday on 17th June.'
          ];
          
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: index < 2 ? AppTheme.primaryBlue.withValues(alpha: 0.1) : Colors.transparent,
              child: Icon(
                index < 2 ? Icons.notifications_active : Icons.notifications_none,
                color: index < 2 ? AppTheme.primaryBlue : AppTheme.textGrey,
              ),
            ),
            title: Text(titles[index], style: TextStyle(fontWeight: index < 2 ? FontWeight.bold : FontWeight.normal)),
            subtitle: Text(messages[index]),
            trailing: const Text('2h ago', style: TextStyle(fontSize: 10, color: AppTheme.textGrey)),
            onTap: () {},
          );
        },
      ),
    );
  }
}
