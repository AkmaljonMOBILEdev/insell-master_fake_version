import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../printer.dart';

class BarcodePrintingWidget extends StatefulWidget {
  const BarcodePrintingWidget({super.key, required this.barcode});

  final PrinterBarcode barcode;

  @override
  State<BarcodePrintingWidget> createState() => _BarcodePrintingWidgetState();
}

class _BarcodePrintingWidgetState extends State<BarcodePrintingWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(widget.barcode.vendorCode),
          SvgPicture.string(generateEan13Image(widget.barcode), width: 150, height: 125),
          ],
      ),
    );
  }
}
