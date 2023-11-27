import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../utils/utils.dart';
import 'app_input_underline.dart';

class AppEditableWidget extends StatefulWidget {
  const AppEditableWidget({super.key, this.controller, required this.onChanged, this.hinText});

  final TextEditingController? controller;
  final Function(String) onChanged;
  final String? hinText;

  @override
  State<AppEditableWidget> createState() => _AppEditableWidgetState();
}

class _AppEditableWidgetState extends State<AppEditableWidget> {
  bool isEditable = false;

  @override
  Widget build(BuildContext context) {
    return isEditable
        ? AppInputUnderline(
            controller: widget.controller,
            hintText: widget.hinText ?? '',
            onChanged: (String value) {
              widget.onChanged(value);
            },
            hideIcon: true,
            textAlign: TextAlign.center,
            inputFormatters: [AppTextInputFormatter()],
            onTapOutside: (PointerDownEvent? event) {
              setState(() {
                isEditable = false;
              });
            },
          )
        : GestureDetector(
            onTap: () {
              setState(() {
                isEditable = true;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Text(
                widget.controller?.text ?? '',
                style: TextStyle(color: AppColors.appColorWhite, fontSize: 14),
                textAlign: TextAlign.end,
              ),
            ),
          );
  }
}
