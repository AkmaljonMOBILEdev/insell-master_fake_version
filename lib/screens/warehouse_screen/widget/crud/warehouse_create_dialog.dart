import 'dart:convert';

import 'package:easy_sell/database/model/currency_dto.dart';
import 'package:easy_sell/database/model/exchange_rate_dto.dart';
import 'package:easy_sell/database/model/product_dto.dart';
import 'package:easy_sell/database/model/shop_dto.dart';
import 'package:easy_sell/database/model/supplier_dto.dart';
import 'package:easy_sell/screens/sync_screen/downlaod_functions.dart';
import 'package:easy_sell/screens/sync_screen/upload_functions.dart';
import 'package:easy_sell/screens/transfer_product_screen/widget/transfer_items_header.dart';
import 'package:easy_sell/screens/warehouse_screen/widget/crud/warehouse_excel_upload_widget.dart';
import 'package:easy_sell/screens/warehouse_screen/widget/warehouse_income_product_item.dart';
import 'package:easy_sell/services/https_services.dart';
import 'package:easy_sell/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:unicons/unicons.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/user_role.dart';
import '../../../../database/my_database.dart';
import '../../../../database/table/product_income_table.dart';
import '../../../../services/excel_service.dart';
import '../../../../widgets/app_autocomplete.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_input_table.dart';
import '../../../../widgets/app_input_underline.dart';
import '../../../../widgets/app_search_field.dart';
import '../../screens/product_screen/widget/product_info_dialog.dart';

class WarehouseCreateIncomeProductsDialog extends StatefulWidget {
  const WarehouseCreateIncomeProductsDialog({Key? key, required this.close}) : super(key: key);
  final void Function() close;

  @override
  State<WarehouseCreateIncomeProductsDialog> createState() => _WarehouseCreateIncomeProductsDialogState();
}

class _WarehouseCreateIncomeProductsDialogState extends State<WarehouseCreateIncomeProductsDialog> {
  MyDatabase database = Get.find<MyDatabase>();
  late TextEditingController _searchController;
  List<ProductIncomeDataStruct> _productIncomesList = [];
  List<ProductDTO> _searchList = [];
  int? _selectedSupplierId;
  String supplierDebt = '0';
  String description = '';
  final formKey = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();
  late UploadFunctions uploadFunctions;
  late DownloadFunctions downloadFunctions;
  double exchangeRate = 1;
  bool loading = false;
  int priceSettingId = -1;
  CurrencyDataStruct? currency;
  int? shopId;
  int? fromShopId;
  bool infoIsHidden = false;

  TextEditingController discountController = TextEditingController(text: "0");
  RegExp spaceRemover = RegExp(r'\s+');
  List<CurrencyDataStruct> currencies = [];

  @override
  void initState() {
    super.initState();
    uploadFunctions = UploadFunctions(database: database, setter: setter, progress: {});
    downloadFunctions = DownloadFunctions(database: database, setter: setter, progress: {});
    _searchController = TextEditingController();
    _focusNode.requestFocus();
    getMyShop();
    _getExchangeRate();
    initDebtDay();
    getMe();
    getCurrency();
  }

  void getCurrency() async {
    var res = await HttpServices.get("/currency/all");
    var resJson = jsonDecode(res.body);
    for (var item in resJson['data']) {
      currencies.add(CurrencyDataStruct.fromJson(item));
    }
    setState(() {});
  }

  List<UserRole> editRoles = [UserRole.ADMIN];
  bool canEdit = false;
  bool isEditable = false;

  void getMe() async {
    var res = await HttpServices.get("/user/get-me");
    var json = jsonDecode(res.body);
    var roles = json['roles'];
    setState(() {
      canEdit = editRoles.any((element) => roles.contains(element.name));
    });
  }

  void getMyShop() async {
    var res = await HttpServices.get("/user/get-me");
    var resJson = jsonDecode(res.body);
    if (resJson['shop'] == null) return;
    shopId = resJson['shop']['id'];
    setState(() {});
  }

  ExchangeRateDataStruct? exchangeRateData;

  void _getExchangeRate() async {
    var res = await HttpServices.get("/exchange-rate/latest");
    var resJson = jsonDecode(res.body);
    exchangeRateData = ExchangeRateDataStruct.fromJson(resJson);
    setState(() {
      exchangeRate = exchangeRateData!.rate;
    });
  }

