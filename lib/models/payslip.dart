class Payslip {
  final String month;
  final String year;
  final double netSalary;
  final String currency;

  Payslip({
    required this.month,
    required this.year,
    required this.netSalary,
    required this.currency,
  });

  factory Payslip.fromJson(Map<String, dynamic> json) {
    return Payslip(
      month: json['month'] ?? '',
      year: json['year'] ?? '',
      netSalary: (json['netSalary'] ?? 0).toDouble(),
      currency: json['currency'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'year': year,
      'netSalary': netSalary,
      'currency': currency,
    };
  }

  String get payPeriod => '${month.substring(0, 3).toUpperCase()}-$year';
}

class PayslipDetail {
  final String employeeId;
  final String employeeName;
  final String department;
  final String designation;
  final String location;
  final String currency;
  final String payPeriod;
  final String payMode;
  final String dateOfJoining;
  final String? bankName;
  final String? accountNumber;
  final int workDays;
  final double paidLeave;
  final double otHours;
  final double lop;
  final List<SalaryComponent> earnings;
  final List<SalaryComponent> deductions;
  final double totalEarnings;
  final double totalDeductions;
  final double netPay;
  final String? documentUrl;

  PayslipDetail({
    required this.employeeId,
    required this.employeeName,
    required this.department,
    required this.designation,
    required this.location,
    required this.currency,
    required this.payPeriod,
    required this.payMode,
    required this.dateOfJoining,
    this.bankName,
    this.accountNumber,
    required this.workDays,
    required this.paidLeave,
    required this.otHours,
    required this.lop,
    required this.earnings,
    required this.deductions,
    required this.totalEarnings,
    required this.totalDeductions,
    required this.netPay,
    this.documentUrl,
  });

  factory PayslipDetail.fromJson(Map<String, dynamic> json) {
    return PayslipDetail(
      employeeId: json['employeeId'] ?? '',
      employeeName: json['employeeName'] ?? '',
      department: json['department'] ?? '',
      designation: json['designation'] ?? '',
      location: json['location'] ?? '',
      currency: json['currency'] ?? '',
      payPeriod: json['payPeriod'] ?? '',
      payMode: json['payMode'] ?? '',
      dateOfJoining: json['dateOfJoining'] ?? '',
      bankName: json['bankName'],
      accountNumber: json['accountNumber'],
      workDays: json['workDays'] ?? 0,
      paidLeave: (json['paidLeave'] ?? 0).toDouble(),
      otHours: (json['otHours'] ?? 0).toDouble(),
      lop: (json['lop'] ?? 0).toDouble(),
      earnings: (json['earnings'] as List? ?? []).map((e) => SalaryComponent.fromJson(e)).toList(),
      deductions: (json['deductions'] as List? ?? []).map((e) => SalaryComponent.fromJson(e)).toList(),
      totalEarnings: (json['totalEarnings'] ?? 0).toDouble(),
      totalDeductions: (json['totalDeductions'] ?? 0).toDouble(),
      netPay: (json['netPay'] ?? 0).toDouble(),
      documentUrl: json['documentUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employeeId': employeeId,
      'employeeName': employeeName,
      'department': department,
      'designation': designation,
      'location': location,
      'currency': currency,
      'payPeriod': payPeriod,
      'payMode': payMode,
      'dateOfJoining': dateOfJoining,
      'bankName': bankName,
      'accountNumber': accountNumber,
      'workDays': workDays,
      'paidLeave': paidLeave,
      'otHours': otHours,
      'lop': lop,
      'earnings': earnings.map((e) => e.toJson()).toList(),
      'deductions': deductions.map((e) => e.toJson()).toList(),
      'totalEarnings': totalEarnings,
      'totalDeductions': totalDeductions,
      'netPay': netPay,
      'documentUrl': documentUrl,
    };
  }
}

class SalaryComponent {
  final String name;
  final double amount;

  SalaryComponent({
    required this.name,
    required this.amount,
  });

  factory SalaryComponent.fromJson(Map<String, dynamic> json) {
    return SalaryComponent(
      name: json['name'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
    };
  }
}
