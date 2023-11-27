import 'dart:convert';

import 'package:easy_sell/database/model/currency_dto.dart';
import 'package:easy_sell/services/https_services.dart';
import 'package:easy_sell/widgets/app_dialog.dart';
import 'package:easy_sell/widgets/app_table_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_input_underline.dart';

class CurrencyAddListWidget extends StatefulWidget {
  const CurrencyAddListWidget({super.key});

  @override
  State<CurrencyAddListWidget> createState() => _CurrencyAddListWidgetState();
}

class _CurrencyAddListWidgetState extends State<CurrencyAddListWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: AppButton(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => AddExpenseTypeDialog(
                          onAdd: () {
                            setState(() {});
                          },
                        ));
              },
              width: 200,
              height: 50,
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
          ),
          Expanded(
              flex: 10,
              child: FutureBuilder(
                future: HttpServices.get("/currency/all"),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var json = jsonDecode(snapshot.data?.body ?? '')['data'];
                    return ListView.separated(
                      separatorBuilder: (context, index) => const Divider(color: Colors.white, thickness: 0.3, height: 0),
                      itemCount: json.length,
                      itemBuilder: (context, index) {
                        var item = json[index];
                        CurrencyDataStruct currencyDto = CurrencyDataStruct.fromJson(item);
                        return Container(
                          decoration: BoxDecoration(
                            color: AppColors.appColorBlackBg,
                            border: Border.all(color: AppColors.appColorGrey300.withOpacity(0.2)),
                          ),
                          child: AppTableItems(
                            height: 40,
                            hideBorder: true,
                            items: [
                              AppTableItemStruct(
                                innerWidget: Center(
                                    child:
                                        Text(currencyDto.name, style: TextStyle(color: AppColors.appColorWhite, fontSize: 18))),
                              ),
                              AppTableItemStruct(
                                innerWidget: Center(
                                    child: Text(currencyDto.abbreviation,
                                        style: TextStyle(color: AppColors.appColorWhite, fontSize: 18))),
                              ),
                              AppTableItemStruct(
                                innerWidget: Center(
                                    child:
                                        Text(currencyDto.symbol, style: TextStyle(color: AppColors.appColorWhite, fontSize: 18))),
                              ),
                              AppTableItemStruct(
                                innerWidget: Center(
                                    child: Text(currencyDto.defaultCurrency ? "Asosiy" : "",
                                        style: TextStyle(color: AppColors.appColorWhite, fontSize: 18))),
                              ),
                              AppTableItemStruct(
                                innerWidget: Center(
                                  child: IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => AddExpenseTypeDialog(
                                                onAdd: () {
                                                  setState(() {});
                                                },
                                                currencyDto: currencyDto,
                                              ));
                                    },
                                    icon: Icon(Icons.edit_rounded, color: AppColors.appColorWhite, size: 25),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: CircularProgressIndicator(color: AppColors.appColorGreen400));
                  }
                },
              )),
        ],
      ),
    );
  }
}

class AddExpenseTypeDialog extends StatefulWidget {
  const AddExpenseTypeDialog({super.key, required this.onAdd, this.currencyDto});

  final Function onAdd;
  final CurrencyDataStruct? currencyDto;

  @override
  State<AddExpenseTypeDialog> createState() => _AddExpenseTypeDialogState();
}

class _AddExpenseTypeDialogState extends State<AddExpenseTypeDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  CurrencyDto currencyDto = CurrencyDto(name: "", abbreviation: "", symbol: "", defaultCurrency: false);

  @override
  void initState() {
    super.initState();
    if (widget.currencyDto != null) {
      currencyDto = CurrencyDto(
        name: widget.currencyDto?.name ?? "",
        abbreviation: widget.currencyDto?.abbreviation ?? "",
        symbol: widget.currencyDto?.symbol ?? "",
        defaultCurrency: widget.currencyDto?.defaultCurrency ?? false,
      );
    }
  }

  void onCreate() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState?.save();
    var response = await HttpServices.post("/currency/create", currencyDto.toJson());
    if (response.statusCode == 201) {
      widget.onAdd();
      Get.back();
    }
  }

  void onUpdate() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState?.save();
    var response = await HttpServices.put("/currency/${widget.currencyDto?.id}", currencyDto.toJson());
    print(response.body);
    if (response.statusCode == 200) {
      widget.onAdd();
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      backgroundColor: AppColors.appColorBlackBg,
      title: Text('Valyuta turi qo\'shish', style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 200,
          height: 350,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppInputUnderline(
                defaultValue: currencyDto.name,
                onSaved: (value) {
                  currencyDto.name = value ?? "";
                },
                hintText: 'Valyuta nomi*',
                prefixIcon: Icons.drive_file_rename_outline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Valyuta nomi bo\'sh bo\'lishi mumkin emas';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              AppInputUnderline(
                defaultValue: currencyDto.abbreviation,
                onSaved: (value) {
                  currencyDto.abbreviation = value ?? "";
                },
                hintText: 'Valyuta qisqartmasi*',
                prefixIcon: Icons.abc,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Valyuta qisqartmasi bo\'sh bo\'lishi mumkin emas';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              AppInputUnderline(
                defaultValue: currencyDto.symbol,
                onSaved: (value) {
                  currencyDto.symbol = value ?? "";
                },
                hintText: 'Valyuta simvoli',
                prefixIcon: Icons.back_hand_rounded,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Asosiy qilish', style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
                  Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      value: currencyDto.defaultCurrency,
                      activeColor: AppColors.appColorGreen400,
                      onChanged: (bool value) {
                        setState(() {
                          currencyDto.defaultCurrency = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const Spacer(),
              AppButton(
                onTap: widget.currencyDto != null ? onUpdate : onCreate,
                width: 200,
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
          ),
        ),
      ),
    );
  }
}

class CurrencyDto {
  String name;
  String abbreviation;
  String symbol;
  bool defaultCurrency;

  CurrencyDto({
    required this.name,
    required this.abbreviation,
    this.symbol = "",
    this.defaultCurrency = false,
  });

  // to json
  Map<String, dynamic> toJson() => {
        "name": name,
        "abbreviation": abbreviation,
        "symbol": symbol,
        "default": defaultCurrency,
      };
}
