import 'dart:convert';
import 'package:easy_sell/database/model/exchange_rate_dto.dart';
import 'package:easy_sell/database/model/product_dto.dart';
import 'package:easy_sell/database/model/product_income_document.dart';
import 'package:easy_sell/database/model/supplier_dto.dart';
import 'package:easy_sell/screens/transfer_product_screen/widget/transfer_items_header.dart';
import 'package:easy_sell/screens/warehouse_screen/widget/crud/warehouse_editable_item.dart';
import 'package:easy_sell/services/https_services.dart';
import 'package:easy_sell/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';
import '../../../../constants/colors.dart';
import '../../../../database/model/shop_dto.dart';
import '../../../../database/my_database.dart';
import '../../../../database/table/product_income_table.dart';
import '../../../../services/excel_service.dart';
import '../../../../widgets/app_autocomplete.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_input_underline.dart';
import '../../../../widgets/app_search_field.dart';
import '../../screens/product_screen/widget/product_info_dialog.dart';

class WarehouseUpdateIncomeProductsDialog extends StatefulWidget {
  const WarehouseUpdateIncomeProductsDialog(
      {Key? key, required this.close, required this.changeEdit, required this.productIncomeDocument})
      : super(key: key);
  final void Function() close;
  final Function(bool value) changeEdit;
  final ProductIncomeDocumentDto productIncomeDocument;

  @override
  State<WarehouseUpdateIncomeProductsDialog> createState() => _WarehouseUpdateIncomeProductsDialogState();
}

class _WarehouseUpdateIncomeProductsDialogState extends State<WarehouseUpdateIncomeProductsDialog> {
  MyDatabase database = Get.find<MyDatabase>();
  late TextEditingController _searchController;
  WarehouseEditableDtoStruct warehouseEditableDtoStruct = WarehouseEditableDtoStruct(productIncomes: []);
  List<ProductDTO> _searchList = [];
  int? _selectedSupplierId;
  String supplierDebt = '0';
  String description = '';
  final formKey = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();
  double exchangeRate = 1;
  bool loading = false;
  int priceSettingId = -1;
  RegExp spaceRemover = RegExp(r'\s+');
  int? fromShopId;
  int? shopId;

