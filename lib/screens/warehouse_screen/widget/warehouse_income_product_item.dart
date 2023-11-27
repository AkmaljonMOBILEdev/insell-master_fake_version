import 'dart:convert';
import 'package:easy_sell/database/model/currency_dto.dart';
import 'package:easy_sell/database/model/exchange_rate_dto.dart';
import 'package:easy_sell/database/table/product_income_table.dart';
import 'package:easy_sell/screens/warehouse_screen/widget/crud/warehouse_create_dialog.dart';
import 'package:easy_sell/services/https_services.dart';
import 'package:easy_sell/widgets/app_dialog.dart';
import 'package:easy_sell/widgets/app_table_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../../constants/colors.dart';
import '../../../database/my_database.dart';
import '../../../utils/utils.dart';
import '../../../widgets/app_autocomplete.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_input_underline.dart';

class WareHouseIncomeProductItem extends StatefulWidget {
  const WareHouseIncomeProductItem({
    super.key,
    required this.index,
    required this.currentProduct,
    required this.onRemove,
    required this.setAmount,
    required this.setExpireDate,
    this.readOnly = false,
    this.focusToSearch,
    required this.setPrice,
    required this.productData,
    required this.setCurrency,
    this.layouts,
    required this.setAutomaticPrice,
    required this.priceSettingId,
    required this.currencies,
  });

  final int index;
  final int priceSettingId;
  final ProductData currentProduct;
  final Future Function() onRemove;
  final Future Function(int amount) setAmount;
  final Future Function(double price) setPrice;
  final bool? readOnly;
  final Null Function()? focusToSearch;
  final ProductIncomeDataStruct productData;
  final Function(DateTime? expireDate) setExpireDate;
  final Function(CurrencyDataStruct? currency) setCurrency;
  final List<int>? layouts;
  final Function(double price) setAutomaticPrice;
  final List<CurrencyDataStruct> currencies;

  @override
  State<WareHouseIncomeProductItem> createState() => _WareHouseIncomeProductItemState();
}

class _WareHouseIncomeProductItemState extends State<WareHouseIncomeProductItem> {
  MyDatabase database = Get.find<MyDatabase>();
  bool readOnly = false;
  FocusNode focusNode = FocusNode();
  bool readOnlyForPrice = false;
  FocusNode focusNodeForPrice = FocusNode();
  FocusNode focusNodeForAutomaticPrice = FocusNode();
  bool readOnlyForAutomaticPrice = false;
  bool currency = false;
  bool isNumber = false;
  final TextEditingController _automaticPriceController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  ExchangeRateDataStruct? exchangeRate;
  String rentableInPercent = '';

  @override
  void initState() {
    super.initState();
    _amountController.text = formatNumber(widget.productData.amount);
    _priceController.text = formatNumber(widget.productData.price);
    setState(() {
      currency = widget.productData.currency == ProductIncomeCurrency.USD;
    });
    getExchangeRate();
    setAutomaticPrice(
      serverId: widget.productData.product.serverId ?? 0,
      price: widget.productData.price,
      currency: widget.productData.currency,
      priceSettingId: widget.priceSettingId,
    );
  }

