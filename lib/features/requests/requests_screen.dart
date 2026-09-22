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
    final currentStatusFilter = ref.watch(requestFilterProvider);
    final currentCategoryFilter = ref.watch(requestCategoryFilterProvider);

    return Scaffold(
      backgroundColor: AppTheme.surfaceContainer,
      appBar: AppBar(
        title: const Text('Requests'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildMetricsSummary(ref),
          _buildFilterBar(ref, currentStatusFilter, currentCategoryFilter),
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

  Widget _buildMetricsSummary(WidgetRef ref) {
    final summary = ref.watch(requestSummaryProvider);
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Expanded(child: _buildMetricTile('Pending', summary.pending, AppTheme.warning, Icons.pending_actions_outlined)),
          const SizedBox(width: 8),
          Expanded(child: _buildMetricTile('Approved', summary.approved, AppTheme.success, Icons.check_circle_outline)),
          const SizedBox(width: 8),
          Expanded(child: _buildMetricTile('Rejected', summary.rejected, AppTheme.error, Icons.error_outline)),
        ],
      ),
    );
  }

  Widget _buildMetricTile(String label, int count, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            count.toString(),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: color),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color.withValues(alpha: 0.7)),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(WidgetRef ref, RequestFilter currentStatus, RequestModule? currentCategory) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppTheme.outline, width: 0.5)),
      ),
      child: Column(
        children: [
          // Status Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: RequestFilter.values.map((filter) {
                final isSelected = currentStatus == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(_capitalize(filter.name)),
                    selected: isSelected,
                    onSelected: (_) => ref.read(requestFilterProvider.notifier).state = filter,
                    selectedColor: AppTheme.primaryBlue.withValues(alpha: 0.1),
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? AppTheme.primaryBlue : AppTheme.textMuted,
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          // Category Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              children: [
                _buildCategoryChip(ref, 'All Categories', null, currentCategory == null),
                ...RequestModule.values.map((module) => 
                  _buildCategoryChip(ref, _capitalize(module.name), module, currentCategory == module)
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(WidgetRef ref, String label, RequestModule? module, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => ref.read(requestCategoryFilterProvider.notifier).state = module,
        showCheckmark: false,
        backgroundColor: Colors.white,
        selectedColor: AppTheme.primaryBlue,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppTheme.textMuted,
          fontSize: 11,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: isSelected ? AppTheme.primaryBlue : AppTheme.outline),
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
    final statusIcon = _getStatusIcon(request.status);
    
    return Semantics(
      container: true,
      label: '${request.type} request with status ${request.status}. Description: ${request.description}. ID: ${request.id}.',
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: InkWell(
          onTap: () => _handleRequestTap(context, request),
          borderRadius: BorderRadius.circular(16),
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
                    _buildStatusChip(request.status, statusColor, statusIcon),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  request.description,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textMain,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'ID: ${request.id}',
                  style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(height: 1),
                ),
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
      ),
    );
  }

  Widget _buildStatusChip(String status, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            status.toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
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
      case 'submitted':
        return AppTheme.warning;
      case 'rejected':
        return AppTheme.error;
      default:
        return AppTheme.textMuted;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Icons.check_circle_outlined;
      case 'pending':
      case 'submitted':
        return Icons.hourglass_empty_outlined;
      case 'rejected':
        return Icons.cancel_outlined;
      default:
        return Icons.info_outline;
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
