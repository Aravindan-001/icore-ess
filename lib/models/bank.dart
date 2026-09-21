class BankInformation {
  final String bankName;
  final String accountNumber;
  final String accountHolder;
  final String branch;
  final String iban;
  final String? swiftCode;

  BankInformation({
    required this.bankName,
    required this.accountNumber,
    required this.accountHolder,
    required this.branch,
    required this.iban,
    this.swiftCode,
  });

  String get maskedAccountNumber {
    if (accountNumber.length < 4) return accountNumber;
    final lastFour = accountNumber.substring(accountNumber.length - 4);
    return '**** **** $lastFour';
  }
}
