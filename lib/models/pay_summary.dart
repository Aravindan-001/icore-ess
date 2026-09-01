class PaySummary {
  final double annualGrossPay;
  final double totalDeductionsYtd;
  final double netPayYtd;
  final List<MonthlyPay> monthlyBreakdown;

  PaySummary({
    required this.annualGrossPay,
    required this.totalDeductionsYtd,
    required this.netPayYtd,
    required this.monthlyBreakdown,
  });
}

class MonthlyPay {
  final String month;
  final double amount;

  MonthlyPay({required this.month, required this.amount});
}
