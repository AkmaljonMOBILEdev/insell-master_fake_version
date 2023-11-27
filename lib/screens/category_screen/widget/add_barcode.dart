import 'package:easy_sell/database/model/product_dto.dart';
import 'package:easy_sell/services/https_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';

import '../../../constants/colors.dart';
import '../../../database/my_database.dart';
import '../../../utils/utils.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_input_underline.dart';

class AddBarcodeButton extends StatefulWidget {
  const AddBarcodeButton({super.key, this.product, required this.getNewBarcode});

  final ProductDTO? product;
  final Function(BarcodeData newBarcode) getNewBarcode;

  @override
  State<AddBarcodeButton> createState() => _AddBarcodeButtonState();
}

class _AddBarcodeButtonState extends State<AddBarcodeButton> {
  MyDatabase database = Get.find<MyDatabase>();
  final TextEditingController _newBarcodeController = TextEditingController();

  void generateNew() async {
    var res = await HttpServices.patch('/barcode/generate-barcode/${widget.product?.productData.serverId}', {});
    print(res.body);
  }

  @override
  Widget build(BuildContext context) {
    return AppButton(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.black.withOpacity(0.9),
            title: Row(
              children: [
                Text('Barcode qo\'shish', style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.highlight_off_rounded, color: AppColors.appColorRed400, size: 25),
                ),
              ],
            ),
            content: SizedBox(
              height: 100,
              child: Column(
                children: [
                  AppInputUnderline(
                    hintText: 'Barcode',
                    controller: _newBarcodeController,
                    prefixIcon: UniconsLine.qrcode_scan,
                  ),
                ],
              ),
            ),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              if (widget.product?.productData.serverId != null)
                IconButton(onPressed: generateNew, icon: Icon(UniconsLine.qrcode_scan, color: AppColors.appColorWhite)),
              AppButton(
                onTap: () async {
                  try {
                    BarcodeCompanion barcode = BarcodeCompanion(
                      barcode: toValue(_newBarcodeController.text),
                      productId: toValue(widget.product?.productData.id ?? -1),
                      isSynced: toValue(false),
                      createdAt: toValue(DateTime.now()),
                    );
                    BarcodeData newBarcode = await database.barcodeDao.createBarcode(barcode);
                    widget.getNewBarcode(newBarcode);
                  } catch (e) {
                    if (context.mounted) {
                      showAppAlertDialog(
                        context,
                        title: 'Xatolik',
                        message: '(${_newBarcodeController.text}) Barcode qo\'shilmadi hatolik\n $e',
                        buttonLabel: 'OK',
                        cancelLabel: 'Bekor qilish',
                      );
                    }
                  }
                },
                width: 200,
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
                      'Qo\'shish',
                      style: TextStyle(color: AppColors.appColorWhite, fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      width: 200,
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
            'Qo\'shish',
            style: TextStyle(color: AppColors.appColorWhite, fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
