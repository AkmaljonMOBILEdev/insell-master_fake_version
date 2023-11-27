import 'dart:io';
import 'package:barcode/barcode.dart';
import 'package:easy_sell/database/my_database.dart';
import 'package:easy_sell/generated/assets.dart';
import 'package:easy_sell/services/storage_services.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PrinterBarcode {
  final String barcodeValue;
  final String vendorCode;
  final double lastPrice;
  final ProductData product;
  final bool isPer;

  PrinterBarcode(
      {required this.barcodeValue, required this.vendorCode, required this.lastPrice, required this.product, this.isPer = false});
}

Future<void> buildBarcodePdf(List<PrinterBarcode> barcodes) async {
  Storage storage = Storage();
  String printerName = await storage.read('codePrinter') ?? 'Xprinter XP-365B';
  try {
    var data = await rootBundle.load(Assets.fontsEasySell);
    var myFont = pw.Font.ttf(data);
    final dm = Barcode.ean13();
    final pdf = pw.Document();
    for (PrinterBarcode barcode in barcodes) {
      final svg = dm.toSvg(barcode.barcodeValue, drawText: false);
      pdf.addPage(
        pw.Page(
          pageFormat: const PdfPageFormat(30 * PdfPageFormat.mm, 20 * PdfPageFormat.mm),
          build: (pw.Context context) {
            return pw.Column(
              children: [
                pw.Text(barcode.vendorCode, style: pw.TextStyle(fontSize: 9, font: myFont)),
                pw.Container(
                  margin: const pw.EdgeInsets.all(6),
                  child: pw.SvgImage(svg: svg.toString(), alignment: pw.Alignment.center),
                )
              ],
            );
          },
        ),
      );
    }
    final filePdf = File('barcode.pdf');
    filePdf.writeAsBytesSync(await pdf.save());
    await Process.run('PDFtoPrinter.exe', [filePdf.path, printerName]);
  } catch (e) {
    rethrow;
  }
}

String generateEan13Code(String code) {
  int sum = 0;
  for (int i = 0; i < code.length; i++) {
    if (i % 2 == 0) {
      sum += int.parse(code[i]) * 1;
    } else {
      sum += int.parse(code[i]) * 3;
    }
  }
  int checkSum = 10 - (sum % 10);
  if (checkSum == 10) {
    checkSum = 0;
  }
  return code + checkSum.toString();
}

String generateEan13Image(PrinterBarcode printerBarcode, {double width = 300, double height = 200}) {
  final dm = Barcode.ean13();
  return dm.toSvg(printerBarcode.barcodeValue, width: width, height: height, drawText: false).toString();
}

bool checkIsEan13Code(String code) {
  final dm = Barcode.ean13();
  return dm.isValid(code);
}
