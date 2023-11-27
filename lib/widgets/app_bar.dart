import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'app_button.dart';

class AppBarWidget extends StatefulWidget {
  AppBarWidget({Key? key, this.title, this.centerTitle, required this.onTapBack, this.actions, this.backgroundColor}) : super(key: key);
  Widget? title;
  bool? centerTitle;
  final void Function() onTapBack;
  Color? backgroundColor;
  List<Widget>? actions;

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: widget.backgroundColor,
      title: widget.title,
      centerTitle: widget.centerTitle,
      leading: AppButton(
        onTap: widget.onTapBack,
        width: 50,
        height: 50,
        margin: const EdgeInsets.all(7),
        color: AppColors.appColorGrey700.withOpacity(0.5),
        hoverColor: AppColors.appColorGreen300,
        colorOnClick: AppColors.appColorGreen700,
        splashColor: AppColors.appColorGreen700,
        borderRadius: BorderRadius.circular(13),
        hoverRadius: BorderRadius.circular(13),
        child: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.appColorWhite),
      ),
      actions: widget.actions,
    );
  }
}
