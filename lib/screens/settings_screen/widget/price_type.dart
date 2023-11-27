import 'dart:convert';

import 'package:easy_sell/services/https_services.dart';
import 'package:easy_sell/widgets/app_dialog.dart';
import 'package:easy_sell/widgets/app_table_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../database/model/price_type_struct.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_input_underline.dart';

class PriceTypeWidget extends StatefulWidget {
  const PriceTypeWidget({super.key});

  @override
  State<PriceTypeWidget> createState() => _PriceTypeWidgetState();
}

class _PriceTypeWidgetState extends State<PriceTypeWidget> {
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
                    builder: (context) => AddPriceTypeWidget(
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
                future: HttpServices.get("/settings/price-type/all"),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var json = jsonDecode(snapshot.data?.body ?? '')['data'];
                    return ListView.separated(
                      separatorBuilder: (context, index) => const Divider(color: Colors.white, thickness: 0.3, height: 0),
                      itemCount: json.length,
                      itemBuilder: (context, index) {
                        var item = json[index];
                        PriceTypeDataStruct currencyDto = PriceTypeDataStruct.fromJson(item);
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
                                    child: Text(currencyDto.defaultPriceType ? "Asosiy" : "",
                                        style: TextStyle(color: AppColors.appColorWhite, fontSize: 18))),
                              ),
                              AppTableItemStruct(
                                innerWidget: Center(
                                  child: IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => AddPriceTypeWidget(
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

class AddPriceTypeWidget extends StatefulWidget {
  const AddPriceTypeWidget({super.key, required this.onAdd, this.currencyDto});

  final Function onAdd;
  final PriceTypeDataStruct? currencyDto;

  @override
  State<AddPriceTypeWidget> createState() => _AddPriceTypeWidgetState();
}

class _AddPriceTypeWidgetState extends State<AddPriceTypeWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PriceTypeDto currencyDto = PriceTypeDto(name: "", defaultCurrency: false, id: 0);

  @override
  void initState() {
    super.initState();
    if (widget.currencyDto != null) {
      currencyDto = PriceTypeDto(
        id: widget.currencyDto?.id ?? 0,
        name: widget.currencyDto?.name ?? "",
        defaultCurrency: widget.currencyDto?.defaultPriceType ?? false,
      );
    }
  }

  void onCreate() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState?.save();
    var response = await HttpServices.post("/settings/price-type/create", currencyDto.toJson());
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
    var response = await HttpServices.put("/settings/price-type/${widget.currencyDto?.id}", currencyDto.toJson());
    if (response.statusCode == 200) {
      widget.onAdd();
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      backgroundColor: AppColors.appColorBlackBg,
      title: Text('Narx turi qo\'shish', style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 200,
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppInputUnderline(
                defaultValue: currencyDto.name,
                onSaved: (value) {
                  currencyDto.name = value ?? "";
                },
                hintText: 'Narx turi nomi*',
                prefixIcon: Icons.drive_file_rename_outline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bo\'sh bo\'lishi mumkin emas';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
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

class PriceTypeDto {
  int id;
  String name;
  bool defaultCurrency;

  PriceTypeDto({
    required this.id,
    required this.name,
    this.defaultCurrency = false,
  });

  // from json
  factory PriceTypeDto.fromJson(Map<String, dynamic> json) => PriceTypeDto(
        name: json["name"],
        defaultCurrency: json["default"],
        id: json["id"],
      );

  // to json
  Map<String, dynamic> toJson() => {
        "name": name,
        "default": defaultCurrency,
        "id": id,
      };
}
