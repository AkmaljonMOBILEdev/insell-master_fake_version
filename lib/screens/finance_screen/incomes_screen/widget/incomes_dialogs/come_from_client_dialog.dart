import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';
import '../../../../../../constants/colors.dart';
import '../../../../../../widgets/app_button.dart';
import '../../../../../../widgets/app_dialog.dart';
import '../../../../../database/model/client_dto.dart';
import '../../../../../services/https_services.dart';
import '../../../../../utils/utils.dart';
import '../../../../../widgets/app_autocomplete.dart';
import '../../../../../widgets/app_dropdown.dart';
import '../../../../../widgets/app_input_underline.dart';

class ComeFromClientDialog extends StatefulWidget {
  const ComeFromClientDialog({Key? key}) : super(key: key);

  @override
  State<ComeFromClientDialog> createState() => _ComeFromClientDialogState();
}

class _ComeFromClientDialogState extends State<ComeFromClientDialog> {
  final _formValidation = GlobalKey<FormState>();
  List<ClientDto> _clientsList = [];
  ClientDto? _client;
  String? _selectedPayType = "CASH";
  final TextEditingController _sumController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Map<String, String> payType = {
    'CASH': 'НАЛИЧНЫЙ',
    'CARD': 'КАРТА',
    'TRANSFER': 'ПЕРЕЧИСЛЕНИЕ',
    'CASHBACK': 'КЕШБЕК',
  };

  void onIncomeCreate() async {
    try {
      if (_formValidation.currentState!.validate()) {
        if (_client == null) {
          throw Exception('Mijozni tanlang');
        }
        if (_sumController.text.isEmpty) {
          throw Exception('Summani kiriting');
        }
        RegExp spaceRemover = RegExp(r"\s+");
        await HttpServices.post('/income/create/client-income', {
          "invoice": {
            "amount": double.tryParse(_sumController.text.replaceAll(spaceRemover, "")),
            "payType": _selectedPayType,
          },
          "description": _descriptionController.text,
          "clientId": _client!.id,
          "createdTime": DateTime.now().millisecondsSinceEpoch,
        });
        Get.back();
      }
    } catch (e) {
      if (context.mounted) {
        showAppAlertDialog(context, title: "Xatolik", message: e.toString(), cancelLabel: "OK");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getClientsList();
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
          Text('Mijozdan kirim', style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
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
                    _client = _clientsList
                        .firstWhereOrNull((el) => ('${el.clientCode} ${el.name}' == value.value) && value.uniqueId == el.id);
                  });
                },
                initialValue: '',
                options:
                    _clientsList.map((e) => AutocompleteDataStruct(value: '${e.clientCode} ${e.name}', uniqueId: e.id)).toList(),
                hintText: 'Mijozni tanlang',
                prefixIcon: UniconsLine.user,
              ),
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
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Summani kiriting';
                        }
                        return null;
                      },
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

  void getClientsList() async {
    var response = await HttpServices.get("/client/all");
    var responseJson = jsonDecode(response.body);
    List<ClientDto> clientsList = [];
    for (var item in responseJson['data']) {
      clientsList.add(ClientDto.fromJson(item));
    }
    setState(() {
      _clientsList = clientsList;
    });
  }
}
