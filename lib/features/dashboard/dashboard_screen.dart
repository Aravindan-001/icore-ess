import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/service_card.dart';
import '../../core/widgets/donut_chart.dart';
import '../../core/utils/dependency_injection.dart';
import '../../models/employee.dart';
import '../../models/attendance.dart';
import '../../services/location_service.dart';

import '../../core/widgets/business_card_dialog.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Timer? _timer;
  DateTime _now = DateTime.now();
  bool _isLoading = true;
  bool _isProcessing = false;
  Employee? _employee;
  AttendanceRecord? _attendance;
  LocationResult? _locationResult;

  @override
  void initState() {
    super.initState();
    
    // Don't start the timer in tests to avoid pumpAndSettle timeouts
    final bool isTest = Platform.environment.containsKey('FLUTTER_TEST');

    if (!isTest) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) {
          setState(() {
            _now = DateTime.now();
          });
        }
      });
    }
    _refreshData();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _refreshData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        DependencyInjection.profileService.getEmployeeProfile(),
        DependencyInjection.attendanceService.getTodayAttendance(),
        DependencyInjection.attendanceService.getCurrentLocation(),
      ]);

      if (mounted) {
        setState(() {
          _employee = results[0] as Employee;
          _attendance = results[1] as AttendanceRecord;
          _locationResult = results[2] as LocationResult;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        debugPrint('Error loading dashboard data: $e');
      }
    }
  }

  Future<void> _handleClockIn() async {
    setState(() => _isProcessing = true);
    try {
      final success = await DependencyInjection.attendanceService.checkIn();
      if (success) {
        await _refreshData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Clocked in successfully!'), backgroundColor: AppTheme.success),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        String message = e.toString().replaceFirst('Exception: ', '');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _DashboardHeader(employee: _employee!, now: _now),
            Transform.translate(
              offset: const Offset(0, -50),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _OfficeLocationCard(
                      location: _locationResult,
                      attendance: _attendance,
                      onClockIn: _handleClockIn,
                      isProcessing: _isProcessing,
                    ),
                    const SizedBox(height: 16),
                    _AttendanceSummaryCard(record: _attendance),
                    const SizedBox(height: 16),
                    const _EServicesSection(),
                    const SizedBox(height: 16),
                    const _NetPaySection(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  final Employee employee;
  final DateTime now;

  const _DashboardHeader({required this.employee, required this.now});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final hour = now.hour;
    String greeting = 'Morning';
    if (hour >= 12 && hour < 17) greeting = 'Afternoon';
    if (hour >= 17) greeting = 'Evening';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 80),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$greeting, ${employee.name}',
                    style: textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Let's get to work!",
                    style: textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.8)),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.white70),
                    onPressed: () => DependencyInjection.authService.logout(context),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => BusinessCardDialog(employee: employee),
                      );
                    },
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      child: const Icon(Icons.person, color: Colors.white, size: 30),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.calendar_today, color: Colors.white70, size: 14),
              const SizedBox(width: 8),
              Text(
                DateFormat('EEEE, dd MMM yyyy').format(now),
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.access_time, color: Colors.white70, size: 14),
              const SizedBox(width: 8),
              Text(
                DateFormat('hh:mm:ss a').format(now),
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OfficeLocationCard extends StatelessWidget {
  final LocationResult? location;
  final AttendanceRecord? attendance;
  final VoidCallback onClockIn;
  final bool isProcessing;

  const _OfficeLocationCard({
    required this.location,
    required this.attendance,
    required this.onClockIn,
    required this.isProcessing,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final address = location?.errorMessage == null 
        ? "240/241, Thoppukollai, Tamil Nadu, India" // Mocking address as per ref UI if not available
        : "Location error: ${location?.errorMessage}";

    return Card(
      elevation: 4,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              address,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: (isProcessing || attendance?.status != AttendanceStatus.notMarked) ? null : onClockIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      minimumSize: const Size(0, 45),
                    ),
                    child: isProcessing 
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Clock In'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, AppConstants.attendanceRoute),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      minimumSize: const Size(0, 45),
                    ),
                    child: const Text('LOG'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AttendanceSummaryCard extends StatelessWidget {
  final AttendanceRecord? record;

  const _AttendanceSummaryCard({required this.record});

  String _formatWorkingTime(DateTime? start, DateTime? end) {
    if (start == null) return "00:00:00";
    final effectiveEnd = end ?? DateTime.now();
    final diff = effectiveEnd.difference(start);
    final hours = diff.inHours.toString().padLeft(2, '0');
    final minutes = (diff.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (diff.inSeconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final startTime = record?.checkInTime != null ? DateFormat('HH:mm').format(record!.checkInTime!) : "00:00";
    final endTime = record?.checkOutTime != null ? DateFormat('HH:mm').format(record!.checkOutTime!) : "--:--";
    final workingTime = _formatWorkingTime(record?.checkInTime, record?.checkOutTime);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 16, color: Color(0xFF0F2D5B)),
                  onPressed: () {},
                ),
                Expanded(
                  child: Text(
                    DateFormat('EEEE, MMMM dd').format(record?.date ?? DateTime.now()),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F2FE),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Text(
                        DateFormat('dd-MM-yyyy').format(record?.date ?? DateTime.now()),
                        style: const TextStyle(fontSize: 10, color: Color(0xFF0F2D5B), fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.calendar_month, size: 12, color: Color(0xFF0F2D5B)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF0F2D5B)),
                  onPressed: () {},
                ),
              ],
            ),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTimeInfo(context, 'Start Time', startTime),
                _buildDivider(),
                _buildTimeInfo(context, 'End Time', endTime),
                _buildDivider(),
                _buildTimeInfo(context, 'Working Time', workingTime, isSuccess: true),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(height: 30, width: 1, color: Colors.grey.withValues(alpha: 0.2));
  }

  Widget _buildTimeInfo(BuildContext context, String label, String value, {bool isSuccess = false}) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isSuccess ? const Color(0xFF10B981) : Colors.black,
          ),
        ),
      ],
    );
  }
}

