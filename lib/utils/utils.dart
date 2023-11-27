import 'dart:async';
import 'dart:io';
import 'package:drift/drift.dart' as drift;
import 'package:easy_sell/widgets/app_input_underline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:window_manager/window_manager.dart';
import '../constants/colors.dart';
import '../widgets/app_button.dart';
import 'package:easy_sell/services/storage_services.dart';

Storage storage = Storage();

// Set window min size
void setMinWindowSize(Size size) async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  if (Platform.isWindows) {
    WindowManager.instance.setMinimumSize(size);
  }
  if (Platform.isMacOS) {
    WindowManager.instance.setMinimumSize(size);
  }
}

// set window max size
void setMaxWindowSize(Size size) async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  if (Platform.isWindows) {
    WindowManager.instance.setMaximumSize(size);
  }
  if (Platform.isMacOS) {
    WindowManager.instance.setMaximumSize(size);
  }
}

// set full screen
void toggleFullScreen() async {
  bool isFullScreen = await WindowManager.instance.isFullScreen();
  if (isFullScreen) {
    WindowManager.instance.setFullScreen(false);
    // WindowManager.instance.setClosable(true);
  } else {
    WindowManager.instance.setAsFrameless();
    WindowManager.instance.setFullScreen(true);
  }
}

// Show app snack bar
void showAppSnackBar(BuildContext context, String content, String buttonLabel, {bool isError = false}) {
  final snackBar = SnackBar(
    content: Text(content, style: const TextStyle(fontSize: 17)),
    backgroundColor: isError ? AppColors.appColorRed400 : AppColors.appColorGreen400.withOpacity(0.7),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    action: SnackBarAction(
      label: buttonLabel,
      disabledTextColor: Colors.white,
      textColor: AppColors.appColorWhite,
      backgroundColor: Colors.black54,
      onPressed: () {},
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

// Show app alert dialog
Future<void> showAppAlertDialog(BuildContext context,
    {String title = 'Alert',
    String message = 'This is an alert dialog.',
    String buttonLabel = 'OK',
    String? cancelLabel = '',
    Function()? onConfirm,
    Widget? messageWidget,
    MaterialColor? colorButton}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.black.withOpacity(0.9),
        title: Text(title, style: TextStyle(color: AppColors.appColorRed400)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message, style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
              if (messageWidget != null) messageWidget,
            ],
          ),
        ),
        actions: [
          if (cancelLabel != '')
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AppButton(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  height: 30,
                  width: 100,
                  borderRadius: BorderRadius.circular(10),
                  hoverRadius: BorderRadius.circular(10),
                  child: Center(
                    child: Text('Bekor qilish', style: TextStyle(color: AppColors.appColorWhite)),
                  ),
                ),
                AppButton(
                  onTap: () {
                    Navigator.of(context).pop();
                    if (onConfirm != null) {
                      onConfirm();
                    }
                  },
                  height: 30,
                  width: 100,
                  color: colorButton ?? AppColors.appColorGreen400,
                  borderRadius: BorderRadius.circular(10),
                  hoverRadius: BorderRadius.circular(10),
                  child: Center(
                    child: Text(buttonLabel, style: TextStyle(color: AppColors.appColorWhite)),
                  ),
                ),
              ],
            ),
        ],
      );
    },
  );
}

// Show app scanner dialog with callback
Future<void> showAppScannerDialog(BuildContext context,
    {String title = 'Dialog', String message = 'Message.', Function(String? barcode)? onConfirm}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      String? barcode;
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.black.withOpacity(0.9),
        title: Text(title, style: TextStyle(color: AppColors.appColorWhite)),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.qr_code_scanner_rounded, color: AppColors.appColorGreen400, size: 30),
            const SizedBox(width: 5),
            SizedBox(
              width: 150,
              child: AppInputUnderline(
                hintText: 'Skannerlang...',
                onChanged: (value) {
                  barcode = value;
                },
                onEditingComplete: () {
                  Navigator.of(context).pop();
                  if (onConfirm != null) {
                    onConfirm(barcode?.trim().isEmpty ?? true ? null : barcode?.trim());
                  }
                },
                hideIcon: true,
                focusedBorderColor: Colors.transparent,
              ),
            )
          ],
        ),
        actions: [
          AppButton(
            onTap: () {
              Navigator.of(context).pop();
            },
            height: 30,
            width: 100,
            borderRadius: BorderRadius.circular(10),
            hoverRadius: BorderRadius.circular(10),
            child: Center(child: Text('Bekor qilish', style: TextStyle(color: AppColors.appColorWhite))),
          ),
        ],
      );
    },
  );
}

// Show app date picker
Future<DateTime?> showAppDatePicker(BuildContext context) async {
  DateTime? pickedDate = await showDatePicker(
    locale: const Locale('uz'),
    context: context,
    initialDatePickerMode: DatePickerMode.year,
    initialDate: DateTime.now(),
    firstDate: DateTime(1920),
    lastDate: DateTime(2100),
    builder: (context, child) {
      return Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.dark(
            primary: AppColors.appColorGreen400,
            onPrimary: Colors.white,
            surface: Colors.grey.shade900,
            onSurface: Colors.white,
          ),
          dialogTheme: const DialogTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
          ),
          dialogBackgroundColor: Colors.grey.shade800,
        ),
        child: child ?? Container(),
      );
    },
  );
  if (pickedDate != null) {
    return pickedDate;
  }
  return null;
}