  bool infoIsHidden = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _focusNode.requestFocus();
    _getExchangeRate();
    initDebtDay();
    initIncomeList();
  }

  void initIncomeList() async {
    fromShopId = widget.productIncomeDocument.fromShop?.id;
    shopId = widget.productIncomeDocument.shop?.id;
    warehouseEditableDtoStruct.supplier = widget.productIncomeDocument.supplier;
    int? expiredDebtInDays = widget.productIncomeDocument.expiredDebtDate?.isAfter(DateTime.now()) ?? false
        ? widget.productIncomeDocument.expiredDebtDate?.difference(DateTime.now()).inDays
        : 0;
    warehouseEditableDtoStruct.expiredDebtDate = TextEditingController(text: expiredDebtInDays.toString());
    warehouseEditableDtoStruct.discount = TextEditingController(text: formatNumber(widget.productIncomeDocument.discount));
    // warehouseEditableDtoStruct.currency = widget.productIncomeDocument.discountCurrency;
    List<WarehouseEditableItemStruct> productIncomes = [];
    for (var productIncome in widget.productIncomeDocument.productIncomes) {
      WarehouseEditableItemStruct newItem = WarehouseEditableItemStruct(
          isDollar: productIncome.currency == ProductIncomeCurrency.USD,
          expireDateController: productIncome.expiredDate,
          productData: productIncome.product,
          amountController: TextEditingController(text: formatNumber(productIncome.amount)),
          priceController: TextEditingController(text: (productIncome.price.toString())),
          automaticPriceController: TextEditingController(text: formatNumber(0)));
      productIncomes.add(newItem);
    }
    setState(() {
      warehouseEditableDtoStruct.productIncomes = productIncomes;
    });
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
    onTapProduct(createProduct);
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

  bool isChanged = false;

  @override
  void didUpdateWidget(covariant WarehouseUpdateIncomeProductsDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.productIncomeDocument != widget.productIncomeDocument) {
      initIncomeList();
      totalPriceWithCurrency();
      updateAllSuggestPrice();
    }
  }

  final ScrollController bodyScrollbar = ScrollController();
  final TextEditingController _searchInProductIncomesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return AlertDialog(
      backgroundColor: Colors.black.withOpacity(0.9),
      title: Column(
        children: [
          Row(
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
                  SizedBox(
                    width: 300,
                    child: AppInputUnderline(
                      hintText: 'Qidirish',
                      hideIcon: true,
                      outlineBorder: true,
                      controller: _searchInProductIncomesController,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        infoIsHidden = !infoIsHidden;
                      });
                    },
                    icon: Icon(infoIsHidden ? Icons.fullscreen_exit : Icons.fullscreen, color: Colors.white, size: 25),
                  ),
                  IconButton(
                    onPressed: () async {
                      List<ProductIncomeDto> all = widget.productIncomeDocument.productIncomes;
                      List header = ['Mahsulot', 'Taminotchi artikuli', 'Artikul', 'Miqdori', 'Narxi', 'Yaroqlilik'];
                      List data = all.map((e) {
                        return [
                          e.product.name,
                          e.product.vendorCode,
                          e.product.code,
                          e.amount,
                          e.price,
                          formatDate(e.expiredDate)
                        ];
                      }).toList();
                      await ExcelService.createExcelFile([header, ...data],
                          'Zakupka (ADMIN) ${formatDate(widget.productIncomeDocument.createdTime).toString()}', context);
                    },
                    icon: Icon(Icons.downloading, color: AppColors.appColorWhite, size: 25),
                  ),
                  IconButton(
                    onPressed: () {
                      widget.changeEdit(false);
                    },
                    icon: const Icon(Icons.edit, color: Colors.yellowAccent, size: 25),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.highlight_off_rounded, color: AppColors.appColorRed400, size: 25),
                  ),
                ],
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
                height: infoIsHidden ? 0 : 180,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(color: Colors.grey.shade800.withOpacity(0.7), borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    Expanded(
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
                                      initialValue: warehouseEditableDtoStruct.supplier?.name ?? '',
                                      prefixIcon: UniconsLine.user,
                                      hintText: 'Taminotchi',
                                      getValue: (AutocompleteDataStruct value) {
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
                                      initialValue: shops.firstWhereOrNull((element) => element.id == fromShopId)?.name ?? '',
                                      prefixIcon: UniconsLine.shop,
                                      hintText: 'Qayerdan(kimdan)',
                                      getValue: (AutocompleteDataStruct value) {
                                        // supplierDebtCalculator(value.uniqueId);
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
                                      initialValue: shops.firstWhereOrNull((element) => element.id == shopId)?.name ?? '',
                                      prefixIcon: UniconsLine.shop,
                                      hintText: 'Qabul qiluvchi *',
                                      getValue: (AutocompleteDataStruct value) {
                                        // supplierDebtCalculator(value.uniqueId);
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
                                width: 200,
                                child: AppInputUnderline(
                                  maxLines: 1,
                                  hintText: 'Skidka',
                                  inputFormatters: [
                                    AppTextInputFormatter(),
                                  ],
                                  hideIcon: true,
                                  controller: warehouseEditableDtoStruct.discount,
                                  onChanged: (String value) {
                                    setState(() {});
                                  },
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  /// TODO: change currency
                                  // Currency? discountCurrency = warehouseEditableDtoStruct.currency;
                                  // setState(() {
                                  //   warehouseEditableDtoStruct.currency =
                                  //       (discountCurrency == Currency.uzs) ? Currency.usd : Currency.uzs;
                                  // });
                                },
                                icon: Text(
                                  '',
                                  style: TextStyle(color: AppColors.appColorWhite, fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 200,
                            child: AppInputUnderline(
                              controller: warehouseEditableDtoStruct.expiredDebtDate,
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
                                  width: 200,
                                  child: AppAutoComplete(
                                    prefixIcon: UniconsLine.money_bill,
                                    hintText: 'Narx sozlamasi',
                                    getValue: (AutocompleteDataStruct value) async {
                                      setState(() {
                                        priceSettingId = priceSettings.firstWhereOrNull((element) =>
                                            element['name'] == value.value && element['id'] == value.uniqueId)?['id'];
                                      });
                                      updateAllSuggestPrice();
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
                            width: 300,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade800.withOpacity(0.7),
                              border: Border.all(color: AppColors.appColorWhite.withOpacity(0.2), width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              title: Text(formatNumber(totalPriceWithCurrency()),
                                  style: TextStyle(color: AppColors.appColorWhite, fontSize: 15)),
                              subtitle: Text('Umumiy', style: TextStyle(color: AppColors.appColorGrey400)),
                              trailing: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isDollar = !isDollar;
                                  });
                                },
                                icon: Text(
                                  isDollar ? "USD \$" : "SUM",
                                  style: TextStyle(color: AppColors.appColorWhite, fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 15,
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
                          Expanded(
                            flex: 1,
                            child: AppButton(
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
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                flex: 10,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
                      color: Colors.grey.shade800.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: TransferItemsHeader(
                          layouts: [6, 6, 6, 6, 6, 2, 6, 4, 4, 6, 3],
                          readOnly: false,
                        ),
                      ),
                      Expanded(
                        flex: 10,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          child: ListView.builder(
                            cacheExtent: 3000,
                            itemExtent: 50,
                            itemCount: warehouseEditableDtoStruct.productIncomes.length,
                            itemBuilder: (BuildContext context, int index) {
                              WarehouseEditableItemStruct productIncome =
                                  warehouseEditableDtoStruct.productIncomes.toList()[index];
                              return WarehouseEditableItem(
                                index: index,
                                layouts: const [6, 6, 6, 6, 6, 2, 6, 4, 4, 6, 4],
                                incomeProduct: productIncome,
                                updateWidget: () async {
                                  setState(() {
                                    isChanged = true;
                                  });
                                  updateAllSuggestPrice();
                                },
                                deleteItem: () {
                                  setState(() {
                                    warehouseEditableDtoStruct.productIncomes.remove(productIncome);
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Dollarda :  ${formatNumber(total(currency: ProductIncomeCurrency.USD))} \$',
                      style: TextStyle(color: AppColors.appColorGreen300, fontSize: 16)),
                  const SizedBox(width: 10),
                  Text('Sumda : ${formatNumber(total(currency: ProductIncomeCurrency.UZS))} SUM',
                      style: TextStyle(color: AppColors.appColorGreen300, fontSize: 16)),
                ],
              ),
              if (_searchList.isNotEmpty)
                Expanded(
                  flex: 1,
                  child: Container(
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
                                  onTap: () => onTapProduct(product),
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
                ),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.appColorWhite.withOpacity(0.2), width: 1),
                borderRadius: BorderRadius.circular(17),
              ),
              width: Get.width * 0.8,
              child: AppSearchBar(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: const Radius.circular(17),
                    bottomLeft: const Radius.circular(17),
                    topLeft: Radius.circular(_searchController.text.isNotEmpty ? 0 : 17),
                    topRight: Radius.circular(_searchController.text.isNotEmpty ? 0 : 17),
                  ),
                  color: AppColors.appColorBlackBg,
                ),
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
                  onTapProduct(_searchList[0]);
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
                        if (priceSettingId == -1) {
                          throw Exception('Narx sozlamasi tanlanmagan');
                        }
                        if (warehouseEditableDtoStruct.supplier == null) {
                          throw Exception('Taminotchi tanlanmagan');
                        }
                        if (warehouseEditableDtoStruct.productIncomes.isEmpty) {
                          throw Exception('Mahsulotlar tanlanmagan');
                        }
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            loading = true;
                          });
                          for (WarehouseEditableItemStruct productIncome in warehouseEditableDtoStruct.productIncomes) {
                            ProductData selectedProduct = warehouseEditableDtoStruct
                                .productIncomes[warehouseEditableDtoStruct.productIncomes.indexOf(productIncome)].productData;
                            if (productIncome.priceController.text.isEmpty) {
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
                            "supplierId": warehouseEditableDtoStruct.supplier?.id,
                            "productIncomes": warehouseEditableDtoStruct.productIncomes.map((e) {
                              ProductData selectedProduct = warehouseEditableDtoStruct
                                  .productIncomes[warehouseEditableDtoStruct.productIncomes.indexOf(e)].productData;
                              return {
                                "productId": selectedProduct.serverId,
                                "price": e.priceController.text.replaceAll(spaceRemover, ""),
                                "amount": e.amountController.text.replaceAll(spaceRemover, ""),
                                "expireDate": e.expireDateController?.millisecondsSinceEpoch,
                                "currency": e.isDollar ? ProductIncomeCurrency.USD.name : ProductIncomeCurrency.UZS.name,
                              };
                            }).toList(),
                            "type": "INCOME",
                            "discount": warehouseEditableDtoStruct.discount?.text.replaceAll(spaceRemover, ""),
                            "discountCurrency": warehouseEditableDtoStruct.currency?.name.toUpperCase(),
                          };
                          var res = await HttpServices.put("/product-income/${widget.productIncomeDocument.id}", request);
                          if (res.statusCode == 201 || res.statusCode == 200) {
                            setState(() {
                              loading = false;
                            });
                            widget.close();
                            Get.back();
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
              width: 95,
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

  Future<double> setAutomaticPrice({
    required int serverId,
    required double price,
    required ProductIncomeCurrency? currency,
    required int priceSettingId,
  }) async {
    var res = await HttpServices.get(
        "/price/product/$serverId/calculate?price=$price&currency=${currency?.name}&priceSettingId=$priceSettingId");
    var resJson = jsonDecode(res.body);
    if (res.statusCode == 200) {
      if (resJson.length > 0) {
        double price = resJson[0]['recommendPrice'];
        return price;
      }
    }
    return 0;
  }

  void onTapProduct(ProductDTO product) async {
    _focusNode.requestFocus();
    bool isExist =
        warehouseEditableDtoStruct.productIncomes.any((element) => element.productData.serverId == product.productData.serverId);
    if (isExist) {
      int index = warehouseEditableDtoStruct.productIncomes
          .indexWhere((element) => element.productData.serverId == product.productData.serverId);
      int amount = int.parse(warehouseEditableDtoStruct.productIncomes[index].amountController.text.replaceAll(spaceRemover, ""));
      setState(() {
        warehouseEditableDtoStruct.productIncomes[index].amountController.text = (amount + 1).toString();
      });
    } else {
      double price = 0;
      ProductIncomeCurrency currency = ProductIncomeCurrency.UZS;
      setState(() {
        warehouseEditableDtoStruct.productIncomes.add(WarehouseEditableItemStruct(
          amountController: TextEditingController(text: '1'),
          priceController: TextEditingController(text: formatNumber(price)),
          isDollar: currency == ProductIncomeCurrency.USD,
          automaticPriceController: TextEditingController(text: "0"),
          productData: product.productData,
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
    for (var element in warehouseEditableDtoStruct.productIncomes) {
      double price = double.tryParse(element.priceController.text.replaceAll(spaceRemover, "")) ?? 0;
      double amount = double.tryParse(element.amountController.text.replaceAll(spaceRemover, "")) ?? 0;
      total += price * amount;
    }
    return total;
  }

  double totalPriceWithCurrency() {
    double total = 0;
    double dollar = 0;
    double sum = 0;
    double discount = widget.productIncomeDocument.discount;

    /// TODO: change currency
    // Currency? discountCurrency = widget.productIncomeDocument.discountCurrency;
    // dollar -= discountCurrency == Currency.uzs ? discount / exchangeRate : discount;
    for (var element in warehouseEditableDtoStruct.productIncomes) {
      double price = double.tryParse(element.priceController.text.replaceAll(spaceRemover, "")) ?? 0;
      double amount = double.tryParse(element.amountController.text.replaceAll(spaceRemover, "")) ?? 0;
      if (element.isDollar) {
        dollar += price * amount;
      } else {
        sum += price * amount;
      }
    }
    total = !isDollar ? (dollar * exchangeRate + sum) : (sum / exchangeRate + dollar);
    return total;
  }

  void updateAllSuggestPrice() async {
    for (var productIncome in warehouseEditableDtoStruct.productIncomes) {
      ProductData selectedProduct =
          warehouseEditableDtoStruct.productIncomes[warehouseEditableDtoStruct.productIncomes.indexOf(productIncome)].productData;
      double automaticPrice = await setAutomaticPrice(
        serverId: selectedProduct.serverId ?? -1,
        priceSettingId: priceSettingId,
        price: double.tryParse(productIncome.priceController.text.replaceAll(spaceRemover, "")) ?? 0,
        currency: productIncome.isDollar ? ProductIncomeCurrency.USD : ProductIncomeCurrency.UZS,
      );
      if (mounted) {
        setState(() {
          productIncome.automaticPriceController = TextEditingController(text: automaticPrice.toString());
        });
      }
    }
  }
}

class WarehouseEditableItemStruct {
  final ProductData productData;
  TextEditingController amountController;
  TextEditingController priceController;
  DateTime? expireDateController;
  bool isDollar;
  TextEditingController automaticPriceController;

  WarehouseEditableItemStruct({
    required this.productData,
    required this.amountController,
    required this.priceController,
    this.expireDateController,
    required this.isDollar,
    required this.automaticPriceController,
  });
}

class WarehouseEditableDtoStruct {
  List<WarehouseEditableItemStruct> productIncomes = [];
  SupplierDto? supplier;
  TextEditingController? expiredDebtDate;
  TextEditingController? discount;
  CurrencyTableData? currency;

  WarehouseEditableDtoStruct({
    required this.productIncomes,
    this.currency,
    this.discount,
    this.supplier,
    this.expiredDebtDate,
  });
}
