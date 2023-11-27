import 'package:easy_sell/database/my_database.dart';
import 'package:easy_sell/widgets/app_button.dart';
import 'package:easy_sell/widgets/app_table_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';
import '../../../../../constants/colors.dart';


class ProductExpensesItem extends StatefulWidget {
  const ProductExpensesItem({Key? key, required this.index}) : super(key: key);
  final int index;

  @override
  State<ProductExpensesItem> createState() => _ProductExpensesItemState();
}

class _ProductExpensesItemState extends State<ProductExpensesItem> {
  MyDatabase database = Get.find<MyDatabase>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppTableItems(
      height: 40,
      items: [
        AppTableItemStruct(
          innerWidget: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                  decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(5)),
                  child: Text('${widget.index + 1}', style: TextStyle(color: AppColors.appColorWhite)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text("name", style: TextStyle(color: AppColors.appColorWhite), overflow: TextOverflow.ellipsis, maxLines: 1),
                ),
              ],
            ),
          ),
        ),
        AppTableItemStruct(
          innerWidget: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("vendorCode", style: TextStyle(color: AppColors.appColorWhite)),
              ],
            ),
          ),
        ),
        AppTableItemStruct(
          innerWidget: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("expensesType", style: TextStyle(color: AppColors.appColorWhite)),
              ],
            ),
          ),
        ),
        AppTableItemStruct(
          innerWidget: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("amount", style: TextStyle(color: AppColors.appColorWhite)),
              ],
            ),
          ),
        ),
        AppTableItemStruct(
          flex: 0,
          hideBorder: true,
          innerWidget: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(width: 5),
              AppButton(
                onTap: () {},
                width: 30,
                height: 30,
                borderRadius: BorderRadius.circular(8),
                hoverRadius: BorderRadius.circular(8),
                child: Icon(UniconsLine.info_circle, color: AppColors.appColorWhite),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
