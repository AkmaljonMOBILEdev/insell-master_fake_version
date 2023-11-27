import 'package:easy_sell/constants/colors.dart';
import 'package:easy_sell/widgets/app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';

import '../widgets/app_button.dart';

class WindowsListener extends WindowListener {
  @override
  void onWindowClose() {
    Get.dialog(
      AppDialog(
        content: SizedBox(
          height: 60,
          width: 300,
          child: Column(
            children: [
              const SizedBox(height: 10),
              Text(
                'Ilovadan chiqib ketish?',
                style: TextStyle(color: AppColors.appColorWhite, fontSize: 20),
              ),
            ],
          ),
        ),
        actions: [
          AppButton(
              tooltip: '',
              onTap: () {
                Get.back();
              },
              width: 150,
              height: 40,
              hoverRadius: BorderRadius.circular(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Yoq',
                    style: TextStyle(color: AppColors.appColorWhite, fontWeight: FontWeight.w500, fontSize: 16, letterSpacing: 1),
                  ),
                ],
              )),
          AppButton(
            tooltip: '',
            onTap: () {
              windowManager.destroy();
            },
            width: 150,
            height: 35,
            color: AppColors.appColorGreen400,
            hoverColor: AppColors.appColorGreen300,
            colorOnClick: AppColors.appColorGreen700,
            splashColor: AppColors.appColorGreen700,
            borderRadius: BorderRadius.circular(12),
            hoverRadius: BorderRadius.circular(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Ha',
                    style:
                        TextStyle(color: AppColors.appColorWhite, fontWeight: FontWeight.w500, fontSize: 16, letterSpacing: 1)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
