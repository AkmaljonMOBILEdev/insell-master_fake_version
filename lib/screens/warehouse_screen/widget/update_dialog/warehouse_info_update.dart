import 'dart:convert';
import 'package:easy_sell/database/model/product_income_document.dart';
import 'package:easy_sell/utils/utils.dart';
import 'package:easy_sell/widgets/app_input_underline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';
import '../../../../constants/colors.dart';
import '../../../../database/model/currency_dto.dart';
import '../../../../database/model/shop_dto.dart';
import '../../../../database/model/supplier_dto.dart';
import '../../../../services/https_services.dart';
import '../../../../widgets/app_autocomplete.dart';
import '../../../../widgets/app_readable_and_writeable_widget.dart';

class WarehouseInfoUpdate extends StatefulWidget {
  const WarehouseInfoUpdate({super.key, required this.productIncomeDocument, required this.setter});

  final ProductIncomeDocumentDto productIncomeDocument;
  final Function(ProductIncomeDocumentDto) setter;

  @override
  State<WarehouseInfoUpdate> createState() => _WarehouseInfoUpdateState();
}

class _WarehouseInfoUpdateState extends State<WarehouseInfoUpdate> {
  ProductIncomeDocumentDto get productIncomeDocument => widget.productIncomeDocument;

  set productIncomeDocument(ProductIncomeDocumentDto val) {
    widget.setter(val);
  }

  List<SupplierDto> suppliers = [];
  List<ShopDto> shops = [];

  @override
  void initState() {
    super.initState();
    getSuppliers();
    getShops();
    getAllCurrency();
    getPriceSettings();
  }

  void getSuppliers() async {
    var suppliersRes = await HttpServices.get("/supplier/all");
    List<SupplierDto> _suppliers = [];
    var json = jsonDecode(suppliersRes.body);
    for (var item in json['data']) {
      _suppliers.add(SupplierDto.fromJson(item));
    }
    if (mounted) {
      setState(() {
        suppliers = _suppliers;
      });
    }
  }

  void getShops() async {
    var shopsRes = await HttpServices.get("/shop/all");
    List<ShopDto> _shops = [];
    var json = jsonDecode(shopsRes.body);
    for (var item in json['data']) {
      _shops.add(ShopDto.fromJson(item));
    }
    if (mounted) {
      setState(() {
        shops = _shops;
      });
    }
  }

  List<CurrencyDataStruct> currencies = [];
  List<SuggestPriceSetting> suggestedPriceSettings = [];

  void getAllCurrency() async {
    var res = await HttpServices.get('/currency/all');
    var json = jsonDecode(res.body);
    List<CurrencyDataStruct> result = [];
    if (res.statusCode == 200) {
      for (var item in json['data']) {
        result.add(CurrencyDataStruct.fromJson(item));
      }
    }
    setState(() {
      currencies = result;
    });
  }

