import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/injection_providers.dart';

class LeaveScreen extends ConsumerStatefulWidget {
  const LeaveScreen({super.key});

  @override
  ConsumerState<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends ConsumerState<LeaveScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final String _documentNumber = 'LR-2025-0214';
  String _selectedLeaveType = 'Annual Leave';
  final String _fromDate = '08/09/2026';
  final String _toDate = '17/09/2026';
  
  bool _fromHalfDay = false;
  bool _toHalfDay = false;
  bool _availAirTicket = false;
  bool _advanceSalary = false;
  
  final _reasonController = TextEditingController(text: 'Annual vacation trip');

  final List<String> _leaveTypes = ['Annual Leave', 'Sick Leave', 'Casual Leave', 'Compensatory Leave'];

  void _resetForm() {
    setState(() {
      _selectedLeaveType = 'Annual Leave';
      _fromHalfDay = false;
      _toHalfDay = false;
      _availAirTicket = false;
      _advanceSalary = false;
      _reasonController.text = '';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Form fields reset successfully.')),
    );
  }

  void _submitRequest() {
    if (_formKey.currentState!.validate()) {
      ref.read(analyticsServiceProvider).logEvent('request_submitted');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Leave Request submitted successfully!'),
          backgroundColor: AppTheme.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Leave', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Leave Balance Section Card
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
                elevation: 0,
                child: const Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 12.0, left: 16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Compensatory Leave',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _BalanceMetricItem(label: 'Available', value: '0.00'),
                          _BalanceMetricItem(label: 'Used', value: '1.00'),
                          _BalanceMetricItem(label: 'Pending', value: '0.00'),
                          _BalanceMetricItem(label: 'Approved', value: '0.00'),
                          _BalanceMetricItem(label: 'Balance', value: '1.00'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 2. Leave Request Form Section
              _buildSectionTitle('Leave Request'),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Document Number
                      TextFormField(
                        initialValue: _documentNumber,
                        decoration: const InputDecoration(
                          labelText: 'Document *',
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        readOnly: true,
                      ),
                      const SizedBox(height: 16),

                      // Leave Type Dropdown
                      DropdownButtonFormField<String>(
                        initialValue: _selectedLeaveType,
                        decoration: const InputDecoration(
                          labelText: 'Leave Type *',
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: _leaveTypes.map((type) {
                          return DropdownMenuItem(value: type, child: Text(type));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedLeaveType = val);
                        },
                      ),
                      const SizedBox(height: 16),

                      // From Date & To Date fields layout row
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: _fromDate,
                              decoration: const InputDecoration(
                                labelText: 'From Date *',
                                suffixIcon: Icon(Icons.calendar_today, size: 16, color: AppTheme.primaryBlue),
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                              readOnly: true,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              initialValue: _toDate,
                              decoration: const InputDecoration(
                                labelText: 'To Date *',
                                suffixIcon: Icon(Icons.calendar_today, size: 16, color: AppTheme.primaryBlue),
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                              readOnly: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Half Day Checkboxes row
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Checkbox(
                                  value: _fromHalfDay,
                                  onChanged: (val) => setState(() => _fromHalfDay = val ?? false),
                                  visualDensity: VisualDensity.compact,
                                ),
                                const Text('Half Day', style: TextStyle(fontSize: 12)),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Checkbox(
                                  value: _toHalfDay,
                                  onChanged: (val) => setState(() => _toHalfDay = val ?? false),
                                  visualDensity: VisualDensity.compact,
                                ),
                                const Text('Half Day', style: TextStyle(fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Policy feature toggles
                      Row(
                        children: [
                          Checkbox(
                            value: _availAirTicket,
                            onChanged: (val) => setState(() => _availAirTicket = val ?? false),
                            visualDensity: VisualDensity.compact,
                          ),
                          const Text('Avail Air Ticket (For Info)', style: TextStyle(fontSize: 13)),
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: _advanceSalary,
                            onChanged: (val) => setState(() => _advanceSalary = val ?? false),
                            visualDensity: VisualDensity.compact,
                          ),
                          const Text('Advance Salary Applicable', style: TextStyle(fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 3. Leave Summary Information Card Block
              _buildSectionTitle('Leave Summary'),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildSummaryBox('Calendar Days', '10'),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSummaryBox('Leave Days', '10'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Form control operation buttons row
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _resetForm,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        side: const BorderSide(color: AppTheme.primaryBlue),
                      ),
                      child: const Text('Reset', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submitRequest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                      child: const Text('Submit Leave Request', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 8.0, top: 4.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textMain),
      ),
    );
  }

  Widget _buildSummaryBox(String title, String val) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
          const SizedBox(height: 4),
          Text(val, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppTheme.primaryBlue)),
        ],
      ),
    );
  }
}

class _BalanceMetricItem extends StatelessWidget {
  final String label;
  final String value;

  const _BalanceMetricItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppTheme.textMain,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: AppTheme.textMuted),
        ),
      ],
    );
  }
}
