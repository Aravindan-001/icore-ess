import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:icore_ess/core/utils/pdf_generator.dart';
import 'package:icore_ess/models/payslip.dart';
import 'package:icore_ess/services/mock/mock_data_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PDF-001 — Payslip Filename Sanitization & Path Traversal Protection', () {
    final baseDetail = MockDataService.getMockPayslipDetail('2025', 'January');

    test('1. Normal value: JAN-2025 produces safe filename payslip_JAN-2025.pdf', () {
      final filename = PdfGenerator.sanitizePayslipFilename('JAN-2025');
      expect(filename, equals('payslip_JAN-2025.pdf'));
    });

    test('2. Slash: JAN/2025 cannot create a subdirectory/path', () {
      final filename = PdfGenerator.sanitizePayslipFilename('JAN/2025');
      expect(filename, equals('payslip_JAN2025.pdf'));
      expect(filename, isNot(contains('/')));
    });

    test('3. Backslash: JAN\\2025 cannot create a Windows path', () {
      final filename = PdfGenerator.sanitizePayslipFilename('JAN\\2025');
      expect(filename, equals('payslip_JAN2025.pdf'));
      expect(filename, isNot(contains('\\')));
    });

    test('4. Unix traversal: ../../secret cannot escape output directory', () {
      final filename = PdfGenerator.sanitizePayslipFilename('../../secret');
      expect(filename, equals('payslip_secret.pdf'));
      expect(filename, isNot(contains('..')));
      expect(filename, isNot(contains('/')));
    });

    test('5. Windows traversal: ....\\secret cannot escape output directory', () {
      final filename = PdfGenerator.sanitizePayslipFilename('....\\secret');
      expect(filename, equals('payslip_secret.pdf'));
      expect(filename, isNot(contains('..')));
      expect(filename, isNot(contains('\\')));
    });

    test('6. Absolute Unix path: /tmp/secret cannot become an absolute path', () {
      final filename = PdfGenerator.sanitizePayslipFilename('/tmp/secret');
      expect(filename, equals('payslip_tmpsecret.pdf'));
      expect(filename, isNot(startsWith('/')));
    });

    test('7. Windows absolute path: C:\\Users\\Test\\secret cannot become an absolute path', () {
      final filename = PdfGenerator.sanitizePayslipFilename('C:\\Users\\Test\\secret');
      expect(filename, equals('payslip_CUsersTestsecret.pdf'));
      expect(filename, isNot(contains(':')));
      expect(filename, isNot(contains('\\')));
    });

    test('8. Empty string falls back to payslip.pdf', () {
      final filename = PdfGenerator.sanitizePayslipFilename('');
      expect(filename, equals('payslip.pdf'));
    });

    test('9. Whitespace-only value falls back to payslip.pdf', () {
      final filename = PdfGenerator.sanitizePayslipFilename('   \t\n ');
      expect(filename, equals('payslip.pdf'));
    });

    test('10. Control/special characters are safely stripped', () {
      final filename = PdfGenerator.sanitizePayslipFilename('JAN\x00\x1f-2025!@#\$%^&*()');
      expect(filename, equals('payslip_JAN-2025.pdf'));
    });

    test('11. Existing valid JAN-2025 behavior remains unchanged', () {
      final filename = PdfGenerator.sanitizePayslipFilename(baseDetail.payPeriod);
      expect(filename, equals('payslip_JAN-2025.pdf'));
    });

    test('12. Verify resulting file path remains inside intended output directory', () async {
      final detail = baseDetail.copyWith(payPeriod: '../../JAN-2025');
      final file = await PdfGenerator.generatePayslipPdf(detail);

      Directory expectedDir;
      try {
        expectedDir = await getTemporaryDirectory();
      } catch (_) {
        expectedDir = Directory.systemTemp;
      }

      // Ensure generated file path resides strictly inside expected temporary directory
      expect(file.path, startsWith(expectedDir.path));
      expect(file.parent.path, equals(expectedDir.path));
      expect(file.path.endsWith('payslip_JAN-2025.pdf'), isTrue);
    });
  });
}

extension on PayslipDetail {
  PayslipDetail copyWith({String? payPeriod}) {
    return PayslipDetail(
      payPeriod: payPeriod ?? this.payPeriod,
      employeeId: employeeId,
      employeeName: employeeName,
      designation: designation,
      department: department,
      location: location,
      currency: currency,
      payMode: payMode,
      dateOfJoining: dateOfJoining,
      bankName: bankName,
      accountNumber: accountNumber,
      workDays: workDays,
      paidLeave: paidLeave,
      otHours: otHours,
      lop: lop,
      earnings: earnings,
      deductions: deductions,
      totalEarnings: totalEarnings,
      totalDeductions: totalDeductions,
      netPay: netPay,
      documentUrl: documentUrl,
    );
  }
}
