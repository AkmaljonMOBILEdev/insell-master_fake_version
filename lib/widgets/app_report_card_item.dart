import 'package:flutter/material.dart';

import '../constants/colors.dart';

class AppReportCardItem extends StatelessWidget {
  final Icon icon;
  final String title;
  final String resultLabel;
  const AppReportCardItem({super.key, required this.icon, required this.title, required this.resultLabel});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 130,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(color: AppColors.appColorGrey700.withOpacity(0.7), borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.black54),
            child: icon,
          ),
          Text(title, style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: AppColors.appColorGrey700),
            child: Text(resultLabel, style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
