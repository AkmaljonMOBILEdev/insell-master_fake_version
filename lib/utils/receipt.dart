import 'dart:io';
import 'package:easy_sell/services/storage_services.dart';
import 'package:easy_sell/utils/utils.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../database/model/trade_dto.dart';
import '../database/model/trade_product_data_dto.dart';
import '../database/my_database.dart';
import '../generated/assets.dart';

class GetAppReceipt {
  Storage storage = Storage();

  Future<void> buildTradeReceipt(
      {ClientData? client,
      required TradeDTO trade,
      EmployeeData? employee,
      required double totalSum,
      double? payment,
      double discount = 0,
      double? refund}) async {
    // final imageQr = pw.MemoryImage(await File(Assets.receiptQrcode).readAsBytes());
    var selectedReceiptPrinter = await storage.read('receiptPrinter');
    var qrcode = await rootBundle.load(Assets.checkQrcode);
    var brand = await rootBundle.load(Assets.checkBrand);
    var qrCodeImage = pw.MemoryImage(qrcode.buffer.asUint8List());
    var brandImage = pw.MemoryImage(brand.buffer.asUint8List());
    // var shopName = await storage.read('shopName');
    // String logo = 'InSell';
    final font = await rootBundle.load(Assets.fontsRobotoRegular);
    final ttf = pw.Font.ttf(font);
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: const PdfPageFormat(76 * PdfPageFormat.mm, double.infinity, marginAll: 5 * PdfPageFormat.mm),
        build: (pw.Context context) {
          return pw.Column(
            children: [
              // pw.Center(child: pw.Text(logo, style: pw.TextStyle(fontSize: 20, font: ttf))),
              pw.Image(brandImage, width: 150, height: 150),
              pw.Text('****************************************************', style: pw.TextStyle(fontSize: 8, font: ttf)),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Документ:', style: pw.TextStyle(fontSize: 8, font: ttf)),
                  pw.Text('#${trade.trade.id}', style: pw.TextStyle(fontSize: 8, font: ttf)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Сана:', style: pw.TextStyle(fontSize: 8, font: ttf)),
                  pw.Text(formatDateTime(trade.trade.finishedAt ?? DateTime.now()), style: pw.TextStyle(fontSize: 8, font: ttf)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Харидор:', style: pw.TextStyle(fontSize: 8, font: ttf)),
                  pw.Text(client?.name ?? '', style: pw.TextStyle(fontSize: 8, font: ttf)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Сотувчи:', style: pw.TextStyle(fontSize: 8, font: ttf)),
                  pw.Text('${employee?.firstName ?? ''} ${employee?.lastName ?? ''}',
                      style: pw.TextStyle(fontSize: 8, font: ttf)),
                ],
              ),
              pw.Text('--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---',
                  style: pw.TextStyle(fontSize: 10, font: ttf)),
              pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: trade.tradeProducts.map(
                    (tradeProduct) {
                      List<TradeProductDataDto> data = trade.data;
                      TradeProductDataDto currentProductData = data[trade.tradeProducts.indexOf(tradeProduct)];
                      return pw.Column(children: [
                        pw.Column(
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                  '${trade.tradeProducts.indexOf(tradeProduct) + 1}. ${tradeProduct.product.productData.vendorCode}  /  ${tradeProduct.product.productData.name}',
                                  style: pw.TextStyle(fontSize: 8, font: ttf)),
                              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                                pw.SizedBox(width: 16),
                                pw.Expanded(
                                  child: pw.Text(
                                      '${formatNumber(currentProductData.amount)}   *   ${formatNumber(currentProductData.price)}',
                                      style: pw.TextStyle(fontSize: 8, font: ttf)),
                                ),
                                pw.Expanded(
                                  child:
                                      pw.Text(' = ', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 8, font: ttf)),
                                ),
                                pw.Text(formatNumber(currentProductData.amount * currentProductData.price),
                                    style: pw.TextStyle(fontSize: 8, font: ttf)),
                              ])
                            ])
                      ]);
                    },
                  ).toList()),
              pw.Text('--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---',
                  style: pw.TextStyle(fontSize: 10, font: ttf)),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Умумий Сум:', style: pw.TextStyle(fontSize: 8, font: ttf)),
                  pw.Text(formatNumber(totalSum), style: pw.TextStyle(fontSize: 8, font: ttf)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Чегирма:', style: pw.TextStyle(fontSize: 8, font: ttf)),
                  pw.Text(formatNumber(trade.trade.discount ?? discount), style: pw.TextStyle(fontSize: 8, font: ttf)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Жами:', style: pw.TextStyle(fontSize: 12, font: ttf, fontWeight: pw.FontWeight.bold)),
                  pw.Text(formatNumber((totalSum) - (trade.trade.discount ?? discount)),
                      style: pw.TextStyle(fontSize: 12, font: ttf)),
                ],
              ),
              pw.Text('--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---',
                  style: pw.TextStyle(fontSize: 10, font: ttf)),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Туланган сумма:', style: pw.TextStyle(fontSize: 8, font: ttf)),
                  pw.Text(formatNumber(payment), style: pw.TextStyle(fontSize: 8, font: ttf)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Кайтим:', style: pw.TextStyle(fontSize: 8, font: ttf)),
                  pw.Text(formatNumber(refund ?? trade.trade.refund), style: pw.TextStyle(fontSize: 8, font: ttf)),
                ],
              ),
              pw.Text('--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---',
                  style: pw.TextStyle(fontSize: 10, font: ttf)),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Кассир Имзоси:', style: pw.TextStyle(fontSize: 8, font: ttf)),
                  pw.Text('^', style: pw.TextStyle(fontSize: 8, font: ttf)),
                ],
              ),
              pw.Text('--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---',
                  style: pw.TextStyle(fontSize: 10, font: ttf)),
              // pw.Text('****************************************************', style: pw.TextStyle(fontSize: 8, font: ttf)),
              // pw.Text('Махсулотларни кайтариш ёки алмаштириш харид чеки оркали Бир кун муддат ичида амалга оширилади',
              //     textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 8, font: ttf)),
              pw.Text('****************************************************', style: pw.TextStyle(fontSize: 8, font: ttf)),
              pw.Text('ХАРИДИНГИЗ УЧУН РАХМАТ!', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 9, font: ttf)),
              pw.Text('****************************************************', style: pw.TextStyle(fontSize: 8, font: ttf)),
              pw.SizedBox(height: 16),
              pw.Image(qrCodeImage, width: 100, height: 100),
            ],
          );
        },
      ),
    );
    final file = File('trade_receipt.pdf');
    file.writeAsBytesSync(await pdf.save());
    Process.run('PDFtoPrinter.exe', [file.path, selectedReceiptPrinter ?? '']);
  }
}
