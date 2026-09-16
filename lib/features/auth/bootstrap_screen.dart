import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/dependency_injection.dart';

class BootstrapScreen extends StatefulWidget {
  const BootstrapScreen({super.key});

  @override
  State<BootstrapScreen> createState() => _BootstrapScreenState();
}

class _BootstrapScreenState extends State<BootstrapScreen> {
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final hasSession = await DependencyInjection.authService.restoreSession();
    
    if (mounted) {
      if (hasSession) {
        Navigator.pushReplacementNamed(context, AppConstants.mainRoute);
      } else {
        Navigator.pushReplacementNamed(context, AppConstants.loginRoute);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
