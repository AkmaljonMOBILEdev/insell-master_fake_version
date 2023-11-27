import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
import '../../../../../constants/colors.dart';
import '../../../../../widgets/app_table_item.dart';


class ProductExpensesItemInfo extends StatefulWidget {
  const ProductExpensesItemInfo({Key? key}) : super(key: key);

  @override
  State<ProductExpensesItemInfo> createState() => _ProductExpensesItemInfoState();
}

class _ProductExpensesItemInfoState extends State<ProductExpensesItemInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.appColorBlackBg.withOpacity(0.4),
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
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
                Text('Tovar Nomi:', style: TextStyle(color: AppColors.appColorWhite, fontSize: 15)),
              ],
            ),
          ),
          AppTableItemStruct(
            hideBorder: true,
            innerWidget: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.confirmation_num_outlined, color: AppColors.appColorWhite, size: 23),
                const SizedBox(width: 10),
                Text('Artikul:', style: TextStyle(color: AppColors.appColorWhite, fontSize: 15)),
              ],
            ),
          ),
          AppTableItemStruct(
            hideBorder: true,
            innerWidget: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.category_outlined, color: AppColors.appColorWhite, size: 23),
                const SizedBox(width: 10),
                Text('Turi:', style: TextStyle(color: AppColors.appColorWhite, fontSize: 15)),
              ],
            ),
          ),
          AppTableItemStruct(
            hideBorder: true,
            innerWidget: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.confirmation_num_rounded, color: AppColors.appColorWhite, size: 23),
                const SizedBox(width: 10),
                Text('Qiymati:', style: TextStyle(color: AppColors.appColorWhite, fontSize: 15)),
              ],
            ),
          ),
          AppTableItemStruct(
            flex: 0,
            hideBorder: true,
            innerWidget: const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [SizedBox(width: 70)],
            ),
          ),
        ],
      ),
    );
  }
}
