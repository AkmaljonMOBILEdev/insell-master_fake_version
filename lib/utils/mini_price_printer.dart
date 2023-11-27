import 'dart:io';
import 'package:easy_sell/services/storage_services.dart';
import 'package:easy_sell/utils/printer.dart';
import 'package:easy_sell/utils/utils.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<void> buildMiniPrice(List<PrinterBarcode> barcodes) async {
  try {
    Storage storage = Storage();
    String printerName = await storage.read('codePrinter') ?? 'Xprinter XP-365B';
    final pdf = pw.Document();

    for (PrinterBarcode barcode in barcodes) {
      pdf.addPage(
        pw.Page(
          pageFormat: const PdfPageFormat(30 * PdfPageFormat.mm, 20 * PdfPageFormat.mm),
          build: (pw.Context context) {
            return pw.Container(
                child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(formatNumber(double.parse(firstNumber(barcode.lastPrice))),
                            style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(width: 3),
                        pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Text(lastThreeNumber(barcode.lastPrice),
                                style: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold)),
                            pw.Text("so'm", style: const pw.TextStyle(fontSize: 7)),
                          ],
                        ),
                      ],
                    ),
                    flex: 1),
                pw.Expanded(
                    child: pw.Center(
                      child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          children: [
                            if (barcode.isPer)
                              pw.Text(
                                "(1 donasi uchun)",
                                style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold),
                              ),
                            pw.SizedBox(height: 1),
                            pw.Text(
                              barcode.product.name,
                              style: const pw.TextStyle(fontSize: 7),
                              textAlign: pw.TextAlign.center,
                              maxLines: 1,
                              overflow: pw.TextOverflow.clip,
                            ),
                            pw.Text(
                              barcode.product.code ?? '',
                              style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
                              textAlign: pw.TextAlign.center,
                            ),
                          ]),
                    ),
                    flex: 1),
              ],
            ));
          },
        ),
      );
    }
    final filePdf = File('buildMiniPrice.pdf');
    filePdf.writeAsBytesSync(await pdf.save());
    await Process.run('PDFtoPrinter.exe', [filePdf.path, printerName]);
  } catch (e) {
    rethrow;
  }
}

String lastThreeNumber(double priceArg) {
  String price = priceArg.toStringAsFixed(0);
  if (price.length > 3) {
    return price.substring(price.length - 3);
  } else {
    return price;
  }
}

String firstNumber(double priceArg) {
  String price = priceArg.toStringAsFixed(0);
  if (price.length > 3) {
    return price.substring(0, price.length - 3);
  } else {
    return "";
  }
}
