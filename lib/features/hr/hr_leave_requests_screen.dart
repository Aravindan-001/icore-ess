import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class HrLeaveRequestsScreen extends StatefulWidget {
  const HrLeaveRequestsScreen({super.key});

  @override
  State<HrLeaveRequestsScreen> createState() => _HrLeaveRequestsScreenState();
}

class _HrLeaveRequestsScreenState extends State<HrLeaveRequestsScreen> {
  final List<Map<String, dynamic>> _mockRequests = [
    {
      'employee': 'ANITHA K',
      'id': '20140',
      'type': 'Annual Leave',
      'fromDate': '08/09/2026',
      'toDate': '17/09/2026',
      'status': 'Pending',
    },
    {
      'employee': 'RAHUL K',
      'id': '10032',
      'type': 'Sick Leave',
      'fromDate': '10/10/2026',
      'toDate': '11/10/2026',
      'status': 'Pending',
    },
  ];

  void _updateStatus(int index, String status) {
    setState(() {
      _mockRequests[index]['status'] = status;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Request $status'), backgroundColor: status == 'Approved' ? AppTheme.success : AppTheme.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Leave Management', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _mockRequests.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final req = _mockRequests[index];
          final isPending = req['status'] == 'Pending';
          
          return Card(
            color: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        req['employee'],
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(req['status']).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          req['status'],
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _getStatusColor(req['status'])),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('ID: ${req['id']} • ${req['type']}', style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Divider(height: 1),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.calendar_month, size: 14, color: AppTheme.textMuted),
                      const SizedBox(width: 4),
                      Text('${req['fromDate']} to ${req['toDate']}', style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                  if (isPending) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _updateStatus(index, 'Rejected'),
                            style: OutlinedButton.styleFrom(foregroundColor: AppTheme.error, side: const BorderSide(color: AppTheme.error)),
                            child: const Text('Reject'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _updateStatus(index, 'Approved'),
                            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.success, foregroundColor: Colors.white, elevation: 0),
                            child: const Text('Approve'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Approved': return AppTheme.success;
      case 'Rejected': return AppTheme.error;
      default: return Colors.orange;
    }
  }
}
