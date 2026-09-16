import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/utils/dependency_injection.dart';
import '../../models/claim.dart';

class ClaimsScreen extends StatefulWidget {
  const ClaimsScreen({super.key});

  @override
  State<ClaimsScreen> createState() => _ClaimsScreenState();
}

class _ClaimsScreenState extends State<ClaimsScreen> {
  List<MedicalClaim> _claims = [];
  bool _isLoading = true;
  final _descController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchClaims();
  }

  Future<void> _fetchClaims() async {
    setState(() => _isLoading = true);
    try {
      final claims = await DependencyInjection.expenseService.getMedicalClaims();
      if (mounted) {
        setState(() {
          _claims = claims;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading claims: $e'), backgroundColor: AppTheme.error),
        );
      }
    }
  }

  void _showCreateClaim() {
    _descController.clear();
    _amountController.clear();
    final typeController = TextEditingController(text: 'Medical');
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
                Text('Create Medical Claim', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: typeController,
                  label: 'Claim Type',
                  hint: 'e.g. Medical, Dental',
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _descController,
                  label: 'Claim Description',
                  hint: 'e.g. Dental checkup',
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _amountController,
                  label: 'Amount',
                  hint: 'Enter claim amount',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: isSubmitting ? null : () async {
                    if (_descController.text.isEmpty || _amountController.text.isEmpty || typeController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill all fields')),
                      );
                      return;
                    }

                    setModalState(() => isSubmitting = true);
                    
                    try {
                      final success = await DependencyInjection.expenseService.submitMedicalClaim(
                        type: typeController.text,
                        description: _descController.text,
                        amount: double.tryParse(_amountController.text) ?? 0.0,
                      );
                      if (success && mounted) {
                        if (context.mounted) Navigator.pop(context);
                        _fetchClaims();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Medical claim submitted successfully'), backgroundColor: AppTheme.success),
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
                    : const Text('Submit Claim'),
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
      appBar: AppBar(title: const Text('Medical Claims')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _claims.isEmpty
              ? const Center(child: Text('No claims found'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _claims.length,
                  itemBuilder: (context, index) {
                    final claim = _claims[index];
                    return Card(
                      child: ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.medical_services)),
                        title: Text(claim.description, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${claim.type} • ${DateFormat('dd MMM yyyy').format(claim.date)}'),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('₹${claim.amount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text(claim.status, style: TextStyle(color: _getStatusColor(claim.status), fontSize: 12)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateClaim,
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