class _EServicesSection extends StatelessWidget {
  const _EServicesSection();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'E-services',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.8,
              children: [
                ServiceCard(
                  title: 'Leave\nRequest',
                  icon: Icons.event_note,
                  color: const Color(0xFF3B82F6),
                  backgroundColor: const Color(0xFFEFF6FF),
                  onTap: () => Navigator.pushNamed(context, AppConstants.leaveRoute),
                ),
                ServiceCard(
                  title: 'Pay\nSlip',
                  icon: Icons.receipt_long,
                  color: const Color(0xFFA855F7),
                  backgroundColor: const Color(0xFFFAF5FF),
                  onTap: () => Navigator.pushNamed(context, AppConstants.payslipRoute),
                ),
                ServiceCard(
                  title: 'Pay\nSummary',
                  icon: Icons.analytics,
                  color: const Color(0xFF10B981),
                  backgroundColor: const Color(0xFFECFDF5),
                  onTap: () => Navigator.pushNamed(context, AppConstants.paySummaryRoute),
                ),
                ServiceCard(
                  title: 'Reimburse\nment',
                  icon: Icons.published_with_changes,
                  color: const Color(0xFFF59E0B),
                  backgroundColor: const Color(0xFFFFFBEB),
                  onTap: () => Navigator.pushNamed(context, AppConstants.reimbursementRoute),
                ),
                ServiceCard(
                  title: 'Pre\nOrder',
                  icon: Icons.shopping_cart,
                  color: const Color(0xFF06B6D4),
                  backgroundColor: const Color(0xFFECFEFF),
                  onTap: () => Navigator.pushNamed(context, AppConstants.preOrderRoute),
                ),
                ServiceCard(
                  title: 'Sales\nOrder',
                  icon: Icons.description,
                  color: const Color(0xFFEF4444),
                  backgroundColor: const Color(0xFFFEF2F2),
                  onTap: () => Navigator.pushNamed(context, AppConstants.salesOrderRoute),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NetPaySection extends StatelessWidget {
  const _NetPaySection();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Net Pay', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                TextButton(
                  onPressed: () {},
                  child: const Text('View More...', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Available Balance', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 4),
                    Text(
                      '₹ 2,14,346.00',
                      style: textTheme.headlineSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.calendar_today, size: 12),
                      SizedBox(width: 4),
                      Text('August 2026', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const DonutChart(
                  values: [48, 26, 26],
                  colors: [Color(0xFF84CC16), Color(0xFFEF4444), Color(0xFF6366F1)],
                  strokeWidth: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPayDetailItem(context, 'Earningss', '₹ 3,00,000.00', const Color(0xFF64748B), Icons.trending_up),
                    const SizedBox(height: 8),
                    _buildPayDetailItem(context, 'Deduction', '₹ 84,000.00', const Color(0xFF64748B), Icons.trending_down),
                    const SizedBox(height: 8),
                    _buildPayDetailItem(context, 'Perks', '₹ 84,000.00', const Color(0xFF64748B), Icons.stars_outlined),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPayDetailItem(BuildContext context, String label, String amount, Color color, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color.withValues(alpha: 0.6)),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            Text(amount, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}
