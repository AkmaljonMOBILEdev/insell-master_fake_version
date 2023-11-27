import 'package:flutter/material.dart';

class AppReadAndWriteWidget extends StatefulWidget {
  const AppReadAndWriteWidget({super.key, required this.value, required this.setter});

  final String value;
  final Function(String) setter;

  @override
  State<AppReadAndWriteWidget> createState() => _AppReadAndWriteWidgetState();
}

class _AppReadAndWriteWidgetState extends State<AppReadAndWriteWidget> {
  bool isEditable = false;

  String get value => widget.value;

  set value(String val) {
    widget.setter(val);
  }

  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return !isEditable
        ? TextButton(
            onPressed: () {
              setState(() {
                isEditable = true;
              });
              focusNode.requestFocus();
            },
            child: Text(
              widget.value,
              style: const TextStyle(color: Colors.white),
            ),
          )
        : SizedBox(
            width: 100,
            child: TextFormField(
              focusNode: focusNode,
              initialValue: widget.value,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  )),
              onFieldSubmitted: (value) {
                setState(() {
                  isEditable = false;
                });
              },
              onTapOutside: (value) {
                setState(() {
                  isEditable = false;
                });
              },
              validator: (String? val) {
                if (val == null || val.isEmpty) {
                  return 'Maydon to\'ldirilishi shart';
                }
                RegExp spaceRemover = RegExp(r'\s+');
                val = val.replaceAll(spaceRemover, '');
                val = val.replaceAll(',', '.');
                if (double.tryParse(val) == null) {
                  return 'Faqat son kiriting';
                }
                return null;
              },
              onChanged: (String val) {
                RegExp spaceRemover = RegExp(r'\s+');
                val = val.replaceAll(spaceRemover, '');
                setState(() {
                  value = val;
                });
              },
            ),
          );
  }
}
