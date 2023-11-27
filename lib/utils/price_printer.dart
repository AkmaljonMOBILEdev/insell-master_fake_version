import 'dart:io';
import 'package:easy_sell/services/storage_services.dart';
import 'package:easy_sell/utils/printer.dart';
import 'package:easy_sell/utils/utils.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<void> buildPricePdf(List<PrinterBarcode> barcodes) async {
  try {
    Storage storage = Storage();
    String printerName = await storage.read('pricePrinter') ?? 'Gainscha GS-2408D';
    final pdf = pw.Document();

    for (PrinterBarcode barcode in barcodes) {
      pdf.addPage(
        pw.Page(
          orientation: pw.PageOrientation.landscape,
          pageFormat: const PdfPageFormat(38 * PdfPageFormat.mm, 60 * PdfPageFormat.mm, marginAll: 2 * PdfPageFormat.mm),
          build: (pw.Context context) {
            return pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  flex: 8,
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    mainAxisSize: pw.MainAxisSize.max,
                    children: [
                      pw.Text(formatNumber(double.parse(firstNumber(barcode.lastPrice))),
                          style: pw.TextStyle(fontSize: 40, fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(width: 5),
                      pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        mainAxisSize: pw.MainAxisSize.max,
                        children: [
                          pw.Text(lastThreeNumber(barcode.lastPrice),
                              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                          pw.Text("so'm", style: const pw.TextStyle(fontSize: 9)),
                        ],
                      ),
                    ],
                  ),
                ),
                pw.Expanded(
                  flex: 10,
                  child: pw.Center(
                      child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                        pw.SizedBox(height: 5),
                        pw.Text(
                          barcode.product.name,
                          style: const pw.TextStyle(fontSize: 10),
                          textAlign: pw.TextAlign.center,
                          maxLines: 1,
                          overflow: pw.TextOverflow.clip,
                        ),
                        pw.Text(
                          barcode.product.code ?? '',
                          style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
                        ),
                        pw.SvgImage(
                          svg: generateEan13Image(barcode, width: 38 * 2, height: 20),
                          height: 20,
                          width: 38 * 2,
                        ),
                      ])),
                )
              ],
            );
          },
        ),
      );
    }
    final filePdf = File('buildPricePdf.pdf');
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
