import 'package:flutter/material.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/payslip/payslip_screen.dart';
import '../features/leave/leave_screen.dart';
import '../features/pay_summary/pay_summary_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/hr/hr_dashboard_screen.dart';
import '../features/hr/hr_employee_list_screen.dart';
import '../features/hr/hr_leave_requests_screen.dart';
import '../features/hr/hr_payslip_mgmt_screen.dart';
import '../core/utils/session_manager.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  String? _userRole;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    final role = await SessionManager.getUserRole();
    if (mounted) {
      setState(() {
        _userRole = role;
        _isLoading = false;
      });
    }
  }

  List<Widget> _getScreens() {
    if (_userRole == 'hr') {
      return [
        const HrDashboardScreen(),
        const HrEmployeeListScreen(),
        const HrLeaveRequestsScreen(),
        const HrPayslipMgmtScreen(),
        const ProfileScreen(),
      ];
    }
    return [
      const DashboardScreen(),
      const PayslipScreen(),
      const LeaveScreen(),
      const PaySummaryScreen(),
      const ProfileScreen(),
    ];
  }

  List<NavigationDestination> _getDestinations() {
    if (_userRole == 'hr') {
      return const [
        NavigationDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard),
          label: 'Admin',
        ),
        NavigationDestination(
          icon: Icon(Icons.people_outlined),
          selectedIcon: Icon(Icons.people),
          label: 'Employees',
        ),
        NavigationDestination(
          icon: Icon(Icons.event_note_outlined),
          selectedIcon: Icon(Icons.event_note),
          label: 'Leaves',
        ),
        NavigationDestination(
          icon: Icon(Icons.payments_outlined),
          selectedIcon: Icon(Icons.payments),
          label: 'Payroll',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ];
    }
    return const [
      NavigationDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home),
        label: 'Home',
      ),
      NavigationDestination(
        icon: Icon(Icons.receipt_long_outlined),
        selectedIcon: Icon(Icons.receipt_long),
        label: 'Payslips',
      ),
      NavigationDestination(
        icon: Icon(Icons.calendar_today_outlined),
        selectedIcon: Icon(Icons.calendar_today),
        label: 'Leave',
      ),
      NavigationDestination(
        icon: Icon(Icons.analytics_outlined),
        selectedIcon: Icon(Icons.analytics),
        label: 'Pay Summary',
      ),
      NavigationDestination(
        icon: Icon(Icons.person_outline),
        selectedIcon: Icon(Icons.person),
        label: 'Profile',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final screens = _getScreens();

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: _getDestinations(),
      ),
    );
  }
}
