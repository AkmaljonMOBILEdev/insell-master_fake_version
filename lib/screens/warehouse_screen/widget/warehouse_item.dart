import 'package:easy_sell/database/model/product_income_dto.dart';
import 'package:easy_sell/database/my_database.dart';
import 'package:easy_sell/utils/utils.dart';
import 'package:easy_sell/widgets/app_table_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/colors.dart';

class WarehouseItem extends StatefulWidget {
  const WarehouseItem({Key? key, required this.productIncome, required this.index}) : super(key: key);
  final ProductIncomeDTO productIncome;
  final int index;

  @override
  State<WarehouseItem> createState() => _WarehouseItemState();
}

class _WarehouseItemState extends State<WarehouseItem> {
  MyDatabase database = Get.find<MyDatabase>();
  double amount = 0;
  double price = 0;

  @override
  void initState() {
    super.initState();
    getBalance();
  }

  void getBalance() async {
    // double balance = await database.balanceDao.getAmountByProductId(widget.productIncome.product.productData.id);
    // double price_ = await database.productIncomeDao.lastPriceByProductId(widget.productIncome.product.productData.id);
    double balance = 0;
    double price_ = 0;
    setState(() {
      amount = balance;
      price = price_;
    });
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
                  decoration: BoxDecoration(
                      color: widget.productIncome.isSynced ? AppColors.appColorGreen700 : Colors.white12,
                      borderRadius: BorderRadius.circular(5)),
                  child: Text('${widget.index + 1}', style: TextStyle(color: AppColors.appColorWhite)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Tooltip(
                    message: widget.productIncome.product.productData.name,
                    child: Text(widget.productIncome.product.productData.name,
                        style: TextStyle(color: AppColors.appColorWhite), overflow: TextOverflow.ellipsis, maxLines: 1),
                  ),
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
                Text(
                    (widget.productIncome.product.productData.vendorCode != null &&
                            widget.productIncome.product.productData.vendorCode!.isNotEmpty)
                        ? (widget.productIncome.product.productData.vendorCode ?? '')
                        : (widget.productIncome.product.productData.code ?? ''),
                    style: TextStyle(color: AppColors.appColorWhite)),
                const SizedBox(width: 10)
              ],
            ),
          ),
        ),
        AppTableItemStruct(
          innerWidget: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text(formatNumber(amount), style: TextStyle(color: AppColors.appColorWhite)), const SizedBox(width: 10)],
            ),
          ),
        ),
      ],
    );
  }
}
