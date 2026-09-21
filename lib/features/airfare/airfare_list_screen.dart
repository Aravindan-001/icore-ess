import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../models/airfare.dart';
import 'airfare_provider.dart';

class AirfareListScreen extends ConsumerWidget {
  const AirfareListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final declarationsAsync = ref.watch(airfareDeclarationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Airfare Declaration'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: declarationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Unable to load airfare declarations.'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(airfareDeclarationsProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (declarations) {
          if (declarations.isEmpty) {
            return const Center(child: Text('No airfare declarations found.'));
          }
          return RefreshIndicator(
            onRefresh: () => ref.refresh(airfareDeclarationsProvider.future),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: declarations.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final declaration = declarations[index];
                return _buildDeclarationItem(context, declaration);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildDeclarationItem(BuildContext context, AirfareDeclaration declaration) {
    final dateStr = declaration.travelDate != null
        ? DateFormat('dd MMMM yyyy').format(declaration.travelDate!)
        : declaration.travelYear;

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () => Navigator.pushNamed(
          context,
          AppConstants.airfareDetailRoute,
          arguments: declaration.id,
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
                      declaration.id,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textMuted,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${declaration.fromLocation} → ${declaration.toLocation}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textMain,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$dateStr • ${declaration.travelType}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textMuted,
                      ),
                    ),
                    if (declaration.amount != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Amount: ₹${declaration.amount!.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    _buildStatusChip(declaration.status),
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

  Widget _buildStatusChip(AirfareStatus status) {
    Color color;
    String label;
    switch (status) {
      case AirfareStatus.pending:
        color = AppTheme.warning;
        label = 'PENDING';
        break;
      case AirfareStatus.approved:
        color = AppTheme.success;
        label = 'APPROVED';
        break;
      case AirfareStatus.rejected:
        color = AppTheme.error;
        label = 'REJECTED';
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
        label,
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
