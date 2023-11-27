import 'package:easy_sell/database/model/currency_dto.dart';
import 'package:easy_sell/utils/utils.dart';
import 'package:easy_sell/widgets/app_autocomplete.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../constants/colors.dart';
import '../../../../../../database/model/product_outcome_document.dart';
import '../../../../../../widgets/app_readable_and_writeable_widget.dart';
import '../../../../../../widgets/app_table_item.dart';

class OutcomeItem extends StatefulWidget {
  const OutcomeItem(
      {super.key,
      required this.product,
      required this.index,
      required this.onRemove,
      required this.layout,
      required this.currencies});

  final ProductExpense product;
  final int index;
  final Function() onRemove;

  final List<int> layout;
  final List<CurrencyDataStruct> currencies;

  @override
  State<OutcomeItem> createState() => _OutcomeItemState();
}

class _OutcomeItemState extends State<OutcomeItem> {
  ProductExpense get product => widget.product;

  @override
  Widget build(BuildContext context) {
    return AppTableItems(
      height: 50,
      hideBorder: true,
      layouts: widget.layout,
      items: [
        AppTableItemStruct(
          innerWidget: Row(
            children: [
              const SizedBox(
                width: 5,
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(5)),
                child: Text('${widget.index + 1}', style: TextStyle(color: AppColors.appColorWhite)),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  product.product.name,
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
              product.product.vendorCode ?? '',
              style: TextStyle(color: AppColors.appColorWhite, fontSize: 14),
            ),
          ),
        ),
        AppTableItemStruct(
          innerWidget: Center(
            child: Text(
              product.product.code ?? '',
              style: TextStyle(color: AppColors.appColorWhite, fontSize: 14),
            ),
          ),
        ),
        AppTableItemStruct(
          innerWidget: Center(
            child: AppReadAndWriteWidget(
              value: formatNumber(product.amount),
              setter: (String val) {
                setState(() {
                  product.amount = double.tryParse(val) ?? 0;
                });
              },
            ),
          ),
        ),
        AppTableItemStruct(
          innerWidget: Center(
            child: AppReadAndWriteWidget(
              value: formatNumber(product.price),
              setter: (String val) {
                setState(() {
                  product.price = double.tryParse(val) ?? 0;
                });
              },
            ),
          ),
        ),
        AppTableItemStruct(
          innerWidget: Center(
            child: AppAutoComplete(
              initialValue: product.currency?.name ?? '',
              hintText: 'Valyuta',
              options: widget.currencies.map((e) => AutocompleteDataStruct(value: e.name, uniqueId: e.id)).toList(),
              getValue: (AutocompleteDataStruct val) {
                setState(() {
                  product.currency = widget.currencies.firstWhereOrNull((element) => element.id == val.uniqueId);
                });
              },
            ),
          ),
        ),
        AppTableItemStruct(
          innerWidget: Center(
            child: Text(
              "${formatNumber(product.amount * product.price)} ${product.currency?.name}",
              style: TextStyle(color: AppColors.appColorWhite, fontSize: 14),
            ),
          ),
        ),
        AppTableItemStruct(
          innerWidget: IconButton(
            onPressed: widget.onRemove,
            icon: const Icon(Icons.delete, color: Colors.red),
          ),
        ),
      ],
    );
  }
}
