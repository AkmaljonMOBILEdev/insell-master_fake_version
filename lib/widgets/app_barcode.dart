import 'package:easy_sell/database/my_database.dart';
import 'package:easy_sell/services/auto_sync.dart';
import 'package:easy_sell/utils/printer_widget/barcode_widget.dart';
import 'package:easy_sell/utils/printer_widget/price_widget.dart';
import 'package:easy_sell/utils/utils.dart';
import 'package:easy_sell/widgets/app_button.dart';
import 'package:easy_sell/widgets/app_dropdown.dart';
import 'package:easy_sell/widgets/app_input_underline.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
import '../constants/colors.dart';
import '../utils/mini_price_printer.dart';
import '../utils/price_printer.dart';
import '../utils/printer.dart';
import '../utils/printer_widget/mini_price_widget.dart';

class PrintBarcode extends StatefulWidget {
  const PrintBarcode({super.key, required this.barcode, required this.vendorCode});

  final String barcode;
  final String vendorCode;

  @override
  State<PrintBarcode> createState() => _PrintBarcodeState();
}

class _PrintBarcodeState extends State<PrintBarcode> {
  final _formKey = GlobalKey<FormState>();
  final _barcodeController = TextEditingController();
  final _vendorCodeController = TextEditingController();
  final _countController = TextEditingController();
  double lastPrice = 0;
  String step = 'validate';
  List<PrinterBarcode> barcodeList = [];
  final ScrollController _scrollController = ScrollController();
  bool isPer = false;

  @override
  void initState() {
    super.initState();
    _barcodeController.text = widget.barcode;
    _vendorCodeController.text = widget.vendorCode;
    _countController.text = '1';
  }

  List<PrinterBarcode> generateList(ProductData product, int count, double price, String vendorCode, String barcode,
      {bool isPer = false}) {
    final barcodes = <PrinterBarcode>[];
    for (int i = 0; i < count; i++) {
      barcodes.add(PrinterBarcode(
        lastPrice: price,
        product: product,
        vendorCode: vendorCode,
        barcodeValue: barcode,
        isPer: isPer,
      ));
    }
    return barcodes;
  }

