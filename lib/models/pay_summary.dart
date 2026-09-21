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

  factory PaySummary.fromJson(Map<String, dynamic> json) {
    return PaySummary(
      annualGrossPay: (json['annualGrossPay'] ?? 0).toDouble(),
      totalDeductionsYtd: (json['totalDeductionsYtd'] ?? 0).toDouble(),
      netPayYtd: (json['netPayYtd'] ?? 0).toDouble(),
      monthlyBreakdown: (json['monthlyBreakdown'] as List? ?? []).map((e) => MonthlyPay.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'annualGrossPay': annualGrossPay,
      'totalDeductionsYtd': totalDeductionsYtd,
      'netPayYtd': netPayYtd,
      'monthlyBreakdown': monthlyBreakdown.map((e) => e.toJson()).toList(),
    };
  }
}

class MonthlyPay {
  final String month;
  final double amount;

  MonthlyPay({required this.month, required this.amount});

  factory MonthlyPay.fromJson(Map<String, dynamic> json) {
    return MonthlyPay(
      month: json['month'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'amount': amount,
    };
  }
}
