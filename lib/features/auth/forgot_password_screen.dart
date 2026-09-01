import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/utils/dependency_injection.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      try {
        final success = await DependencyInjection.repository.forgotPassword(_idController.text);
        
        if (mounted) {
          setState(() => _isLoading = false);
          if (success) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Request Submitted'),
                content: const Text('If the Employee ID or Email is valid, you will receive instructions to reset your password shortly.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                      Navigator.pop(context); // Go back to login
                    },
                    child: const Text('Back to Login'),
                  ),
                ],
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Invalid Employee ID or Email.'),
                backgroundColor: AppTheme.error,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: AppTheme.error),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Reset Your Password',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'Enter your Employee ID or registered Email address and we will send you instructions to reset your password.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.textGrey),
              ),
              const SizedBox(height: 32),
              CustomTextField(
                controller: _idController,
                label: 'Employee ID / Email',
                hint: 'Enter your ID or Email',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your ID or Email';
                  }
                  // Basic validation for Employee ID (e.g., EMPxxx) or Email
                  final isEmail = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
                  final isEmpId = RegExp(r'^EMP\d+$').hasMatch(value);
                  
                  if (!isEmail && !isEmpId && value != 'EMP001') { // Allow EMP001 for mock
                     // In a real app, validation might be stricter.
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleSubmit,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text('Submit Request'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
