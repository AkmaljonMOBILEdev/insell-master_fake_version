import 'package:easy_sell/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/colors.dart';

class AppInputFormSubmit extends StatefulWidget {
  AppInputFormSubmit({
    Key? key,
    required this.onFieldSubmitted,
    this.keyboardType,
    this.maxLines,
    this.hintTextColor,
    required this.hintText,
    this.enableBorderColor,
    this.focusedBorderColor,
    this.prefixIcon,
    this.suffixIcon,
    this.textHide,
    this.iconSize,
    this.iconColor,
    this.validator,
    this.inputFormatters,
    this.onTap,
    this.controller,
    this.focusNode,
    this.textInputAction,
    this.onChanged,
    this.onSaved,
    this.hideIcon,
    this.defaultValue,
    this.onEditingComplete,
  }) : super(key: key);

  TextInputType? keyboardType;
  int? maxLines;
  final String hintText;
  Color? hintTextColor;
  Color? enableBorderColor;
  Color? focusedBorderColor;
  IconData? prefixIcon;
  Widget? suffixIcon;
  bool? textHide;
  double? iconSize;
  Color? iconColor;
  List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  void Function()? onTap;
  TextEditingController? controller;
  FocusNode? focusNode;
  TextInputAction? textInputAction;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final bool? hideIcon;
  final String? defaultValue;
  final Function(String) onFieldSubmitted;
  final void Function()? onEditingComplete;

  @override
  State<AppInputFormSubmit> createState() => _AppInputFormSubmitState();
}

class _AppInputFormSubmitState extends State<AppInputFormSubmit> {
  @override
  void initState() {
    super.initState();
    widget.controller?.text = formatEditUpdate(widget.controller?.text ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: true,
      autofocus: true,
      textInputAction: widget.textInputAction ?? TextInputAction.search,
      keyboardType: TextInputType.text,
      onSaved: widget.onSaved,
      initialValue: widget.defaultValue,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      controller: widget.controller,
      focusNode: widget.focusNode,
      validator: widget.validator,
      inputFormatters: widget.inputFormatters,
      maxLines: widget.maxLines ?? 1,
      cursorColor: AppColors.appColorGreen400,
      obscureText: widget.textHide ?? false,
      style: TextStyle(color: AppColors.appColorWhite),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(color: widget.hintTextColor ?? AppColors.appColorGrey300, letterSpacing: 1, fontWeight: FontWeight.w500),
        prefixIcon: widget.hideIcon == true
            ? null
            : Icon(
                widget.prefixIcon ?? Icons.person,
                color: widget.iconColor ?? AppColors.appColorGrey300,
                size: widget.iconSize,
              ),
        suffixIcon: widget.suffixIcon,
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: BorderSide(color: widget.enableBorderColor ?? AppColors.appColorGrey700),
        ),
        focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: BorderSide(color: widget.focusedBorderColor ?? AppColors.appColorGreen400),
        ),
      ),
      onEditingComplete: widget.onEditingComplete,
      onFieldSubmitted: (value) {
        widget.onFieldSubmitted(value);
      },
    );
  }
}
