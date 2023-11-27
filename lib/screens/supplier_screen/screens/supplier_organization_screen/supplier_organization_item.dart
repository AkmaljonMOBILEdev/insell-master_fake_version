import 'package:easy_sell/database/model/supplier_organization_dto.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

import '../../../../constants/colors.dart';
import '../../../../widgets/app_button.dart';

class SupplierOrganizationItem extends StatefulWidget {
  const SupplierOrganizationItem({super.key, required this.item, required this.index, required this.callback});

  final SupplierOrganizationDto item;
  final int index;
  final Function callback;

  @override
  State<SupplierOrganizationItem> createState() => _SupplierOrganizationItemState();
}

class _SupplierOrganizationItemState extends State<SupplierOrganizationItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 45,
          child: Row(
            children: [
              Expanded(
                flex: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                  decoration: BoxDecoration(color: AppColors.appColorGreen700, borderRadius: BorderRadius.circular(5)),
                  child: Text('${widget.index + 1}', style: TextStyle(color: AppColors.appColorWhite)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.item.name, style: TextStyle(color: AppColors.appColorWhite)),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(widget.item.address ?? '-', style: TextStyle(color: AppColors.appColorWhite)),
              ),
              Expanded(
                flex: 1,
                child: Text(widget.item.phoneNumber ?? '-', style: TextStyle(color: AppColors.appColorWhite)),
              ),
              AppButton(
                onTap: () {
                  // showDialog(
                  //   context: context,
                  //   builder: (BuildContext context) {
                  //     return SupplierInfoDialog(
                  //       supplier: widget.supplier,
                  //       callback: widget.callback,
                  //     );
                  //   },
                  // );
                },
                width: 30,
                height: 30,
                borderRadius: BorderRadius.circular(10),
                hoverRadius: BorderRadius.circular(10),
                hoverColor: AppColors.appColorGreen300,
                child: Center(child: Icon(UniconsLine.eye, color: AppColors.appColorWhite, size: 20)),
              ),
            ],
          ),
        ),
        const Divider(
          height: 1,
          color: Colors.white24,
        ),
      ],
    );
  }
}
