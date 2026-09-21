import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/injection_providers.dart';
import 'leave_provider.dart';

class ApplyLeaveScreen extends ConsumerStatefulWidget {
  const ApplyLeaveScreen({super.key});

  @override
  ConsumerState<ApplyLeaveScreen> createState() => _ApplyLeaveScreenState();
}

class _ApplyLeaveScreenState extends ConsumerState<ApplyLeaveScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedLeaveType = 'Annual Leave';
  DateTime? _startDate;
  DateTime? _endDate;
  final _reasonController = TextEditingController();

  final List<String> _leaveTypes = ['Annual Leave', 'Sick Leave', 'Casual Leave', 'Roster Leave'];

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        if (_endDate != null && _endDate!.isBefore(_startDate!)) {
          _endDate = null;
        }
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a start date first.')),
      );
      return;
    }
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate!,
      firstDate: _startDate!,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_startDate == null || _endDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Start and End dates are required.')),
        );
        return;
      }

      if (_endDate!.isBefore(_startDate!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('End date cannot be before start date.')),
        );
        return;
      }

      final success = await ref.read(applyLeaveNotifierProvider.notifier).submitLeave(
            type: _selectedLeaveType!,
            startDate: _startDate!,
            endDate: _endDate!,
            reason: _reasonController.text,
          );

      if (success && mounted) {
        final submissionState = ref.read(applyLeaveNotifierProvider);
        ref.read(analyticsServiceProvider).logEvent('request_submitted');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Leave application submitted. ID: ${submissionState.successRequestId}'),
            backgroundColor: AppTheme.success,
          ),
        );
        ref.read(applyLeaveNotifierProvider.notifier).reset();
        Navigator.pop(context);
      } else if (mounted) {
        final submissionState = ref.read(applyLeaveNotifierProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(submissionState.errorMessage ?? 'Submission failed.'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final submissionState = ref.watch(applyLeaveNotifierProvider);
    final isLoading = submissionState.isLoading;

    final startText = _startDate != null ? DateFormat('dd MMM yyyy').format(_startDate!) : 'Select Start Date';
    final endText = _endDate != null ? DateFormat('dd MMM yyyy').format(_endDate!) : 'Select End Date';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Apply Leave'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFieldLabel('Leave Type'),
              DropdownButtonFormField<String>(
                initialValue: _selectedLeaveType,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                items: _leaveTypes.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: isLoading ? null : (val) => setState(() => _selectedLeaveType = val),
                validator: (val) => val == null ? 'Leave type is required' : null,
              ),
              const SizedBox(height: 20),

              _buildFieldLabel('Start Date'),
              InkWell(
                onTap: isLoading ? null : () => _selectStartDate(context),
                borderRadius: BorderRadius.circular(16),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.calendar_today, color: AppTheme.primaryBlue),
                  ),
                  child: Text(
                    startText,
                    style: TextStyle(
                      fontSize: 16,
                      color: _startDate != null ? AppTheme.textMain : AppTheme.textMuted,
                      fontWeight: _startDate != null ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              _buildFieldLabel('End Date'),
              InkWell(
                onTap: isLoading ? null : () => _selectEndDate(context),
                borderRadius: BorderRadius.circular(16),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.calendar_today, color: AppTheme.primaryBlue),
                  ),
                  child: Text(
                    endText,
                    style: TextStyle(
                      fontSize: 16,
                      color: _endDate != null ? AppTheme.textMain : AppTheme.textMuted,
                      fontWeight: _endDate != null ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              _buildFieldLabel('Reason'),
              TextFormField(
                controller: _reasonController,
                maxLines: 4,
                enabled: !isLoading,
                decoration: const InputDecoration(
                  hintText: 'Enter detailed reason for leave application',
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Reason is required' : null,
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _submitForm,
                  child: isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('Submit Application'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppTheme.textMuted,
        ),
      ),
    );
  }
}
