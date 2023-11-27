import 'package:easy_sell/screens/prices_screen/widget/price_history_toolbar.dart';
import 'package:easy_sell/screens/prices_screen/widget/product_history_item.dart';
import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../database/my_database.dart';
import '../../../widgets/app_dialog.dart';

class PriceHistory extends StatefulWidget {
  const PriceHistory({super.key, required this.prices});

  final List<PriceData> prices;

  @override
  State<PriceHistory> createState() => _PriceHistoryState();
}

class _PriceHistoryState extends State<PriceHistory> {
  List<PriceData> get priceData => widget.prices;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return AppDialog(
      backgroundColor: AppColors.appColorBlackBg,
      title: Text(
        "Narxlar Tarixi",
        style: TextStyle(color: AppColors.appColorWhite),
        textAlign: TextAlign.center,
      ),
      content: SizedBox(
        width: width * 0.6,
        height: height * 0.6,
        child: Column(
          children: [
            const Expanded(flex: 1, child: PriceHistoryToolbar()),
            Expanded(
              flex: 11,
              child: ListView.builder(
                itemCount: priceData.length,
                itemBuilder: (context, index) {
                  return ProductHistoryItem(
                    priceData: priceData[index],
                    index: index,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
