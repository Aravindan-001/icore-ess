import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import 'profile_provider.dart';

class BankInformationScreen extends ConsumerStatefulWidget {
  const BankInformationScreen({super.key});

  @override
  ConsumerState<BankInformationScreen> createState() => _BankInformationScreenState();
}

class _BankInformationScreenState extends ConsumerState<BankInformationScreen> {
  bool _isAccountVisible = false;

  @override
  Widget build(BuildContext context) {
    final bankInfoAsync = ref.watch(bankInfoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bank Information'),
      ),
      body: bankInfoAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => const Center(child: Text('Error loading information')),
        data: (bank) => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.2), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Salary Account',
                          style: TextStyle(color: AppTheme.primaryBlue, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        const Icon(Icons.account_balance, color: AppTheme.primaryBlue, size: 20),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      bank.bankName,
                      style: const TextStyle(
                        color: AppTheme.textMain,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'ACCOUNT NUMBER',
                              style: TextStyle(color: AppTheme.textMuted, fontSize: 10, letterSpacing: 1),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _isAccountVisible ? bank.accountNumber : bank.maskedAccountNumber,
                              style: const TextStyle(
                                color: AppTheme.textMain,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(
                            _isAccountVisible ? Icons.visibility_off : Icons.visibility,
                            color: AppTheme.primaryBlue,
                          ),
                          onPressed: () => setState(() => _isAccountVisible = !_isAccountVisible),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'ACCOUNT HOLDER',
                                style: TextStyle(color: AppTheme.textMuted, fontSize: 10, letterSpacing: 1),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                bank.accountHolder,
                                style: const TextStyle(color: AppTheme.textMain, fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'BRANCH',
                              style: TextStyle(color: AppTheme.textMuted, fontSize: 10, letterSpacing: 1),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              bank.branch,
                              style: const TextStyle(color: AppTheme.textMain, fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _buildInfoTile('IBAN', bank.iban),
              if (bank.swiftCode != null) _buildInfoTile('SWIFT/BIC Code', bank.swiftCode!),
              const SizedBox(height: 20),
              const Card(
                color: Color(0xFFF0F9FF),
                elevation: 0,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: AppTheme.primaryBlue, size: 20),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'To update your bank details, please contact the HR department or submit a profile update request.',
                          style: TextStyle(fontSize: 12, color: AppTheme.primaryBlue),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textMain),
        ),
        const Divider(height: 32),
      ],
    );
  }
}
