import 'dart:convert';
import 'package:easy_sell/services/https_services.dart';
import 'package:easy_sell/widgets/app_autocomplete.dart';
import 'package:easy_sell/widgets/app_dialog.dart';
import 'package:easy_sell/widgets/app_input_underline.dart';
import 'package:easy_sell/widgets/app_table_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';
import '../../../constants/colors.dart';
import '../../../database/model/currency_dto.dart';
import '../../../database/model/exchange_rate_dto.dart';
import '../../../utils/utils.dart';
import '../../../widgets/app_button.dart';

class ExchangeRateHistory extends StatefulWidget {
  const ExchangeRateHistory({super.key});

  @override
  State<ExchangeRateHistory> createState() => _ExchangeRateHistoryState();
}

class _ExchangeRateHistoryState extends State<ExchangeRateHistory> {
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
                    builder: (context) => AddExchangeDialog(
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
                future: HttpServices.get("/exchange-rate/all"),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var json = jsonDecode(snapshot.data?.body ?? '')['data'];
                    return ListView.separated(
                      separatorBuilder: (context, index) => const Divider(color: Colors.white, thickness: 0.3, height: 0),
                      itemCount: json.length,
                      itemBuilder: (context, index) {
                        var item = json[index];
                        ExchangeRateDataStruct exchangeRateDto = ExchangeRateDataStruct.fromJson(item);
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
                                innerWidget: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text("1 ${exchangeRateDto.fromCurrency.abbreviation}",
                                        style: TextStyle(color: AppColors.appColorWhite, fontSize: 18))),
                              ),
                              AppTableItemStruct(
                                innerWidget:
                                    Center(child: Icon(Icons.arrow_forward_rounded, color: AppColors.appColorWhite, size: 25)),
                              ),
                              AppTableItemStruct(
                                innerWidget: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("${formatNumber(exchangeRateDto.rate)} ${exchangeRateDto.currency.abbreviation}",
                                        style: TextStyle(color: AppColors.appColorWhite, fontSize: 18))),
                              ),
                              AppTableItemStruct(
                                innerWidget: Center(
                                    child: Text(formatDate(exchangeRateDto.createdAt,format: 'HH:mm dd/MM/yyyy'),
                                        style: TextStyle(color: AppColors.appColorWhite, fontSize: 18))),
                              ),
                              // AppTableItemStruct(
                              //   innerWidget: Center(
                              //     child: IconButton(
                              //       onPressed: () {
                              //         showDialog(
                              //             context: context,
                              //             builder: (context) => AddExchangeDialog(
                              //                   onAdd: () {
                              //                     setState(() {});
                              //                   },
                              //                   exchangeRate: exchangeRateDto,
                              //                 ));
                              //       },
                              //       icon: Icon(Icons.edit_rounded, color: AppColors.appColorWhite, size: 25),
                              //     ),
                              //   ),
                              // ),
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

class AddExchangeDialog extends StatefulWidget {
  const AddExchangeDialog({super.key, required this.onAdd, this.exchangeRate});

  final Function onAdd;
  final ExchangeRateDataStruct? exchangeRate;

  @override
  State<AddExchangeDialog> createState() => _AddExchangeDialogState();
}

class _AddExchangeDialogState extends State<AddExchangeDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ExchangeRateDto exchangeRateDto = ExchangeRateDto.empty();
  List<CurrencyDataStruct> currencies = [];

  @override
  void initState() {
    super.initState();
    getCurrency();
  }

  void getCurrency() async {
    var response = await HttpServices.get("/currency/all");
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body)['data'];
      currencies = json.map<CurrencyDataStruct>((e) => CurrencyDataStruct.fromJson(e)).toList();
    }
    setState(() {});
  }

  void onCreate() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState?.save();
    var response = await HttpServices.post("/exchange-rate/create", exchangeRateDto.toJson());
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
    var response = await HttpServices.put("/currency/${widget.exchangeRate?.id}", exchangeRateDto.toJson());
    if (response.statusCode == 200) {
      widget.onAdd();
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      backgroundColor: AppColors.appColorBlackBg,
      title: Text('Kurs qo\'shish', style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 300,
          height: 350,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppAutoComplete(
                getValue: (AutocompleteDataStruct value) {
                  exchangeRateDto.fromCurrencyId = currencies.firstWhere((element) => element.id == value.uniqueId).id;
                },
                options: currencies.map((e) => AutocompleteDataStruct(value: e.name, uniqueId: e.id)).toList(),
                hintText: 'Dan*',
                prefixIcon: UniconsLine.arrow_circle_up,
              ),
              const SizedBox(height: 10),
              AppAutoComplete(
                getValue: (AutocompleteDataStruct value) {
                  exchangeRateDto.currencyId = currencies.firstWhere((element) => element.id == value.uniqueId).id;
                },
                options: currencies.map((e) => AutocompleteDataStruct(value: e.name, uniqueId: e.id)).toList(),
                hintText: 'Ga*',
                prefixIcon: UniconsLine.arrow_circle_down,
              ),
              const SizedBox(height: 10),
              AppInputUnderline(
                hintText: 'Kurs*',
                prefixIcon: UniconsLine.exchange,
                onSaved: (value) {
                  exchangeRateDto.rate = double.parse(value ?? '1');
                },
              ),
              const SizedBox(height: 10),
              AppInputUnderline(
                hintText: 'Izoh',
                prefixIcon: UniconsLine.comment,
                onSaved: (value) {
                  exchangeRateDto.description = value ?? '';
                },
              ),
              const Spacer(),
              AppButton(
                onTap: onCreate,
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

class ExchangeRateDto {
  double rate;
  String description;
  int currencyId;
  int fromCurrencyId;

  ExchangeRateDto({this.rate = 1, this.description = '', required this.currencyId, required this.fromCurrencyId});

  Map<String, dynamic> toJson() {
    return {
      "rate": rate,
      "description": description,
      "currencyId": currencyId,
      "fromCurrencyId": fromCurrencyId,
    };
  }

  // empty constructor
  static ExchangeRateDto empty() {
    return ExchangeRateDto(currencyId: -1, fromCurrencyId: -1);
  }
}
