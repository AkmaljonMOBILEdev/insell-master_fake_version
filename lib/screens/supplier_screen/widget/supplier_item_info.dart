import 'package:easy_sell/widgets/app_button.dart';
import 'package:easy_sell/widgets/app_sort_button.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
import '../../../constants/colors.dart';

class SupplierItemInfo extends StatefulWidget {
  const SupplierItemInfo({Key? key, required this.sortByName, required this.sorted}) : super(key: key);
  final Function sortByName;
  final bool sorted;

  @override
  State<SupplierItemInfo> createState() => _SupplierItemInfoState();
}

class _SupplierItemInfoState extends State<SupplierItemInfo> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.appColorBlackBg.withOpacity(0.4),
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 5),
          SizedBox(
            width: screenWidth / 1.38,
            child: Row(
              children: [
                const SizedBox(width: 10),
                Expanded(
                  flex: 0,
                  child: Text('№:', style: TextStyle(color: AppColors.appColorWhite)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      AppSortButton(
                        icon: UniconsLine.user_circle,
                        title: ' F.I.O:',
                        sortedIcon: widget.sorted ? Icons.arrow_drop_up_sharp : Icons.arrow_drop_down_sharp,
                        onTap: () => widget.sortByName(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Icon(UniconsLine.location_point, color: AppColors.appColorWhite, size: 19),
                      Text(' Organizatsiya:', style: TextStyle(color: AppColors.appColorWhite)),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Icon(UniconsLine.phone, color: AppColors.appColorWhite, size: 19),
                      Text(' Tel raqami:', style: TextStyle(color: AppColors.appColorWhite)),
                    ],
                  ),
                ),
                const SizedBox(width: 40)
              ],
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
