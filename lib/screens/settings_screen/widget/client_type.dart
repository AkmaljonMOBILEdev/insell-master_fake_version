import 'dart:convert';
import 'package:easy_sell/services/https_services.dart';
import 'package:easy_sell/widgets/app_autocomplete.dart';
import 'package:easy_sell/widgets/app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';

import '../../../constants/colors.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_input_underline.dart';

class ClientTypesWidget extends StatefulWidget {
  const ClientTypesWidget({super.key});

  @override
  State<ClientTypesWidget> createState() => _ClientTypesWidgetState();
}

class _ClientTypesWidgetState extends State<ClientTypesWidget> {
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
                    builder: (context) => AddClientTypeDialog(
                          value: null,
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
              flex: 11,
              child: FutureBuilder(
                future: HttpServices.get("/settings/client-type/all"),
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
                              Text("${index + 1}. ${item['name']}",
                                  style: TextStyle(color: AppColors.appColorWhite, fontSize: 18)),
                              IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AddClientTypeDialog(
                                              value: item,
                                              onAdd: () {
                                                setState(() {});
                                              },
                                            ));
                                  },
                                  icon: const Icon(Icons.edit_rounded, color: Colors.deepOrangeAccent, size: 25)),
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

class AddClientTypeDialog extends StatefulWidget {
  const AddClientTypeDialog({super.key, required this.onAdd, this.value});

  final Function onAdd;
  final dynamic value;

  @override
  State<AddClientTypeDialog> createState() => _AddClientTypeDialogState();
}

class _AddClientTypeDialogState extends State<AddClientTypeDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool tradeDebt = false;
  bool banned = false;
  int? cashbackId;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.value != null) {
      print(widget.value);
      _nameController.text = widget.value['name'];
      _descriptionController.text = widget.value['description'];
      tradeDebt = widget.value['tradeDebt'];
      banned = widget.value['banned'];
      cashbackId = widget.value['cashbackId'];
    }
  }

  void onCreate() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    var response = await HttpServices.post("/settings/client-type/create", {
      "name": _nameController.text,
      "description": _descriptionController.text,
      "tradeDebt": tradeDebt,
      "banned": banned,
      "cashbackId": cashbackId ?? "",
    });
    if (response.statusCode == 201) {
      widget.onAdd();
      Get.back();
    }
  }

  void onUpdate() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    var response = await HttpServices.put("/settings/client-type/${widget.value['id']}", {
      "name": _nameController.text,
      "description": _descriptionController.text,
      "tradeDebt": tradeDebt,
      "banned": banned,
      "cashbackId": cashbackId ?? "",
    });
    if (response.statusCode == 200) {
      widget.onAdd();
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: Text('Xarajat turi qo\'shish', style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 300,
          height: 350,
          child: Column(
            children: [
              AppInputUnderline(
                controller: _nameController,
                hintText: 'Mijoz turi',
                onChanged: (value) {},
                prefixIcon: Icons.person_3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Xarajat turi nomi bo\'sh bo\'lishi mumkin emas';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              FutureBuilder(
                future: HttpServices.get("/settings/cashback/all"),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var json = jsonDecode(snapshot.data?.body ?? '')['data'];
                    List<AutocompleteDataStruct> data = [];
                    for (var item in json) {
                      data.add(AutocompleteDataStruct(value: item['name'], uniqueId: item['id']));
                    }
                    return AppAutoComplete(
                      initialValue: data.firstWhereOrNull((element) => element.uniqueId == cashbackId)?.value,
                      getValue: (AutocompleteDataStruct value) {
                        setState(() {
                          cashbackId = value.uniqueId;
                        });
                      },
                      options: data,
                      hintText: 'Cashback turi',
                      prefixIcon: UniconsLine.percentage,
                    );
                  } else {
                    return Center(child: CircularProgressIndicator(color: AppColors.appColorGreen400));
                  }
                },
              ),
              const SizedBox(height: 20),
              AppInputUnderline(
                controller: _descriptionController,
                hintText: 'Izoh',
                onChanged: (value) {},
                prefixIcon: Icons.comment,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Qarzga berish', style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
                  Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      value: tradeDebt,
                      activeColor: AppColors.appColorGreen400,
                      onChanged: (bool value) {
                        setState(() {
                          tradeDebt = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Bloklash', style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
                  Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      value: banned,
                      activeColor: AppColors.appColorGreen400,
                      onChanged: (bool value) {
                        setState(() {
                          banned = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Spacer(),
              AppButton(
                onTap: widget.value == null ? onCreate : onUpdate,
                width: 300,
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
                    Text(widget.value == null ? 'Qo\'shish' : "Yangilash",
                        style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
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
