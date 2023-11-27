import 'package:easy_sell/utils/utils.dart';
import 'package:easy_sell/widgets/app_dialog.dart';
import 'package:easy_sell/widgets/app_input_underline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/colors.dart';
import '../../../services/https_services.dart';
import '../../../widgets/app_button.dart';

class AddExchangeRateDialog extends StatefulWidget {
  const AddExchangeRateDialog({super.key, required this.reload});

  final Function reload;

  @override
  State<AddExchangeRateDialog> createState() => _AddExchangeRateDialogState();
}

class _AddExchangeRateDialogState extends State<AddExchangeRateDialog> {
  final TextEditingController _inputController = TextEditingController();

  void createExchangeRate() async {
    if (_inputController.text.isNotEmpty) {
      var req = {
        "rate": double.parse(_inputController.text),
      };
      var response = await HttpServices.post("/exchange-rate/create", req);
      if (response.statusCode == 201) {
        showAppSnackBar(context, 'Dollar kursi muvaffaqiyatli qo\'shildi', "OK");
        widget.reload();
        Get.back();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      backgroundColor: Colors.black.withOpacity(0.9),
      title: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(Icons.highlight_off_rounded, color: AppColors.appColorRed400, size: 25),
            ),
          ),
          Text('Dollar kursi', style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
        ],
      ),
      content: SizedBox(
        width: 200,
        height: 80,
        child: AppInputUnderline(
          controller: _inputController,
          hintText: 'Dollar kursini kiriting',
          prefixIcon: Icons.attach_money_rounded,
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AppButton(
              tooltip: '',
              onTap: createExchangeRate,
              width: 220,
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
                  Text('Saqlash',
                      style:
                          TextStyle(color: AppColors.appColorWhite, fontWeight: FontWeight.w500, fontSize: 16, letterSpacing: 1)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
