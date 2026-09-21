import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../models/unified_request.dart';
import 'requests_provider.dart';

class RequestsScreen extends ConsumerWidget {
  const RequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(filteredRequestsProvider);
    final currentFilter = ref.watch(requestFilterProvider);

    return Scaffold(
      backgroundColor: AppTheme.surfaceContainer,
      appBar: AppBar(
        title: const Text('My Requests'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildFilterBar(ref, currentFilter),
          Expanded(
            child: requestsAsync.when(
              data: (requests) => _buildRequestList(context, ref, requests),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => _buildErrorState(ref, err),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(WidgetRef ref, RequestFilter currentFilter) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppTheme.outline, width: 0.5)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: RequestFilter.values.map((filter) {
            final isSelected = currentFilter == filter;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(_capitalize(filter.name)),
                selected: isSelected,
                onSelected: (_) => ref.read(requestFilterProvider.notifier).state = filter,
                backgroundColor: Colors.white,
                selectedColor: AppTheme.primaryBlue.withValues(alpha: 0.1),
                checkmarkColor: AppTheme.primaryBlue,
                labelStyle: TextStyle(
                  color: isSelected ? AppTheme.primaryBlue : AppTheme.textMuted,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected ? AppTheme.primaryBlue : AppTheme.outline,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildRequestList(BuildContext context, WidgetRef ref, List<UnifiedRequest> requests) {
    if (requests.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => ref.refresh(allRequestsProvider.future),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_late_outlined, size: 64, color: AppTheme.textMuted),
                  SizedBox(height: 16),
                  Text('No requests found', style: TextStyle(color: AppTheme.textMuted, fontSize: 16)),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.refresh(allRequestsProvider.future),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: requests.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final request = requests[index];
          return _buildRequestCard(context, request);
        },
      ),
    );
  }

  Widget _buildRequestCard(BuildContext context, UnifiedRequest request) {
    final statusColor = _getStatusColor(request.status);
    
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () => _handleRequestTap(context, request),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      request.type.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryBlue,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  _buildStatusChip(request.status, statusColor),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                request.description,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textMain,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'ID: ${request.id}',
                style: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildIconText(Icons.calendar_today_outlined, 
                    DateFormat('dd MMM yyyy').format(request.submittedDate)),
                  if (request.lastUpdated != null)
                    _buildIconText(Icons.update, 
                      'Updated: ${DateFormat('dd MMM').format(request.lastUpdated!)}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildIconText(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppTheme.textMuted),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
      ],
    );
  }

  Widget _buildErrorState(WidgetRef ref, Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppTheme.error),
          const SizedBox(height: 16),
          const Text('Failed to load requests'),
          TextButton(
            onPressed: () => ref.refresh(allRequestsProvider),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return AppTheme.success;
      case 'pending':
        return AppTheme.warning;
      case 'rejected':
        return AppTheme.error;
      default:
        return AppTheme.textMuted;
    }
  }

  void _handleRequestTap(BuildContext context, UnifiedRequest request) {
    switch (request.module) {
      case RequestModule.leave:
        Navigator.pushNamed(context, AppConstants.leaveRoute);
        break;
      case RequestModule.overtime:
        Navigator.pushNamed(context, AppConstants.overtimeDetailRoute, arguments: request.id);
        break;
      case RequestModule.airfare:
        Navigator.pushNamed(context, AppConstants.airfareDetailRoute, arguments: request.id);
        break;
      case RequestModule.education:
        Navigator.pushNamed(context, AppConstants.educationDeclarationDetailRoute, arguments: request.id);
        break;
      case RequestModule.profile:
        Navigator.pushNamed(context, AppConstants.profileRequestsRoute);
        break;
      case RequestModule.medicalClaim:
      case RequestModule.reimbursement:
        _showLightweightDetail(context, request);
        break;
    }
  }

  void _showLightweightDetail(BuildContext context, UnifiedRequest request) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  request.type,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Request ID', request.id),
            _buildDetailRow('Status', request.status),
            _buildDetailRow('Submitted Date', DateFormat('dd MMMM yyyy').format(request.submittedDate)),
            const SizedBox(height: 16),
            const Text('Description', style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
            const SizedBox(height: 4),
            Text(request.description, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppTheme.textMuted)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  String _capitalize(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}
