import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../widgets/app_table_item.dart';

class SellItemInfo extends StatelessWidget {
  const SellItemInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.appColorBlackBg.withOpacity(0.4),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(17),
          topRight: Radius.circular(17),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: AppTableItems(
              height: 35,
              hideBorder: true,
              layouts: const [6, 4, 4, 3, 1],
              items: [
                AppTableItemStruct(
                  flex: 6,
                  innerWidget: Row(
                    children: [
                      const SizedBox(width: 10),
                      Icon(
                        Icons.format_list_numbered,
                        color: AppColors.appColorWhite,
                      ),
                      const SizedBox(width: 10),
                      Text('Mahsulotlar', style: TextStyle(color: AppColors.appColorWhite)),
                    ],
                  ),
                ),
                AppTableItemStruct(
                  flex: 4,
                  innerWidget: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(' Artikul', style: TextStyle(color: AppColors.appColorWhite)),
                    ],
                  ),
                ),
                AppTableItemStruct(
                  flex: 4,
                  innerWidget: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(' Miqdor', style: TextStyle(color: AppColors.appColorWhite)),
                    ],
                  ),
                ),
                AppTableItemStruct(
                  flex: 3,
                  innerWidget: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(' Narx', style: TextStyle(color: AppColors.appColorWhite)),
                    ],
                  ),
                ),
                AppTableItemStruct(
                  flex: 1,
                  innerWidget: Container(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
