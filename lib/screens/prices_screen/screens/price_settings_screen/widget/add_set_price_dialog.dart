import 'dart:convert';
import 'package:easy_sell/database/model/price_rounded_dto.dart';
import 'package:easy_sell/widgets/app_input_underline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';
import '../../../../../constants/colors.dart';
import '../../../../../database/model/currency_dto.dart';
import '../../../../../database/model/price_set_dto.dart';
import '../../../../../services/https_services.dart';
import '../../../../../utils/utils.dart';
import '../../../../../utils/validator.dart';
import '../../../../../widgets/app_autocomplete.dart';
import '../../../../../widgets/app_button.dart';
import '../../../../../widgets/app_dialog.dart';
import 'package:http/http.dart' as http;

import '../../../../settings_screen/widget/price_type.dart';

class SetPriceRole {
  int? fromPriceTypeId;
  int? priceTypeId;
  TextEditingController fromPriceController = TextEditingController();
  TextEditingController toPriceController = TextEditingController();
  TextEditingController percentController = TextEditingController();
  bool decrease = false;
  bool fromIncomePrice = false;

  SetPriceRole();

  SetPriceRole.fromMap(Map<String, dynamic> map) {
    fromPriceTypeId = map['fromPriceTypeId'];
    priceTypeId = map['priceTypeId'];
    fromPriceController.text = map['fromPrice'].toString();
    toPriceController.text = map['toPrice'].toString();
    percentController.text = map['percent'].toString();
    decrease = map['decrease'];
    fromIncomePrice = map['fromIncomePrice'];
  }

  Map<String, dynamic> toJson() {
    return {
      'fromPriceTypeId': fromPriceTypeId,
      'priceTypeId': priceTypeId,
      'fromPrice': fromPriceController.text,
      'toPrice': toPriceController.text,
      'percent': percentController.text,
      'decrease': decrease,
      'fromIncomePrice': fromIncomePrice,
    };
  }
}

Map<String, String> priceType = {
  'COST': 'СТОИМОСТЬ',
  'RETAIL': 'РОЗНИЦА',
  'SALE': 'РАСПРОДАЖА',
  'MINIMUM': 'МИНИМУМ',
};

class AddSetPriceRoundingDialog extends StatefulWidget {
  const AddSetPriceRoundingDialog({Key? key, this.setPriceDto, required this.callback}) : super(key: key);
  final PriceSetDto? setPriceDto;
  final VoidCallback callback;

  @override
  State<AddSetPriceRoundingDialog> createState() => _AddSetPriceRoundingDialogState();
}

