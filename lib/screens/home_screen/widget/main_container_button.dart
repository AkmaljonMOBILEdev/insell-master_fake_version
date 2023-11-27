import 'package:flutter/material.dart';
import '../../../generated/assets.dart';
import '../../../constants/colors.dart';
import '../../../widgets/app_button.dart';


class MainContainerButton extends StatelessWidget {
  const MainContainerButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return AppButton(
      onTap: () {
        print('Clicked');
      },
      width: screenWidth / 3.5,
      height: 85,
      margin: const EdgeInsets.all(5),
      borderRadius: BorderRadius.circular(30),
      hoverRadius: BorderRadius.circular(30),
      color: AppColors.appColorBlackBg,
      hoverColor: AppColors.appColorBlackBgHover,
      colorOnClick: AppColors.appColorBlackBg,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            Image.asset(
              Assets.imagesPos,
              width: 60,
              height: 60,
            ),
            const SizedBox(width: 10),
            Text('Kassa', style: TextStyle(color: AppColors.appColorWhite, fontWeight: FontWeight.w500, fontSize: 40, letterSpacing: 3)),
          ],
        ),
      ),
    );
  }
}
