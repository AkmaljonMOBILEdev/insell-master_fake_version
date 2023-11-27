import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
import '../../../../../constants/colors.dart';
import '../../../../../widgets/app_sort_button.dart';

class MoneySendHistoryItemInfo extends StatefulWidget {
  const MoneySendHistoryItemInfo({Key? key, required this.sortByName, required this.sorted, this.width}) : super(key: key);
  final Function sortByName;
  final bool sorted;
  final double? width;

  @override
  State<MoneySendHistoryItemInfo> createState() => _MoneySendHistoryItemInfoState();
}

class _MoneySendHistoryItemInfoState extends State<MoneySendHistoryItemInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.appColorBlackBg.withOpacity(0.4),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 5),
          SizedBox(
            width: widget.width,
            child: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 0,
                  child: Text('№:', style: TextStyle(color: AppColors.appColorWhite)),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      AppSortButton(
                        width: 120,
                        icon: Icons.arrow_upward_rounded,
                        title: ' Kimdan:',
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
                      Icon(UniconsLine.calendar_alt, color: AppColors.appColorWhite, size: 20),
                      Text(' Sana:', style: TextStyle(color: AppColors.appColorWhite)),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Icon(UniconsLine.money_bill, color: AppColors.appColorWhite, size: 19),
                      Text(' Miqdor:', style: TextStyle(color: AppColors.appColorWhite)),
                    ],
                  ),
                ),
                const SizedBox(width: 80),
              ],
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
