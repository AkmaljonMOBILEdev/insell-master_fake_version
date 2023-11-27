import 'package:easy_sell/screens/sync_screen/downlaod_functions.dart';
import 'package:easy_sell/services/https_services.dart';
import 'package:easy_sell/widgets/app_dialog.dart';
import 'package:easy_sell/widgets/app_input_underline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';
import '../../../../../constants/colors.dart';
import '../../../../../database/model/product_dto.dart';
import '../../../../../database/model/product_kit_dao.dart';
import '../../../../../database/my_database.dart';
import '../../../../../utils/utils.dart';
import '../../../../../widgets/app_button.dart';

class CreateBoxDialog extends StatefulWidget {
  const CreateBoxDialog({super.key, required this.productBox});

  final ProductDTO productBox;

  @override
  State<CreateBoxDialog> createState() => _CreateBoxDialogState();
}

class _CreateBoxDialogState extends State<CreateBoxDialog> {
  MyDatabase database = Get.find<MyDatabase>();
  final TextEditingController _boxAmountController = TextEditingController();
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(Icons.highlight_off_rounded, color: AppColors.appColorRed400, size: 25),
            ),
          ),
          Text('Set qoshish', style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
        ],
      ),
      content: SizedBox(
        width: 500,
        height: 500,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(color: AppColors.appColorBlackBg, borderRadius: BorderRadius.circular(15)),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Set nomi:', style: TextStyle(color: AppColors.appColorWhite, fontSize: 18)),
                Text(widget.productBox.productData.name, style: TextStyle(color: AppColors.appColorWhite, fontSize: 18)),
              ]),
            ),
            AppInputUnderline(
              controller: _boxAmountController,
              hintText: 'Sonini kiriting',
              prefixIcon: UniconsLine.box,
              onChanged: (String value) {
                setState(() {
                  count = int.tryParse(value) ?? 0;
                });
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: widget.productBox.productsKit?.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 3),
                    decoration:
                        BoxDecoration(color: Colors.grey.shade800.withOpacity(0.7), borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.appColorBlackBg,
                          radius: 15,
                          child: Text('${index + 1}', style: TextStyle(color: AppColors.appColorWhite)),
                        ),
                        title: Row(
                          children: [
                            Text(widget.productBox.productsKit?[index].product.productData.name ?? '',
                                style: TextStyle(color: AppColors.appColorWhite)),
                            Text(' (${widget.productBox.productsKit?[index].product.productData.vendorCode})',
                                style: TextStyle(color: AppColors.appColorWhite)),
                          ],
                        ),
                        subtitle: Text(
                          '${formatNumber(widget.productBox.productsKit?[index].productKit.amount)} dona.  ${formatNumber(widget.productBox.productsKit?[index].product.prices.first.value ?? 0)} dan',
                          style: TextStyle(color: AppColors.appColorGrey300, fontSize: 16),
                        ),
                        trailing: Text(
                          "${formatNumber(count)} x ${formatNumber(widget.productBox.productsKit?[index].productKit.amount)}",
                          style: TextStyle(color: AppColors.appColorGrey300, fontSize: 16),
                        )),
                  );
                },
              ),
            )
          ],
        ),
      ),
      actions: [
        AppButton(
          tooltip: '',
          onTap: () async {
            try {
              ///TODO: add product income
              double amount = double.tryParse(_boxAmountController.text.replaceAll(" ", "")) ?? 0;
              validator(amount);
              await HttpServices.post(
                  '/product-income/income/kit?productId=${widget.productBox.productData.serverId}&amount=${amount.toInt()}', {});
              DownloadFunctions df = DownloadFunctions(
                database: database,
                setter: (v) {},
                progress: {},
              );
              // await df.getProductIncomes("");
              // await df.getBalance("");
              // close dialog
              Get.back();
            } catch (e) {
              showAppAlertDialog(context, title: 'Xatolik', message: 'Xatolik yuz berdi: $e');
            }
          },
          width: 120,
          height: 40,
          color: AppColors.appColorGreen400,
          hoverColor: AppColors.appColorGreen300,
          colorOnClick: AppColors.appColorGreen700,
          splashColor: AppColors.appColorGreen700,
          borderRadius: BorderRadius.circular(12),
          hoverRadius: BorderRadius.circular(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Saqlash',
                style: TextStyle(color: AppColors.appColorWhite, fontWeight: FontWeight.w500, fontSize: 16, letterSpacing: 1),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void validator(double value) {
    List<ProductKitDTO>? productKits = widget.productBox.productsKit;
    if (productKits == null) {
      throw ('Setda mahsulotlar mavjud emas');
    }
    List<String> errorList = [];
    for (ProductKitDTO productKit in productKits) {
      if (productKit.productKit.amount * value > productKit.product.amount) {
        errorList.add(
            '\n\n Skladda ${productKit.product.productData.name} mahsulotidan:\n ${formatNumber(productKit.productKit.amount * value)} dona mavjud emas \n Mavjud dona: ${formatNumber(productKit.product.amount)} dona');
      }
    }
    if (errorList.isNotEmpty) {
      throw (errorList.join('\n'));
    }
  }
}
