import 'package:easy_sell/database/model/product_outcome_document.dart';
import 'package:easy_sell/database/my_database.dart';
import 'package:easy_sell/screens/warehouse_screen/screens/return_to_supplier/widgets/update_dialog/return_create_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';

import '../../../../../constants/colors.dart';
import '../../../../../widgets/app_button.dart';

class ReturnProductRightContainers extends StatefulWidget {
  const ReturnProductRightContainers({Key? key, required this.getAll, required this.isCashier}) : super(key: key);
  final Function getAll;
  final bool isCashier;

  @override
  State<ReturnProductRightContainers> createState() => _ReturnProductRightContainersState();
}

class _ReturnProductRightContainersState extends State<ReturnProductRightContainers> {
  double totalBalance = 0;
  MyDatabase database = Get.find<MyDatabase>();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: widget.isCashier
              ? Container(
                  width: screenWidth / 3.99,
                  decoration: BoxDecoration(color: AppColors.appColorBlackBg, borderRadius: BorderRadius.circular(20)),
                )
              : AppButton(
                  onTap: () {
                    Get.to(
                      () => ReturnProductUpdateDialog(
                        reload: () {
                          widget.getAll();
                        },
                        isCreate: true,
                        productOutcomeDocument: ProductOutcomeDocumentDto.empty(),
                        setter: (ProductOutcomeDocumentDto val) {},
                      ),
                    );
                  },
                  width: screenWidth / 3.99,
                  // height: screenHeight / 1.473,
                  borderRadius: BorderRadius.circular(20),
                  hoverRadius: BorderRadius.circular(20),
                  color: AppColors.appColorBlackBg,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(UniconsLine.upload, color: AppColors.appColorGreen400, size: 40),
                      Text('Maxsulotni qaytarish', style: TextStyle(color: AppColors.appColorWhite, fontSize: 22))
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}
