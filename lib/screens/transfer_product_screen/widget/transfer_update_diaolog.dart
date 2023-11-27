import 'dart:convert';

import 'package:easy_sell/database/my_database.dart';
import 'package:easy_sell/screens/transfer_product_screen/widget/transfer_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';

import '../../../constants/colors.dart';
import '../../../database/model/product_dto.dart';
import '../../../database/model/shop_dto.dart';
import '../../../database/model/transfer_dto.dart';
import '../../../services/https_services.dart';
import '../../../utils/utils.dart';
import '../../../widgets/app_autocomplete.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_dialog.dart';
import '../../../widgets/app_input_underline.dart';
import '../../../widgets/app_search_field.dart';

class TransferUpdateDialog extends StatefulWidget {
  const TransferUpdateDialog({super.key, required this.transferItem, required this.shopList, required this.close});

  final List<ShopDto> shopList;
  final TransferDto transferItem;
  final Function() close;

  @override
  State<TransferUpdateDialog> createState() => _TransferUpdateDialogState();
}

class _TransferUpdateDialogState extends State<TransferUpdateDialog> {
  final FocusNode _focusNode = FocusNode();
  List<ProductDTO> _searchList = [];
  MyDatabase database = Get.find<MyDatabase>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  TransferDto? transfer;
  List<ProductOutcomeStruct> products = [];
  ShopDto? selectedFromShop;
  ShopDto? selectedToShop;

  @override
  void initState() {
    super.initState();
    setState(() {
      transfer = widget.transferItem;
      selectedFromShop = widget.transferItem.fromShop;
      selectedToShop = widget.transferItem.toShop;
    });
    initProductList();
  }

  void initProductList() async {
    try {
      List<ProductOutcomeStruct> products_ = [];
      for (var item in widget.transferItem.products) {
        ProductData? product = await database.productDao.getByServerId(item.product.serverId);
        if (product == null) {
          throw 'Maxsulot topilmadi: ${item.product.name}\nIltimos synxronizatsiya qiling';
        }
        products_.add(ProductOutcomeStruct(product: product, controller: TextEditingController(text: formatNumber(item.amount))));
      }
      setState(() {
        products = products_;
      });
    } catch (e) {
      showAppAlertDialog(context, title: 'Xatolik', message: 'Xatolik yuz berdi:\n$e', cancelLabel: 'Ok', buttonLabel: 'OK');
    }
  }