class _AddSetPriceRoundingDialogState extends State<AddSetPriceRoundingDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _additionalExchangeRateController = TextEditingController();
  final _formValidation = GlobalKey<FormState>();
  List<PriceRoundedDto> _priceRoundings = [];
  PriceRoundedDto? _priceRoundingData;
  CurrencyDataStruct? _currencyData;

  List<SetPriceRole> _setPriceRoles = [
    SetPriceRole(),
  ];

  @override
  void initState() {
    super.initState();
    getPriceRoundings();
    getPriceTypes();
    getCurrencies();
    if (widget.setPriceDto != null) {
      _nameController.text = widget.setPriceDto?.name ?? '';
      _descriptionController.text = widget.setPriceDto?.description ?? '';
      _additionalExchangeRateController.text = widget.setPriceDto?.exchangeRateAddition.toString() ?? '';
      addPriceRoles(widget.setPriceDto?.setPriceRoles ?? []);
    }
  }

  List<PriceTypeDto> _priceTypes = [];

  void getPriceTypes() async {
    var response = await HttpServices.get("/settings/price-type/all");
    var responseJson = jsonDecode(response.body);
    List<PriceTypeDto> priceTypeList = [];
    for (var item in responseJson['data']) {
      priceTypeList.add(PriceTypeDto.fromJson(item));
    }
    setState(() {
      _priceTypes = priceTypeList;
    });
  }

  List<CurrencyDataStruct> _currencies = [];

  void getCurrencies() async {
    var response = await HttpServices.get("/currency/all");
    var responseJson = jsonDecode(response.body);
    List<CurrencyDataStruct> currencyList = [];
    for (var item in responseJson['data']) {
      currencyList.add(CurrencyDataStruct.fromJson(item));
    }
    setState(() {
      _currencies = currencyList;
    });
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
          Text('Narx o\'rnatish', style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
        ],
      ),
      content: SizedBox(
        height: 500,
        width: 900,
        child: Form(
          key: _formValidation,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 500,
                  width: 350,
                  child: Card(
                    color: Colors.grey.shade800,
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      child: Column(
                        children: [
                          AppInputUnderline(
                            controller: _nameController,
                            hintText: 'Nomi',
                            validator: AppValidator().namedValidate,
                            prefixIcon: Icons.view_headline,
                            numberFormat: false,
                          ),
                          AppInputUnderline(
                            controller: _descriptionController,
                            hintText: 'Izoh',
                            maxLines: 2,
                            textInputAction: TextInputAction.newline,
                            prefixIcon: UniconsLine.comment_alt,
                          ),
                          AppInputUnderline(
                            controller: _additionalExchangeRateController,
                            hintText: 'Kursoviy raznitsa',
                            prefixIcon: UniconsLine.focus_add,
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Expanded(
                                child: AppAutoComplete(
                                  getValue: (AutocompleteDataStruct value) {
                                    setState(() {
                                      _priceRoundingData = _priceRoundings
                                          .firstWhereOrNull((el) => el.name == value.value && value.uniqueId == el.id);
                                    });
                                  },
                                  initialValue:
                                      _priceRoundings.firstWhereOrNull((el) => el.id == widget.setPriceDto?.roundingId)?.name,
                                  options:
                                      _priceRoundings.map((e) => AutocompleteDataStruct(value: e.name, uniqueId: e.id)).toList(),
                                  hintText: _priceRoundings
                                          .firstWhereOrNull((element) => element.id == widget.setPriceDto?.roundingId)
                                          ?.name ??
                                      'Yaxlitlash formulasini tanlang',
                                  // 'Yaxlitlash formulasini tanlang',
                                  prefixIcon: UniconsLine.map,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Expanded(
                                child: AppAutoComplete(
                                  getValue: (AutocompleteDataStruct value) {
                                    setState(() {
                                      _currencyData =
                                          _currencies.firstWhereOrNull((el) => el.name == value.value && value.uniqueId == el.id);
                                    });
                                  },
                                  options: _currencies.map((e) => AutocompleteDataStruct(value: e.name, uniqueId: e.id)).toList(),
                                  hintText: 'Valyuta *',
                                  prefixIcon: UniconsLine.exchange,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: ListView.builder(
                  itemCount: _setPriceRoles.length,
                  itemBuilder: (BuildContext context, index) {
                    SetPriceRole setPriceRole = _setPriceRoles[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                      child: Card(
                        color: Colors.grey.shade800,
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 25,
                                        height: 25,
                                        decoration: BoxDecoration(
                                            color: randomColors[index % randomColors.length],
                                            borderRadius: BorderRadius.circular(10)),
                                        child: Center(
                                          child: Text(
                                            '${index + 1}',
                                            style: TextStyle(
                                                color: AppColors.appColorWhite, fontSize: 16, fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        'chi',
                                        style:
                                            TextStyle(color: AppColors.appColorWhite, fontSize: 16, fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      AppButton(
                                        onTap: () {
                                          setState(() {
                                            _setPriceRoles.removeAt(index);
                                          });
                                        },
                                        width: 30,
                                        height: 30,
                                        hoverRadius: BorderRadius.circular(10),
                                        child: Icon(Icons.close_rounded, color: AppColors.appColorWhite, size: 25),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 275,
                                    child: AppInputUnderline(
                                      hintText: 'Dan',
                                      onChanged: (value) {},
                                      controller: setPriceRole.fromPriceController,
                                      keyboardType: TextInputType.number,
                                      prefixIcon: UniconsLine.arrow_from_right,
                                      validator: AppValidator().sumValidate,
                                      inputFormatters: [AppTextInputFormatter()],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    width: 275,
                                    child: AppInputUnderline(
                                      hintText: 'Gacha',
                                      controller: setPriceRole.toPriceController,
                                      keyboardType: TextInputType.number,
                                      prefixIcon: UniconsLine.arrow_to_right,
                                      inputFormatters: [AppTextInputFormatter()],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: AppAutoComplete(
                                      hintText: 'Narx turi',
                                      getValue: (AutocompleteDataStruct newValue) {
                                        setState(() {
                                          setPriceRole.fromPriceTypeId = newValue.uniqueId;
                                        });
                                      },
                                      options: _priceTypes
                                          .map((e) => AutocompleteDataStruct(
                                                uniqueId: e.id,
                                                value: e.name,
                                              ))
                                          .toList(),
                                      initialValue: _priceTypes
                                          .firstWhereOrNull((element) => element.id == setPriceRole.fromPriceTypeId)
                                          ?.name,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: AppAutoComplete(
                                      hintText: 'Narx turi',
                                      initialValue:
                                          _priceTypes.firstWhereOrNull((element) => element.id == setPriceRole.priceTypeId)?.name,
                                      getValue: (AutocompleteDataStruct newValue) {
                                        setState(() {
                                          setPriceRole.priceTypeId = newValue.uniqueId;
                                        });
                                      },
                                      options: _priceTypes
                                          .map((e) => AutocompleteDataStruct(
                                                uniqueId: e.id,
                                                value: e.name,
                                              ))
                                          .toList(),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 275,
                                    child: AppInputUnderline(
                                      controller: setPriceRole.percentController,
                                      hintText: 'Foiz',
                                      validator: AppValidator().validate,
                                      prefixIcon: Icons.percent_rounded,
                                      numberFormat: false,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Center(
                                        child: Text(
                                          'Chegirma:',
                                          style: TextStyle(
                                              color: AppColors.appColorWhite, fontSize: 16, fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      const SizedBox(width: 140),
                                      Transform.scale(
                                        scale: 0.8,
                                        child: Switch(
                                          value: setPriceRole.decrease,
                                          activeColor: AppColors.appColorGreen400,
                                          onChanged: (bool value) {
                                            setState(() {
                                              setPriceRole.decrease = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Center(
                                    child: Text(
                                      'Oprexoddanmi ?',
                                      style: TextStyle(color: AppColors.appColorWhite, fontSize: 16, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Transform.scale(
                                    scale: 0.8,
                                    child: Switch(
                                      value: setPriceRole.fromIncomePrice,
                                      activeColor: AppColors.appColorGreen400,
                                      onChanged: (bool value) {
                                        setState(() {
                                          setPriceRole.fromIncomePrice = value;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AppButton(
              onTap: () {
                setState(() {
                  _setPriceRoles.add(SetPriceRole());
                });
              },
              height: 40,
              width: 40,
              color: Colors.blue.shade800,
              borderRadius: BorderRadius.circular(12),
              hoverRadius: BorderRadius.circular(12),
              child: Center(
                child: Icon(Icons.add, color: AppColors.appColorWhite),
              ),
            ),
            const SizedBox(width: 10),
            AppButton(
              tooltip: '',
              onTap: () {
                if (_formValidation.currentState!.validate()) {
                  createOrUpdateSetPrice();
                  widget.callback();
                }
              },
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
                    widget.setPriceDto != null ? 'Yangilash' : 'Saqlash',
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

  void getPriceRoundings() async {
    var response = await HttpServices.get("/settings/rounding/all");
    var responseJson = jsonDecode(response.body);
    List<PriceRoundedDto> roundedList = [];
    for (var item in responseJson['data']) {
      roundedList.add(PriceRoundedDto.fromJson(item));
    }
    setState(() {
      _priceRoundings = roundedList;
    });
  }

  void addPriceRoles(List<SetPriceRoleDto> roles) {
    _setPriceRoles.clear();
    for (var role in roles) {
      SetPriceRole setPriceRole = SetPriceRole();
      setPriceRole.fromPriceTypeId = role.fromPriceTypeId;
      setPriceRole.priceTypeId = role.priceTypeId;
      setPriceRole.fromPriceController.text = role.fromPrice.toString();
      if (role.toPrice != double.maxFinite) {
        setPriceRole.toPriceController.text = role.toPrice.toString();
      }
      setPriceRole.percentController.text = role.percent.toString();
      setPriceRole.decrease = role.decrease;
      setPriceRole.fromIncomePrice = role.fromIncomePrice;
      _setPriceRoles.add(setPriceRole);
    }
  }

  void createOrUpdateSetPrice() async {
    RegExp spaceRemover = RegExp(r'\s+');
    try {
      var req = {
        "name": _nameController.text,
        "description": _descriptionController.text,
        'exchangeRateAddition': double.tryParse(_additionalExchangeRateController.text.replaceAll(spaceRemover, '')) ?? 0.0,
        "roundingId": widget.setPriceDto?.roundingId ?? _priceRoundingData?.id,
        "currencyId": _currencyData?.id,
        'setPriceRoles': _setPriceRoles.map((e) {
          double fromPrice = double.tryParse(e.fromPriceController.text.replaceAll(' ', '')) ?? 0.0;
          double toPrice = double.tryParse(e.toPriceController.text.replaceAll(' ', '')) ?? 0.0;
          double? percent = double.tryParse(e.percentController.text.replaceAll(' ', '')) ?? 0.0;
          SetPriceRole newRole = SetPriceRole()
            ..fromPriceTypeId = e.fromPriceTypeId
            ..priceTypeId = e.priceTypeId
            ..fromPriceController.text = fromPrice.toString()
            ..toPriceController.text = toPrice.toString()
            ..percentController.text = percent.toString();
          return newRole.toJson();
        }).toList(),
      };
      http.Response response;
      if (widget.setPriceDto != null) {
        response = await HttpServices.put("/settings/set-price/${widget.setPriceDto?.id}", req);
      } else {
        response = await HttpServices.post("/settings/set-price/create", req);
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
      } else {
        throw Exception('Xatolik yuz berdi: ${response.body}');
      }
    } catch (e) {
      if (context.mounted) {
        showAppSnackBar(context, "Xatolik yuz berdi:$e", "OK", isError: true);
        print('$e');
      }
    }
  }
}
