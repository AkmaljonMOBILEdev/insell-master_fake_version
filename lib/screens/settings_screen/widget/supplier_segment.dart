import 'dart:convert';

import 'package:easy_sell/services/https_services.dart';
import 'package:easy_sell/widgets/app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_input_underline.dart';

class SupplierSegment extends StatefulWidget {
  const SupplierSegment({super.key});

  @override
  State<SupplierSegment> createState() => _SupplierSegmentState();
}

class _SupplierSegmentState extends State<SupplierSegment> {
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
                    builder: (context) => AddSupplierSegmentDialog(
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
                future: HttpServices.get("/settings/supplier-segment/all"),
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
                                        builder: (context) => AddSupplierSegmentDialog(
                                              value: item,
                                              onAdd: () {
                                                setState(() {});
                                              },
                                            ));
                                  },
                                  icon: const Icon(Icons.edit, color: Colors.deepOrangeAccent, size: 25)),
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

class AddSupplierSegmentDialog extends StatefulWidget {
  const AddSupplierSegmentDialog({super.key, required this.onAdd, this.value});

  final Function onAdd;
  final dynamic value;

  @override
  State<AddSupplierSegmentDialog> createState() => _AddSupplierSegmentDialogState();
}

class _AddSupplierSegmentDialogState extends State<AddSupplierSegmentDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.value != null) {
      _nameController.text = widget.value['name'];
      _descriptionController.text = widget.value['description'];
    }
  }

  void onCreate() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    var response = await HttpServices.post("/settings/supplier-segment/create", {
      "name": _nameController.text,
      "description": _descriptionController.text,
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
    var response = await HttpServices.put("/settings/supplier-segment/${widget.value['id']}", {
      "name": _nameController.text,
      "description": _descriptionController.text,
    });
    if (response.statusCode == 200) {
      widget.onAdd();
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: Text('Segment qo\'shish', style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 300,
          height: 250,
          child: Column(
            children: [
              AppInputUnderline(
                controller: _nameController,
                hintText: 'Segment nomi',
                onChanged: (value) {},
                prefixIcon: Icons.add_box_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Segment nomi bo\'sh bo\'lishi mumkin emas';
                  }
                  return null;
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
                    Text(widget.value == null ? 'Qo\'shish' : 'O\'zgartirish',
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
