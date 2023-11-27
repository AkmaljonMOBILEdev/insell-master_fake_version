import 'dart:convert';

import 'package:easy_sell/database/model/shop_dto.dart';
import 'package:easy_sell/database/my_database.dart';
import 'package:easy_sell/screens/transfer_product_screen/widget/tranfer_dialog_product_item.dart';
import 'package:easy_sell/screens/transfer_product_screen/widget/transfer_toolbar.dart';
import 'package:easy_sell/services/https_services.dart';
import 'package:easy_sell/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:unicons/unicons.dart';
import '../../../constants/colors.dart';
import '../../../database/model/product_dto.dart';
import '../../../widgets/app_autocomplete.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_input_table.dart';
import '../../../widgets/app_input_underline.dart';
import '../../../widgets/app_search_field.dart';

class MoveAddProductDialog extends StatefulWidget {
  const MoveAddProductDialog({Key? key, required this.close, required this.showDropDown}) : super(key: key);
  final void Function() close;
  final bool showDropDown;

  @override
  State<MoveAddProductDialog> createState() => _MoveAddProductDialogState();
}

class _MoveAddProductDialogState extends State<MoveAddProductDialog> {
  MyDatabase database = Get.find<MyDatabase>();
  final formKey = GlobalKey<FormState>();
  String selectedUnit = 'PENDING';
  List<String> dropdownItems = ['PENDING', 'IN_PROGRESS', 'CANCELED', 'COMPLETED'];

  List<ShopDto> shopList = [];
  ShopDto? selectedFromShop;
  ShopDto? selectedToShop;
  List<ProductDTO> _searchList = [];
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  List<TransferProductDataStruct> transferProductList = [];
  final FocusNode _focusNode = FocusNode();
  double exchangeRate = 1;
  bool isAdmin = false;

  void setter(void Function() fn) {}

  void searchProduct(String value) async {
    List<ProductDTO> products = await database.productDao.getAllProductsByLimitOrSearch(search: value);
    setState(() {
      _searchList = products;
    });
  }

  @override
  void initState() {
    super.initState();
    getAllShops();
    getMe();
  }

  void getMe() async {
    var res = await HttpServices.get("/user/get-me");
    var json = jsonDecode(res.body);
    setState(() {
      isAdmin = json['roles'].contains('ADMIN');
    });
  }

