import 'package:flutter/material.dart';
import '../../core/widgets/empty_state.dart';

class RequestsScreen extends StatelessWidget {
  const RequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Requests'),
      ),
      body: const EmptyState(
        title: 'No Active Requests',
        message: 'Your submitted requests will appear here.',
        icon: Icons.assignment_outlined,
      ),
    );
  }
}
