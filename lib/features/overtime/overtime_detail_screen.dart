import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../models/overtime.dart';
import 'overtime_provider.dart';

class OvertimeDetailScreen extends ConsumerWidget {
  final String requestId;

  const OvertimeDetailScreen({
    super.key,
    required this.requestId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestAsync = ref.watch(overtimeDetailProvider(requestId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Overtime Request'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: requestAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Unable to load request details.'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(overtimeDetailProvider(requestId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (request) => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoSection('Request ID', request.id),
              _buildInfoSection('Date', DateFormat('dd MMMM yyyy').format(request.date)),
              _buildInfoSection('Hours', '${request.hours} hours'),
              _buildInfoSection('Reason', request.reason),
              _buildStatusSection('Status', request.status),
              const Divider(height: 40),
              _buildInfoSection('Submitted Date', DateFormat('dd MMMM yyyy').format(request.submittedDate)),
              if (request.approvedBy != null) _buildInfoSection('Approved By', request.approvedBy!),
              if (request.approvalDate != null) _buildInfoSection('Approval Date', DateFormat('dd MMMM yyyy').format(request.approvalDate!)),
              if (request.remarks != null) _buildInfoSection('Remarks', request.remarks!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textMain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSection(String label, OvertimeStatus status) {
    Color color;
    switch (status) {
      case OvertimeStatus.pending:
        color = AppTheme.warning;
        break;
      case OvertimeStatus.approved:
        color = AppTheme.success;
        break;
      case OvertimeStatus.rejected:
        color = AppTheme.error;
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color.withValues(alpha: 0.2)),
            ),
            child: Text(
              status.name.toUpperCase(),
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