  void getAllShops() async {
    var res = await HttpServices.get("/shop/all");
    List<ShopDto> shops = [];
    var json = jsonDecode(res.body);
    for (var item in json['data']) {
      shops.add(ShopDto.fromJson(item));
    }
    setState(() {
      shopList = shops;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black.withOpacity(0.9),
      contentPadding: const EdgeInsets.all(5),
      insetPadding: const EdgeInsets.all(5),
      title: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
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
                                    autoSelectProduct(product,
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
                onPressed: () => Get.back(),
                icon: Icon(Icons.highlight_off_rounded, color: AppColors.appColorRed400, size: 25),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text('Maxsulotlarni yuborish', style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
        ],
      ),
      content: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.always,
        onChanged: () {
          formKey.currentState?.save();
        },
        child: SizedBox(
          width: Get.width,
          height: Get.height,
          child: Column(
            children: [
              Container(
                width: Get.width,
                padding: const EdgeInsets.only(bottom: 3, top: 3, left: 10, right: 10),
                decoration: BoxDecoration(color: Colors.grey.shade800.withOpacity(0.7), borderRadius: BorderRadius.circular(15)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (isAdmin)
                      SizedBox(
                        width: 300,
                        child: AppAutoComplete(
                          prefixIcon: UniconsLine.share,
                          hintText: 'Yuboruvchi',
                          getValue: (AutocompleteDataStruct value) {
                            setState(() {
                              selectedFromShop = shopList
                                  .firstWhereOrNull((element) => element.name == value.value && element.id == value.uniqueId);
                            });
                          },
                          options: shopList
                              .map((e) => AutocompleteDataStruct(
                                    uniqueId: e.id,
                                    value: e.name,
                                  ))
                              .toList(),
                        ),
                      ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 300,
                      child: AppAutoComplete(
                        prefixIcon: UniconsLine.user_circle,
                        hintText: 'Qabul qiluvchi',
                        getValue: (AutocompleteDataStruct value) {
                          setState(() {
                            selectedToShop = shopList
                                .firstWhereOrNull((element) => element.name == value.value && element.id == value.uniqueId);
                          });
                        },
                        options: shopList
                            .map((e) => AutocompleteDataStruct(
                                  uniqueId: e.id,
                                  value: e.name,
                                ))
                            .toList(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 350,
                      child: AppInputUnderline(
                        maxLines: 1,
                        hintText: 'Izoh',
                        textInputAction: TextInputAction.newline,
                        prefixIcon: UniconsLine.comment_alt,
                        controller: _commentController,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                flex: 10,
                child: Container(
                  width: Get.width,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade800.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white12)),
                  child: Column(
                    children: [
                      const Expanded(
                          flex: 1,
                          child: TransferItemsToolbar(
                            layouts: [6, 6, 6, 4, 4, 5],
                          )),
                      Expanded(
                        flex: 9,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          child: ListView.builder(
                            itemCount: transferProductList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return TransferDialogItem(
                                index: index,
                                layouts: const [6, 6, 6, 4, 4, 4, 1],
                                productData: transferProductList[index],
                                onRemove: () {
                                  setState(() {
                                    transferProductList.removeAt(index);
                                  });
                                },
                                setAmount: (int amount) {
                                  setState(() {
                                    transferProductList[index].amount = amount.toDouble();
                                  });
                                },
                                setExpireDate: (DateTime? expireDate) {
                                  setState(() {
                                    transferProductList[index].expireDate = expireDate;
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
              const SizedBox(
                height: 10,
              ),
              if (_searchList.isNotEmpty)
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    width: Get.width,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Wrap(
                        spacing: 10,
                        children: _searchList
                            .map((product) => InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () {
                                    autoSelectProduct(product.productData);
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                      decoration: BoxDecoration(
                                        color: Colors.white12,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: AppColors.appColorGrey700),
                                      ),
                                      child: Text(product.productData.name, style: TextStyle(color: AppColors.appColorGreen400))),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                )
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
                borderRadius: BorderRadius.circular(17),
                border: Border.all(color: AppColors.appColorGrey700),
              ),
              width: Get.width * 0.85,
              child: AppSearchBar(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(17)),
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
                  autoSelectProduct(_searchList[0].productData);
                  setState(() {
                    _searchController.text = '';
                    _searchList = [];
                  });
                },
                searchWhenEmpty: false,
              ),
            ),
            const SizedBox(width: 10),
            AppButton(
              tooltip: '',
              onTap: () async {
                if (formKey.currentState!.validate()) {
                  try {
                    if (selectedToShop == null) {
                      throw 'Qabul qiluvchi tanlanmagan';
                    } else if (transferProductList.isEmpty) {
                      throw 'Mahsulotlar tanlanmagan';
                    }
                    var request = {
                      "fromShopId": selectedFromShop?.id,
                      "toShopId": selectedToShop?.id,
                      "description": _commentController.text,
                      "createdTime": DateTime.now().millisecondsSinceEpoch,
                      "products": [
                        for (var item in transferProductList)
                          {
                            "productId": item.product.serverId,
                            "amount": item.amount,
                          },
                      ],
                      "status": "PENDING",
                    };
                    var res = await HttpServices.post("/products-transfer/create", request);
                    if (res.statusCode == 200 || res.statusCode == 201) {
                      widget.close();
                    } else {
                      throw 'Xatolik yuz berdi: ${res.body}';
                    }
                  } catch (e) {
                    showAppAlertDialog(context,
                        title: 'Xatolik', message: 'Xatolik yuz berdi:\n$e', cancelLabel: 'Ok', buttonLabel: 'OK');
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

  void autoSelectProduct(
    ProductData product, {
    int amount = 1,
    double price = 0,
    DateTime? expireDate,
  }) async {
    // if product already added to list
    bool isExist = transferProductList.any((element) => element.product.id == product.id);
    if (isExist) {
      int index = transferProductList.indexWhere((element) => element.product.id == product.id);
      setState(() {
        transferProductList[index].amount += amount.toDouble();
      });
      _searchList.clear();
      _searchController.clear();
      _focusNode.requestFocus();
      return;
    }
    setState(() {
      transferProductList.add(TransferProductDataStruct(product: product, amount: amount.toDouble(), price: price));
      _searchList.clear();
      _searchController.clear();
    });
    _focusNode.requestFocus();
  }

  double total() {
    double total = 0;
    for (var item in transferProductList) {
      total += item.amount * item.price;
    }
    return (total);
  }
}

class TransferProductDataStruct {
  ProductData product;
  double amount;
  double price;
  DateTime? expireDate;

  TransferProductDataStruct({required this.product, required this.amount, required this.price});
}
