import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/dependency_injection.dart';
import '../../models/attendance.dart';
import '../../services/location_service.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  AttendanceRecord? _attendance;
  LocationResult? _locationResult;
  bool _isLoading = true;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final attendance = await DependencyInjection.attendanceService.getTodayAttendance();
      final location = await DependencyInjection.attendanceService.getCurrentLocation();

      if (mounted) {
        setState(() {
          _attendance = attendance;
          _locationResult = location;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
        );
      }
    }
  }

  Future<void> _handleCheckIn() async {
    setState(() => _isProcessing = true);
    try {
      final success = await DependencyInjection.attendanceService.checkIn();
      if (success) {
        await _refreshData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Checked in successfully!'), backgroundColor: AppTheme.success),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        String message = e.toString();
        if (message.startsWith('Exception: ')) {
          message = message.replaceFirst('Exception: ', '');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _handleCheckOut() async {
    setState(() => _isProcessing = true);
    try {
      final success = await DependencyInjection.attendanceService.checkOut();
      if (success) {
        await _refreshData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Checked out successfully!'), backgroundColor: AppTheme.success),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        String message = e.toString();
        if (message.startsWith('Exception: ')) {
          message = message.replaceFirst('Exception: ', '');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _refreshData,
            tooltip: 'Refresh Location',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.spacingXl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('EEEE, dd MMMM yyyy').format(DateTime.now()),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.textGrey),
                  ),
                  const SizedBox(height: AppConstants.spacing2Xl),
                  _buildStatusCard(),
                  const SizedBox(height: AppConstants.spacing2Xl),
                  _buildLocationCard(),
                  const SizedBox(height: AppConstants.spacing4Xl),
                  _buildActionButtons(),
                ],
              ),
            ),
    );
  }

  Widget _buildStatusCard() {
    final status = _attendance?.status ?? AttendanceStatus.notMarked;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacing2Xl),
        child: Column(
          children: [
            if (status == AttendanceStatus.checkedOut)
              Icon(Icons.check_circle, color: colorScheme.primary, size: 64)
            else
              Icon(
                status == AttendanceStatus.checkedIn ? Icons.login : Icons.radio_button_unchecked,
                color: status == AttendanceStatus.checkedIn ? colorScheme.secondary : colorScheme.outline,
                size: 64,
              ),
            const SizedBox(height: AppConstants.spacingLg),
            Text(
              status == AttendanceStatus.checkedOut
                  ? 'Attendance Completed'
                  : (status == AttendanceStatus.checkedIn ? 'Currently Checked In' : 'Not Checked In'),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: status == AttendanceStatus.checkedOut ? colorScheme.primary : colorScheme.onSurface,
                  ),
            ),
            if (status != AttendanceStatus.notMarked) ...[
              const SizedBox(height: AppConstants.spacing2Xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTimeColumn('Check In', _attendance?.checkInTime),
                  _buildTimeColumn('Check Out', _attendance?.checkOutTime),
                ],
              ),
            ],
            if (status == AttendanceStatus.checkedOut) ...[
              const SizedBox(height: AppConstants.spacing2Xl),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLg, vertical: AppConstants.spacingSm),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Today's attendance has been completed.",
                  style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTimeColumn(String label, DateTime? time) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: AppConstants.spacingXs),
        Text(
          time != null ? DateFormat('hh:mm a').format(time) : '--:--',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildLocationCard() {
    if (_locationResult == null) return const SizedBox.shrink();

    if (_locationResult!.errorMessage != null) {
      return _buildErrorLocationCard();
    }

    final colorScheme = Theme.of(context).colorScheme;
    final within = _locationResult!.isWithinGeofence;
    final distance = _locationResult!.distanceFromOffice;
    final accuracy = _locationResult!.accuracy;

    // Use specific colors for location status to ensure high visibility
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
                      color: statusColor.withValues(alpha: 0.8),
                    ),
                  ),
                  Text(
                    'Distance: ${distance.toStringAsFixed(1)} m',
                    style: TextStyle(color: statusColor.withValues(alpha: 0.7)),
                  ),
                  Text(
                    'Accuracy: ${accuracy.toStringAsFixed(1)} m',
                    style: TextStyle(
                      fontSize: 12,
                      color: accuracy > AppConstants.maxAllowedAccuracyInMeters / 2 ? colorScheme.error : statusColor.withValues(alpha: 0.7),
                      fontWeight: accuracy > AppConstants.maxAllowedAccuracyInMeters / 2 ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  if (accuracy > AppConstants.maxAllowedAccuracyInMeters / 2)
                    Padding(
                      padding: const EdgeInsets.only(top: AppConstants.spacingXs),
                      child: Text(
                        'Poor GPS accuracy. Please try to move to an open area for better results.',
                        style: TextStyle(fontSize: 11, color: colorScheme.error, fontStyle: FontStyle.italic),
                      ),
                    ),
                  const SizedBox(height: AppConstants.spacingXs),
                  Text(
                    within ? "You're within the office area" : 'You must be within 50 meters of the office.',
                    style: TextStyle(fontSize: 12, color: statusColor.withValues(alpha: 0.9)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorLocationCard() {
    final colorScheme = Theme.of(context).colorScheme;
    IconData icon = Icons.error_outline;
    String title = 'Location Error';
    String message = _locationResult!.errorMessage!;
    Widget? action;

    if (_locationResult!.isLocationServiceDisabled) {
      icon = Icons.location_disabled;
      title = 'GPS Disabled';
      message = 'Location services are turned off. Please enable GPS to mark attendance.';
    } else if (_locationResult!.isPermissionDenied) {
      icon = Icons.security;
      title = 'Permission Required';
      message = 'Location permission is required to mark attendance.';
      action = TextButton(
        onPressed: _refreshData,
        child: const Text('Allow Access'),
      );
    } else if (_locationResult!.isPermissionDeniedForever) {
      icon = Icons.settings;
      title = 'Permission Denied';
      message = 'Location permission is permanently denied. Please enable it from Settings.';
      action = TextButton(
        onPressed: () => DependencyInjection.locationService.openLocationSettings(),
        child: const Text('Open Settings'),
      );
    }

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: colorScheme.errorContainer.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.error.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingXl),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: colorScheme.error, size: 32),
                const SizedBox(width: AppConstants.spacingLg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.error)),
                      Text(message, style: TextStyle(color: colorScheme.error.withValues(alpha: 0.8))),
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

  Widget _buildActionButtons() {
    final status = _attendance?.status ?? AttendanceStatus.notMarked;
    final within = _locationResult?.isWithinGeofence ?? false;
    final colorScheme = Theme.of(context).colorScheme;

    if (status == AttendanceStatus.checkedOut) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        if (status == AttendanceStatus.notMarked)
          ElevatedButton(
            onPressed: (_isProcessing || !within) ? null : _handleCheckIn,
            style: ElevatedButton.styleFrom(backgroundColor: colorScheme.primary),
            child: _isProcessing
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text('CHECK IN'),
          ),
        if (status == AttendanceStatus.checkedIn)
          ElevatedButton(
            onPressed: (_isProcessing || !within) ? null : _handleCheckOut,
            style: ElevatedButton.styleFrom(backgroundColor: colorScheme.secondary),
            child: _isProcessing
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text('CHECK OUT'),
          ),
      ],
    );
  }

}
