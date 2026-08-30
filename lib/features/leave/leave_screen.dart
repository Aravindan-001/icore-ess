import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/dependency_injection.dart';
import '../../core/widgets/empty_state.dart';
import '../../models/leave.dart';

class LeaveScreen extends StatelessWidget {
  const LeaveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leave Management')),
      body: FutureBuilder(
        future: Future.wait([
          DependencyInjection.repository.getLeaveBalances(),
          DependencyInjection.repository.getLeaveRequests(),
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading leave data'));
          }

          final balances = snapshot.data![0] as List<LeaveBalance>;
          final requests = snapshot.data![1] as List<LeaveRequest>;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Leave Balance', style: Theme.of(context).textTheme.titleLarge),
                ),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: balances.length,
                  itemBuilder: (context, index) {
                    final balance = balances[index];
                    return Card(
                      child: ListTile(
                        title: Text(balance.type, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Used: ${balance.used} | Pending: ${balance.pending}'),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              balance.available.toInt().toString(),
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                            ),
                            const Text('Available'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Recent Requests', style: Theme.of(context).textTheme.titleLarge),
                      const Icon(Icons.history, color: AppTheme.textGrey),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                if (requests.isEmpty)
                  const EmptyState(title: 'No History', message: 'You haven\'t applied for any leave yet.')
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      final request = requests[index];
                      return Card(
                        child: ListTile(
                          leading: _buildStatusIcon(request.status),
                          title: Text(request.type),
                          subtitle: Text('${DateFormat('dd MMM').format(request.startDate)} - ${DateFormat('dd MMM yyyy').format(request.endDate)}'),
                          trailing: _buildStatusChip(request.status),
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AppConstants.leaveApplyRoute).then((_) {
          // Refresh could be handled here if using a state management solution
        }),
        label: const Text('Apply Leave'),
        icon: const Icon(Icons.add),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildStatusIcon(LeaveStatus status) {
    IconData icon;
    Color color;
    switch (status) {
      case LeaveStatus.approved:
        icon = Icons.check_circle;
        color = AppTheme.success;
        break;
      case LeaveStatus.rejected:
        icon = Icons.cancel;
        color = AppTheme.error;
        break;
      case LeaveStatus.pending:
        icon = Icons.pending;
        color = AppTheme.warning;
        break;
    }
    return Icon(icon, color: color, size: 32);
  }

  Widget _buildStatusChip(LeaveStatus status) {
    Color color;
    String label;
    switch (status) {
      case LeaveStatus.approved:
        color = AppTheme.success;
        label = 'Approved';
        break;
      case LeaveStatus.rejected:
        color = AppTheme.error;
        label = 'Rejected';
        break;
      case LeaveStatus.pending:
        color = AppTheme.warning;
        label = 'Pending';
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}
