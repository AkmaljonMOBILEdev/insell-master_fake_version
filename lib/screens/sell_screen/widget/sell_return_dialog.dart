import 'package:easy_sell/database/my_database.dart';
import 'package:easy_sell/widgets/app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../widgets/app_button.dart';

class SellReturnProductDialog extends StatefulWidget {
  const SellReturnProductDialog({super.key, required this.onReturn, this.client});

  final Null Function(Map value) onReturn;
  final ClientData? client;

  @override
  State<SellReturnProductDialog> createState() => _SellReturnProductDialogState();
}

class _SellReturnProductDialogState extends State<SellReturnProductDialog> {
  bool isReturnToClient = true;
  bool isReturnToStock = true;

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
          Text('DIQQAT!', style: TextStyle(color: AppColors.appColorRed400, fontSize: 20)),
        ],
      ),
      content: SizedBox(
        height: 160,
        child: Column(
          children: [
            Text('Maxsulotlar qaytariladi. Ishonchingiz komilmi?',
                style: TextStyle(color: AppColors.appColorWhite, fontSize: 18)),
            const SizedBox(height: 30),
            if (widget.client != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Mijozga pul qaytarilsinmi ?', style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
                  Checkbox(
                    value: isReturnToClient,
                    onChanged: (value) {
                      setState(() {
                        isReturnToClient = value!;
                      });
                    },
                  ),
                ],
              ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Omborga qo\'shilsinmi ? (Mahsulot yaroqli bo\'lsa)',
                    style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
                Checkbox(
                  value: isReturnToStock,
                  onChanged: (value) {
                    setState(() {
                      isReturnToStock = value!;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          AppButton(
            tooltip: '',
            onTap: () async {
              Navigator.pop(context);
            },
            width: 110,
            height: 40,
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            hoverRadius: BorderRadius.circular(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Bekor qilish',
                  style: TextStyle(color: AppColors.appColorWhite, fontWeight: FontWeight.w500, fontSize: 16, letterSpacing: 1),
                ),
              ],
            ),
          ),
          AppButton(
            tooltip: '',
            onTap: () async {
              widget.onReturn(
                  {'returnedMoney': isReturnToClient, 'returnedProductsIncome': isReturnToStock, "clientId": widget.client?.id});
            },
            width: 110,
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
                  'Qaytarish',
                  style: TextStyle(color: AppColors.appColorWhite, fontWeight: FontWeight.w500, fontSize: 16, letterSpacing: 1),
                ),
              ],
            ),
          ),
        ])
      ],
    );
  }
}
