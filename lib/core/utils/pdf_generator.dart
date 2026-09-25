import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/payslip.dart';

class PdfGenerator {
  static Future<File> generatePayslipPdf(PayslipDetail detail) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('PAYSLIP', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              
              // Header Table 1
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      _buildPdfHeaderCell('Employee ID & Name'),
                      _buildPdfHeaderCell('Department & Designation'),
                      _buildPdfHeaderCell('Location & Currency'),
                      _buildPdfHeaderCell('Pay Period'),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _buildPdfDataCell('${detail.employeeId}\n${detail.employeeName}'),
                      _buildPdfDataCell('${detail.department}\n${detail.designation}'),
                      _buildPdfDataCell('${detail.location}\n${detail.currency}'),
                      _buildPdfDataCell(detail.payPeriod),
                    ],
                  ),
                ],
              ),
              
              // Header Table 2
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      _buildPdfHeaderCell('Pay Mode & D.O.J'),
                      _buildPdfHeaderCell('Bank & Account No'),
                      _buildPdfHeaderCell('Hours Breakup'),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _buildPdfDataCell('${detail.payMode}\n${detail.dateOfJoining}'),
                      _buildPdfDataCell('${detail.bankName ?? ''}\n${detail.accountNumber ?? ''}'),
                      _buildPdfDataCell('Work Days: ${detail.workDays}\nPaid Leave: ${detail.paidLeave.toStringAsFixed(2)}\nOT Hrs: ${detail.otHours.toStringAsFixed(0)}\nLOP: ${detail.lop.toStringAsFixed(2)}'),
                    ],
                  ),
                ],
              ),
              
              pw.SizedBox(height: 20),
              
              // Earnings & Deductions Table
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Earnings Column
                  pw.Expanded(
                    child: pw.Table(
                      border: pw.TableBorder.all(color: PdfColors.grey),
                      children: [
                        pw.TableRow(
                          decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                          children: [
                            _buildPdfHeaderCell('Earnings'),
                            _buildPdfHeaderCell('Amount', alignRight: true),
                          ],
                        ),
                        ...detail.earnings.map((e) => pw.TableRow(
                          children: [
                            _buildPdfDataCell(e.name),
                            _buildPdfDataCell(e.amount.toStringAsFixed(2), alignRight: true),
                          ],
                        )),
                        // Padding rows if needed to match height
                        ...List.generate(max(0, detail.deductions.length - detail.earnings.length), (_) => pw.TableRow(
                          children: [ _buildPdfDataCell(''), _buildPdfDataCell(''), ],
                        )),
                        pw.TableRow(
                          decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                          children: [
                            _buildPdfDataCell('Total Earnings', isBold: true, alignRight: true),
                            _buildPdfDataCell(detail.totalEarnings.toStringAsFixed(2), isBold: true, alignRight: true),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Deductions Column
                  pw.Expanded(
                    child: pw.Table(
                      border: pw.TableBorder.all(color: PdfColors.grey),
                      children: [
                        pw.TableRow(
                          decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                          children: [
                            _buildPdfHeaderCell('Deductions'),
                            _buildPdfHeaderCell('Amount', alignRight: true),
                          ],
                        ),
                        ...detail.deductions.map((d) => pw.TableRow(
                          children: [
                            _buildPdfDataCell(d.name),
                            _buildPdfDataCell(d.amount.toStringAsFixed(2), alignRight: true),
                          ],
                        )),
                        ...List.generate(max(0, detail.earnings.length - detail.deductions.length), (_) => pw.TableRow(
                          children: [ _buildPdfDataCell(''), _buildPdfDataCell(''), ],
                        )),
                        pw.TableRow(
                          decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                          children: [
                            _buildPdfDataCell('Total Deductions', isBold: true, alignRight: true),
                            _buildPdfDataCell(detail.totalDeductions.toStringAsFixed(2), isBold: true, alignRight: true),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              pw.SizedBox(height: 10),
              
              // Net Pay
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Container(
                    width: 200,
                    padding: const pw.EdgeInsets.all(5),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.grey300,
                      border: pw.TableBorder.all(color: PdfColors.grey),
                    ),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Net Pay:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text(detail.netPay.toStringAsFixed(2), style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    Directory output;
    try {
      output = await getTemporaryDirectory();
    } catch (_) {
      output = Directory.systemTemp;
    }
    final file = File("${output.path}/payslip_${detail.payPeriod}.pdf");
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static pw.Widget _buildPdfHeaderCell(String text, {bool alignRight = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(
        text,
        textAlign: alignRight ? pw.TextAlign.right : pw.TextAlign.left,
        style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  static pw.Widget _buildPdfDataCell(String text, {bool isBold = false, bool alignRight = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(
        text,
        textAlign: alignRight ? pw.TextAlign.right : pw.TextAlign.left,
        style: pw.TextStyle(fontSize: 10, fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal),
      ),
    );
  }

  static int max(int a, int b) => a > b ? a : b;

  static Future<void> shareFile(File file) async {
    await Share.shareXFiles([XFile(file.path)], text: 'My Payslip');
  }
}
