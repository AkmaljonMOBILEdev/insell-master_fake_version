import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../constants/colors.dart';
import '../../../../../widgets/app_dialog.dart';
import 'package:http/http.dart' as http;

class ExchangeHistoryDialog extends StatefulWidget {
  const ExchangeHistoryDialog({Key? key}) : super(key: key);

  @override
  State<ExchangeHistoryDialog> createState() => _ExchangeHistoryDialogState();
}

class _ExchangeHistoryDialogState extends State<ExchangeHistoryDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      backgroundColor: Colors.black.withOpacity(0.9),
      title: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(Icons.highlight_off_rounded, color: AppColors.appColorRed400, size: 25),
            ),
          ),
          Text('Kurs tarixi', style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
        ],
      ),
      content: SizedBox(
        height: 500,
        width: 900,
        child: SizedBox(),
      ),
    );
  }
}
