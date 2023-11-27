import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';
import '../../../../../../constants/colors.dart';
import '../../../../../../widgets/app_button.dart';
import '../../../../../../widgets/app_dialog.dart';
import '../../../../../database/model/pos_dto.dart';
import '../../../../../services/https_services.dart';
import '../../../../../utils/utils.dart';
import '../../../../../widgets/app_autocomplete.dart';
import '../../../../../widgets/app_dropdown.dart';
import '../../../../../widgets/app_input_underline.dart';

class ComeFromOtherCashDialog extends StatefulWidget {
  const ComeFromOtherCashDialog({Key? key}) : super(key: key);

  @override
  State<ComeFromOtherCashDialog> createState() => _ComeFromOtherCashDialogState();
}

class _ComeFromOtherCashDialogState extends State<ComeFromOtherCashDialog> {
  final _formValidation = GlobalKey<FormState>();
  final TextEditingController _sumController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedPayType = "CASH";
  List<PosDto> _posList = [];
  PosDto? _posTo;
  PosDto? _posFrom;

  Map<String, String> payType = {
    'CASH': 'НАЛИЧНЫЙ',
    'CARD': 'КАРТА',
    'TRANSFER': 'ПЕРЕЧИСЛЕНИЕ',
    'CASHBACK': 'КЕШБЕК',
  };

  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    getAllPos();
    getMe();
  }

  void getMe() async {
    var response = await HttpServices.get("/user/get-me");
    var responseJson = jsonDecode(response.body);
    setState(() {
      isAdmin = (responseJson['roles']).contains('ADMIN');
    });
  }

  void getAllPos() async {
    var response = await HttpServices.get("/pos/all");
    var responseJson = jsonDecode(response.body);
    List<PosDto> posList = [];
    for (var item in responseJson['data']) {
      posList.add(PosDto.fromJson(item));
    }
    setState(() {
      _posList = posList;
    });
  }

  void onIncomeCreate() async {
    try {
      if (_formValidation.currentState!.validate()) {
        if (_posFrom == null) {
          throw Exception('Chiqim kassani tanlang');
        }
        if (isAdmin) {
          if (_posTo == null) {
            throw Exception('Kirim kassani tanlang');
          }
        }
        if (_sumController.text.isEmpty) {
          throw Exception('Summani kiriting');
        }
        RegExp spaceRemover = RegExp(r"\s+");
        var res = await HttpServices.post('/income/create/pos-income', {
          "invoice": {
            "amount": double.tryParse(_sumController.text.replaceAll(spaceRemover, "")),
            "payType": _selectedPayType,
          },
          "description": _descriptionController.text,
          "createdTime": DateTime.now().millisecondsSinceEpoch,
          "posId": isAdmin ? _posTo!.id : null,
          "fromPosId": _posFrom!.id,
        });
        if (res.statusCode != 200 && res.statusCode != 201) {
          throw Exception(res.body);
        } else {
          showAppSnackBar(context, "Muvaffaqiyatli", "ok");
          Get.back();
        }
      }
    } catch (e) {
      if (context.mounted) {
        showAppAlertDialog(context, title: "Xatolik", message: e.toString(), cancelLabel: "OK");
      }
    }
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
          Text('Boshqa kassadan kirim', style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
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
                    _posFrom = _posList.firstWhereOrNull((el) => el.name == value.value && value.uniqueId == el.id);
                  });
                },
                initialValue: '',
                // _priceRoundings.firstWhereOrNull((el) => el.id == widget.setPriceDto?.roundingId)?.name,
                options: _posList.map((e) => AutocompleteDataStruct(value: e.name, uniqueId: e.id)).toList(),
                hintText: 'Kassa tanlang',
                // _priceRoundings.firstWhereOrNull((element) => element.id == widget.setPriceDto?.roundingId)?.name ??
                prefixIcon: Icons.point_of_sale_rounded,
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
              if (isAdmin)
                AppAutoComplete(
                  getValue: (AutocompleteDataStruct value) {
                    setState(() {
                      _posTo = _posList.firstWhereOrNull((el) => el.name == value.value && value.uniqueId == el.id);
                    });
                  },
                  initialValue: '',
                  // _priceRoundings.firstWhereOrNull((el) => el.id == widget.setPriceDto?.roundingId)?.name,
                  options: _posList.map((e) => AutocompleteDataStruct(value: e.name, uniqueId: e.id)).toList(),
                  hintText: 'Kirim kassa',
                  // _priceRoundings.firstWhereOrNull((element) => element.id == widget.setPriceDto?.roundingId)?.name ??
                  prefixIcon: Icons.point_of_sale_rounded,
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
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AppButton(
              tooltip: '',
              onTap: onIncomeCreate,
              width: 250,
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
}
