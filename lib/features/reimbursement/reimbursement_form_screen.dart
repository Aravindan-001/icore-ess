import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../models/reimbursement_models.dart';
import 'reimbursement_providers.dart';

class ReimbursementFormScreen extends ConsumerStatefulWidget {
  final ReimbursementRequest? initialRequest;

  const ReimbursementFormScreen({super.key, this.initialRequest});

  @override
  ConsumerState<ReimbursementFormScreen> createState() => _ReimbursementFormScreenState();
}

class _ReimbursementFormScreenState extends ConsumerState<ReimbursementFormScreen> {
  final _notesController = TextEditingController();
  final _costCenters = [
    'Canadian - Cost Center',
    'Chang Jiang - Cost Center',
    'Chenab - Cost Center',
    'Chindwin - Cost Center',
    'Chu - Cost Center',
  ];
  final _reimbursementTypes = ['Fuel', 'Parking', 'Travel', 'Food', 'Medical', 'Education', 'Accommodation', 'Other'];

  @override
  void initState() {
    super.initState();
    if (widget.initialRequest != null) {
      _notesController.text = widget.initialRequest!.notes;
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(reimbursementFormStateProvider(widget.initialRequest));
    final notifier = ref.read(reimbursementFormStateProvider(widget.initialRequest).notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.initialRequest == null ? 'Create Reimbursement' : 'Reimbursement Detail', style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (formState.errorMessage != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
                child: Text(formState.errorMessage!, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
              )
            ],

            // Read only Document Number
            _buildFieldLabel('Document Number (Auto Generated)'),
            TextFormField(
              initialValue: formState.documentNumber,
              readOnly: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),

            // Date picker field selector
            _buildFieldLabel('Reimbursement Date'),
            InkWell(
              onTap: !formState.status.name.contains('newStatus') ? null : () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: formState.date,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (picked != null) notifier.setDate(picked);
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(DateFormat('dd/MM/yyyy').format(formState.date), style: const TextStyle(fontSize: 16)),
                    const Icon(Icons.calendar_today, color: AppTheme.primaryBlue),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Document Type drop-down selector
            _buildFieldLabel('Document Type *'),
            DropdownButtonFormField<DocumentType>(
              initialValue: formState.documentType,
              items: DocumentType.values.map((type) {
                return DropdownMenuItem(value: type, child: Text(type.displayName));
              }).toList(),
              onChanged: !formState.status.name.contains('newStatus') ? null : (v) {
                if (v != null) notifier.setDocumentType(v);
              },
              decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
            ),
            const SizedBox(height: 16),

            // Read only Approval status badge
            _buildFieldLabel('Approval Status'),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
              child: Text(formState.status.displayName, style: const TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.bold)),
            ),
            const Divider(height: 40),

            // Line items list heading and insertion call
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Line Items', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                if (formState.status == ReimbursementStatus.newStatus)
                  ElevatedButton.icon(
                    key: const Key('add_line_item_button'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryBlue, foregroundColor: Colors.white),
                    onPressed: () => _showAddLineItemDialog(context, notifier),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Item'),
                  )
              ],
            ),
            const SizedBox(height: 12),

