import 'package:flutter/material.dart';
import '../constants/colors.dart';

class AppInput extends StatefulWidget {
  AppInput({
    Key? key,
    this.onChanged,
    this.hintText,
    this.prefixIcon,
    this.borderRadius,
    this.fillColor,
    this.maxHeight,
    this.padding,
    this.suffixIcon,
    this.controller,
  }) : super(key: key);
  final Function(String)? onChanged;
  final String? hintText;
  final Widget? prefixIcon;
  BorderRadius? borderRadius;
  Color? fillColor;
  double? maxHeight;
  EdgeInsets? padding;
  Widget? suffixIcon;
  TextEditingController? controller;

  @override
  State<AppInput> createState() => _AppInputState();
}

class _AppInputState extends State<AppInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? const EdgeInsets.all(0.0),
      child: TextField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        style: TextStyle(color: AppColors.appColorWhite),
        decoration: InputDecoration(
          constraints: BoxConstraints(maxHeight: widget.maxHeight ?? 35),
          contentPadding: const EdgeInsets.all(0),
          hintText: widget.hintText,
          hintStyle: TextStyle(color: AppColors.appColorWhite),
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
          border: OutlineInputBorder(borderRadius: widget.borderRadius ?? BorderRadius.circular(10), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(10), borderSide: BorderSide(color: AppColors.appColorGreen700, width: 1.5)),
          filled: true,
          fillColor: widget.fillColor ?? AppColors.appColorBlackBg.withOpacity(0.4),
        ),
        autofocus: true,
      ),
    );
  }
}
