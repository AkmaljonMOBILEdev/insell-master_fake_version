import 'package:easy_sell/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

import '../../../constants/colors.dart';

class PartnerRightContainers extends StatefulWidget {
  const PartnerRightContainers({super.key, required this.getByPartner});

  final void Function(String) getByPartner;

  @override
  State<PartnerRightContainers> createState() => _PartnerRightContainersState();
}

class _PartnerRightContainersState extends State<PartnerRightContainers> {
  String? _selectedPartnerButton;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Expanded(
          child: Container(
            width: screenWidth / 3.99,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: _selectedPartnerButton == "ORGANIZATION" ? AppColors.appColorGreen400 : AppColors.appColorBlackBg,
            ),
            child: AppButton(
              onTap: () {
                if (_selectedPartnerButton == "ORGANIZATION") {
                  setState(() {
                    _selectedPartnerButton = "";
                    widget.getByPartner('');
                  });
                } else {
                  setState(() {
                    _selectedPartnerButton = "ORGANIZATION";
                    widget.getByPartner(_selectedPartnerButton ?? '');
                  });
                }
              },
              hoverRadius: BorderRadius.circular(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(UniconsLine.building, color: AppColors.appColorWhite, size: 35),
                  Text(' Organizatsiya ', style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Container(
            width: screenWidth / 3.99,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: _selectedPartnerButton == "PARTNER" ? AppColors.appColorGreen400 : AppColors.appColorBlackBg,
            ),
            child: AppButton(
              onTap: () {
                if (_selectedPartnerButton == "PARTNER") {
                  setState(() {
                    _selectedPartnerButton = "";
                    widget.getByPartner('');
                  });
                } else {
                  setState(() {
                    _selectedPartnerButton = "PARTNER";
                    widget.getByPartner(_selectedPartnerButton ?? '');
                  });
                }
              },
              hoverRadius: BorderRadius.circular(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(UniconsLine.user_md, color: AppColors.appColorWhite, size: 35),
                  Text(' Kontragent ', style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Container(
            width: screenWidth / 3.99,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: _selectedPartnerButton == "BANK" ? AppColors.appColorGreen400 : AppColors.appColorBlackBg,
            ),
            child: AppButton(
              onTap: () {
                if (_selectedPartnerButton == "BANK") {
                  setState(() {
                    _selectedPartnerButton = "";
                    widget.getByPartner('');
                  });
                } else {
                  setState(() {
                    _selectedPartnerButton = "BANK";
                    widget.getByPartner(_selectedPartnerButton ?? '');
                  });
                }
              },
              hoverRadius: BorderRadius.circular(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.other_houses, color: AppColors.appColorWhite, size: 35),
                  Text(' Bank ', style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
