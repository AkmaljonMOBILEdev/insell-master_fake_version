import 'package:easy_sell/widgets/app_sort_button.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
import '../../../constants/colors.dart';

class SeasonItemInfo extends StatefulWidget {
  const SeasonItemInfo({Key? key, required this.sortByName, required this.sorted}) : super(key: key);
  final Function sortByName;
  final bool sorted;

  @override
  State<SeasonItemInfo> createState() => _SeasonItemInfoState();
}

class _SeasonItemInfoState extends State<SeasonItemInfo> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

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
                        icon: UniconsLine.umbrella,
                        title: ' Nomi:',
                        // TODO: ikon uchirilsa ham chqib qolishi
                        // onTap: () => widget.sortByName(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      AppSortButton(
                        width: 200,
                        icon: UniconsLine.calendar_alt,
                        title: ' Boshlang\'ich sana:',
                        sortedIcon: widget.sorted ? Icons.arrow_drop_up_sharp : Icons.arrow_drop_down_sharp,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Icon(Icons.calendar_month_outlined, color: AppColors.appColorWhite, size: 19),
                      Text(' Tugash sana:', style: TextStyle(color: AppColors.appColorWhite)),
                    ],
                  ),
                ),
                // Expanded(
                //   flex: 1,
                //   child: Row(
                //     children: [
                //       Icon(UniconsLine.money_bill, color: AppColors.appColorWhite, size: 19),
                //       Text(' Qiymat:', style: TextStyle(color: AppColors.appColorWhite)),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
