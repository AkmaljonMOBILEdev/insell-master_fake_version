import 'package:easy_sell/screens/transfer_product_screen/widget/transfer_add_product_dialog.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
import '../../../constants/colors.dart';
import '../../../widgets/app_button.dart';

class MoveRightContainers extends StatefulWidget {
  const MoveRightContainers({Key? key, required this.close}) : super(key: key);
  final Function() close;

  @override
  State<MoveRightContainers> createState() => _MoveRightContainersState();
}

class _MoveRightContainersState extends State<MoveRightContainers> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: AppButton(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return MoveAddProductDialog(
                    showDropDown: false,
                    close: widget.close,
                  );
                },
              );
            },
            width: screenWidth / 3.99,
            // height: screenHeight / 1.450,
            borderRadius: BorderRadius.circular(20),
            hoverRadius: BorderRadius.circular(20),
            color: AppColors.appColorBlackBg,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(UniconsLine.share, color: AppColors.appColorGreen400, size: 40),
                Text('Maxsulot yuborish', style: TextStyle(color: AppColors.appColorWhite, fontSize: 22))
              ],
            ),
          ),
        ),
      ],
    );
  }
}
