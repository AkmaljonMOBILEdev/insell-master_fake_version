import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';
import '../../../constants/colors.dart';
import '../../../utils/utils.dart';
import '../../../utils/validator.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_dialog.dart';
import '../../../widgets/app_input_underline.dart';

class SellAddDiscountDialog extends StatefulWidget {
  const SellAddDiscountDialog({super.key, required this.setDiscount, required this.discount});

  final void Function(double value) setDiscount;
  final double discount;

  @override
  State<SellAddDiscountDialog> createState() => _SellAddDiscountDialogState();
}

class _SellAddDiscountDialogState extends State<SellAddDiscountDialog> {
  final TextEditingController _sumController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      backgroundColor: Colors.black.withOpacity(0.9),
      title: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.highlight_off_rounded, color: AppColors.appColorRed400, size: 25),
            ),
          ),
          const SizedBox(height: 10),
          Text('Chegirma qo\'shish', style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
        ],
      ),
      content: Form(
        // key: _formValidation,
        child: SizedBox(
          width: 350,
          height: 90,
          child: Column(children: [
            AppInputUnderline(
              controller: _sumController,
              hintText: 'Chegirma',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [AppTextInputFormatter()],
              prefixIcon: UniconsLine.pricetag_alt,
              validator: AppValidator().namedValidate,
            ),
          ]),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AppButton(
              onTap: () {
                _clearFields();
              },
              height: 40,
              width: 40,
              borderRadius: BorderRadius.circular(15),
              hoverRadius: BorderRadius.circular(15),
              child: Center(
                child: Icon(Icons.cleaning_services_rounded, color: AppColors.appColorWhite),
              ),
            ),
            AppButton(
              tooltip: '',
              onTap: () async {
                widget.setDiscount(double.parse(_sumController.text.replaceAll(" ", "")));
                Get.back();
              },
              width: 250,
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
        ),
      ],
    );
  }

  void _clearFields() {
    _sumController.clear();
  }
}
