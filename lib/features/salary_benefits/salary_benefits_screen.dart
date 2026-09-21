import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/service_card.dart';

class SalaryBenefitsScreen extends StatelessWidget {
  const SalaryBenefitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Salary & Benefits'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
        children: [
          ServiceCard(
            title: 'Payslips',
            icon: Icons.receipt_long,
            onTap: () => Navigator.pushNamed(context, AppConstants.payslipRoute),
          ),
          ServiceCard(
            title: 'Pay Summary',
            icon: Icons.summarize,
            onTap: () => Navigator.pushNamed(context, AppConstants.paySummaryRoute),
          ),
          ServiceCard(
            title: 'Overtime',
            icon: Icons.more_time,
            onTap: () => Navigator.pushNamed(context, AppConstants.overtimeRoute),
          ),
          ServiceCard(
            title: 'Reimburse',
            icon: Icons.payments,
            onTap: () => Navigator.pushNamed(context, AppConstants.reimbursementRoute),
          ),
          ServiceCard(
            title: 'Airfare Declaration',
            icon: Icons.flight,
            onTap: () => Navigator.pushNamed(context, AppConstants.airfareRoute),
          ),
          ServiceCard(
            title: 'Education Declaration',
            icon: Icons.school,
            onTap: () => Navigator.pushNamed(context, AppConstants.educationDeclarationRoute),
          ),
        ],
      ),
    );
  }
}