// format date
String formatDate(DateTime? date, {String format = 'dd.MM.yyyy'}) {
  if (date == null) return "";
  final dateFormatter = DateFormat(format);
  return dateFormatter.format(date);
}

String formatDateEpoch(int epoch) {
  final dateFormatter = DateFormat('dd.MM.yyyy');
  final formattedDate = dateFormatter.format(DateTime.fromMillisecondsSinceEpoch(epoch));
  return formattedDate;
}

String formatDateTimeEpoch(int epoch) {
  final dateFormatter = DateFormat('dd.MM.yyyy HH:mm');
  final formattedDate = dateFormatter.format(DateTime.fromMillisecondsSinceEpoch(epoch));
  return formattedDate;
}

String formatDateTime(DateTime? date) {
  if (date == null) return "";
  final dateFormatter = DateFormat('dd.MM.yyyy HH:mm');
  return dateFormatter.format(date);
}

// format number
String formatNumber(dynamic number) {
  final numberFormatter = NumberFormat.decimalPattern('ru_RU');
  if (number == null) return "0";
  if (number is String) {
    number = double.parse(number);
  }
  if (number is int) {
    number = number.toDouble();
  }
  if (number % 1 > 0) {
    number = number.toStringAsFixed(2);
    if (number == '-0.00' || number == '0.00') {
      number = '0';
    }
    return numberFormatter.format(double.parse(number));
  }
  if (number is double) {
    return numberFormatter.format(number);
  }
  return number.toString();
}

// input formatter for numbers
String splitSpace(String text) {
  String result = "";
  int count = 0;
  for (int i = text.length - 1; i >= 0; i--) {
    count++;
    result = text[i] + result;
    if (count == 3 && i != 0) {
      result = " $result";
      count = 0;
    }
  }
  return result;
}

String formatEditUpdate(String defaultText) {
  String text = defaultText.replaceAll(" ", "");
  bool hasDot = text.contains(".");
  if (text.isEmpty) {
    return "";
  }
  // regex for number, a dot and spaces
  RegExp regex = RegExp(r"^\d+\.?\d*$");
  if (!regex.hasMatch(text)) {
    return defaultText;
  }
  if (hasDot) {
    String beforeDot = text.split(".")[0];
    String afterDot = text.split(".")[1];
    beforeDot = splitSpace(beforeDot);
    return "$beforeDot.$afterDot";
  }
  text = splitSpace(text);
  return text;
}

class AppTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    RegExp spaceRemover = RegExp(r"\s+\b|\b\s");
    String text = newValue.text.replaceAll(spaceRemover, "");
    bool hasDot = text.contains(".");
    if (text.isEmpty) {
      return const TextEditingValue(
        text: "",
        selection: TextSelection.collapsed(offset: 0),
      );
    }
    // regex for number, a dot and spaces
    RegExp regex = RegExp(r"^\d+\.?\d*$");
    if (!regex.hasMatch(text)) {
      return oldValue;
    }
    if (hasDot) {
      String beforeDot = text.split(".")[0];
      String afterDot = text.split(".")[1];
      beforeDot = splitSpace(beforeDot);
      return TextEditingValue(
        text: "$beforeDot.$afterDot",
        selection: TextSelection.collapsed(offset: "$beforeDot.$afterDot".length),
      );
    }
    text = splitSpace(text);
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  // get unformatted number
  double getUnformattedNumber(String text) {
    // remove spaces using regex
    if (text.isEmpty) return 0;
    text = text.replaceAll(RegExp(r"\s+\b|\b\s"), "");
    return double.parse(text);
  }
}

drift.Value<T> toValue<T>(T value) => drift.Value<T>(value);

// get printer list
Future<List> getPrintersList() async {
  List printers = [];
  if (Platform.isWindows) {
    ProcessResult results = await Process.run('wmic', ['printer', 'get', 'name']);
    for (var element in results.stdout.toString().replaceAll(" ", '').split('\n')) {
      if (element.isNotEmpty && element != 'Name') {
        printers.add(element);
      }
    }
  } else {
    ProcessResult results = await Process.run('lpstat', ['-a']);
    for (var element in results.stdout.toString().replaceAll(" ", '').split('\n')) {
      if (element.isNotEmpty && element != 'Name') {
        printers.add(element);
      }
    }
  }
  return printers;
}

// get printer config list
Future<List> getPrinterConfigList() async {
  List printers = [];
  if (Platform.isWindows) {
    ProcessResult results = await Process.run('wmic', ['printer', 'get', 'PrinterPaperNames']);
    for (var element in results.stdout.toString().replaceAll(" ", '').split('\n')) {
      if (element.isNotEmpty && element != 'Name') {
        printers.add(element.trim());
      }
    }
  } else {
    ProcessResult results = await Process.run('lpstat', ['-a']);
    for (var element in results.stdout.toString().replaceAll(" ", '').split('\n')) {
      if (element.isNotEmpty && element != 'Name') {
        printers.add(element);
      }
    }
  }
  return printers;
}
