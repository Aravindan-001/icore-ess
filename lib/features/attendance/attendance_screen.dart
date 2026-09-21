import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/injection_providers.dart';
import '../../models/attendance.dart';
import '../../services/location_service.dart';
import 'attendance_provider.dart';

final attendanceFilterProvider = StateProvider<int>((ref) => 0);

class AttendanceScreen extends ConsumerWidget {
  const AttendanceScreen({super.key});

  Future<void> _refreshData(WidgetRef ref) async {
    ref.invalidate(todayAttendanceProvider);
    ref.invalidate(attendanceLocationProvider);
    ref.invalidate(attendanceHistoryProvider);
    await Future.wait([
      ref.read(todayAttendanceProvider.future),
      ref.read(attendanceLocationProvider.future),
      ref.read(attendanceHistoryProvider.future),
    ]);
  }

  String _calculateWorkingDuration(AttendanceRecord record) {
    if (record.checkInTime == null) return '--';
    final end = record.checkOutTime ?? DateTime.now();
    final diff = end.difference(record.checkInTime!);
    if (diff.isNegative) return '00h 00m';
    final hours = diff.inHours.toString().padLeft(2, '0');
    final minutes = (diff.inMinutes % 60).toString().padLeft(2, '0');
    return '${hours}h ${minutes}m';
  }

