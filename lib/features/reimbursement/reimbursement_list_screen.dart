import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../models/reimbursement_models.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/providers/injection_providers.dart';
import 'reimbursement_providers.dart';

class ReimbursementListScreen extends ConsumerWidget {
  const ReimbursementListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listAsync = ref.watch(reimbursementListProvider);
    final filteredItems = ref.watch(filteredReimbursementsProvider);
    final summary = ref.watch(reimbursementSummaryProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Reimbursements', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              final _ = ref.refresh(reimbursementListProvider);
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterBottomSheet(context, ref),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/reimbursement/form', arguments: null).then((_) {
            final _ = ref.refresh(reimbursementListProvider);
          });
        },
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Create'),
      ),
      body: Column(
        children: [
          // Aggregate Summary Section Dashboard
          _buildSummaryDashboard(summary),
          
          // Search Control Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: (val) => ref.read(reimbursementFilterProvider.notifier).setSearchQuery(val),
              decoration: InputDecoration(
                hintText: 'Search by Doc #, notes or line details...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
              ),
            ),
          ),

          // Main data list handler
          Expanded(
            child: listAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 12),
                      Text('Error: $err', textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          final _ = ref.refresh(reimbursementListProvider);
                        },
                        child: const Text('Retry'),
                      )
                    ],
                  ),
                ),
              ),
              data: (_) {
                if (filteredItems.isEmpty) {
                  return const EmptyState(
                    title: 'No Reimbursements',
                    message: 'No reimbursement requests found.',
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    final _ = ref.refresh(reimbursementListProvider);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, idx) {
                      final item = filteredItems[idx];
                      return _buildRequestCard(context, ref, item);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryDashboard(ReimbursementSummary summary) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Reimbursement Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppTheme.primaryBlue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                child: Text('Count: ${summary.totalRequests}', style: const TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.bold, fontSize: 13)),
              )
            ],
          ),
          const Divider(height: 24),
          Row(
            children: [
              _buildSummaryMetric('Bill Amt', summary.totalBillAmount, Colors.blueGrey),
              _buildSummaryMetric('Claim Amt', summary.totalClaimAmount, AppTheme.primaryBlue),
              _buildSummaryMetric('Reimbursed', summary.totalReimbursedAmount, AppTheme.success),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryMetric(String title, double value, Color color) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            '₹${value.toStringAsFixed(2)}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: color),
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }

  Widget _buildRequestCard(BuildContext context, WidgetRef ref, ReimbursementRequest item) {
    Color badgeColor = Colors.grey;
    if (item.status == ReimbursementStatus.approved || item.status == ReimbursementStatus.paid) {
      badgeColor = AppTheme.success;
    } else if (item.status == ReimbursementStatus.submitted) {
      badgeColor = Colors.amber.shade700;
    } else if (item.status == ReimbursementStatus.rejected) {
      badgeColor = Colors.red;
    }

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.pushNamed(context, '/reimbursement/form', arguments: item).then((_) {
            final _ = ref.refresh(reimbursementListProvider);
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item.documentNumber, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryBlue)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: badgeColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                    child: Text(item.status.displayName, style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold, fontSize: 12)),
                  )
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Type: ${item.documentType.displayName}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  Text(DateFormat('dd/MM/yyyy').format(item.date), style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                ],
              ),
              if (item.notes.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(item.notes, style: TextStyle(color: Colors.grey.shade600, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Bill Amt', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                      Text('₹${item.totalBillAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Claim Amt', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                      Text('₹${item.totalClaimAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Reimbursed', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                      Text('₹${item.totalReimbursedAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.success)),
                    ],
                  ),
                ],
              ),
              if (item.status == ReimbursementStatus.submitted) ...[
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    ),
                    onPressed: () => _confirmCancel(context, ref, item.documentNumber),
                    icon: const Icon(Icons.cancel, size: 16),
                    label: const Text('Cancel Request', style: TextStyle(fontSize: 12)),
                  ),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }

  void _confirmCancel(BuildContext context, WidgetRef ref, String docNum) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Request'),
        content: const Text('Are you sure you want to cancel this submitted reimbursement request?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('No')),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await ref.read(expenseServiceProvider).cancelReimbursementRequest(docNum);
              if (success) {
                final _ = ref.refresh(reimbursementListProvider);
              }
            },
            child: const Text('Yes, Cancel', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Consumer(
          builder: (context, refWatch, _) {
            final currentFilter = refWatch.watch(reimbursementFilterProvider);
            return Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Sort By', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        _buildChoiceChip(ref, 'Newest First', currentFilter.sortOption == 'newest', () => ref.read(reimbursementFilterProvider.notifier).setSortOption('newest')),
                        _buildChoiceChip(ref, 'Oldest First', currentFilter.sortOption == 'oldest', () => ref.read(reimbursementFilterProvider.notifier).setSortOption('oldest')),
                        _buildChoiceChip(ref, 'Highest Amount', currentFilter.sortOption == 'highest', () => ref.read(reimbursementFilterProvider.notifier).setSortOption('highest')),
                        _buildChoiceChip(ref, 'Lowest Amount', currentFilter.sortOption == 'lowest', () => ref.read(reimbursementFilterProvider.notifier).setSortOption('lowest')),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('Status Filter', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: ReimbursementStatus.values.map((status) {
                        return _buildChoiceChip(
                          ref,
                          status.displayName,
                          currentFilter.statusFilter == status,
                          () => ref.read(reimbursementFilterProvider.notifier).setStatusFilter(status),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryBlue, foregroundColor: Colors.white),
                        onPressed: () {
                          ref.read(reimbursementFilterProvider.notifier).reset();
                          Navigator.pop(ctx);
                        },
                        child: const Text('Reset All Filters'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildChoiceChip(WidgetRef ref, String label, bool selected, VoidCallback onTap) {
    return ChoiceChip(
      label: Text(label, style: TextStyle(color: selected ? AppTheme.primaryBlue : Colors.black87, fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: AppTheme.primaryBlue.withValues(alpha: 0.2),
    );
  }
}
