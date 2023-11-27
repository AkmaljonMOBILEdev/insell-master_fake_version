import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
import '../../../constants/colors.dart';
import '../../../widgets/app_table_item.dart';

class WarehouseItemInfo extends StatefulWidget {
  const WarehouseItemInfo({Key? key, required this.sortByName, required this.sorted}) : super(key: key);
  final Function sortByName;
  final bool sorted;

  @override
  State<WarehouseItemInfo> createState() => _WarehouseItemInfoState();
}

class _WarehouseItemInfoState extends State<WarehouseItemInfo> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth / 1.38,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.appColorBlackBg.withOpacity(0.4),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: AppTableItems(
        items: [
          AppTableItemStruct(
            hideBorder: true,
            innerWidget: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('№', style: TextStyle(color: AppColors.appColorWhite)),
                const SizedBox(width: 10),
                Text('Tovar Nomi:', style: TextStyle(color: AppColors.appColorWhite)),
              ],
            ),
          ),
          AppTableItemStruct(
            hideBorder: true,
            innerWidget: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.confirmation_num_outlined, color: AppColors.appColorWhite, size: 18),
                const SizedBox(width: 10),
                Text('Artikul:', style: TextStyle(color: AppColors.appColorWhite)),
              ],
            ),
          ),
          AppTableItemStruct(
            hideBorder: true,
            innerWidget: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(UniconsLine.balance_scale, color: AppColors.appColorWhite, size: 18),
                const SizedBox(width: 10),
                Text('Soni:', style: TextStyle(color: AppColors.appColorWhite)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
