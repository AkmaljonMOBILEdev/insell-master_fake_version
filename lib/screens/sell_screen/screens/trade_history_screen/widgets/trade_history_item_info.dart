import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
import '../../../../../constants/colors.dart';

class TradeHistoryItemInfo extends StatelessWidget {
  const TradeHistoryItemInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.appColorBlackBg.withOpacity(0.4),
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(17), topRight: Radius.circular(17)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 5),
          SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                const SizedBox(width: 5),
                Expanded(
                  flex: 1,
                  child: Text('№:', style: TextStyle(color: AppColors.appColorWhite)),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(UniconsLine.calendar_alt, color: AppColors.appColorWhite, size: 19),
                      Text(' Sana:', style: TextStyle(color: AppColors.appColorWhite)),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(UniconsLine.user, color: AppColors.appColorWhite, size: 19),
                      Text(' Haridor:', style: TextStyle(color: AppColors.appColorWhite)),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(UniconsLine.money_bill, color: AppColors.appColorWhite, size: 20),
                      Text(' Summa:', style: TextStyle(color: AppColors.appColorWhite)),
                    ],
                  ),
                ),
                const Expanded(flex: 1, child: SizedBox(width: 20)),
              ],
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
