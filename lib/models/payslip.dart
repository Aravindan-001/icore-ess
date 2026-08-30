class Payslip {
  final String month;
  final String year;
  final double basicSalary;
  final double allowances;
  final double deductions;
  final double netSalary;

  Payslip({
    required this.month,
    required this.year,
    required this.basicSalary,
    required this.allowances,
    required this.deductions,
    required this.netSalary,
  });

  double get grossSalary => basicSalary + allowances;
}