  void setter(Function f) {}

  void _handleCreatedProduct(ProductData data) async {
    ProductDTO createProduct = await database.productDao.getProductWithProductId(data.id);
    onTapProduct(createProduct.productData);
    setState(() {});
  }

  final TextEditingController _supplierDebtController = TextEditingController();

  void initDebtDay() {
    storage.read('supplier_debt').then((value) {
      if (value != null) {
        _supplierDebtController.text = value;
      }
    });
  }

  bool isDollar = true;
  String messageUploading = "";
  List<Map<String, dynamic>> unknownProducts = [];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return AlertDialog(
      backgroundColor: Colors.black.withOpacity(0.9),
      insetPadding: const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.all(0),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          (_selectedSupplierId != null)
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Qarzdorlik Summa : 0', style: TextStyle(color: AppColors.appColorGreen300, fontSize: 20)),
                  ],
                )
              : Container(),
          Text('Maxsulotlarni qabul qilish', style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
          Row(
            children: [
              Text(messageUploading, style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
              const SizedBox(width: 10),
              if (unknownProducts.isNotEmpty)
                IconButton(
                  onPressed: () async {
                    showAppAlertDialog(
                      context,
                      title: 'Xatolik(${unknownProducts.length} ta)',
                      message: 'Topilmagan mahsulotlar',
                      buttonLabel: 'Ok',
                      cancelLabel: 'Bekor qilish',
                      messageWidget: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Clipboard.setData(
                                    ClipboardData(text: unknownProducts.map((e) => e.values.join(", ")).toList().join('\n')));
                                if (context.mounted) {
                                  showAppAlertDialog(
                                    context,
                                    title: 'Muvaffaqiyatli',
                                    message: 'Nusxalangan',
                                    cancelLabel: "OK",
                                  );
                                }
                              },
                              icon: Icon(Icons.copy, color: AppColors.appColorWhite, size: 25)),
                          IconButton(
                            onPressed: () async {
                              List header = ['Mahsulot', 'Taminotchi artikuli', 'Artikul', 'Sotuv narxi'];

                              List data = unknownProducts.map((e) {
                                return [
                                  e['0'].toString(),
                                  e['1'].toString(),
                                  e['2'].toString(),
                                ];
                              }).toList();
                              await ExcelService.createExcelFile(
                                  [header, ...data], 'Topilmaganlar ${formatDate(DateTime.now()).toString()}', context);
                            },
                            icon: Icon(Icons.downloading, color: AppColors.appColorWhite, size: 25),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: Icon(Icons.device_unknown, color: AppColors.appColorRed400, size: 25),
                ),
              IconButton(
                onPressed: () async {
                  Map<String, dynamic> result = await showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Excelga yuklash', style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
                          IconButton(onPressed: Get.back, icon: Icon(Icons.close, color: AppColors.appColorWhite, size: 25)),
                        ],
                      ),
                      insetPadding: const EdgeInsets.all(0),
                      content: SizedBox(width: MediaQuery.of(context).size.width, child: const UploadPurchaseExcel()),
                      backgroundColor: Colors.black,
                    ),
                  );
                  List<Map<String, dynamic>> products = result['json'];
                  for (var product in products) {
                    onTapProduct(
                      product['product'],
                      amount: int.tryParse(product['amount']) ?? 0,
                      price: double.tryParse(product['price']) ?? 0,
                      fromExcel: true,
                    );
                  }
                  unknownProducts = result['unknownProducts'];
                  setState(() {});
                },
                icon: const Icon(Icons.cloud_upload_outlined, color: Colors.yellow, size: 25),
              ),
              IconButton(
                onPressed: () {
                  _focusNode.unfocus();
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AppInputTable(
                            callback: (List<TableResult> result) async {
                              try {
                                const List<String> selectedFields = ['name', 'vendor_code', 'code'];
                                for (var item in result) {
                                  ProductData? product = await database.productDao.findByTableResults(item, selectedFields);
                                  if (product != null) {
                                    int priceIndex = item.fields.indexOf('price');
                                    int amountIndex = item.fields.indexOf('amount');
                                    int expireDateIndex = item.fields.indexOf('expire_date');
                                    String format = 'dd.MM.yyyy';
                                    if (item.values[expireDateIndex].contains("/")) {
                                      format = 'dd/MM/yyyy';
                                    } else if (item.values[expireDateIndex].contains("-")) {
                                      format = 'dd-MM-yyyy';
                                    }
                                    onTapProduct(product,
                                        fromExcel: true,
                                        expireDate: item.values[expireDateIndex].isEmpty
                                            ? null
                                            : DateFormat(format).parse(item.values[expireDateIndex]),
                                        amount: int.tryParse(item.values[amountIndex]) ?? 1,
                                        price: double.tryParse(item.values[priceIndex]) ?? 0);
                                  } else {
                                    showAppAlertDialog(
                                      context,
                                      title: 'XATOLIK!',
                                      message: 'So\'rov bo\'yicha topilmadi:${item.values.join(",")}',
                                      cancelLabel: "OK",
                                    );
                                  }
                                }
                                Get.back();
                              } catch (e) {
                                showAppAlertDialog(context,
                                    title: 'Xatolik', message: e.toString(), buttonLabel: 'Ok', cancelLabel: 'Bekor qilish');
                              }
                            },
                            defaultFieldsForHeader: [
                              TableField(
                                label: 'Mahsulot',
                                value: 'name',
                              ),
                              TableField(
                                label: 'Taminotchi Artikuli',
                                value: 'vendor_code',
                              ),
                              TableField(
                                label: 'Artikul',
                                value: 'code',
                              ),
                              TableField(
                                label: 'Miqdor',
                                value: 'amount',
                              ),
                              TableField(
                                label: 'Narx',
                                value: 'price',
                              ),
                              TableField(
                                label: 'Yaroqlilik',
                                value: 'expire_date',
                                inputFormatter: [
                                  MaskTextInputFormatter(
                                    mask: '##.##.####',
                                    filter: {"#": RegExp(r'[0-9]')},
                                  )
                                ],
                              ),
                            ],
                          ));
                },
                icon: Icon(Icons.paste_outlined, color: AppColors.appColorWhite, size: 25),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    infoIsHidden = !infoIsHidden;
                  });
                },
                icon: Icon(infoIsHidden ? Icons.fullscreen : Icons.fullscreen_exit, color: AppColors.appColorWhite, size: 25),
              ),
              IconButton(
                onPressed: () => Get.back(),
                icon: Icon(Icons.highlight_off_rounded, color: AppColors.appColorRed400, size: 25),
              ),
            ],
          ),
        ],
      ),
      content: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.always,
        child: SizedBox(
          width: width,
          height: height,
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: infoIsHidden ? 0 : height * 0.26,
                clipBehavior: Clip.antiAlias,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(color: Colors.grey.shade800.withOpacity(0.7), borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FutureBuilder(
                                future: HttpServices.get("/supplier/all"),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    List<SupplierDto> suppliers = [];
                                    var json = jsonDecode(snapshot.data.body);
                                    for (var item in json['data']) {
                                      suppliers.add(SupplierDto.fromJson(item));
                                    }
                                    return SizedBox(
                                      width: 300,
                                      child: AppAutoComplete(
                                        prefixIcon: UniconsLine.user,
                                        hintText: 'Taminotchi *',
                                        getValue: (AutocompleteDataStruct value) {
                                          supplierDebtCalculator(value.uniqueId);
                                          setState(() {
                                            _selectedSupplierId = suppliers
                                                .firstWhereOrNull(
                                                    (element) => element.name == value.value && element.id == value.uniqueId)
                                                ?.id;
                                          });
                                        },
                                        options: suppliers
                                            .map((e) => AutocompleteDataStruct(
                                                  value: e.name,
                                                  uniqueId: e.id,
                                                ))
                                            .toList(),
                                      ),
                                    );
                                  } else {
                                    return SizedBox(
                                      width: 300,
                                      child: Center(
                                        child: CircularProgressIndicator(color: AppColors.appColorGreen400),
                                      ),
                                    );
                                  }
                                }),
                            FutureBuilder(
                                future: HttpServices.get("/shop/all"),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    List<ShopDto> shops = [];
                                    var json = jsonDecode(snapshot.data.body);
                                    for (var item in json['data']) {
                                      shops.add(ShopDto.fromJson(item));
                                    }
                                    return SizedBox(
                                      width: 320,
                                      child: AppAutoComplete(
                                        prefixIcon: UniconsLine.shop,
                                        hintText: 'Qayerdan(kimdan)',
                                        getValue: (AutocompleteDataStruct value) {
                                          supplierDebtCalculator(value.uniqueId);
                                          setState(() {
                                            fromShopId = shops
                                                .firstWhereOrNull(
                                                    (element) => element.name == value.value && element.id == value.uniqueId)
                                                ?.id;
                                          });
                                        },
                                        options: shops
                                            .map((e) => AutocompleteDataStruct(
                                                  value: e.name,
                                                  uniqueId: e.id,
                                                ))
                                            .toList(),
                                      ),
                                    );
                                  } else {
                                    return SizedBox(
                                      width: 300,
                                      child: Center(
                                        child: CircularProgressIndicator(color: AppColors.appColorGreen400),
                                      ),
                                    );
                                  }
                                }),
                            if (canEdit)
                              FutureBuilder(
                                  future: HttpServices.get("/shop/all"),
                                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (snapshot.hasData) {
                                      List<ShopDto> shops = [];
                                      var json = jsonDecode(snapshot.data.body);
                                      for (var item in json['data']) {
                                        shops.add(ShopDto.fromJson(item));
                                      }
                                      return SizedBox(
                                        width: 320,
                                        child: AppAutoComplete(
                                          prefixIcon: UniconsLine.shop,
                                          hintText: 'Qabul qiluvchi *',
                                          getValue: (AutocompleteDataStruct value) {
                                            supplierDebtCalculator(value.uniqueId);
                                            setState(() {
                                              shopId = shops
                                                  .firstWhereOrNull(
                                                      (element) => element.name == value.value && element.id == value.uniqueId)
                                                  ?.id;
                                            });
                                          },
                                          options: shops
                                              .map((e) => AutocompleteDataStruct(
                                                    value: e.name,
                                                    uniqueId: e.id,
                                                  ))
                                              .toList(),
                                        ),
                                      );
                                    } else {
                                      return SizedBox(
                                        width: 300,
                                        child: Center(
                                          child: CircularProgressIndicator(color: AppColors.appColorGreen400),
                                        ),
                                      );
                                    }
                                  }),
                            Row(
                              children: [
                                SizedBox(
                                  width: 220,
                                  child: AppInputUnderline(
                                    maxLines: 1,
                                    hintText: 'Skidka',
                                    inputFormatters: [AppTextInputFormatter()],
                                    hideIcon: true,
                                    controller: discountController,
                                    onChanged: (String value) {
                                      setState(() {});
                                    },
                                  ),
                                ),
                                Text(
                                  '',
                                  style: TextStyle(color: AppColors.appColorWhite, fontSize: 18),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 300,
                              child: AppInputUnderline(
                                controller: _supplierDebtController,
                                keyboardType: TextInputType.number,
                                prefixIcon: UniconsLine.clock,
                                inputFormatters: [
                                  AppTextInputFormatter(),
                                ],
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    storage.write('supplier_debt', value);
                                  } else {
                                    storage.delete('supplier_debt');
                                  }
                                },
                                hintText: 'Qarzdorlik muddati',
                              ),
                            ),
                            FutureBuilder(
                              future: HttpServices.get("/settings/set-price/all"),
                              builder: (BuildContext context, AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  List priceSettings = [];
                                  var json = jsonDecode(snapshot.data.body);
                                  for (var item in json['data']) {
                                    priceSettings.add(item);
                                  }
                                  return SizedBox(
                                    width: 320,
                                    child: AppAutoComplete(
                                      prefixIcon: UniconsLine.money_bill,
                                      hintText: 'Narx sozlamasi *',
                                      getValue: (AutocompleteDataStruct value) async {
                                        setState(() {
                                          priceSettingId = priceSettings.firstWhereOrNull((element) =>
                                              element['name'] == value.value && element['id'] == value.uniqueId)?['id'];
                                        });
                                      },
                                      options: priceSettings
                                          .map((e) => AutocompleteDataStruct(
                                                value: e['name'],
                                                uniqueId: e['id'],
                                              ))
                                          .toList(),
                                    ),
                                  );
                                } else {
                                  return SizedBox(
                                    width: 300,
                                    child: Center(
                                      child: CircularProgressIndicator(color: AppColors.appColorGreen400),
                                    ),
                                  );
                                }
                              },
                            ),
                            Container(
                              width: 320,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade800.withOpacity(0.7),
                                border: Border.all(color: AppColors.appColorWhite.withOpacity(0.2), width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                title: Text(formatNumber(totalPriceWithCurrency()),
                                    style: TextStyle(color: AppColors.appColorWhite, fontSize: 15)),
                                subtitle: Text('Umumiy', style: TextStyle(color: AppColors.appColorGrey400)),
                                trailing: SizedBox(
                                  width: 150,
                                  child: AppAutoComplete(
                                    prefixIcon: UniconsLine.money_bill,
                                    hintText: 'Valyuta',
                                    options: currencies
                                        .map((e) => AutocompleteDataStruct(
                                              value: e.name,
                                              uniqueId: e.id,
                                            ))
                                        .toList(),
                                    getValue: (AutocompleteDataStruct value) {
                                      setState(() {
                                        currency = currencies.firstWhereOrNull(
                                            (element) => element.name == value.value && element.id == value.uniqueId);
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                width: Get.width,
                                child: AppInputUnderline(
                                  maxLines: 1,
                                  hintText: 'Izoh',
                                  textInputAction: TextInputAction.newline,
                                  prefixIcon: UniconsLine.comment_alt,
                                  onChanged: (value) {
                                    setState(() {
                                      description = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                            AppButton(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ProductInfoDialog(
                                      callback: () {},
                                      onProductCreated: _handleCreatedProduct,
                                    );
                                  },
                                );
                              },
                              tooltip: 'Maxsulot yaratish',
                              width: 40,
                              height: 40,
                              color: AppColors.appColorGreen400,
                              borderRadius: BorderRadius.circular(10),
                              hoverRadius: BorderRadius.circular(10),
                              child: Icon(UniconsLine.shopping_bag, color: AppColors.appColorWhite, size: 25),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                flex: 10,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
                      color: Colors.grey.shade800.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: TransferItemsHeader(
                          layouts: [6, 6, 6, 6, 6, 3, 6, 3, 5, 6, 3],
                        ),
                      ),
                      Expanded(
                        flex: 10,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          child: ListView.builder(
                            cacheExtent: 1000,
                            itemExtent: 50,
                            shrinkWrap: true,
                            itemCount: _productIncomesList.length,
                            itemBuilder: (BuildContext context, int index) {
                              ProductData currentProduct = _productIncomesList[index].product;
                              // BalanceData productBalance = database.balanceDao.getById(currentProduct.productData.id);
                              return WareHouseIncomeProductItem(
                                index: index,
                                priceSettingId: priceSettingId,
                                layouts: const [6, 6, 6, 6, 6, 3, 6, 3, 5, 6, 3],
                                currentProduct: currentProduct,
                                productData: _productIncomesList[index],
                                currencies: currencies,
                                onRemove: () async {
                                  setState(() {
                                    _productIncomesList.removeAt(index);
                                  });
                                  // update
                                },
                                setAmount: (int amount) async {
                                  setState(() {
                                    _productIncomesList[index].amount = amount;
                                  });
                                },
                                setPrice: (double price) async {
                                  setState(() {
                                    _productIncomesList[index].price = price;
                                  });
                                },
                                setExpireDate: (DateTime? expireDate) {
                                  setState(() {
                                    _productIncomesList[index].expireDate = expireDate;
                                  });
                                },
                                setCurrency: (CurrencyDataStruct? currency) async {
                                  setState(() {
                                    _productIncomesList[index].currency = currency;
                                  });
                                },
                                setAutomaticPrice: (double price) async {
                                  if (_productIncomesList.length <= index) {
                                    return;
                                  }
                                  setState(() {
                                    _productIncomesList[index].automaticPrice = price;
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text('Jami :  ${formatNumber(_productIncomesList.length)} ta',
                        style: TextStyle(color: AppColors.appColorGreen300, fontSize: 16)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Dollarda :  ${formatNumber(total(currency: ProductIncomeCurrency.USD))} \$',
                          style: TextStyle(color: AppColors.appColorGreen300, fontSize: 16)),
                      const SizedBox(width: 10),
                      Text('Sumda : ${formatNumber(total(currency: ProductIncomeCurrency.UZS))} SUM',
                          style: TextStyle(color: AppColors.appColorGreen300, fontSize: 16)),
                      const SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                ],
              ),
              if (_searchList.isNotEmpty)
                Container(
                  height: 50,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(10)),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _searchList
                          .map(
                            (product) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: () => onTapProduct(product.productData),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                  decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(10)),
                                  child: Text(product.productData.name, style: TextStyle(color: AppColors.appColorGreen400)),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.appColorWhite.withOpacity(0.2), width: 1),
                borderRadius: BorderRadius.circular(17),
              ),
              width: Get.width * 0.85,
              child: AppSearchBar(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(17), color: AppColors.appColorBlackBg),
                controller: _searchController,
                focusNode: _focusNode,
                focusedColor: Colors.transparent,
                searchEngine: (
                  String searchTerm, {
                  bool isEmptySearch = false,
                }) async {
                  if (isEmptySearch) {
                    setState(() {
                      _searchList = [];
                    });
                    return;
                  }
                  List<ProductDTO> products =
                      await database.productDao.getAllProductsByLimitOrSearch(search: searchTerm, limit: 20);
                  setState(() {
                    _searchList = products;
                  });
                },
                onEditingComplete: () async {
                  List<ProductDTO> products =
                      await database.productDao.getAllProductsByLimitOrSearch(search: _searchController.text, limit: 20);
                  setState(() {
                    _searchList = products;
                  });
                  if (_searchList.isEmpty) {
                    if (context.mounted) {
                      showAppAlertDialog(
                        context,
                        title: 'Xatolik',
                        message: 'Siz kiritgan maxsulot bazada mavjud emas\nQidiruv so\'rovi: ${_searchController.text}',
                        buttonLabel: 'Ok',
                        cancelLabel: 'Bekor qilish',
                      );
                    }
                    setState(() {
                      _searchController.text = '';
                      _searchList = [];
                    });
                    return;
                  }
                  onTapProduct(_searchList[0].productData);
                  setState(() {
                    _searchController.text = '';
                    _searchList = [];
                  });
                },
                searchWhenEmpty: false,
              ),
            ),
            const SizedBox(width: 20),
            AppButton(
              tooltip: '',
              onTap: loading
                  ? null
                  : () async {
                      try {
                        if (_selectedSupplierId == null) {
                          throw Exception('Taminotchi tanlanmagan');
                        }
                        if (_productIncomesList.isEmpty) {
                          throw Exception('Mahsulotlar tanlanmagan');
                        }
                        if (shopId == null) {
                          throw Exception("Sizga do'kon berilmagan");
                        }
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            loading = true;
                          });
                          for (ProductIncomeDataStruct productIncome in _productIncomesList) {
                            ProductData selectedProduct = productIncome.product;
                            if (productIncome.price == 0) {
                              throw Exception('Mahsulot narxi kiritilmagan: ${selectedProduct.name}');
                            }
                          }

                          var request = {
                            "fromShopId": fromShopId,
                            "shopId": shopId,
                            "description": description,
                            "createdTime": DateTime.now().millisecondsSinceEpoch,
                            "expiredDebtDate": _supplierDebtController.text.isEmpty
                                ? null
                                : DateTime.now()
                                    .add(Duration(days: int.parse(_supplierDebtController.text.replaceAll(" ", ""))))
                                    .millisecondsSinceEpoch,
                            "supplierId": _selectedSupplierId,
                            "productIncomes": _productIncomesList.map((e) {
                              ProductData selectedProduct = e.product;
                              return {
                                "productId": selectedProduct.serverId,
                                "price": e.price,
                                "amount": e.amount,
                                "expireDate": e.expireDate?.millisecondsSinceEpoch,
                                "currencyId": e.currency?.id,
                              };
                            }).toList(),
                            "type": "INCOME",
                            "discount": discountController.text.isEmpty
                                ? 0
                                : double.parse(discountController.text.replaceAll(spaceRemover, "")),
                            "currencyId": currency?.id,
                          };
                          print(request);
                          var res = await HttpServices.post("/product-income/create", request);
                          if (res.statusCode == 201 || res.statusCode == 200) {
                            var newRequest = _productIncomesList.map((e) {
                              ProductData selectedProduct = e.product;
                              if (e.automaticPrice != 0) {
                                return {
                                  "productId": selectedProduct.serverId,
                                  "price": e.automaticPrice,
                                };
                              }
                            }).toList();
                            var newRes = await HttpServices.post("/price/set/all", newRequest);
                            if (newRes.statusCode == 200 || newRes.statusCode == 201) {
                              if (context.mounted) {
                                showAppSnackBar(context, "Muvaffaqiyatli", "OK");
                              }
                              widget.close();
                              await downloadFunctions.getPrices('prices');
                            }
                          } else {
                            throw Exception('Xatolik yuz berdi: ${res.body}');
                          }
                        } else {
                          throw Exception('Narxlar yoki miqdorlar kiritilmagan bo\'lishi mumkin');
                        }
                      } catch (e) {
                        if (context.mounted) {
                          setState(() {
                            loading = false;
                          });
                          showAppAlertDialog(context,
                              title: 'Xatolik', message: e.toString(), buttonLabel: 'Ok', cancelLabel: 'Bekor qilish');
                        }
                      }
                    },
              width: 130,
              height: 50,
              color: AppColors.appColorGreen400,
              hoverColor: AppColors.appColorGreen300,
              colorOnClick: AppColors.appColorGreen700,
              splashColor: AppColors.appColorGreen700,
              borderRadius: BorderRadius.circular(12),
              hoverRadius: BorderRadius.circular(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  loading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.appColorWhite),
                          ),
                        )
                      : Text(
                          'Saqlash',
                          style: TextStyle(
                              color: AppColors.appColorWhite, fontWeight: FontWeight.w500, fontSize: 16, letterSpacing: 1),
                        ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  void onTapProduct(
    ProductData product, {
    double price = 0,
    int amount = 1,
    DateTime? expireDate,
    bool fromExcel = false,
  }) async {
    _focusNode.requestFocus();
    bool isExist = _productIncomesList.any((element) => element.product.id == product.id);
    if (isExist && !fromExcel) {
      int index = _productIncomesList.indexWhere((element) => element.product.id == product.id);
      int lastAmount = _productIncomesList[index].amount;
      setState(() {
        _productIncomesList[index].amount = lastAmount + amount;
        _productIncomesList[index].price = price;
        _productIncomesList[index].expireDate = expireDate;
      });
    } else {
      setState(() {
        _productIncomesList.add(ProductIncomeDataStruct(
          product: product,
          price: price,
          amount: amount,
          currency: currency,
          expireDate: expireDate,
        ));
      });
    }
    setState(() {
      _searchList = [];
    });
    _searchController.clear();
  }

  double total({ProductIncomeCurrency currency = ProductIncomeCurrency.USD}) {
    double total = 0;
    _productIncomesList.where((element) => element.currency == currency).forEach((element) {
      total += element.price * element.amount;
    });
    return total;
  }

  double totalPriceWithCurrency() {
    double total = 0;
    double dollar = 0;
    double sum = 0;
    double discountValue =
        discountController.text.isEmpty ? 0 : double.parse(discountController.text.replaceAll(spaceRemover, ""));

    /// TODO: discount currency
    bool currencyDiscountIsDollar = false;

    for (var element in _productIncomesList) {
      if (element.currency == ProductIncomeCurrency.USD) {
        dollar += element.price * element.amount;
      } else {
        sum += element.price * element.amount;
      }
    }
    total = !isDollar ? ((dollar) * exchangeRate + sum) : ((sum) / exchangeRate + dollar);
    if (currencyDiscountIsDollar) {
      total -= isDollar ? discountValue : discountValue * exchangeRate;
    } else {
      total -= isDollar ? discountValue / exchangeRate : discountValue;
    }
    return total;
  }

  void supplierDebtCalculator(int supplierId) async {
    // double debt = await _moneyCalculatorService.calculateSupplierCheck(supplierId);
    setState(() {
      supplierDebt = formatNumber(0);
    });
  }
}

class ProductIncomeDataStruct {
  ProductData product;
  double price;
  int amount;
  DateTime? expireDate;
  CurrencyDataStruct? currency;
  double? automaticPrice = 0;

  ProductIncomeDataStruct(
      {required this.product, required this.price, required this.amount, this.expireDate, this.currency, this.automaticPrice});
}
