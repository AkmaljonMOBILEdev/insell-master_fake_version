import 'package:easy_sell/screens/partner_screen/widget/partner_item_info.dart';
import 'package:flutter/material.dart';
import '../../../constants/colors.dart';

class Partners extends StatefulWidget {
  const Partners({super.key});

  @override
  State<Partners> createState() => _PartnersState();
}

class _PartnersState extends State<Partners> {

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        const PartnerItemInfo(),
        Expanded(
          child: Container(
            width: screenWidth / 1.38,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(borderRadius: const BorderRadius.only(), color: AppColors.appColorBlackBg),
            child: Center(
              child: Text(
                'Xamkorlar turini tanlang',
                style: TextStyle(color: AppColors.appColorWhite, fontSize: 20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
