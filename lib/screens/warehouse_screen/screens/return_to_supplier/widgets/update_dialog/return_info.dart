import 'dart:convert';
import 'package:easy_sell/utils/utils.dart';
import 'package:easy_sell/widgets/app_input_underline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';

import '../../../../../../constants/colors.dart';
import '../../../../../../database/model/currency_dto.dart';
import '../../../../../../database/model/product_outcome_document.dart';
import '../../../../../../database/model/shop_dto.dart';
import '../../../../../../database/model/supplier_dto.dart';
import '../../../../../../services/https_services.dart';
import '../../../../../../widgets/app_autocomplete.dart';

class ReturnInfoUpdate extends StatefulWidget {
  const ReturnInfoUpdate({super.key, required this.productOutcomeDocument, required this.setter});

  final ProductOutcomeDocumentDto productOutcomeDocument;
  final Function(ProductOutcomeDocumentDto) setter;

  @override
  State<ReturnInfoUpdate> createState() => _ReturnInfoUpdateState();
}

class _ReturnInfoUpdateState extends State<ReturnInfoUpdate> {
  ProductOutcomeDocumentDto get productOutcomeDocument => widget.productOutcomeDocument;

  set productOutcomeDocument(ProductOutcomeDocumentDto val) {
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
                  productOutcomeDocument.supplier?.name ?? '',
                  style: TextStyle(color: AppColors.appColorWhite),
                ),
                trailing: SizedBox(
                  width: 300,
                  child: AppAutoComplete(
                    initialValue: productOutcomeDocument.supplier?.name ?? '',
                    prefixIcon: UniconsLine.user,
                    hintText: 'Taminotchi *',
                    getValue: (AutocompleteDataStruct value) {
                      setState(() {
                        productOutcomeDocument.supplier = suppliers.firstWhereOrNull((element) => element.id == value.uniqueId);
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
              // ListTile(
              //   leading: Icon(
              //     UniconsLine.shop,
              //     color: AppColors.appColorWhite,
              //   ),
              //   title: Text(
              //     'Qayerdan(kimdan)',
              //     style: TextStyle(color: AppColors.appColorWhite),
              //   ),
              //   subtitle: Text(
              //     productOutcomeDocument.fromShop?.name ?? '',
              //     style: TextStyle(color: AppColors.appColorWhite),
              //   ),
              //   trailing: SizedBox(
              //     width: 300,
              //     child: AppAutoComplete(
              //       initialValue: productOutcomeDocument.fromShop?.name ?? '',
              //       prefixIcon: UniconsLine.shop,
              //       hintText: 'Qayerdan(kimdan)',
              //       getValue: (AutocompleteDataStruct value) {
              //         setState(() {
              //           productOutcomeDocument.fromShop = shops.firstWhereOrNull((element) => element.id == value.uniqueId);
              //         });
              //       },
              //       options: shops
              //           .map((e) => AutocompleteDataStruct(
              //                 value: e.name,
              //                 uniqueId: e.id,
              //               ))
              //           .toList(),
              //     ),
              //   ),
              // ),
              ListTile(
                leading: Icon(
                  UniconsLine.shop,
                  color: AppColors.appColorWhite,
                ),
                title: Text(
                  'Sklad *',
                  style: TextStyle(color: AppColors.appColorWhite),
                ),
                subtitle: Text(
                  productOutcomeDocument.shop?.name ?? '',
                  style: TextStyle(color: AppColors.appColorWhite),
                ),
                trailing: SizedBox(
                  width: 300,
                  child: AppAutoComplete(
                    initialValue: productOutcomeDocument.shop?.name ?? '',
                    prefixIcon: UniconsLine.shop,
                    hintText: 'Sklad *',
                    getValue: (AutocompleteDataStruct value) {
                      setState(() {
                        productOutcomeDocument.shop = shops.firstWhereOrNull((element) => element.id == value.uniqueId);
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
                  productOutcomeDocument.currency?.name ?? '',
                  style: TextStyle(color: AppColors.appColorWhite),
                ),
                trailing: SizedBox(
                  width: 300,
                  child: AppAutoComplete(
                    initialValue: productOutcomeDocument.currency?.name ?? '',
                    prefixIcon: UniconsLine.shop,
                    hintText: 'Valyuta *',
                    getValue: (AutocompleteDataStruct value) {
                      setState(() {
                        productOutcomeDocument.currency = currencies.firstWhereOrNull((element) => element.id == value.uniqueId);
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
                  Icons.edit_calendar,
                  color: AppColors.appColorWhite,
                ),
                title: Text(
                  'Yaratilgan sana',
                  style: TextStyle(color: AppColors.appColorWhite),
                ),
                subtitle: Text(
                  formatDate(productOutcomeDocument.createdTime),
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
                          productOutcomeDocument.createdTime = selectedDay;
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
                  calculateTotalPrice(productOutcomeDocument),
                  style: TextStyle(color: AppColors.appColorWhite, fontSize: 16),
                ),
              ),
              AppInputUnderline(
                hintText: 'Izoh',
                defaultValue: productOutcomeDocument.description,
                prefixIcon: UniconsLine.comment,
                onChanged: (val) {
                  productOutcomeDocument.description = val;
                },
              ),
            ],
          ),
        ),
        Expanded(flex: 2, child: Container()),
      ],
    );
  }

  String calculateTotalPrice(ProductOutcomeDocumentDto productOutcomeDocument) {
    double total = productOutcomeDocument.productExpenses.fold(0.0, (previousValue, element) {
      return previousValue + element.amount * element.price;
    });
    return "${formatNumber(total)} ${productOutcomeDocument.currency?.name ?? ""}";
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
