import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';
import '../../../../../../constants/colors.dart';
import '../../../../../../widgets/app_button.dart';
import '../../../../../../widgets/app_dialog.dart';
import 'package:http/http.dart' as http;
import '../../../../../database/model/counter_party_dto.dart';
import '../../../../../database/model/pos_dto.dart';
import '../../../../../services/https_services.dart';
import '../../../../../utils/utils.dart';
import '../../../../../widgets/app_autocomplete.dart';
import '../../../../../widgets/app_dropdown.dart';
import '../../../../../widgets/app_input_underline.dart';


class PayToOtherOrgDialog extends StatefulWidget {
  const PayToOtherOrgDialog({Key? key}) : super(key: key);

  @override
  State<PayToOtherOrgDialog> createState() => _PayToOtherOrgDialogState();
}

class _PayToOtherOrgDialogState extends State<PayToOtherOrgDialog> {
  final _formValidation = GlobalKey<FormState>();
  List<CounterPartyDto> _counterPartiesList = [];
  List<PosDto> _posList = [];
  PosDto? _pos;
  CounterPartyDto? _counterparty;
  String? _selectedPayType = "CASH";
  final TextEditingController _sumController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Map<String, String> payType = {
    'CASH': 'НАЛИЧНЫЙ',
    'CARD': 'КАРТА',
    'TRANSFER': 'ПЕРЕЧИСЛЕНИЕ',
    'CASHBACK': 'КЕШБЕК',
  };

  @override
  void initState() {
    super.initState();
    getOrganizationList();
    getPosList();
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
          Text('Boshqa organizatsiyaga to\'lov', style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
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
                    _counterparty = _counterPartiesList.firstWhereOrNull((el) => ('${el.counterpartyCode} ${el.name}' == value.value) && value.uniqueId == el.id);
                  });
                },
                initialValue: '',
                // _priceRoundings.firstWhereOrNull((el) => el.id == widget.setPriceDto?.roundingId)?.name,
                options: _counterPartiesList.map((e) => AutocompleteDataStruct(value: '${e.counterpartyCode} ${e.name}', uniqueId: e.id)).toList(),
                hintText: 'Organizatsiyani tanlang',
                // _priceRoundings.firstWhereOrNull((element) => element.id == widget.setPriceDto?.roundingId)?.name ??
                prefixIcon: UniconsLine.building,
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
                          _selectedPayType = value; // setPriceRole.fromPriceType = newValue;
                        });
                      },
                      dropDownItems: payType.keys.toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              AppAutoComplete(
                getValue: (AutocompleteDataStruct value) {
                  setState(() {
                    _pos = _posList.firstWhereOrNull((el) => el.name == value.value && value.uniqueId == el.id);
                  });
                },
                initialValue: '',
                // _priceRoundings.firstWhereOrNull((el) => el.id == widget.setPriceDto?.roundingId)?.name,
                options: _posList.map((e) => AutocompleteDataStruct(value: e.name, uniqueId: e.id)).toList(),
                hintText: 'Kassani tanlang',
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
              onTap: () {
                if (_formValidation.currentState!.validate()) {
                  createPayToOrganization();
                }
              },
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

  void getOrganizationList() async {
    var response = await HttpServices.get("/counterparty/organization/all");
    var responseJson = jsonDecode(response.body);
    List<CounterPartyDto> counterPartyList = [];
    for (var item in responseJson['data']) {
      counterPartyList.add(CounterPartyDto.fromJson(item));
    }
    setState(() {
      _counterPartiesList = counterPartyList;
    });
  }

  void getPosList() async {
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

  void createPayToOrganization() async {
    try {
      var req = {
        "invoice": {
          "amount": _sumController.text.replaceAll(' ', '') ?? 0.0,
          "description": _descriptionController.text,
          "payType": _selectedPayType,
        },
        "description": _descriptionController.text,
        "counterpartyId": _counterparty?.id,
        "posId": _pos?.id,
        "createdTime": DateTime.now().millisecondsSinceEpoch
      };
      http.Response response;
      response = await HttpServices.post("/consumption/create/organization-consumption", req);
      Get.back();
      print(response.body);
      showAppSnackBar(context, "To'lov muvofaqiyatli qo'shildi", "OK");
    } catch (e) {
      if (context.mounted) {
        showAppSnackBar(context, "Xatolik yuz berdi:$e", "OK", isError: true);
        print('$e');
      }
    }
  }
}
