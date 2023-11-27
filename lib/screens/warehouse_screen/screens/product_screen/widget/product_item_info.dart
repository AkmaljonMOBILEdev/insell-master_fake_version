import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
import '../../../../../constants/colors.dart';
import '../../../../../widgets/app_sort_button.dart';

class ProductItemInfo extends StatefulWidget {
  const ProductItemInfo({Key? key, required this.sortByName, required this.sorted, this.width}) : super(key: key);
  final Function sortByName;
  final bool sorted;
  final double? width;

  @override
  State<ProductItemInfo> createState() => _ProductItemInfoState();
}

class _ProductItemInfoState extends State<ProductItemInfo> {
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
          SizedBox(
            width: widget.width,
            child: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 0,
                  child: Text('№:', style: TextStyle(color: AppColors.appColorWhite)),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      AppSortButton(
                        width: 120,
                        icon: UniconsLine.card_atm,
                        title: ' Tovar nomi:',
                        sortedIcon: widget.sorted ? Icons.arrow_drop_up_sharp : Icons.arrow_drop_down_sharp,
                        onTap: () => widget.sortByName(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Icon(UniconsLine.info_circle, color: AppColors.appColorWhite, size: 19),
                      Text(' Artikul:', style: TextStyle(color: AppColors.appColorWhite)),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Icon(UniconsLine.money_bill, color: AppColors.appColorWhite, size: 20),
                      Text(' Ulgurji narx:', style: TextStyle(color: AppColors.appColorWhite)),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Icon(UniconsLine.money_insert, color: AppColors.appColorWhite, size: 19),
                      Text(' Sotuv narx:', style: TextStyle(color: AppColors.appColorWhite)),
                    ],
                  ),
                ),
                const SizedBox(width: 80),
              ],
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
