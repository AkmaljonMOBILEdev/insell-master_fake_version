import 'dart:convert';
import 'package:easy_sell/screens/warehouse_screen/widget/crud/warehouse_update_dialog.dart';
import 'package:easy_sell/widgets/app_input_underline.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
import '../../../../constants/colors.dart';
import '../../../../database/table/product_income_table.dart';
import '../../../../services/https_services.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/app_editable_widget.dart';
import '../../../../widgets/app_table_item.dart';

class WarehouseEditableItem extends StatefulWidget {
  const WarehouseEditableItem(
      {super.key,
      this.layouts,
      required this.index,
      required this.incomeProduct,
      required this.updateWidget,
      required this.deleteItem});

  final List<int>? layouts;
  final int index;
  final WarehouseEditableItemStruct incomeProduct;
  final Function() updateWidget;
  final Function() deleteItem;

  @override
  State<WarehouseEditableItem> createState() => _WarehouseEditableItemState();
}

class _WarehouseEditableItemState extends State<WarehouseEditableItem> {
  RegExp spaceRemover = RegExp(r'\s+');
  String total = '0';
  WarehouseEditableItemStruct? currentIncomeItem;

  @override
  void initState() {
    super.initState();
    setState(() {
      currentIncomeItem = widget.incomeProduct;
    });
    calculateTotal();
  }

  @override
  void didUpdateWidget(covariant WarehouseEditableItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    calculateTotal();
  }

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
                  currentIncomeItem?.productData.name ?? '',
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
              currentIncomeItem?.productData.vendorCode ?? '',
              style: TextStyle(color: AppColors.appColorWhite, fontSize: 14),
            ),
          ),
        ),
        AppTableItemStruct(
          innerWidget: Center(
            child: Text(
              currentIncomeItem?.productData.code ?? '',
              style: TextStyle(color: AppColors.appColorWhite, fontSize: 14),
            ),
          ),
        ),
        AppTableItemStruct(
          flex: 5,
          innerWidget: Center(
            child: AppEditableWidget(
              controller: currentIncomeItem?.amountController,
              onChanged: (value) {
                widget.updateWidget();
              },
              hinText: 'Miqdor',
            ),
          ),
        ),
        AppTableItemStruct(
          flex: 4,
          innerWidget: Center(
            child: AppEditableWidget(
              controller: currentIncomeItem?.priceController,
              onChanged: (value) {
                widget.updateWidget();
              },
              hinText: 'Narx',
            ),
          ),
        ),
        AppTableItemStruct(
          innerWidget: Center(
            child: IconButton(
              onPressed: () {
                setState(() {
                  currentIncomeItem?.isDollar = !(currentIncomeItem?.isDollar ?? false);
                });
                widget.updateWidget();
              },
              icon: Icon((currentIncomeItem?.isDollar ?? false) ? UniconsLine.dollar_sign : UniconsLine.money_bill,
                  color: (currentIncomeItem?.isDollar ?? false) ? AppColors.appColorGreen400 : Colors.white, size: 20),
            ),
          ),
        ),
        AppTableItemStruct(
          innerWidget: Center(
              child: AppInputUnderline(
            controller: widget.incomeProduct.automaticPriceController,
            hintText: 'Tavsiya narx',
            hideIcon: true,
            textAlign: TextAlign.center,
            inputFormatters: [AppTextInputFormatter()],
          )),
        ),
        AppTableItemStruct(
          flex: 2,
          innerWidget: Center(
            child: Text(
              "",
              style: TextStyle(color: AppColors.appColorWhite, fontSize: 14),
              textAlign: TextAlign.end,
            ),
          ),
        ),
        AppTableItemStruct(
          innerWidget: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: Center(
              child: Text(
                formatDate(currentIncomeItem?.expireDateController),
                style: TextStyle(color: AppColors.appColorWhite, fontSize: 14),
                textAlign: TextAlign.end,
              ),
            ),
          ),
        ),
        AppTableItemStruct(
          flex: 2,
          innerWidget: Center(
            child: Text(
              total,
              style: TextStyle(color: AppColors.appColorWhite, fontSize: 14),
              textAlign: TextAlign.end,
            ),
          ),
        ),
        AppTableItemStruct(
            innerWidget: Row(
          children: [
            IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AppTableItems(
                        items: [
                          AppTableItemStruct(
                            flex: 3,
                            innerWidget: Center(
                                child: FutureBuilder(
                              future:
                                  HttpServices.get("/price/product/last-income-price/${currentIncomeItem?.productData.serverId}"),
                              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                if (snapshot.hasData) {
                                  double price = 0;
                                  ProductIncomeCurrency currency = ProductIncomeCurrency.UZS;
                                  var json = jsonDecode(snapshot.data.body != '' ? snapshot.data.body : '{}');
                                  if (json['price'] != null) {
                                    price = json['price'];
                                  }
                                  if (json['currency'] != null) {
                                    currency = json['currency'] == 'UZS' ? ProductIncomeCurrency.UZS : ProductIncomeCurrency.USD;
                                  }
                                  return Text(
                                    formatNumber(price) + (currency == ProductIncomeCurrency.UZS ? ' SUM' : ' \$'),
                                    style: TextStyle(color: AppColors.appColorWhite, fontSize: 14),
                                    textAlign: TextAlign.end,
                                  );
                                }
                                return Text(
                                  '',
                                  style: TextStyle(color: AppColors.appColorWhite, fontSize: 14),
                                  textAlign: TextAlign.end,
                                );
                              },
                            )),
                          ),
                          AppTableItemStruct(
                            flex: 3,
                            innerWidget: Center(
                                child: FutureBuilder(
                              future: HttpServices.get(
                                  "/price/product/last-by-type/${currentIncomeItem?.productData.serverId}?priceType=RETAIL"),
                              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                if (snapshot.hasData) {
                                  double price = 0;
                                  ProductIncomeCurrency currency = ProductIncomeCurrency.UZS;
                                  var json = jsonDecode(snapshot.data.body != '' ? snapshot.data.body : '{}');
                                  if (json['price'] != null) {
                                    price = json['price'];
                                  }
                                  if (json['currency'] != null) {
                                    currency = json['currency'] == 'UZS' ? ProductIncomeCurrency.UZS : ProductIncomeCurrency.USD;
                                  }
                                  return Text(
                                    formatNumber(price) + (currency == ProductIncomeCurrency.UZS ? ' SUM' : ' \$'),
                                    style: TextStyle(color: AppColors.appColorWhite, fontSize: 14),
                                    textAlign: TextAlign.end,
                                  );
                                }
                                return Text(
                                  '',
                                  style: TextStyle(color: AppColors.appColorWhite, fontSize: 14),
                                  textAlign: TextAlign.end,
                                );
                              },
                            )),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.history_toggle_off, color: Colors.orange)),
            IconButton(
                onPressed: widget.deleteItem,
                icon: const Icon(
                  Icons.close,
                  color: Colors.red,
                )),
          ],
        )),
      ],
    );
  }

  void calculateTotal() {
    total = formatNumber((double.tryParse(currentIncomeItem?.amountController.text.replaceAll(spaceRemover, "") ?? "0") ?? 0) *
        (double.tryParse(currentIncomeItem?.priceController.text.replaceAll(spaceRemover, "") ?? "0") ?? 0));
    setState(() {});
  }
}
