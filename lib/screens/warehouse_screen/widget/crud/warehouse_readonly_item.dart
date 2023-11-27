import 'package:easy_sell/database/model/product_income_document.dart';
import 'package:flutter/material.dart';
import '../../../../constants/colors.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/app_table_item.dart';

class WarehouseReadonlyItem extends StatefulWidget {
  const WarehouseReadonlyItem({super.key, this.layouts, required this.index, required this.incomeProduct});

  final List<int>? layouts;
  final int index;
  final ProductIncomeDto incomeProduct;

  @override
  State<WarehouseReadonlyItem> createState() => _WarehouseReadonlyItemState();
}

class _WarehouseReadonlyItemState extends State<WarehouseReadonlyItem> {
  @override
  Widget build(BuildContext context) {
    return AppTableItems(
      height: 50,
      hideBorder: true,
      layouts: widget.layouts,
      items: [
        AppTableItemStruct(
          innerWidget: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(5)),
                child: Text('${widget.index + 1}', style: TextStyle(color: AppColors.appColorWhite)),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  widget.incomeProduct.product.name,
                  style: TextStyle(color: AppColors.appColorWhite, fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
        AppTableItemStruct(
          innerWidget: Center(
            child: Text(
              widget.incomeProduct.product.vendorCode ?? '',
              style: TextStyle(color: AppColors.appColorWhite, fontSize: 14),
            ),
          ),
        ),
        AppTableItemStruct(
          innerWidget: Center(
            child: Text(
              widget.incomeProduct.product.code ?? '',
              style: TextStyle(color: AppColors.appColorWhite, fontSize: 14),
            ),
          ),
        ),
        AppTableItemStruct(
          flex: 5,
          innerWidget: Center(
            child: Text(
              formatNumber(widget.incomeProduct.amount),
              style: TextStyle(color: AppColors.appColorWhite, fontSize: 14),
            ),
          ),
        ),
        AppTableItemStruct(innerWidget: const SizedBox()),
      ],
    );
  }
}
