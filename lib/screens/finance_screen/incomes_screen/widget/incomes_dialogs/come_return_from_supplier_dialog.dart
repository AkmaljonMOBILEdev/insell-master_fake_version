import 'dart:convert';

import 'package:easy_sell/database/model/supplier_dto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';
import '../../../../../../constants/colors.dart';
import '../../../../../../widgets/app_button.dart';
import '../../../../../../widgets/app_dialog.dart';
import '../../../../../services/https_services.dart';
import '../../../../../utils/utils.dart';
import '../../../../../widgets/app_autocomplete.dart';
import '../../../../../widgets/app_dropdown.dart';
import '../../../../../widgets/app_input_underline.dart';

class ReturnFromSupplier extends StatefulWidget {
  const ReturnFromSupplier({Key? key}) : super(key: key);

  @override
  State<ReturnFromSupplier> createState() => _ReturnFromSupplierState();
}

class _ReturnFromSupplierState extends State<ReturnFromSupplier> {
  final _formValidation = GlobalKey<FormState>();
  final TextEditingController _sumController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedPayType = "CASH";
  List<SupplierDto> _supplierList = [];
  SupplierDto? selectedSupplier;

  Map<String, String> payType = {
    'CASH': 'НАЛИЧНЫЙ',
    'CARD': 'КАРТА',
    'TRANSFER': 'ПЕРЕЧИСЛЕНИЕ',
    'CASHBACK': 'КЕШБЕК',
  };

  @override
  void initState() {
    super.initState();
    getSupplierList();
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
          Text('Taminotchidan qaytarish', style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
        ],
      ),
      content: SizedBox(
        height: 300,
        width: 400,
        child: Form(
          key: _formValidation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AppAutoComplete(
                  getValue: (AutocompleteDataStruct value) {
                    setState(() {
                      selectedSupplier = _supplierList
                          .firstWhereOrNull((el) => '${el.supplierCode} ${el.name}' == value.value && value.uniqueId == el.id);
                    });
                  },
                  initialValue: '',
                  options: _supplierList
                      .map((e) => AutocompleteDataStruct(value: '${e.supplierCode} ${e.name}', uniqueId: e.id))
                      .toList(),
                  hintText: 'Taminotchi',
                  prefixIcon: UniconsLine.user_md),
              const SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(
                    width: 250,
                    child: AppInputUnderline(
                      hintText: 'Summa',
                      controller: _sumController,
                      keyboardType: TextInputType.number,
                      prefixIcon: UniconsLine.money_bill,
                      inputFormatters: [AppTextInputFormatter()],
                    ),
                  ),
                  Expanded(
                    child: AppDropDown(
                      selectedValue: _selectedPayType,
                      onChanged: (value) {
                        setState(() {
                          _selectedPayType = value;
                        });
                      },
                      dropDownItems: payType.keys.toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              AppInputUnderline(
                controller: _descriptionController,
                hintText: 'Izoh',
                maxLines: 3,
                textInputAction: TextInputAction.newline,
                prefixIcon: UniconsLine.comment_alt,
              ),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppButton(
              onTap: () => _clearFields(),
              height: 40,
              width: 40,
              borderRadius: BorderRadius.circular(15),
              hoverRadius: BorderRadius.circular(15),
              child: Center(
                child: Icon(Icons.cleaning_services_rounded, color: AppColors.appColorWhite),
              ),
            ),
            AppButton(
              tooltip: '',
              onTap: onIncomeCreate,
              width: 300,
              height: 40,
              color: AppColors.appColorGreen400,
              hoverColor: AppColors.appColorGreen300,
              colorOnClick: AppColors.appColorGreen700,
              splashColor: AppColors.appColorGreen700,
              borderRadius: BorderRadius.circular(12),
              hoverRadius: BorderRadius.circular(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Saqlash',
                    style: TextStyle(color: AppColors.appColorWhite, fontWeight: FontWeight.w500, fontSize: 16, letterSpacing: 1),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _clearFields() {
    _sumController.clear();
    _descriptionController.clear();
  }

  void getSupplierList() async {
    var response = await HttpServices.get("/supplier/all");
    var responseJson = jsonDecode(response.body);
    List<SupplierDto> suppliers = [];
    for (var item in responseJson['data']) {
      suppliers.add(SupplierDto.fromJson(item));
    }
    setState(() {
      _supplierList = suppliers;
    });
  }

  void onIncomeCreate() async {
    try {
      if (_formValidation.currentState!.validate()) {
        if (selectedSupplier == null) {
          throw Exception('Mijozni tanlang');
        }
        if (_sumController.text.isEmpty) {
          throw Exception('Summani kiriting');
        }
        RegExp spaceRemover = RegExp(r"\s+");
        var res = await HttpServices.post('/income/create/supplier-return-income', {
          "invoice": {
            "amount": double.tryParse(_sumController.text.replaceAll(spaceRemover, "")),
            "payType": _selectedPayType,
          },
          "description": _descriptionController.text,
          "supplierId": selectedSupplier!.id,
          "createdTime": DateTime.now().millisecondsSinceEpoch,
        });
        if (res.statusCode != 200 && res.statusCode != 201) {
          throw Exception(res.body);
        }
        showAppSnackBar(context, "Muvaffaqiyatli", "OK");
        Get.back();
      }
    } catch (e) {
      if (context.mounted) {
        showAppAlertDialog(context, title: "Xatolik", message: e.toString(), cancelLabel: "OK");
      }
    }
  }
}
