import 'package:easy_sell/database/model/product_dto.dart';
import 'package:easy_sell/screens/warehouse_screen/screens/box_screen/widget/add_box_info_dialog.dart';
import 'package:easy_sell/utils/utils.dart';
import 'package:easy_sell/widgets/app_table_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';

import '../../../../../constants/colors.dart';
import '../../../../../widgets/app_button.dart';
import 'create_box_dialog.dart';

class AddBoxItems extends StatelessWidget {
  const AddBoxItems({super.key, required this.productBox, required this.index});

  final ProductDTO productBox;
  final int index;

  @override
  Widget build(BuildContext context) {
    return AppTableItems(
      height: 40,
      hideBorder: true,
      items: [
        AppTableItemStruct(
          flex: 2,
          innerWidget: Row(
            children: [
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(5)),
                child: Text('${index + 1}', style: TextStyle(color: AppColors.appColorWhite)),
              ),
              const SizedBox(width: 10),
              Column(
                children: [
                  Text(productBox.productData.name, style: TextStyle(color: AppColors.appColorWhite)),
                  Text(productBox.productData.vendorCode ?? "-", style: TextStyle(color: AppColors.appColorWhite)),
                ],
              ),
            ],
          ),
        ),
        AppTableItemStruct(
          flex: 4,
          innerWidget: Center(
            child: Text(
              formatNumber(productBox.prices.first.value ?? 0),
              style: TextStyle(color: AppColors.appColorWhite),
            ),
          ),
        ),
        AppTableItemStruct(
          flex: 4,
          innerWidget: Center(
            child: Text(
              ' ',
              style: TextStyle(color: AppColors.appColorWhite),
            ),
          ),
        ),
        // AppTableItemStruct(
        //   flex: 02,
        //   innerWidget: SizedBox()
        // ),
        AppTableItemStruct(
          flex: 3,
          innerWidget: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppButton(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AddBoxInfoDialog(productBox: productBox);
                    },
                  );
                },
                width: 30,
                height: 30,
                borderRadius: BorderRadius.circular(10),
                hoverRadius: BorderRadius.circular(10),
                hoverColor: AppColors.appColorGreen300,
                child: Icon(UniconsLine.eye, color: AppColors.appColorWhite, size: 20),
              ),
              const SizedBox(width: 5),
              AppButton(
                width: 100,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CreateBoxDialog(
                        productBox: productBox,
                      );
                    },
                  );
                },
                color: AppColors.appColorGreen400,
                hoverColor: AppColors.appColorGreen300,
                colorOnClick: AppColors.appColorGreen700,
                splashColor: AppColors.appColorGreen700,
                borderRadius: BorderRadius.circular(10),
                hoverRadius: BorderRadius.circular(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(UniconsLine.plus, color: AppColors.appColorWhite, size: 22),
                    const SizedBox(width: 5),
                    Text('Qo\'shish', style: TextStyle(color: AppColors.appColorWhite, fontSize: 16, fontWeight: FontWeight.w500))
                  ],
                ),
              ),
            ],
          ),
          // AppButton(
          //   onTap: () {},
          //   color: AppColors.appColorGreen400,
          //   hoverColor: AppColors.appColorGreen300,
          //   colorOnClick: AppColors.appColorGreen700,
          //   splashColor: AppColors.appColorGreen700,
          //   borderRadius: BorderRadius.circular(15),
          //   hoverRadius: BorderRadius.circular(15),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Icon(UniconsLine.plus, color: AppColors.appColorWhite, size: 22),
          //       const SizedBox(width: 5),
          //       Text('Qo\'shish', style: TextStyle(color: AppColors.appColorWhite, fontSize: 16, fontWeight: FontWeight.w500))
          //     ],
          //   ),
          // ),
        ),
      ],
    );
  }
}
