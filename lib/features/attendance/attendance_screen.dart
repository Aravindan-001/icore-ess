import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
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
      final attendance = await DependencyInjection.repository.getTodayAttendance();
      final location = await DependencyInjection.locationService.getLocationDetails();

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
    final location = await DependencyInjection.locationService.getLocationDetails();
    setState(() => _locationResult = location);

    if (location.errorMessage != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(location.errorMessage!)),
        );
      }
      return;
    }

    if (!location.isWithinGeofence) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You must be within 50 meters of the office to check in.')),
        );
      }
      return;
    }

    setState(() => _isProcessing = true);
    try {
      final success = await DependencyInjection.repository.checkIn(DateTime.now());
      if (success) {
        await _refreshData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Checked in successfully!'), backgroundColor: AppTheme.success),
          );
        }
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _handleCheckOut() async {
    final location = await DependencyInjection.locationService.getLocationDetails();
    setState(() => _locationResult = location);

    if (location.errorMessage != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(location.errorMessage!)),
        );
      }
      return;
    }

    if (!location.isWithinGeofence) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You must return to the office area to check out.')),
        );
      }
      return;
    }

    setState(() => _isProcessing = true);
    try {
      final success = await DependencyInjection.repository.checkOut(DateTime.now());
      if (success) {
        await _refreshData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Checked out successfully!'), backgroundColor: AppTheme.success),
          );
        }
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
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('EEEE, dd MMMM yyyy').format(DateTime.now()),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.textGrey),
                  ),
                  const SizedBox(height: 24),
                  _buildStatusCard(),
                  const SizedBox(height: 24),
                  _buildLocationCard(),
                  const SizedBox(height: 40),
                  _buildActionButtons(),
                ],
              ),
            ),
    );
  }

  Widget _buildStatusCard() {
    final status = _attendance?.status ?? AttendanceStatus.notMarked;
    
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            if (status == AttendanceStatus.checkedOut)
              const Icon(Icons.check_circle, color: AppTheme.success, size: 64)
            else
              Icon(
                status == AttendanceStatus.checkedIn ? Icons.login : Icons.radio_button_unchecked,
                color: status == AttendanceStatus.checkedIn ? AppTheme.accentBlue : AppTheme.textGrey,
                size: 64,
              ),
            const SizedBox(height: 16),
            Text(
              status == AttendanceStatus.checkedOut
                  ? 'Attendance Completed'
                  : (status == AttendanceStatus.checkedIn ? 'Currently Checked In' : 'Not Checked In'),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: status == AttendanceStatus.checkedOut ? AppTheme.success : AppTheme.textDark,
                  ),
            ),
            if (status != AttendanceStatus.notMarked) ...[
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTimeColumn('Check In', _attendance?.checkInTime),
                  _buildTimeColumn('Check Out', _attendance?.checkOutTime),
                ],
              ),
            ],
            if (status == AttendanceStatus.checkedOut) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Today's attendance has been completed.",
                  style: TextStyle(color: AppTheme.success, fontWeight: FontWeight.w500),
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
        const SizedBox(height: 4),
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

    final within = _locationResult!.isWithinGeofence;
    final distance = _locationResult!.distanceFromOffice;
    final accuracy = _locationResult!.accuracy;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: within ? Colors.green.shade50 : Colors.orange.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: within ? Colors.green.shade200 : Colors.orange.shade200,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(
              within ? Icons.location_on : Icons.location_off,
              color: within ? AppTheme.success : Colors.orange,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    within ? 'Office Location Verified' : 'Outside Office Area',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: within ? Colors.green.shade700 : Colors.orange.shade700,
                    ),
                  ),
                  Text(
                    'Distance: ${distance.toStringAsFixed(1)} m',
                    style: TextStyle(color: within ? Colors.green.shade600 : Colors.orange.shade600),
                  ),
                  Text(
                    'Accuracy: ${accuracy.toStringAsFixed(1)} m',
                    style: TextStyle(
                      fontSize: 12,
                      color: accuracy > 50 ? Colors.red : (within ? Colors.green.shade600 : Colors.orange.shade600),
                      fontWeight: accuracy > 50 ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  if (accuracy > 50)
                    const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        'Poor GPS accuracy. Please try to move to an open area for better results.',
                        style: TextStyle(fontSize: 11, color: Colors.red, fontStyle: FontStyle.italic),
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    within ? "You're within the office area" : 'You must be within 50 meters of the office.',
                    style: TextStyle(fontSize: 12, color: within ? Colors.green.shade800 : Colors.orange.shade800),
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
        onPressed: () => Geolocator.openAppSettings(),
        child: const Text('Open Settings'),
      );
    }

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: Colors.red.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.red.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.red, size: 32),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red.shade700)),
                      Text(message, style: TextStyle(color: Colors.red.shade600)),
                    ],
                  ),
                ),
              ],
            ),
            if (action != null) ...[
              const SizedBox(height: 8),
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

    if (status == AttendanceStatus.checkedOut) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        if (status == AttendanceStatus.notMarked)
          ElevatedButton(
            onPressed: (_isProcessing || !within) ? null : _handleCheckIn,
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryBlue),
            child: _isProcessing
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text('CHECK IN'),
          ),
        if (status == AttendanceStatus.checkedIn)
          ElevatedButton(
            onPressed: (_isProcessing || !within) ? null : _handleCheckOut,
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentBlue),
            child: _isProcessing
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text('CHECK OUT'),
          ),
      ],
    );
  }
}
