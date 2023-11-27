import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

import '../../../../../constants/colors.dart';

class WarehouseHistoryItemInfo extends StatefulWidget {
  const WarehouseHistoryItemInfo({super.key});

  @override
  State<WarehouseHistoryItemInfo> createState() => _WarehouseHistoryItemInfoState();
}

class _WarehouseHistoryItemInfoState extends State<WarehouseHistoryItemInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.appColorBlackBg.withOpacity(0.4),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      Text('№:', style: TextStyle(color: AppColors.appColorWhite)),
                      const SizedBox(width: 10),
                      Row(
                        children: [
                          Icon(UniconsLine.box, color: AppColors.appColorWhite, size: 19),
                          Text('Nomi', style: TextStyle(color: AppColors.appColorWhite)),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Sklad', style: TextStyle(color: AppColors.appColorWhite)),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Sana', style: TextStyle(color: AppColors.appColorWhite)),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Umumiy', style: TextStyle(color: AppColors.appColorWhite)),
                    ],
                  ),
                ),
                Expanded(
                  flex: 0,
                  child: Container(),
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