  void getExchangeRate() async {
    try {
      var res = await HttpServices.get("/exchange-rate/latest");
      if (res.statusCode == 200) {
        var json = jsonDecode(res.body);
        if (mounted) {
          setState(() {
            exchangeRate = ExchangeRateDataStruct.fromJson(json);
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void setAutomaticPrice({
    required int serverId,
    required double price,
    required CurrencyDataStruct? currency,
    required int priceSettingId,
  }) async {
    var res = await HttpServices.get(
        "/price/product/$serverId/calculate?price=$price&currency=${currency?.name}&priceSettingId=$priceSettingId");
    var resJson = jsonDecode(res.body);
    if (res.statusCode == 200) {
      if (resJson.length > 0) {
        double price = resJson[0]['recommendPrice'];
        if (mounted) {
          setState(() {
            widget.setAutomaticPrice(price);
          });
        }
      }
    }
  }

  @override
  void didUpdateWidget(covariant WareHouseIncomeProductItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    setAutomaticPrice(
      serverId: widget.productData.product.serverId ?? 0,
      price: widget.productData.price,
      currency: widget.productData.currency,
      priceSettingId: widget.priceSettingId,
    );
    setState(() {
      rentableInPercent = rentableInPercentFunc();
    });
  }

  @override
  Widget build(BuildContext context) {
    ProductData currentProduct = widget.currentProduct;
    return AppTableItems(
      height: 50,
      hideBorder: true,
      layouts: widget.layouts,
      items: [
        AppTableItemStruct(
          innerWidget: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(5)),
                child: Text('${widget.index + 1}', style: TextStyle(color: AppColors.appColorWhite)),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  currentProduct.name,
                  style: TextStyle(color: AppColors.appColorWhite, fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
        AppTableItemStruct(
          innerWidget: Center(
            child: Text(
              currentProduct.vendorCode ?? '',
              style: TextStyle(color: AppColors.appColorWhite, fontSize: 14),
            ),
          ),
        ),
        AppTableItemStruct(
          innerWidget: Center(
            child: Text(
              currentProduct.code ?? '',
              style: TextStyle(color: AppColors.appColorWhite, fontSize: 14),
            ),
          ),
        ),
        AppTableItemStruct(
          flex: 5,
          innerWidget: Center(
            child: GestureDetector(
                onTap: toggle,
                child: (readOnly && widget.readOnly == false)
                    ? SizedBox(
                        width: 100,
                        child: AppInputUnderline(
                          controller: _amountController,
                          focusNode: focusNode,
                          onTapOutside: (event) {
                            focusNode.unfocus();
                            widget.focusToSearch != null ? widget.focusToSearch!() : null;
                            setState(() {
                              readOnly = false;
                            });
                          },
                          hintText: 'Miqdor',
                          inputFormatters: [AppTextInputFormatter()],
                          hideIcon: true,
                          enableBorderColor: Colors.green,
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            if (value.isEmpty) return;
                            widget.setAmount(int.parse(value.replaceAll(' ', '')));
                          },
                        ),
                      )
                    : Container(
                        constraints: const BoxConstraints(minWidth: 50),
                        child: Text(formatNumber(widget.productData.amount),
                            style: TextStyle(color: AppColors.appColorWhite), textAlign: TextAlign.center),
                      )),
          ),
        ),
        AppTableItemStruct(
          flex: 4,
          innerWidget: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            // decoration: BoxDecoration(
            //   border: Border.all(color: AppColors.appColorGrey700),
            //   color: Colors.grey.withOpacity(0.1),
            // ),
            child: AppInputUnderline(
              controller: _priceController,
              hintText: formatNumber(widget.productData.price),
              focusNode: focusNodeForPrice,
              onTapOutside: (event) {
                focusNodeForPrice.unfocus();
                widget.focusToSearch != null ? widget.focusToSearch!() : null;
                setState(() {
                  readOnlyForPrice = false;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) return 'Narx kiritilmagan';
                return null;
              },
              inputFormatters: [AppTextInputFormatter()],
              hideIcon: true,
              enableBorderColor: Colors.transparent,
              focusedBorderColor: Colors.transparent,
              textAlign: TextAlign.center,
              onChanged: (value) async {
                widget.setPrice(double.tryParse(value.replaceAll(' ', '')) ?? 0);
              },
            ),
          ),
        ),
        AppTableItemStruct(
          innerWidget: Center(
            child: AppAutoComplete(
              hintText: 'Valyuta',
              options: widget.currencies
                  .map((e) => AutocompleteDataStruct(
                        value: e.name,
                        uniqueId: e.id,
                      ))
                  .toList(),
              getValue: (AutocompleteDataStruct value) {
                CurrencyDataStruct? currency = widget.currencies.firstWhereOrNull((element) => element.id == value.uniqueId);
                widget.setCurrency(currency);
              },
            ),
          ),
        ),
        AppTableItemStruct(
          innerWidget: Center(
            child: GestureDetector(
                onTap: toggleForAutomaticPrice,
                child: (isNumber && widget.readOnly == false)
                    ? SizedBox(
                        width: 100,
                        child: AppInputUnderline(
                          focusNode: focusNodeForAutomaticPrice,
                          controller: _automaticPriceController,
                          onTapOutside: (event) {
                            focusNodeForAutomaticPrice.unfocus();
                            widget.focusToSearch != null ? widget.focusToSearch!() : null;
                            setState(() {
                              isNumber = false;
                            });
                          },
                          hintText: 'Tavsiya Narx',
                          inputFormatters: [AppTextInputFormatter()],
                          hideIcon: true,
                          enableBorderColor: Colors.green,
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            if (value.isEmpty) return;
                            widget.setAutomaticPrice(double.tryParse(value.replaceAll(' ', '')) ?? 0);
                          },
                        ),
                      )
                    : Container(
                        constraints: const BoxConstraints(minWidth: 50),
                        child: Text(formatNumber(widget.productData.automaticPrice),
                            style: TextStyle(color: AppColors.appColorWhite), textAlign: TextAlign.center),
                      )),
          ),
        ),
        AppTableItemStruct(
          flex: 3,
          innerWidget: Center(
            child: Text(
              rentableInPercent,
              style: TextStyle(color: AppColors.appColorGreen300, fontSize: 12),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ),
        AppTableItemStruct(
          innerWidget: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: Center(
              child: TextFormField(
                initialValue: widget.productData.expireDate != null
                    ? DateFormat('dd/MM/yyyy').format(widget.productData.expireDate!)
                    : null,
                style: TextStyle(color: AppColors.appColorWhite),
                inputFormatters: [
                  MaskTextInputFormatter(
                    mask: '##/##/####',
                    filter: {"#": RegExp(r'[0-9]')},
                  )
                ],
                // none
                decoration: InputDecoration(
                  hintText: "DD/MM/YYYY",
                  hintStyle: TextStyle(color: AppColors.appColorGrey300),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                ),
                onChanged: (value) {
                  int length = value.length;
                  if (value.isEmpty || length < 10) {
                    return;
                  }
                  DateTime? expireDate = DateFormat('dd/MM/yyyy').parse(value);
                  widget.setExpireDate(expireDate);
                },
              ),
            ),
          ),
        ),
        AppTableItemStruct(
          flex: 3,
          innerWidget: Center(
            child: Text(
              widget.productData.price == 0 ? '-' : formatNumber(widget.productData.amount * widget.productData.price),
              style: TextStyle(color: AppColors.appColorWhite, fontSize: 14),
              textAlign: TextAlign.end,
            ),
          ),
        ),
        AppTableItemStruct(
          innerWidget: (widget.readOnly == true)
              ? const SizedBox()
              : Row(
                  children: [
                    Center(
                      child: AppButton(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) => AppDialog(
                                    title: Text('Narxlar tarixi', style: TextStyle(color: AppColors.appColorRed400)),
                                    content: IntrinsicHeight(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text('Oxirgi kirim narxi: ',
                                                  style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
                                              FutureBuilder(
                                                future: HttpServices.get(
                                                    "/price/product/last-income-price/${currentProduct.serverId}"),
                                                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                                  if (snapshot.hasData) {
                                                    double price = 0;
                                                    ProductIncomeCurrency currency = ProductIncomeCurrency.UZS;
                                                    var json = jsonDecode(snapshot.data.body != '' ? snapshot.data.body : '{}');
                                                    if (json['price'] != null) {
                                                      price = json['price'];
                                                    }
                                                    if (json['currency'] != null) {
                                                      currency = json['currency'] == 'UZS'
                                                          ? ProductIncomeCurrency.UZS
                                                          : ProductIncomeCurrency.USD;
                                                    }
                                                    return Text(
                                                      formatNumber(price) +
                                                          (currency == ProductIncomeCurrency.UZS ? ' SUM' : ' \$'),
                                                      style: TextStyle(color: AppColors.appColorWhite, fontSize: 20),
                                                      textAlign: TextAlign.end,
                                                    );
                                                  }
                                                  return Text(
                                                    '',
                                                    style: TextStyle(color: AppColors.appColorWhite, fontSize: 14),
                                                    textAlign: TextAlign.end,
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text('Oxirgi sotuv narxi: ',
                                                  style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
                                              FutureBuilder(
                                                future: HttpServices.get(
                                                    "/price/product/last-by-type/${currentProduct.serverId}?priceType=RETAIL"),
                                                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                                  if (snapshot.hasData) {
                                                    double price = 0;
                                                    ProductIncomeCurrency currency = ProductIncomeCurrency.UZS;
                                                    var json = jsonDecode(snapshot.data.body != '' ? snapshot.data.body : '{}');
                                                    if (json['price'] != null) {
                                                      price = json['price'];
                                                    }
                                                    if (json['currency'] != null) {
                                                      currency = json['currency'] == 'UZS'
                                                          ? ProductIncomeCurrency.UZS
                                                          : ProductIncomeCurrency.USD;
                                                    }
                                                    return Text(
                                                      formatNumber(price) +
                                                          (currency == ProductIncomeCurrency.UZS ? ' SUM' : ' \$'),
                                                      style: TextStyle(color: AppColors.appColorWhite, fontSize: 20),
                                                      textAlign: TextAlign.end,
                                                    );
                                                  }
                                                  return Text(
                                                    '',
                                                    style: TextStyle(color: AppColors.appColorWhite, fontSize: 12),
                                                    textAlign: TextAlign.end,
                                                  );
                                                },
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ));
                        },
                        width: 24,
                        height: 24,
                        color: Colors.deepOrangeAccent,
                        borderRadius: BorderRadius.circular(8),
                        hoverRadius: BorderRadius.circular(8),
                        child: const Icon(Icons.history_toggle_off, color: Colors.white, size: 20),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Center(
                      child: AppButton(
                        onTap: widget.onRemove,
                        width: 24,
                        height: 24,
                        color: AppColors.appColorRed300,
                        borderRadius: BorderRadius.circular(8),
                        hoverRadius: BorderRadius.circular(8),
                        child: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  void toggle() {
    setState(() {
      readOnly = !readOnly;
    });
    if (readOnly) {
      focusNode.requestFocus();
    }
  }

  void toggleForPrice() {
    setState(() {
      readOnlyForPrice = !readOnlyForPrice;
    });
    if (readOnlyForPrice) {
      focusNodeForPrice.requestFocus();
      _amountController.text = formatNumber(widget.productData.amount);
      _amountController.selection = TextSelection.fromPosition(TextPosition(offset: _amountController.text.length));
    }
  }

  void toggleForAutomaticPrice() {
    setState(() {
      isNumber = !isNumber;
    });
    if (isNumber) {
      focusNodeForAutomaticPrice.requestFocus();
      _automaticPriceController.text = formatNumber(widget.productData.automaticPrice);
      _automaticPriceController.selection =
          TextSelection.fromPosition(TextPosition(offset: _automaticPriceController.text.length));
    }
  }

  String rentableInPercentFunc() {
    if (widget.productData.automaticPrice == 0 || widget.productData.price == 0) {
      return '';
    }
    double automaticPrice = widget.productData.automaticPrice ?? 0;
    double price = (currency ? (widget.productData.price * (exchangeRate?.rate ?? 0)) : widget.productData.price);
    double rentable = automaticPrice - price;
    double rentableInPercent = rentable / price * 100;
    return ' (${rentableInPercent.toStringAsFixed(0)} %)';
  }

  @override
  void dispose() {
    focusNodeForPrice.dispose();
    focusNode.dispose();
    focusNodeForAutomaticPrice.dispose();
    super.dispose();
  }
}
