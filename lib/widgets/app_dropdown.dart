import 'package:easy_sell/utils/translator.dart';
import 'package:flutter/material.dart';
import '../constants/colors.dart';

class AppDropDown extends StatefulWidget {
  const AppDropDown(
      {Key? key, required this.dropDownItems, this.selectedValue, required this.onChanged, this.underlineColor, this.icon, this.iconSize})
      : super(key: key);
  final List<String> dropDownItems;
  final String? selectedValue;
  final ValueChanged<String> onChanged;
  final Color? underlineColor;
  final Widget? icon;
  final double? iconSize;

  @override
  State<AppDropDown> createState() => _AppDropDownState();
}

class _AppDropDownState extends State<AppDropDown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      icon: widget.icon,
      iconSize: widget.iconSize ?? 24,
      dropdownColor: Colors.grey.shade900,
      borderRadius: BorderRadius.circular(20),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 5),
        border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppColors.appColorWhite)),
        focusedBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppColors.appColorWhite)),
      ),
      value: widget.selectedValue,
      onChanged: (value) {
        widget.onChanged(value ?? '');
      },
      items: widget.dropDownItems.map<DropdownMenuItem<String>>(
        (String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(translate(value), style: TextStyle(fontSize: 17, color: AppColors.appColorWhite)),
            ),
          );
        },
      ).toList(),
    );
  }
}