            if (formState.lineItems.isEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200)),
                child: const Center(child: Text('No line items added yet.', style: TextStyle(color: Colors.grey))),
              )
            ] else ...[
              ...formState.lineItems.map((item) => _buildLineItemCard(item, formState.status == ReimbursementStatus.newStatus, notifier)),
            ],
            const Divider(height: 40),

            // Calculations Totals Box Dashboard Panel
            _buildCalculationsSummary(formState),
            const SizedBox(height: 16),

            // Notes field
            _buildFieldLabel('Notes / Remarks'),
            TextFormField(
              controller: _notesController,
              maxLines: 3,
              readOnly: formState.status != ReimbursementStatus.newStatus,
              onChanged: (val) => notifier.setNotes(val),
              decoration: InputDecoration(hintText: 'Enter additional remarks...', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
            ),
            const SizedBox(height: 32),

            // Action Panel
            if (formState.status == ReimbursementStatus.newStatus) _buildFormActions(notifier, formState),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(label, style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w600, fontSize: 14)),
    );
  }

  Widget _buildCalculationsSummary(ReimbursementFormState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
      child: Column(
        children: [
          _buildSummaryRow('Total Bill Amount:', '₹${state.totalBillAmount.toStringAsFixed(2)}', Colors.black87),
          const SizedBox(height: 8),
          _buildSummaryRow('Total Claim Amount:', '₹${state.totalClaimAmount.toStringAsFixed(2)}', AppTheme.primaryBlue),
          const SizedBox(height: 8),
          _buildSummaryRow('Remaining Claim Balance:', '₹${(state.totalBillAmount - state.totalClaimAmount).toStringAsFixed(2)}', Colors.grey),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, Color valColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: valColor, fontSize: 15)),
      ],
    );
  }

  Widget _buildLineItemCard(ReimbursementLineItem item, bool editable, ReimbursementFormNotifier notifier) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: Colors.grey.shade200)),
      color: Colors.grey.shade50,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item.type, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryBlue)),
                if (editable)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => notifier.removeLineItem(item.id),
                  )
              ],
            ),
            const SizedBox(height: 4),
            Text('Cost Center: ${item.costCenter}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
            Text('Desc: ${item.description}', style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
            Text('Ref/Bill #: ${item.billRefNo}', style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
            Text('Date: ${DateFormat('dd/MM/yyyy').format(item.date)}', style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
            const Divider(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Bill: ₹${item.billAmount}', style: const TextStyle(fontWeight: FontWeight.w600)),
                Text('Claim: ₹${item.claimAmount}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryBlue)),
              ],
            ),
            if (item.attachment != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.attach_file, size: 14, color: Colors.green),
                  const SizedBox(width: 4),
                  Text(item.attachment!.fileName, style: const TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildFormActions(ReimbursementFormNotifier notifier, ReimbursementFormState state) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), side: const BorderSide(color: AppTheme.primaryBlue)),
            onPressed: state.isSaving ? null : () async {
              final messenger = ScaffoldMessenger.of(context);
              final navigator = Navigator.of(context);
              final success = await notifier.saveDraft();
              if (success && mounted) {
                messenger.showSnackBar(const SnackBar(content: Text('Draft saved successfully!'), backgroundColor: AppTheme.success));
                navigator.pop();
              }
            },
            child: state.isSaving ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Save Draft'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            key: const Key('submit_reimbursement_button'),
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), backgroundColor: Colors.green, foregroundColor: Colors.white),
            onPressed: state.isSaving ? null : () => _confirmSubmission(context, notifier),
            child: const Text('Submit Request'),
          ),
        ),
      ],
    );
  }

  void _confirmSubmission(BuildContext context, ReimbursementFormNotifier notifier) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Submission'),
        content: const Text('Are you sure you want to finalize and submit this reimbursement request? It will be locked for editing.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              final navigator = Navigator.of(context);
              Navigator.pop(ctx);
              final success = await notifier.submitRequest();
              if (success && mounted) {
                messenger.showSnackBar(const SnackBar(content: Text('Reimbursement submitted successfully!'), backgroundColor: AppTheme.success));
                navigator.pop();
              }
            },
            child: const Text('Confirm Submit'),
          )
        ],
      ),
    );
  }

  void _showAddLineItemDialog(BuildContext context, ReimbursementFormNotifier notifier) {
    String selectedType = _reimbursementTypes.first;
    String selectedCostCenter = _costCenters.first;
    final descCtrl = TextEditingController();
    final refCtrl = TextEditingController();
    final billCtrl = TextEditingController();
    final claimCtrl = TextEditingController();
    DateTime itemDate = DateTime.now();
    ReimbursementAttachment? chosenAttachment;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, top: 20, left: 16, right: 16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Add Line Item', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.primaryBlue)),
                    const SizedBox(height: 16),

                    _buildFieldLabel('Reimbursement Type *'),
                    DropdownButtonFormField<String>(
                      initialValue: selectedType,
                      items: _reimbursementTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                      onChanged: (v) => setModalState(() => selectedType = v!),
                      decoration: const InputDecoration(border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 12),

                    _buildFieldLabel('Cost Center (Searchable) *'),
                    DropdownButtonFormField<String>(
                      initialValue: selectedCostCenter,
                      items: _costCenters.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                      onChanged: (v) => setModalState(() => selectedCostCenter = v!),
                      decoration: const InputDecoration(border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 12),

                    _buildFieldLabel('Description *'),
                    TextField(controller: descCtrl, decoration: const InputDecoration(border: OutlineInputBorder())),
                    const SizedBox(height: 12),

                    _buildFieldLabel('Bill / Ref Number'),
                    TextField(controller: refCtrl, decoration: const InputDecoration(border: OutlineInputBorder())),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel('Bill Amount *'),
                              TextField(controller: billCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(border: OutlineInputBorder())),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel('Claim Amount *'),
                              TextField(controller: claimCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(border: OutlineInputBorder())),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            setModalState(() {
                              chosenAttachment = const ReimbursementAttachment(fileName: 'receipt_upload.png', status: AttachmentStatus.uploaded);
                            });
                          },
                          icon: const Icon(Icons.attach_file),
                          label: const Text('Attach File'),
                        ),
                        if (chosenAttachment != null)
                          Text(chosenAttachment!.fileName, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold))
                      ],
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryBlue, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
                        onPressed: () {
                          final billAmt = double.tryParse(billCtrl.text) ?? 0.0;
                          final claimAmt = double.tryParse(claimCtrl.text) ?? 0.0;
                          
                          if (descCtrl.text.isEmpty || billCtrl.text.isEmpty || claimCtrl.text.isEmpty) {
                            ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Please fill all mandatory fields.')));
                            return;
                          }
                          if (billAmt < 0 || claimAmt < 0) {
                            ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Amounts cannot be negative.')));
                            return;
                          }
                          if (claimAmt > billAmt) {
                            ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Claim amount cannot exceed bill amount.')));
                            return;
                          }

                          notifier.addLineItem(ReimbursementLineItem(
                            id: DateTime.now().microsecondsSinceEpoch.toString(),
                            type: selectedType,
                            costCenter: selectedCostCenter,
                            description: descCtrl.text,
                            billRefNo: refCtrl.text,
                            date: itemDate,
                            billAmount: billAmt,
                            claimAmount: claimAmt,
                            attachment: chosenAttachment,
                          ));
                          Navigator.pop(ctx);
                        },
                        child: const Text('Add Line Item'),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
