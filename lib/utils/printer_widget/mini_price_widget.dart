import 'package:easy_sell/utils/utils.dart';
import 'package:flutter/material.dart';
import '../printer.dart';

class MiniPricePrinterWidget extends StatefulWidget {
  const MiniPricePrinterWidget({super.key, required this.barcode});

  final PrinterBarcode barcode;

  @override
  State<MiniPricePrinterWidget> createState() => _MiniPricePrinterWidgetState();
}

class _MiniPricePrinterWidgetState extends State<MiniPricePrinterWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20 * 4,
      height: 30 * 4,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RotatedBox(
            quarterTurns: 1,
            child: Column(
              children: [
                Text(
                  widget.barcode.product.name,
                  style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600),
                ),
                Text(
                  widget.barcode.product.code ?? '',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          RotatedBox(
            quarterTurns: 1,
            child: PriceNumberWidget(price: widget.barcode.lastPrice),
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
        Text(formatNumber(double.parse(firstNumber())), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(width: 10),
        Column(
          children: [
            Text(lastThreeNumber(), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            const Text("so'm", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, height: 0.5)),
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
