import 'package:flutter/material.dart';
import '../utils/session_manager.dart';
import '../constants/app_constants.dart';

/// Centralized role-based route guard for HR-only screens.
/// Wraps HR screens to ensure that only authenticated users with the 'hr' role
/// can access them. Non-HR users are redirected to a safe route (e.g. main/home).
class HrRouteGuard extends StatefulWidget {
  final Widget child;

  const HrRouteGuard({
    super.key,
    required this.child,
  });

  @override
  State<HrRouteGuard> createState() => _HrRouteGuardState();
}

class _HrRouteGuardState extends State<HrRouteGuard> {
  bool _isChecking = true;
  bool _isAuthorized = false;

  @override
  void initState() {
    super.initState();
    _checkAuthorization();
  }

  Future<void> _checkAuthorization() async {
    final isValidSession = await SessionManager.hasSession();
    final role = await SessionManager.getUserRole();
    final isHr = isValidSession && role == 'hr';

    if (!mounted) return;

    if (!isHr) {
      setState(() {
        _isAuthorized = false;
        _isChecking = false;
      });

      // Post-frame callback to safely handle navigation redirection
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Access Denied: HR authorization required.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );

        // Redirect to safe authenticated route or login
        if (!isValidSession || role == null) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppConstants.loginRoute,
            (route) => false,
          );
        } else if (Navigator.canPop(context)) {
          Navigator.pop(context);
        } else {
          Navigator.pushReplacementNamed(context, AppConstants.mainRoute);
        }
      });
    } else {
      setState(() {
        _isAuthorized = true;
        _isChecking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!_isAuthorized) {
      // Return empty container while redirecting to prevent exposing HR screen contents
      return const Scaffold(
        body: SizedBox.shrink(),
      );
    }

    return widget.child;
  }
}
