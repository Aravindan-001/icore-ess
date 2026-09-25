import 'payslip.dart';

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
      monthlyBreakdown: (json['monthlyBreakdown'] as List? ?? [])
          .map((e) => MonthlyPay.fromJson(e))
          .toList(),
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
  final String? year;
  final double? grossPay;
  final double? totalDeductions;
  final List<SalaryComponent>? earnings;
  final List<SalaryComponent>? deductions;

  MonthlyPay({
    required this.month,
    required this.amount,
    this.year,
    this.grossPay,
    this.totalDeductions,
    this.earnings,
    this.deductions,
  });

  factory MonthlyPay.fromJson(Map<String, dynamic> json) {
    return MonthlyPay(
      month: json['month'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      year: json['year'],
      grossPay: json['grossPay'] != null ? (json['grossPay'] as num).toDouble() : null,
      totalDeductions: json['totalDeductions'] != null ? (json['totalDeductions'] as num).toDouble() : null,
      earnings: json['earnings'] != null
          ? (json['earnings'] as List).map((e) => SalaryComponent.fromJson(e)).toList()
          : null,
      deductions: json['deductions'] != null
          ? (json['deductions'] as List).map((e) => SalaryComponent.fromJson(e)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'amount': amount,
      if (year != null) 'year': year,
      if (grossPay != null) 'grossPay': grossPay,
      if (totalDeductions != null) 'totalDeductions': totalDeductions,
      if (earnings != null) 'earnings': earnings!.map((e) => e.toJson()).toList(),
      if (deductions != null) 'deductions': deductions!.map((e) => e.toJson()).toList(),
    };
  }
}
