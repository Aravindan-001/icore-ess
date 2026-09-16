import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/dependency_injection.dart';

class ReimbursementRow {
  final String type;
  final String description;
  final String billRefNo;
  final DateTime date;
  final double amount;
  final double claimAmount;
  final String comments;

  ReimbursementRow({
    required this.type,
    required this.description,
    required this.billRefNo,
    required this.date,
    required this.amount,
    required this.claimAmount,
    required this.comments,
  });
}

class ReimbursementScreen extends StatefulWidget {
  const ReimbursementScreen({super.key});

  @override
  State<ReimbursementScreen> createState() => _ReimbursementScreenState();
}

class _ReimbursementScreenState extends State<ReimbursementScreen> {
  DateTime _selectedDate = DateTime.now();
  String _documentType = 'General';
  final List<ReimbursementRow> _rows = [];
  final TextEditingController _notesController = TextEditingController();
  String? _attachmentName;
  bool _isSubmitting = false;

  final List<String> _documentTypes = ['General', 'Medical', 'Travel', 'Utility'];
  final List<String> _reimbursementTypes = ['FUEL', 'INTERNET', 'TRAVEL', 'OTHERS'];

  Future<void> _selectDate(BuildContext context, DateTime initialDate, Function(DateTime) onDateSelected) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      onDateSelected(picked);
    }
  }

  void _showAddRowDialog() {
    String selectedType = _reimbursementTypes.contains('FUEL') ? 'FUEL' : _reimbursementTypes.first;
    DateTime selectedRowDate = _selectedDate;
    final descController = TextEditingController();
    final billRefController = TextEditingController();
    final amountController = TextEditingController();
    final claimAmountController = TextEditingController();
    final commentsController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Type
                    _buildDialogFieldLabel('Type'),
                    DropdownButtonFormField<String>(
                      initialValue: selectedType,
                      isExpanded: true,
                      items: _reimbursementTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                      onChanged: (v) => setDialogState(() => selectedType = v!),
                      decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.zero),
                    ),
                    const SizedBox(height: 12),

                    // Description
                    _buildDialogFieldLabel('Description'),
                    TextFormField(
                      controller: descController,
                      decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 4)),
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),

                    // Bill Reference No.
                    _buildDialogFieldLabel('Bill Reference No.'),
                    TextFormField(
                      controller: billRefController,
                      decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 4)),
                    ),
                    const SizedBox(height: 12),

                    // Date
                    _buildDialogFieldLabel('Date'),
                    InkWell(
                      onTap: () => _selectDate(context, selectedRowDate, (d) => setDialogState(() => selectedRowDate = d)),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        width: double.infinity,
                        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black38, width: 0.8))),
                        child: Text(DateFormat('yyyy-MM-dd').format(selectedRowDate)),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Amount
                    _buildDialogFieldLabel('Amount'),
                    TextFormField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 4)),
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),

                    // Claim Amount
                    _buildDialogFieldLabel('Claim Amount'),
                    TextFormField(
                      controller: claimAmountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 4)),
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),

                    // Comment
                    _buildDialogFieldLabel('Comment'),
                    TextFormField(
                      controller: commentsController,
                      decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 4)),
                    ),
                    const SizedBox(height: 32),

                    Center(
                      child: Column(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              setDialogState(() => _attachmentName = 'receipt.png');
                            },
                            icon: const Icon(Icons.attachment, size: 20),
                            label: const Text('Attach file'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF1F5F9),
                              foregroundColor: AppTheme.primaryBlue,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                setState(() {
                                  _rows.add(ReimbursementRow(
                                    type: selectedType,
                                    description: descController.text,
                                    billRefNo: billRefController.text,
                                    date: selectedRowDate,
                                    amount: double.tryParse(amountController.text) ?? 0.0,
                                    claimAmount: double.tryParse(claimAmountController.text) ?? 0.0,
                                    comments: commentsController.text,
                                  ));
                                });
                                Navigator.pop(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppTheme.primaryBlue,
                              side: BorderSide(color: AppTheme.outline.withValues(alpha: 0.5)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                              elevation: 2,
                            ),
                            child: const Text('Add Row'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDialogFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
    );
  }

  Future<void> _handleSubmit() async {
    if (_rows.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please add at least one row')));
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      for (var row in _rows) {
        await DependencyInjection.expenseService.submitReimbursement(
          category: row.type,
          description: row.description,
          amount: row.claimAmount,
        );
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reimbursement submitted successfully'), backgroundColor: AppTheme.success),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFCFD),
      appBar: AppBar(
        title: const Text('Reimbursement'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date
            const Text('Date', style: TextStyle(color: Colors.grey, fontSize: 13)),
            InkWell(
              onTap: () => _selectDate(context, _selectedDate, (d) => setState(() => _selectedDate = d)),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                width: double.infinity,
                decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black38, width: 0.8))),
                child: Text(DateFormat('yyyy-MM-dd').format(_selectedDate), style: const TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 24),

            // Document Type
            const Text('Document Type', style: TextStyle(color: Colors.grey, fontSize: 13)),
            DropdownButtonFormField<String>(
              initialValue: _documentType,
              items: _documentTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
              onChanged: (v) => setState(() => _documentType = v!),
              decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.zero),
            ),
            const SizedBox(height: 32),

            // Add Row Button
            Center(
              child: ElevatedButton(
                onPressed: _showAddRowDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppTheme.primaryBlue,
                  side: BorderSide(color: AppTheme.outline.withValues(alpha: 0.5)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  elevation: 2,
                ),
                child: const Text('Add Row'),
              ),
            ),
            const SizedBox(height: 32),

            // Rows List
            ..._rows.asMap().entries.map((entry) => _buildRowCard(entry.key, entry.value)),

            const SizedBox(height: 32),

            // Notes
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black38),
                borderRadius: BorderRadius.circular(4),
              ),
              child: TextField(
                controller: _notesController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Notes',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Attachment
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() => _attachmentName = 'invoice.pdf');
                  },
                  icon: const Icon(Icons.attachment, color: AppTheme.primaryBlue, size: 20),
                  label: const Text('Add Attachment', style: TextStyle(color: AppTheme.primaryBlue)),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    backgroundColor: const Color(0xFFF1F5F9),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _attachmentName ?? 'No file selected',
                    style: const TextStyle(color: Colors.black54, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Submit Button
            Center(
              child: SizedBox(
                width: 160,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Submit', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildRowCard(int index, ReimbursementRow row) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRowDetail('Reimbursement Type', row.type),
                  _buildRowDetail('Description', row.description),
                  _buildRowDetail('Bill/Ref No', row.billRefNo),
                  _buildRowDetail('Requested On', DateFormat('yyyy-MM-dd').format(row.date)),
                  _buildRowDetail('Amount', row.amount.toStringAsFixed(1)),
                  _buildRowDetail('Claim Amount', row.claimAmount.toStringAsFixed(1)),
                  _buildRowDetail('Comments', row.comments),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Remove Row'),
                  content: const Text('Are you sure you want to remove this row?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                    TextButton(
                      onPressed: () {
                        setState(() => _rows.removeAt(index));
                        Navigator.pop(context);
                      },
                      child: const Text('Remove', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.delete, color: Color(0xFF455A64)),
          ),
        ],
      ),
    );
  }

  Widget _buildRowDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black87, fontSize: 14, height: 1.4),
          children: [
            TextSpan(text: '$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
