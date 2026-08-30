import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/service_card.dart';
import '../../core/utils/dependency_injection.dart';
import '../../models/employee.dart';
import '../../models/leave.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('iCore ESS'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () => Navigator.pushNamed(context, AppConstants.profileRoute),
          ),
        ],
      ),
      body: FutureBuilder(
        future: Future.wait([
          DependencyInjection.repository.getEmployeeProfile(),
          DependencyInjection.repository.getLeaveBalances(),
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading dashboard data'));
          }

          final employee = snapshot.data![0] as Employee;
          final leaveBalances = snapshot.data![1] as List<LeaveBalance>;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header / Greeting
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryBlue,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundImage: employee.profileImageUrl.isNotEmpty ? NetworkImage(employee.profileImageUrl) : null,
                        child: employee.profileImageUrl.isEmpty ? const Icon(Icons.person, size: 35) : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome,',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                            ),
                            Text(
                              employee.name,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppTheme.white),
                            ),
                            Text(
                              '${employee.designation} • ${employee.id}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white60),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Leave Summary
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Leave Summary', style: Theme.of(context).textTheme.titleLarge),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, AppConstants.leaveRoute),
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 140,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    scrollDirection: Axis.horizontal,
                    itemCount: leaveBalances.length,
                    itemBuilder: (context, index) {
                      final balance = leaveBalances[index];
                      return Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: Colors.grey.shade200),
                        ),
                        child: Container(
                          width: 140,
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(balance.type, style: Theme.of(context).textTheme.labelLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
                              const Spacer(),
                              Text(
                                balance.available.toInt().toString(),
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(color: AppTheme.primaryBlue, fontWeight: FontWeight.bold),
                              ),
                              Text('Available Days', style: Theme.of(context).textTheme.bodySmall),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Quick Services
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Services', style: Theme.of(context).textTheme.titleLarge),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                    children: [
                      ServiceCard(
                        title: 'Leave',
                        icon: Icons.calendar_today,
                        onTap: () => Navigator.pushNamed(context, AppConstants.leaveRoute),
                      ),
                      ServiceCard(
                        title: 'Payslip',
                        icon: Icons.receipt_long,
                        onTap: () => Navigator.pushNamed(context, AppConstants.payslipRoute),
                      ),
                      ServiceCard(
                        title: 'Pay Summary',
                        icon: Icons.summarize,
                        onTap: () => Navigator.pushNamed(context, AppConstants.paySummaryRoute),
                      ),
                      ServiceCard(
                        title: 'Claims',
                        icon: Icons.request_quote,
                        onTap: () => Navigator.pushNamed(context, AppConstants.claimsRoute),
                      ),
                      ServiceCard(
                        title: 'Reimburse',
                        icon: Icons.payments,
                        onTap: () => Navigator.pushNamed(context, AppConstants.reimbursementRoute),
                      ),
                      ServiceCard(
                        title: 'Orders',
                        icon: Icons.shopping_bag,
                        onTap: () => Navigator.pushNamed(context, AppConstants.preOrderRoute),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}
