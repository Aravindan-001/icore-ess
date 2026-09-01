import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/utils/dependency_injection.dart';
import '../../models/reimbursement.dart';

class ReimbursementScreen extends StatefulWidget {
  const ReimbursementScreen({super.key});

  @override
  State<ReimbursementScreen> createState() => _ReimbursementScreenState();
}

class _ReimbursementScreenState extends State<ReimbursementScreen> {
  List<Reimbursement> _reimbursements = [];
  bool _isLoading = true;
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchReimbursements();
  }

  Future<void> _fetchReimbursements() async {
    setState(() => _isLoading = true);
    try {
      final data = await DependencyInjection.repository.getReimbursements();
      if (mounted) {
        setState(() {
          _reimbursements = data;
          _isLoading = false;
        });
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

  void _showAddReimbursement() {
    _titleController.clear();
    _amountController.clear();
    final categoryController = TextEditingController(text: 'General');
    bool isSubmitting = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 20,
              right: 20,
              top: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('New Reimbursement', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: categoryController,
                  label: 'Category',
                  hint: 'e.g. Travel, Internet',
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _titleController,
                  label: 'Description',
                  hint: 'e.g. Internet Bill',
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _amountController,
                  label: 'Amount',
                  hint: 'Enter amount',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: isSubmitting ? null : () async {
                    if (_titleController.text.isEmpty || _amountController.text.isEmpty || categoryController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill all fields')),
                      );
                      return;
                    }

                    setModalState(() => isSubmitting = true);
                    
                    try {
                      final employee = await DependencyInjection.repository.getEmployeeProfile();
                      final reimbursement = Reimbursement(
                        id: 'REI${DateTime.now().millisecondsSinceEpoch}',
                        employeeId: employee.id,
                        category: categoryController.text,
                        description: _titleController.text,
                        amount: double.tryParse(_amountController.text) ?? 0.0,
                        date: DateTime.now(),
                        status: 'Pending',
                      );

                      final success = await DependencyInjection.repository.submitReimbursement(reimbursement);
                      if (success && mounted) {
                        if (context.mounted) Navigator.pop(context);
                        _fetchReimbursements();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Reimbursement request submitted'), backgroundColor: AppTheme.success),
                          );
                        }
                      }
                    } catch (e) {
                      if (mounted && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e'), backgroundColor: AppTheme.error),
                        );
                      }
                    } finally {
                      if (mounted) setModalState(() => isSubmitting = false);
                    }
                  },
                  child: isSubmitting 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Submit Request'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reimbursements')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _reimbursements.isEmpty
              ? const Center(child: Text('No reimbursements found'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _reimbursements.length,
                  itemBuilder: (context, index) {
                    final item = _reimbursements[index];
                    return Card(
                      child: ListTile(
                        title: Text(item.description, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${item.category} • ${DateFormat('dd MMM yyyy').format(item.date)}'),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('₹${item.amount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text(item.status, style: TextStyle(color: _getStatusColor(item.status), fontSize: 12)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddReimbursement,
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Color _getStatusColor(String status) {
    if (status == 'Approved') return AppTheme.success;
    if (status == 'Rejected') return AppTheme.error;
    return AppTheme.warning;
  }
}
