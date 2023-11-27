import 'dart:convert';

import 'package:easy_sell/services/https_services.dart';
import 'package:easy_sell/utils/utils.dart';
import 'package:easy_sell/widgets/app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_input_underline.dart';

class CurrencySide extends StatefulWidget {
  const CurrencySide({super.key});

  @override
  State<CurrencySide> createState() => _CurrencySideState();
}

class _CurrencySideState extends State<CurrencySide> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppButton(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AddExpenseTypeDialog(
                  onAdd: () {
                    setState(() {});
                  },
                ),
              );
            },
            width: 150,
            height: 40,
            margin: const EdgeInsets.all(10),
            color: AppColors.appColorGreen400,
            hoverRadius: BorderRadius.circular(10),
            borderRadius: BorderRadius.circular(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_rounded, color: AppColors.appColorWhite, size: 25),
                const SizedBox(width: 10),
                Text('Qo\'shish', style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
              ],
            ),
          ),
          Expanded(
            flex: 10,
            child: FutureBuilder(
              future: HttpServices.get("/expense-type/all"),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var json = jsonDecode(snapshot.data?.body ?? '')['data'];
                  return ListView.builder(
                    itemCount: json.length,
                    itemBuilder: (context, index) {
                      var item = json[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: AppColors.appColorGrey300.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${index + 1}. ${item['name']}", style: TextStyle(color: AppColors.appColorWhite, fontSize: 18)),
                            Text(formatDateTimeEpoch(item['createdAt']), style: TextStyle(color: AppColors.appColorWhite, fontSize: 18)),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator(color: AppColors.appColorGreen400));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AddExpenseTypeDialog extends StatefulWidget {
  const AddExpenseTypeDialog({super.key, required this.onAdd});

  final Function onAdd;

  @override
  State<AddExpenseTypeDialog> createState() => _AddExpenseTypeDialogState();
}

class _AddExpenseTypeDialogState extends State<AddExpenseTypeDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _abbreviationController = TextEditingController();
  final TextEditingController _symbolController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool affectToProfit = false;

  // void onCreate() async {
  //   if (!_formKey.currentState!.validate()) {
  //     return;
  //   }
  //   var response = await HttpServices.post("/expense-type/create", {
  //     "name": _nameController.text,
  //     "affectToProfit": affectToProfit,
  //   });
  //   if (response.statusCode == 201) {
  //     widget.onAdd();
  //     Get.back();
  //   }
  // }

  // void onUpdate() async {
  //   if (!_formKey.currentState!.validate()) {
  //     return;
  //   }
  //   var response = await HttpServices.put("/expense-type/create", {
  //     "name": _nameController.text,
  //     "affectToProfit": affectToProfit,
  //   });
  //   if (response.statusCode == 200) {
  //     widget.onAdd();
  //     Get.back();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Valyuta turi qo\'shish', style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
          IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.highlight_off_rounded, color: AppColors.appColorRed400, size: 25),
          ),
        ],
      ),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 300,
          height: 200,
          child: Column(
            children: [
              const SizedBox(height: 10),
              AppInputUnderline(
                controller: _nameController,
                hintText: 'Valyuta nomi',
                onChanged: (value) {},
                prefixIcon: Icons.attach_money,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Xarajat turi nomi bo\'sh bo\'lishi mumkin emas';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              AppInputUnderline(
                controller: _abbreviationController,
                hintText: 'Abbreviatura(UZS / USD)',
                onChanged: (value) {},
                prefixIcon: Icons.abc,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Xarajat turi nomi bo\'sh bo\'lishi mumkin emas';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              AppInputUnderline(
                controller: _symbolController,
                hintText: 'Valyuta simvoli',
                onChanged: (value) {},
                prefixIcon: Icons.emoji_symbols_sharp,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Xarajat turi nomi bo\'sh bo\'lishi mumkin emas';
                  }
                  return null;
                },
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
      actions: [
        AppButton(
          onTap: () {},
          width: 170,
          height: 40,
          hoverRadius: BorderRadius.circular(10),
          color: AppColors.appColorGreen400,
          borderRadius: BorderRadius.circular(10),
          hoverColor: AppColors.appColorGreen400.withOpacity(0.8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_rounded, color: AppColors.appColorWhite, size: 25),
              const SizedBox(width: 10),
              Text('Qo\'shish', style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
            ],
          ),
        ),
      ],
    );
  }
}
