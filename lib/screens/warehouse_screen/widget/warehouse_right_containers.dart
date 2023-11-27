import 'package:easy_sell/database/my_database.dart';
import 'package:easy_sell/screens/warehouse_screen/widget/update_dialog/warehouse_new_update_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';
import '../../../constants/colors.dart';
import '../../../database/model/product_income_document.dart';
import '../../../widgets/app_button.dart';

class WarehouseRightContainers extends StatefulWidget {
  const WarehouseRightContainers({Key? key, required this.getAll, required this.isCashier}) : super(key: key);
  final Function getAll;
  final bool isCashier;

  @override
  State<WarehouseRightContainers> createState() => _WarehouseRightContainersState();
}

class _WarehouseRightContainersState extends State<WarehouseRightContainers> {
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
                      () => WarehouseUpdateDialog(
                        reload: () {
                          widget.getAll();
                        },
                        isCreate: true,
                        productIncomeDocument: ProductIncomeDocumentDto.empty(),
                        setter: (ProductIncomeDocumentDto val) {},
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
                      Icon(UniconsLine.download_alt, color: AppColors.appColorGreen400, size: 40),
                      Text('Maxsulot qabul qilish', style: TextStyle(color: AppColors.appColorWhite, fontSize: 22))
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}
