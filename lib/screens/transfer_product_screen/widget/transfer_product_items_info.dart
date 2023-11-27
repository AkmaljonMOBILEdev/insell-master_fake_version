import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
import '../../../constants/colors.dart';

class MoveProductItemsInfo extends StatefulWidget {
  const MoveProductItemsInfo({Key? key}) : super(key: key);

  @override
  State<MoveProductItemsInfo> createState() => _MoveProductItemsInfoState();
}

class _MoveProductItemsInfoState extends State<MoveProductItemsInfo> {
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
                const SizedBox(width: 20),
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Icon(Icons.reply, color: AppColors.appColorWhite, size: 20),
                      Text(' Yuboruvchi:', style: TextStyle(color: AppColors.appColorWhite)),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Icon(UniconsLine.share, color: AppColors.appColorWhite, size: 20),
                      Text(' Qabul qiluvchi:', style: TextStyle(color: AppColors.appColorWhite)),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Icon(Icons.calendar_month_rounded, color: AppColors.appColorWhite, size: 20),
                      Text(' Vaqti:', style: TextStyle(color: AppColors.appColorWhite)),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Icon(Icons.featured_play_list_outlined, color: AppColors.appColorWhite, size: 19),
                      Text(' Status:', style: TextStyle(color: AppColors.appColorWhite)),
                    ],
                  ),
                ),
                const SizedBox(width: 20)
              ],
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