  void autoSelectProduct(ProductDTO product) async {
    bool? isExist = products.any((element) {
      return element.product.id == product.productData.id;
    });
    if (isExist == true) {
      int? index = products.indexWhere((element) => element.product.id == product.productData.id);
      setState(() {
        products[index].controller.text = (int.parse(products[index].controller.text) + 1).toString();
      });

      _searchList.clear();
      _searchController.clear();
      _focusNode.requestFocus();
      return;
    }
    setState(() {
      products.add(ProductOutcomeStruct(product: product.productData, controller: TextEditingController(text: '1')));
      _searchList.clear();
      _searchController.clear();
    });
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    List<ShopDto> shopList = widget.shopList;
    return AppDialog(
      backgroundColor: Colors.black.withOpacity(0.9),
      title: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(onPressed: widget.close, icon: Icon(Icons.edit, color: AppColors.appColorGreen400, size: 20)),
              IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(Icons.highlight_off_rounded, color: AppColors.appColorRed400, size: 25),
              ),
            ],
          ),
          Text('Maxsulotlarni harakati malumotlari', style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
        ],
      ),
      content: Form(
        key: formKey,
        child: SizedBox(
          width: Get.width * 0.8,
          height: Get.height * 0.7,
          child: Column(children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.grey.shade800.withOpacity(0.7),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.appColorGrey700, width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 300,
                    child: AppAutoComplete(
                      initialValue: selectedFromShop?.name ?? "",
                      prefixIcon: UniconsLine.share,
                      hintText: 'Yuboruvchi',
                      getValue: (AutocompleteDataStruct value) {
                        setState(() {
                          selectedFromShop =
                              shopList.firstWhereOrNull((element) => element.name == value.value && element.id == value.uniqueId);
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
                      initialValue: selectedToShop?.name ?? "",
                      prefixIcon: UniconsLine.user_circle,
                      hintText: 'Qabul qiluvchi',
                      getValue: (AutocompleteDataStruct value) {
                        setState(() {
                          selectedToShop =
                              shopList.firstWhereOrNull((element) => element.name == value.value && element.id == value.uniqueId);
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
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Expanded(
              child: TransferItemsToolbar(
                layouts: [3, 1, 1, 1, 1, 1],
              ),
            ),
            Expanded(
              flex: 10,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.grey.shade800.withOpacity(0.7),
                ),
                child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        SizedBox(
                          height: 35,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 0,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                                        decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(5)),
                                        child: Text('${index + 1}', style: TextStyle(color: AppColors.appColorWhite)),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Text(products[index].product.name, style: TextStyle(color: AppColors.appColorWhite)),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('${products[index].product.vendorCode}',
                                        style: TextStyle(color: AppColors.appColorWhite)),
                                    const SizedBox(width: 10)
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('${products[index].product.code}', style: TextStyle(color: AppColors.appColorWhite)),
                                    const SizedBox(width: 10)
                                  ],
                                ),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Center(
                                    child: AppInputUnderline(
                                      hideIcon: true,
                                      hintText: 'Miqdor',
                                      controller: products[index].controller,
                                      textAlign: TextAlign.center,
                                    ),
                                  )),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FutureBuilder(
                                        future: HttpServices.get(
                                            "/product/${widget.transferItem.products[index].product.serverId}/remainder"),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            var json = jsonDecode(snapshot.data?.body ?? "");
                                            var amount = json ?? 0;
                                            return Text(formatNumber(amount), style: TextStyle(color: AppColors.appColorWhite));
                                          } else {
                                            return const Text("-");
                                          }
                                        }),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(products[index].expiredDate != null ? formatDate(products[index].expiredDate) : "-",
                                        style: TextStyle(color: AppColors.appColorWhite)),
                                    const SizedBox(width: 10),
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            products.removeAt(index);
                                          });
                                        },
                                        icon: Icon(Icons.close, color: AppColors.appColorRed300, size: 20)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1, color: Colors.white24),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (_searchList.isNotEmpty)
              Expanded(
                flex: 1,
                child: Container(
                  width: Get.width,
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.appColorGrey700),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _searchList
                          .map((product) => InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: () {
                                  autoSelectProduct(product);
                                },
                                child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 5),
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
              ),
          ]),
        ),
      ),
      actions: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: AppColors.appColorGrey700),
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
              List<ProductDTO> products = await database.productDao.getAllProductsByLimitOrSearch(search: searchTerm, limit: 20);
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
              autoSelectProduct(_searchList[0]);
              setState(() {
                _searchController.text = '';
                _searchList = [];
              });
            },
            searchWhenEmpty: false,
          ),
        ),
        const SizedBox(height: 10),
        AppButton(
          tooltip: '',
          onTap: () async {
            if (formKey.currentState!.validate()) {
              try {
                if (selectedToShop == null) {
                  throw 'Qabul qiluvchi tanlanmagan';
                } else if (products.isEmpty) {
                  throw 'Mahsulotlar tanlanmagan';
                }
                var request = {
                  "fromShopId": selectedFromShop?.id,
                  "toShopId": selectedToShop?.id,
                  "createdTime": DateTime.now().millisecondsSinceEpoch,
                  "products": [
                    for (var item in products)
                      {
                        "productId": item.product.serverId,
                        "amount": item.controller.text,
                      },
                  ],
                  "status": "PENDING",
                };
                var res = await HttpServices.put("/products-transfer/${transfer?.id}", request);
                if (res.statusCode == 200 || res.statusCode == 201) {
                  if (context.mounted) {
                    showAppSnackBar(context, "Muvaffaqiyatli", "OK");
                  }
                  widget.close();
                  Get.back();
                } else {
                  throw res.body;
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
    );
  }
}

class ProductOutcomeStruct {
  final ProductData product;
  final TextEditingController controller;
  final DateTime? expiredDate;

  ProductOutcomeStruct({required this.product, required this.controller, this.expiredDate});
}
