import 'package:easy_sell/constants/colors.dart';
import 'package:flutter/material.dart';

import 'app_button.dart';

class AppRadioButton extends StatefulWidget {
  const AppRadioButton({super.key, required this.label, required this.isSelected, required this.onChanged, this.width, this.height, this.icon});

  final String label;
  final IconData? icon;
  final bool isSelected;
  final ValueChanged<bool> onChanged;
  final double? width;
  final double? height;

  @override
  State<AppRadioButton> createState() => _AppRadioButtonState();
}

class _AppRadioButtonState extends State<AppRadioButton> {
  @override
  Widget build(BuildContext context) {
    return AppButton(
      onTap: () => widget.onChanged(!widget.isSelected),
      width: widget.width ?? 76,
      height: widget.height ?? 30,
      color: widget.isSelected ? AppColors.appColorGreen300 : AppColors.appColorGrey700,
      borderRadius: BorderRadius.circular(10),
      hoverRadius: BorderRadius.circular(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(widget.isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked, color: AppColors.appColorWhite, size: 23),
          const SizedBox(width: 3),
          Text(widget.label, style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
        ],
      ),
    );
  }
}