  List<AttendanceRecord> _filterHistory(List<AttendanceRecord> history, int filterIndex) {
    final now = DateTime.now();
    if (filterIndex == 1) {
      return history.where((r) => r.date.month == now.month && r.date.year == now.year).toList();
    } else if (filterIndex == 2) {
      final prevMonthDate = DateTime(now.year, now.month - 1, 1);
      return history.where((r) => r.date.month == prevMonthDate.month && r.date.year == prevMonthDate.year).toList();
    }
    return history;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendanceAsync = ref.watch(todayAttendanceProvider);
    final locationAsync = ref.watch(attendanceLocationProvider);
    final historyAsync = ref.watch(attendanceHistoryProvider);
    final actionState = ref.watch(attendanceActionProvider);
    final filterIndex = ref.watch(attendanceFilterProvider);

    // Listen for success or error messages to show snackbars
    ref.listen(attendanceActionProvider, (previous, next) {
      if (next.successMessage != null) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.successMessage!), backgroundColor: AppTheme.success),
        );
        ref.read(analyticsServiceProvider).logEvent('attendance_marked');
        ref.read(attendanceActionProvider.notifier).clearStatus();
      } else if (next.error != null) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!), backgroundColor: AppTheme.error),
        );
        ref.read(attendanceActionProvider.notifier).clearStatus();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _refreshData(ref),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshData(ref),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppConstants.spacingXl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Today\'s Attendance',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryBlue,
                ),
              ),
              Text(
                DateFormat('EEEE, dd MMMM yyyy').format(DateTime.now()),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.textGrey),
              ),
              const SizedBox(height: AppConstants.spacing2Xl),
              
              attendanceAsync.when(
                skipLoadingOnRefresh: false,
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (err, stack) => _buildErrorCard('Unable to load attendance record.', () => ref.refresh(todayAttendanceProvider)),
                data: (record) => _buildStatusCard(context, record),
              ),
              
              const SizedBox(height: AppConstants.spacing2Xl),
              
              locationAsync.when(
                skipLoadingOnRefresh: false,
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                error: (err, stack) => _buildErrorCard('Unable to verify location.', () => ref.refresh(attendanceLocationProvider)),
                data: (location) => _buildLocationCard(context, location, ref),
              ),
              
              const SizedBox(height: AppConstants.spacing4Xl),
              
              _buildActionButtons(context, ref, attendanceAsync.value, locationAsync.value, actionState),
              
              const SizedBox(height: AppConstants.spacing4Xl),
              
              // History Section Title & Filtering Tabs
              Text(
                'Attendance History',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textMain,
                ),
              ),
              const SizedBox(height: AppConstants.spacingLg),
              
              // Custom lightweight segmented filters
              Row(
                children: [
                  _buildFilterChip(ref, 0, 'All', filterIndex),
                  const SizedBox(width: AppConstants.spacingSm),
                  _buildFilterChip(ref, 1, 'Current Month', filterIndex),
                  const SizedBox(width: AppConstants.spacingSm),
                  _buildFilterChip(ref, 2, 'Previous Month', filterIndex),
                ],
              ),
              const SizedBox(height: AppConstants.spacingLg),
              
              historyAsync.when(
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                error: (err, stack) => _buildErrorCard('Unable to load attendance history.', () => ref.refresh(attendanceHistoryProvider)),
                data: (historyList) {
                  final filteredList = _filterHistory(historyList, filterIndex);
                  if (filteredList.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 30),
                        child: Text(
                          'No attendance history records found.',
                          style: TextStyle(color: AppTheme.textMuted),
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: [
                      for (final item in filteredList) ...[
                        _buildHistoryItem(context, item),
                        const SizedBox(height: AppConstants.spacingMd),
                      ]
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(WidgetRef ref, int index, String label, int currentSelection) {
    final isSelected = currentSelection == index;
    return GestureDetector(
      onTap: () {
        ref.read(attendanceFilterProvider.notifier).state = index;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLg, vertical: AppConstants.spacingSm),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryBlue : AppTheme.surfaceContainer,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppTheme.primaryBlue : AppTheme.outline),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textMain,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context, AttendanceRecord record) {
    final status = record.status;

    String statusText;
    IconData statusIcon;
    Color statusColor;

    switch (status) {
      case AttendanceStatus.notMarked:
        statusText = 'Not Marked';
        statusIcon = Icons.radio_button_unchecked;
        statusColor = AppTheme.textGrey;
        break;
      case AttendanceStatus.checkedIn:
        statusText = 'Checked In';
        statusIcon = Icons.login;
        statusColor = AppTheme.accentBlue;
        break;
      case AttendanceStatus.checkedOut:
        statusText = 'Completed';
        statusIcon = Icons.check_circle;
        statusColor = AppTheme.success;
        break;
    }

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacing2Xl),
        child: Column(
          children: [
            Icon(statusIcon, color: statusColor, size: 64),
            const SizedBox(height: AppConstants.spacingLg),
            Text(
              statusText,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
            ),
            const SizedBox(height: AppConstants.spacingMd),
            Text(
              'Working Hours: ${_calculateWorkingDuration(record)}',
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textMain, fontSize: 14),
            ),
            const SizedBox(height: AppConstants.spacing2Xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTimeColumn(context, 'Check In', record.checkInTime),
                _buildTimeColumn(context, 'Check Out', record.checkOutTime),
              ],
            ),
            if (status == AttendanceStatus.checkedOut) ...[
              const SizedBox(height: AppConstants.spacing2Xl),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLg, vertical: AppConstants.spacingSm),
                decoration: BoxDecoration(
                  color: AppTheme.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Today's attendance is complete.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppTheme.success, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTimeColumn(BuildContext context, String label, DateTime? time) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppTheme.textGrey)),
        const SizedBox(height: AppConstants.spacingXs),
        Text(
          time != null ? DateFormat('hh:mm a').format(time) : '--:--',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildLocationCard(BuildContext context, LocationResult location, WidgetRef ref) {
    if (location.errorMessage != null) {
      return _buildErrorLocationCard(context, location, ref);
    }

    final within = location.isWithinGeofence;
    final distance = location.distanceFromOffice;
    final accuracy = location.accuracy;
    final poorAccuracy = accuracy > AppConstants.maxAllowedAccuracyInMeters / 2;

    final statusColor = within ? Colors.green : Colors.orange;
    final backgroundColor = statusColor.withValues(alpha: 0.05);
    final borderColor = statusColor.withValues(alpha: 0.2);

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingXl),
        child: Row(
          children: [
            Icon(
              within ? Icons.location_on : Icons.location_off,
              color: statusColor,
              size: 32,
            ),
            const SizedBox(width: AppConstants.spacingLg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    within ? 'Office Location Verified' : 'Outside Office Area',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Distance: ${distance.toStringAsFixed(1)} m',
                    style: TextStyle(color: statusColor.withValues(alpha: 0.8), fontSize: 13),
                  ),
                  Text(
                    'Accuracy: ${accuracy.toStringAsFixed(1)} m',
                    style: TextStyle(
                      fontSize: 13,
                      color: poorAccuracy ? AppTheme.error : statusColor.withValues(alpha: 0.8),
                      fontWeight: poorAccuracy ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  if (poorAccuracy)
                    const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        'Poor GPS accuracy. Move to an open area.',
                        style: TextStyle(fontSize: 11, color: AppTheme.error, fontStyle: FontStyle.italic),
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    within ? "You are within the allowed radius." : 'You must be within 50m of office coordinates.',
                    style: TextStyle(fontSize: 12, color: statusColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorLocationCard(BuildContext context, LocationResult location, WidgetRef ref) {
    IconData icon = Icons.error_outline;
    String title = 'Location Error';
    String message = location.errorMessage ?? 'Unknown error';
    Widget? action;

    if (location.isLocationServiceDisabled) {
      icon = Icons.location_disabled;
      title = 'GPS Disabled';
      message = 'Location services are turned off. Please enable GPS to mark attendance.';
    } else if (location.isPermissionDenied) {
      icon = Icons.security;
      title = 'Permission Required';
      message = 'Location permission is required to mark attendance.';
      action = TextButton(
        onPressed: () => ref.refresh(attendanceLocationProvider),
        child: const Text('Allow Access'),
      );
    } else if (location.isPermissionDeniedForever) {
      icon = Icons.settings;
      title = 'Permission Denied';
      message = 'Location permission is permanently denied. Please enable it from Settings.';
      action = TextButton(
        onPressed: () => ref.read(locationServiceProvider).openLocationSettings(),
        child: const Text('Open Settings'),
      );
    }

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: AppTheme.error.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppTheme.error, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingXl),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: AppTheme.error, size: 32),
                const SizedBox(width: AppConstants.spacingLg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.error)),
                      Text(message, style: TextStyle(color: AppTheme.error.withValues(alpha: 0.8), fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
            if (action != null) ...[
              const SizedBox(height: AppConstants.spacingSm),
              action,
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard(String message, VoidCallback onRetry) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: AppTheme.error, size: 40),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context, 
    WidgetRef ref,
    AttendanceRecord? record, 
    LocationResult? location, 
    AttendanceActionState actionState
  ) {
    if (record == null) return const SizedBox.shrink();
    
    final status = record.status;
    if (status == AttendanceStatus.checkedOut) {
      return const SizedBox.shrink();
    }

    final isProcessing = actionState.isProcessing;
    final within = location?.isWithinGeofence ?? false;
    final canAction = within && !isProcessing;

    return Column(
      children: [
        if (status == AttendanceStatus.notMarked)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: canAction ? () => ref.read(attendanceActionProvider.notifier).checkIn() : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: isProcessing
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('CHECK IN'),
            ),
          ),
        if (status == AttendanceStatus.checkedIn)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: canAction ? () => ref.read(attendanceActionProvider.notifier).checkOut() : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentBlue,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: isProcessing
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('CHECK OUT'),
            ),
          ),
        const SizedBox(height: 16),
        if (!within && location != null && location.errorMessage == null)
          Text(
            'Move within 50m of office to mark attendance.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.warning, fontWeight: FontWeight.w600, fontSize: 13),
          ),
      ],
    );
  }

  Widget _buildHistoryItem(BuildContext context, AttendanceRecord item) {
    String timeStr = '--';
    if (item.checkInTime != null) {
      final startStr = DateFormat('hh:mm a').format(item.checkInTime!);
      if (item.checkOutTime != null) {
        final endStr = DateFormat('hh:mm a').format(item.checkOutTime!);
        timeStr = '$startStr - $endStr';
      } else {
        timeStr = '$startStr - Present';
      }
    }

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.outline),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('dd MMM yyyy').format(item.date),
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textMain),
              ),
              const SizedBox(height: 4),
              Text(
                timeStr,
                style: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Present',
                  style: TextStyle(color: AppTheme.success, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _calculateWorkingDuration(item),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.textMain),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
