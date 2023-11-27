import 'package:easy_sell/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/colors.dart';

class AppInputUnderline extends StatefulWidget {
  AppInputUnderline({
    Key? key,
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
    this.onEditingComplete,
    this.controller,
    this.focusNode,
    this.textInputAction,
    this.onChanged,
    this.onSaved,
    this.hideIcon,
    this.defaultValue,
    this.outlineBorder,
    this.textAlign,
    this.readOnly,
    this.numberFormat = true,
    this.onFieldSubmitted,
    this.onTapOutside,
    this.height,
  }) : super(key: key);

  final TextInputType? keyboardType;
  double? height;
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
  final void Function()? onEditingComplete;
  final Function(String)? onFieldSubmitted;
  final void Function(PointerDownEvent event)? onTapOutside;
  final bool? hideIcon;
  final String? defaultValue;
  bool? outlineBorder;
  TextAlign? textAlign;
  bool? readOnly;
  bool numberFormat;

  @override
  State<AppInputUnderline> createState() => _AppInputUnderlineState();
}

class _AppInputUnderlineState extends State<AppInputUnderline> {
  FocusNode focusNode = FocusNode();
  String? error;

  @override
  void initState() {
    super.initState();
    if (widget.numberFormat) {
      widget.controller?.text = formatEditUpdate(widget.controller?.text ?? '');
    }
    widget.controller?.selection = TextSelection(baseOffset: 0, extentOffset: widget.controller?.text.length ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: TextFormField(
        autofocus: true,
        onTapOutside: widget.onTapOutside,
        readOnly: widget.readOnly ?? false,
        onSaved: widget.onSaved,
        initialValue: widget.defaultValue,
        onChanged: widget.onChanged,
        onTap: widget.onTap,
        controller: widget.controller,
        validator: (value) {
          error = widget.validator?.call(value);
          setState(() {});
          return error;
        },
        focusNode: widget.focusNode ?? focusNode,
        textInputAction: widget.textInputAction,
        inputFormatters: widget.inputFormatters,
        keyboardType: widget.keyboardType,
        maxLines: widget.maxLines ?? 1,
        cursorColor: AppColors.appColorGreen400,
        obscureText: widget.textHide ?? false,
        style: TextStyle(color: AppColors.appColorWhite),
        textAlign: widget.textAlign ?? TextAlign.start,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle:
              TextStyle(color: widget.hintTextColor ?? AppColors.appColorGrey300, letterSpacing: 1, fontWeight: FontWeight.w500),
          prefixIcon: widget.hideIcon == true
              ? null
              : Icon(widget.prefixIcon ?? Icons.person,
                  color: widget.iconColor ?? AppColors.appColorGrey300, size: widget.iconSize),
          suffix: (error != null)
              ? Tooltip(
                  message: error,
                  decoration: BoxDecoration(
                    color: AppColors.appColorRed300,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Icon(Icons.info_outline, color: AppColors.appColorRed300, size: 16),
                )
              : widget.suffixIcon,
          enabledBorder: (widget.outlineBorder == false || widget.outlineBorder == null)
              ? UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                  borderSide: BorderSide(color: widget.enableBorderColor ?? AppColors.appColorGrey700),
                )
              : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: widget.enableBorderColor ?? AppColors.appColorGrey700),
                ),
          focusedBorder: (widget.outlineBorder == false || widget.outlineBorder == null)
              ? UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                  borderSide: BorderSide(color: widget.focusedBorderColor ?? AppColors.appColorGreen400),
                )
              : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: widget.focusedBorderColor ?? AppColors.appColorGreen400),
                ),
          errorStyle: const TextStyle(fontSize: 0, height: 0),
        ),
        onEditingComplete: widget.onEditingComplete,
        onFieldSubmitted: widget.onFieldSubmitted,
        selectionControls: DesktopTextSelectionControls(),
      ),
    );
  }
}
