import 'dart:async';
import 'package:flutter/material.dart';
import 'forgot_password_screen.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/utils/dependency_injection.dart';
import '../../core/utils/session_manager.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _loginIdController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadRememberedCredentials();
  }

  Future<void> _loadRememberedCredentials() async {
    final rememberMe = await SessionManager.getRememberMe();
    if (rememberMe) {
      final savedId = await SessionManager.getRememberedId();
      if (mounted && savedId != null) {
        setState(() {
          _loginIdController.text = savedId;
          _rememberMe = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _loginIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      try {
        final result = await DependencyInjection.authService.login(
          _loginIdController.text,
          _passwordController.text,
          rememberMe: _rememberMe,
        );

        if (mounted) {
          setState(() => _isLoading = false);
          if (result.isSuccess) {
            Navigator.pushReplacementNamed(context, AppConstants.mainRoute);
          } else {
            _showError(result.message ?? 'Invalid Employee ID or password.');
          }
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
          _showError('Connection error. Please try again.');
        }
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacing2Xl),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppConstants.spacing4Xl),
                  
                  // Logo
                  Image.asset(
                    'assets/images/ebaconnect_logo.png',
                    height: 120,
                  ),
                  
                  const SizedBox(height: AppConstants.spacingMd),
                  
                  Text(
                    'ebaConnect',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppTheme.primaryBlue,
                        ),
                  ),
                  
                  const SizedBox(height: AppConstants.spacing4Xl),
                  
                  Text(
                    'Welcome Back',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textMain,
                        ),
                  ),
                  const SizedBox(height: AppConstants.spacingSm),
                  Text(
                    'Sign in to your account',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.textGrey,
                        ),
                  ),
                  
                  const SizedBox(height: AppConstants.spacing4Xl),
                  
                  // Employee ID Field
                  CustomTextField(
                    textFieldKey: const Key('field_Employee ID'),
                    controller: _loginIdController,
                    label: 'Employee ID',
                    hint: 'Enter your employee ID',
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Employee ID is required';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: AppConstants.spacing2Xl),
                  
                  // Password Field
                  CustomTextField(
                    textFieldKey: const Key('field_Password'),
                    controller: _passwordController,
                    label: 'Password',
                    hint: 'Enter your password',
                    isPassword: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: AppTheme.textGrey,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: AppConstants.spacingMd),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            height: 24,
                            width: 24,
                            child: Checkbox(
                              value: _rememberMe,
                              activeColor: AppTheme.primaryBlue,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: AppConstants.spacingSm),
                          Text(
                            'Remember Me',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ForgotPasswordScreen(),
                            ),
                          );
                        },
                        child: const Text('Forgot Password?'),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: AppConstants.spacing4Xl),
                  
                  // Login Button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    child: _isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Login'),
                  ),
                  
                  const SizedBox(height: AppConstants.spacing4Xl),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
