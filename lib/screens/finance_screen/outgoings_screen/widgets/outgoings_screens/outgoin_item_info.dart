import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
import '../../../../../constants/colors.dart';

class OutgoingItemInfo extends StatefulWidget {
  const OutgoingItemInfo({super.key});

  @override
  State<OutgoingItemInfo> createState() => _OutgoingItemInfoState();
}

class _OutgoingItemInfoState extends State<OutgoingItemInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                      Icon(UniconsLine.money_bill, color: AppColors.appColorWhite, size: 19),
                      Text('Summa:', style: TextStyle(color: AppColors.appColorWhite)),
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
              ],
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
