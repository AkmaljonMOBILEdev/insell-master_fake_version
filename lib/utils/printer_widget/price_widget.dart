import 'package:easy_sell/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../printer.dart';

class PricePrinterWidget extends StatefulWidget {
  const PricePrinterWidget({super.key, required this.barcode});

  final PrinterBarcode barcode;

  @override
  State<PricePrinterWidget> createState() => _PricePrinterWidgetState();
}

class _PricePrinterWidgetState extends State<PricePrinterWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38 * 4,
      height: 60 * 4,
      padding: const EdgeInsets.all(7),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 10,
            child: Row(
              children: [
                RotatedBox(
                  quarterTurns: 1,
                  child:
                      SvgPicture.string(generateEan13Image(widget.barcode, width: 38 * 4, height: 25), width: 38 * 4, height: 25),
                ),
                RotatedBox(
                  quarterTurns: 1,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.barcode.product.name,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          widget.barcode.product.code ?? '',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 8,
            child: RotatedBox(
              quarterTurns: 1,
              child: PriceNumberWidget(price: widget.barcode.lastPrice),
            ),
          ),
        ],
      ),
    );
  }
}

class PriceNumberWidget extends StatefulWidget {
  const PriceNumberWidget({super.key, required this.price});

  final double price;

  @override
  State<PriceNumberWidget> createState() => _PriceNumberWidgetState();
}

class _PriceNumberWidgetState extends State<PriceNumberWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(formatNumber(double.parse(firstNumber())), style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
        const SizedBox(width: 10),
        Column(
          children: [
            Text(lastThreeNumber(), style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            const Text("so'm", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, height: 0.5)),
          ],
        ),
      ],
    );
  }

  String lastThreeNumber() {
    String price = widget.price.toStringAsFixed(0);
    if (price.length > 3) {
      return price.substring(price.length - 3);
    } else {
      return price;
    }
  }

  String firstNumber() {
    String price = widget.price.toStringAsFixed(0);
    if (price.length > 3) {
      return price.substring(0, price.length - 3);
    } else {
      return "";
    }
  }
}
