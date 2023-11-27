import 'package:flutter/material.dart';
import '../constants/colors.dart';

class AppDialog extends StatefulWidget {
  AppDialog({Key? key, this.backgroundColor, this.surfaceTintColor, this.borderRadius, this.title, this.content, this.actions}) : super(key: key);
  Color? backgroundColor;
  Color? surfaceTintColor;
  BorderRadiusGeometry? borderRadius;
  Widget? title;
  Widget? content;
  List<Widget>? actions;

  @override
  State<AppDialog> createState() => _AppDialogState();
}

class _AppDialogState extends State<AppDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: widget.backgroundColor ?? AppColors.appColorBlackBg,
      surfaceTintColor: widget.surfaceTintColor ?? Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: widget.borderRadius ?? const BorderRadius.all(Radius.circular(15.0)),
      ),
      title: widget.title ?? const SizedBox(),
      content: widget.content ?? const SizedBox(),
      actions: widget.actions ?? [],
    );
  }
}