  PrintingTypes selectedPrintingType = PrintingTypes.BARCODE;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.9),
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(27), topRight: Radius.circular(27)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Barkod chiqarish', style: TextStyle(fontSize: 20, color: AppColors.appColorWhite)),
                SizedBox(
                  height: 40,
                  width: 200,
                  child: AppDropDown(
                      selectedValue: selectedPrintingType.name.toString(),
                      dropDownItems: PrintingTypes.values.map((e) => e.name.toString()).toList(),
                      onChanged: ((String value) {
                        setState(() {
                          selectedPrintingType = PrintingTypes.fromString(value);
                        });
                      })),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 217,
                        child: AppInputUnderline(
                          hintText: 'Artikul',
                          controller: _vendorCodeController,
                          outlineBorder: true,
                          hideIcon: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Kiritilsin...';
                            }
                            return null;
                          },
                          onEditingComplete: () {
                            FocusScope.of(context).nextFocus();
                            getLastBarcode();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: AppInputUnderline(
                    hintText: 'Dona',
                    controller: _countController,
                    outlineBorder: true,
                    hideIcon: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Kiritilsin...';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 4,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 230,
                        child: AppInputUnderline(
                          readOnly: true,
                          hintText: 'Barcode',
                          controller: _barcodeController,
                          prefixIcon: UniconsLine.qrcode_scan,
                          outlineBorder: true,
                          numberFormat: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter barcode';
                            }
                            if (!checkIsEan13Code(value)) {
                              return 'Invalid barcode';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      AppButton(
                        onTap: (){
                          setState(() {
                            _barcodeController.clear();
                            barcodeList.clear();
                            step = 'validate';
                          });
                        },
                        tooltip: 'Tozalash',
                        color: AppColors.appColorGrey700.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(15),
                        hoverRadius: BorderRadius.circular(15),
                        height: 50,
                        width: 50,
                        child: Icon(Icons.clear_rounded, color: AppColors.appColorRed400, size: 25),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (selectedPrintingType == PrintingTypes.PRICE)
              SwitchListTile(
                value: isPer,
                onChanged: (value) {
                  setState(() {
                    isPer = value;
                  });
                },
                activeColor: AppColors.appColorGreen400,
                title: Text("1 donasi uchun", style: TextStyle(color: AppColors.appColorWhite)),
                secondary: Icon(Icons.add_box_outlined, color: AppColors.appColorWhite),
              ),
            if (step == 'validate')
              AppButton(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      final barcode = _barcodeController.text;
                      final count = int.parse(_countController.text);
                      final vendorCode = _vendorCodeController.text;
                      ProductData product = await getLastBarcode();
                      setState(() {
                        barcodeList = generateList(product, count, lastPrice, vendorCode, barcode, isPer: isPer);
                        step = 'print';
                      });
                      _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOut,
                      );
                    } catch (e) {
                      showAppAlertDialog(context, title: 'Xatolik', message: e.toString());
                    }
                  }
                },
                height: 40,
                width: 600,
                color: AppColors.appColorGreen700,
                hoverColor: AppColors.appColorGreen700,
                colorOnClick: AppColors.appColorGreen700,
                borderRadius: BorderRadius.circular(15),
                hoverRadius: BorderRadius.circular(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Generatsiya', style: TextStyle(fontSize: 18, color: AppColors.appColorWhite)),
                  ],
                ),
              ),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: barcodeList.map((e) {
                    Widget barcodeWidget;
                    switch (selectedPrintingType) {
                      case PrintingTypes.BARCODE:
                        barcodeWidget = BarcodePrintingWidget(barcode: e);
                        break;
                      case PrintingTypes.PRICE:
                        barcodeWidget = MiniPricePrinterWidget(barcode: e);
                        break;
                      case PrintingTypes.PRICELABEL:
                        barcodeWidget = PricePrinterWidget(barcode: e);
                        break;
                    }
                    return barcodeWidget;
                  }).toList(),
                ),
              ),
            ),
            if (step == 'print')
              AppButton(
                onTap: () async {
                  try {
                    if (_formKey.currentState!.validate()) {
                      await runBuild(barcodeList);
                      setState(() {
                        step = 'validate';
                        barcodeList = [];
                      });
                    }
                  } catch (e) {
                    showAppAlertDialog(context, title: 'Xatolik', message: e.toString());
                  }
                },
                height: 40,
                width: 600,
                color: AppColors.appColorGreen700,
                hoverColor: AppColors.appColorGreen700,
                colorOnClick: AppColors.appColorGreen700,
                borderRadius: BorderRadius.circular(15),
                hoverRadius: BorderRadius.circular(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Chop etish', style: TextStyle(fontSize: 18, color: AppColors.appColorWhite)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> runBuild(List<PrinterBarcode> barcodeList) async {
    switch (selectedPrintingType) {
      case PrintingTypes.BARCODE:
        await buildBarcodePdf(barcodeList);
        break;
      case PrintingTypes.PRICE:
        await buildMiniPrice(barcodeList);
        break;
      case PrintingTypes.PRICELABEL:
        await buildPricePdf(barcodeList);
        break;
    }
  }

  Future<ProductData> getLastBarcode() async {
    try {
      final barcode = await database.barcodeDao.getLastBarcodeFromVendorCode(_vendorCodeController.text.trim());
      double? price = await database.priceDao.getLastPriceFromVendorCode(_vendorCodeController.text.trim());
      ProductData product = await database.productDao.getProductFromVendorCode(_vendorCodeController.text.trim());
      setState(() {
        lastPrice = price ?? 0;
      });
      _barcodeController.text = barcode;
      return product;
    } catch (e) {
      rethrow;
    }
  }
}

enum PrintingTypes {
  BARCODE,
  PRICE,
  PRICELABEL;

  static fromString(String str) {
    switch (str) {
      case 'BARCODE':
        return PrintingTypes.BARCODE;
      case 'PRICE':
        return PrintingTypes.PRICE;
      case 'PRICELABEL':
        return PrintingTypes.PRICELABEL;
      default:
        return PrintingTypes.BARCODE;
    }
  }
}
