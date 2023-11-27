import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
import '../../../../../constants/colors.dart';

class PriceRoundingItemInfo extends StatefulWidget {
  const PriceRoundingItemInfo({super.key});

  @override
  State<PriceRoundingItemInfo> createState() => _PriceRoundingItemInfoState();
}

class _PriceRoundingItemInfoState extends State<PriceRoundingItemInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: AppColors.appColorBlackBg.withOpacity(0.4),
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 5),
          SizedBox(
            child: Row(
              children: [
                const SizedBox(width: 10),
                Expanded(flex: 0, child: Text('№:', style: TextStyle(color: AppColors.appColorWhite))),
                const SizedBox(width: 20),
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Icon(Icons.view_headline, color: AppColors.appColorWhite, size: 19),
                      Text(' Nomi:', style: TextStyle(color: AppColors.appColorWhite)),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Icon(UniconsLine.calender, color: AppColors.appColorWhite, size: 19),
                      Text('Sana:', style: TextStyle(color: AppColors.appColorWhite)),
                    ],
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
