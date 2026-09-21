import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../models/overtime.dart';
import 'overtime_provider.dart';

class OvertimeListScreen extends ConsumerWidget {
  const OvertimeListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(overtimeRequestsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Overtime'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: requestsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Unable to load overtime requests.'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(overtimeRequestsProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (requests) {
          if (requests.isEmpty) {
            return const Center(child: Text('No overtime requests found.'));
          }
          return RefreshIndicator(
            onRefresh: () => ref.refresh(overtimeRequestsProvider.future),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: requests.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final request = requests[index];
                return _buildRequestItem(context, request);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildRequestItem(BuildContext context, OvertimeRequest request) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () => Navigator.pushNamed(
          context,
          AppConstants.overtimeDetailRoute,
          arguments: request.id,
        ),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.id,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textMuted,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('dd MMMM yyyy').format(request.date),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textMain,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${request.hours} hours • ${request.reason}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textMuted,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildStatusChip(request.status),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppTheme.textMuted),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(OvertimeStatus status) {
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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
