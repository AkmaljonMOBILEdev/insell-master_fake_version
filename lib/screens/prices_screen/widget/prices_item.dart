import 'package:easy_sell/database/my_database.dart';
import 'package:easy_sell/screens/prices_screen/prices_screen.dart';
import 'package:easy_sell/screens/prices_screen/widget/price_history_dialog.dart';
import 'package:easy_sell/services/auto_sync.dart';
import 'package:easy_sell/services/https_services.dart';
import 'package:easy_sell/utils/utils.dart';
import 'package:easy_sell/widgets/app_button.dart';
import 'package:easy_sell/widgets/app_input_underline.dart';
import 'package:easy_sell/widgets/app_table_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';
import '../../../constants/colors.dart';

class PricesItem extends StatefulWidget {
  const PricesItem({Key? key, required this.index, required this.product}) : super(key: key);
  final int index;
  final ProductWithPrices product;

  @override
  State<PricesItem> createState() => _PricesItemState();
}

class _PricesItemState extends State<PricesItem> {
  MyDatabase database = Get.find<MyDatabase>();

  ProductData get product => widget.product.incomePrice.product;

  List<PriceData> get prices => widget.product.prices;

  set prices(List<PriceData> value) => widget.product.prices = value;

  final TextEditingController _retailPriceController = TextEditingController();
  bool isTextFieldChanged = false;

  void updateProduct() async {
    await downloadFunctions.getPrices('price');
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
                  child: Text(product.name,
                      style: TextStyle(color: AppColors.appColorWhite), overflow: TextOverflow.ellipsis, maxLines: 1),
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
                Text(product.code ?? '', style: TextStyle(color: AppColors.appColorWhite)),
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
                Text(product.vendorCode ?? '', style: TextStyle(color: AppColors.appColorWhite)),
              ],
            ),
          ),
        ),
        AppTableItemStruct(
          innerWidget: Padding(
            padding: const EdgeInsets.only(right: 5, left: 5, bottom: 3),
            child: Center(
                child: Text(
                    "${formatNumber(widget.product.incomePrice.price)} ${widget.product.incomePrice.currency.abbreviation}",
                    style: TextStyle(color: AppColors.appColorWhite))),
          ),
        ),
        AppTableItemStruct(
          innerWidget: Padding(
            padding: const EdgeInsets.only(right: 5, left: 5, bottom: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: AppInputUnderline(
                    hintText: formatNumber(prices.isEmpty ? 0 : prices.first.value),
                    controller: _retailPriceController,
                    inputFormatters: [AppTextInputFormatter()],
                    hideIcon: true,
                    enableBorderColor: Colors.transparent,
                    focusedBorderColor: Colors.transparent,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        isTextFieldChanged = true;
                      });
                    },
                  ),
                ),
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
              AppButton(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return PriceHistory(
                        prices: prices,
                      );
                    },
                  );
                },
                width: 30,
                height: 30,
                borderRadius: BorderRadius.circular(8),
                hoverRadius: BorderRadius.circular(8),
                child: Icon(UniconsLine.history, color: AppColors.appColorWhite),
              ),
              const SizedBox(width: 5),
              isTextFieldChanged
                  ? AppButton(
                      onTap: () async {
                        double price = double.tryParse(_retailPriceController.text.replaceAll(' ', '')) ?? 0;

                        var req = [
                          {
                            "productId": product.serverId,
                            "price": price,
                          }
                        ];
                        var res = await HttpServices.post("/price/set/all", req);
                        if (res.statusCode == 200) {
                          if (context.mounted) {
                            showAppSnackBar(context, 'Narx muvaffaqiyatli yangilandi', "OK");
                          }
                        }
                        updateProduct();
                        setState(() {
                          _retailPriceController.clear();
                          isTextFieldChanged = false;
                        });
                      },
                      width: 27,
                      height: 27,
                      color: AppColors.appColorGreen400,
                      borderRadius: BorderRadius.circular(8),
                      hoverRadius: BorderRadius.circular(8),
                      child: Icon(UniconsLine.check, color: AppColors.appColorWhite),
                    )
                  : const SizedBox(
                      width: 27,
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
