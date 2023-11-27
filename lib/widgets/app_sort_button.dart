import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'app_button.dart';


class AppSortButton extends StatelessWidget {
  AppSortButton({Key? key, this.width, this.height, this.onTap, required this.icon, required this.title, this.sortedIcon}) : super(key: key);
  double? width;
  double? height;
  void Function()? onTap;
  final IconData icon;
  final String title;
  IconData? sortedIcon;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 100,
      height: height ?? 30,
      child: AppButton(
        onTap: onTap,
        splashColor: Colors.transparent,
        child: Row(
          children: [
            Icon(icon, color: AppColors.appColorWhite, size: 19),
            Text(title, style: TextStyle(color: AppColors.appColorWhite)),
            const SizedBox(width: 5),
            Icon(sortedIcon ?? Icons.arrow_drop_up_sharp, color: AppColors.appColorWhite, size: 20),
          ],
        ),
      ),
    );
  }
}
