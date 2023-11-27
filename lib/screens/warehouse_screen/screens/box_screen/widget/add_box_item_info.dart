import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
import '../../../../../constants/colors.dart';


class AddBoxItemInfo extends StatefulWidget {
  const AddBoxItemInfo({super.key});

  @override
  State<AddBoxItemInfo> createState() => _AddBoxItemInfoState();
}

class _AddBoxItemInfoState extends State<AddBoxItemInfo> {
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
                      Icon(UniconsLine.box, color: AppColors.appColorWhite, size: 19),
                      Text(' Nomi:', style: TextStyle(color: AppColors.appColorWhite)),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Icon(UniconsLine.money_bill, color: AppColors.appColorWhite, size: 19),
                      Text('Narxi:', style: TextStyle(color: AppColors.appColorWhite)),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Icon(Icons.numbers, color: AppColors.appColorWhite, size: 19),
                      Text('Miqdori:', style: TextStyle(color: AppColors.appColorWhite)),
                    ],
                  ),
                ),
                const Expanded(flex: 1, child: SizedBox(height: 0))
              ],
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