  void getPriceSettings() async {
    var res = await HttpServices.get('/settings/set-price/all');
    var json = jsonDecode(res.body);
    List<SuggestPriceSetting> result = [];
    if (res.statusCode == 200) {
      for (var item in json['data']) {
        result.add(SuggestPriceSetting.fromJson(item));
      }
    }
    setState(() {
      suggestedPriceSettings = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 2, child: Container()),
        Expanded(
          flex: 4,
          child: ListView(
            children: [
              ListTile(
                leading: Icon(
                  UniconsLine.user,
                  color: AppColors.appColorWhite,
                ),
                title: Text(
                  'Taminotchi',
                  style: TextStyle(color: AppColors.appColorWhite),
                ),
                subtitle: Text(
                  productIncomeDocument.supplier?.name ?? '',
                  style: TextStyle(color: AppColors.appColorWhite),
                ),
                trailing: SizedBox(
                  width: 300,
                  child: AppAutoComplete(
                    initialValue: productIncomeDocument.supplier?.name ?? '',
                    prefixIcon: UniconsLine.user,
                    hintText: 'Taminotchi *',
                    getValue: (AutocompleteDataStruct value) {
                      setState(() {
                        productIncomeDocument.supplier = suppliers.firstWhereOrNull((element) => element.id == value.uniqueId);
                      });
                    },
                    options: suppliers
                        .map((e) => AutocompleteDataStruct(
                              value: e.name,
                              uniqueId: e.id,
                            ))
                        .toList(),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  UniconsLine.shop,
                  color: AppColors.appColorWhite,
                ),
                title: Text(
                  'Qayerdan(kimdan)',
                  style: TextStyle(color: AppColors.appColorWhite),
                ),
                subtitle: Text(
                  productIncomeDocument.fromShop?.name ?? '',
                  style: TextStyle(color: AppColors.appColorWhite),
                ),
                trailing: SizedBox(
                  width: 300,
                  child: AppAutoComplete(
                    initialValue: productIncomeDocument.fromShop?.name ?? '',
                    prefixIcon: UniconsLine.shop,
                    hintText: 'Qayerdan(kimdan)',
                    getValue: (AutocompleteDataStruct value) {
                      setState(() {
                        productIncomeDocument.fromShop = shops.firstWhereOrNull((element) => element.id == value.uniqueId);
                      });
                    },
                    options: shops
                        .map((e) => AutocompleteDataStruct(
                              value: e.name,
                              uniqueId: e.id,
                            ))
                        .toList(),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  UniconsLine.shop,
                  color: AppColors.appColorWhite,
                ),
                title: Text(
                  'Qabul qiluvchi *',
                  style: TextStyle(color: AppColors.appColorWhite),
                ),
                subtitle: Text(
                  productIncomeDocument.shop?.name ?? '',
                  style: TextStyle(color: AppColors.appColorWhite),
                ),
                trailing: SizedBox(
                  width: 300,
                  child: AppAutoComplete(
                    initialValue: productIncomeDocument.shop?.name ?? '',
                    prefixIcon: UniconsLine.shop,
                    hintText: 'Qabul qiluvchi *',
                    getValue: (AutocompleteDataStruct value) {
                      setState(() {
                        productIncomeDocument.shop = shops.firstWhereOrNull((element) => element.id == value.uniqueId);
                      });
                    },
                    options: shops
                        .map((e) => AutocompleteDataStruct(
                              value: e.name,
                              uniqueId: e.id,
                            ))
                        .toList(),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.currency_exchange,
                  color: AppColors.appColorWhite,
                ),
                title: Text(
                  'Valyuta *',
                  style: TextStyle(color: AppColors.appColorWhite),
                ),
                subtitle: Text(
                  productIncomeDocument.currency?.name ?? '',
                  style: TextStyle(color: AppColors.appColorWhite),
                ),
                trailing: SizedBox(
                  width: 300,
                  child: AppAutoComplete(
                    initialValue: productIncomeDocument.currency?.name ?? '',
                    prefixIcon: UniconsLine.shop,
                    hintText: 'Valyuta *',
                    getValue: (AutocompleteDataStruct value) {
                      setState(() {
                        productIncomeDocument.currency = currencies.firstWhereOrNull((element) => element.id == value.uniqueId);
                      });
                    },
                    options: currencies
                        .map((e) => AutocompleteDataStruct(
                              value: e.name,
                              uniqueId: e.id,
                            ))
                        .toList(),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.settings_suggest_sharp,
                  color: AppColors.appColorWhite,
                ),
                title: Text(
                  'Taklif Narxi Turi *',
                  style: TextStyle(color: AppColors.appColorWhite),
                ),
                subtitle: Text(
                  productIncomeDocument.setPrice?.name ?? '',
                  style: TextStyle(color: AppColors.appColorWhite),
                ),
                trailing: SizedBox(
                  width: 300,
                  child: AppAutoComplete(
                    initialValue: productIncomeDocument.setPrice?.name ?? '',
                    prefixIcon: UniconsLine.shop,
                    hintText: 'Taklif Narxi Turi *',
                    getValue: (AutocompleteDataStruct value) {
                      setState(() {
                        productIncomeDocument.setPrice =
                            suggestedPriceSettings.firstWhereOrNull((element) => element.id == value.uniqueId);
                      });
                    },
                    options: suggestedPriceSettings
                        .map((e) => AutocompleteDataStruct(
                              value: e.name,
                              uniqueId: e.id,
                            ))
                        .toList(),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  UniconsLine.percentage,
                  color: AppColors.appColorWhite,
                ),
                title: Text(
                  'Skidka',
                  style: TextStyle(color: AppColors.appColorWhite),
                ),
                trailing: Container(
                  decoration: BoxDecoration(
                    color: AppColors.appColorGrey700.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppReadAndWriteWidget(
                        value: formatNumber(productIncomeDocument.discount),
                        setter: (String val) {
                          setState(() {
                            productIncomeDocument.discount = double.tryParse(val) ?? 0;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.edit_calendar,
                  color: AppColors.appColorWhite,
                ),
                title: Text(
                  'Yaratilgan sana',
                  style: TextStyle(color: AppColors.appColorWhite),
                ),
                subtitle: Text(
                  formatDate(productIncomeDocument.createdTime),
                  style: TextStyle(color: AppColors.appColorWhite),
                ),
                trailing: Container(
                  decoration: BoxDecoration(
                    color: AppColors.appColorGrey700.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    onPressed: () async {
                      DateTime? selectedDay = await showAppDatePicker(context);
                      if (selectedDay != null) {
                        setState(() {
                          productIncomeDocument.createdTime = selectedDay;
                        });
                      }
                    },
                    icon: Icon(Icons.calendar_today, color: AppColors.appColorWhite),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  UniconsLine.calender,
                  color: AppColors.appColorWhite,
                ),
                title: Text(
                  'Qarzdorlik muddati',
                  style: TextStyle(color: AppColors.appColorWhite),
                ),
                subtitle: Text(
                  formatDate(productIncomeDocument.expiredDebtDate),
                  style: TextStyle(color: AppColors.appColorWhite),
                ),
                trailing: Container(
                  decoration: BoxDecoration(
                    color: AppColors.appColorGrey700.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    onPressed: () async {
                      DateTime? selectedDay = await showAppDatePicker(context);
                      if (selectedDay != null) {
                        setState(() {
                          productIncomeDocument.expiredDebtDate = selectedDay;
                        });
                      }
                    },
                    icon: Icon(Icons.calendar_today, color: AppColors.appColorWhite),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.done_all_outlined,
                  color: AppColors.appColorWhite,
                ),
                title: Text(
                  'Umumiy summa',
                  style: TextStyle(color: AppColors.appColorWhite),
                ),
                subtitle: Text(
                  calculateTotalPrice(productIncomeDocument),
                  style: TextStyle(color: AppColors.appColorWhite, fontSize: 16),
                ),
              ),
              AppInputUnderline(
                hintText: 'Izoh',
                defaultValue: productIncomeDocument.description,
                prefixIcon: UniconsLine.comment,
                onChanged: (val) {
                  productIncomeDocument.description = val;
                },
              ),
            ],
          ),
        ),
        Expanded(flex: 2, child: Container()),
      ],
    );
  }

  String calculateTotalPrice(ProductIncomeDocumentDto productIncomeDocument) {
    double total = productIncomeDocument.productIncomes.fold(0.0, (previousValue, element) {
      return previousValue + element.amount * element.price;
    });
    total -= productIncomeDocument.discount;
    return "${formatNumber(total)} ${productIncomeDocument.currency?.name ?? ""}";
  }
}

class SuggestPriceSetting {
  int id;
  String name;

  SuggestPriceSetting({
    required this.id,
    required this.name,
  });

  factory SuggestPriceSetting.fromJson(Map<String, dynamic> json) {
    return SuggestPriceSetting(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
