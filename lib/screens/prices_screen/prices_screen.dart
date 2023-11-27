import 'dart:convert';

import 'package:easy_sell/database/model/product_income_price.dart';
import 'package:easy_sell/screens/prices_screen/widget/prices_item.dart';
import 'package:easy_sell/screens/prices_screen/widget/prices_item_info.dart';
import 'package:easy_sell/screens/prices_screen/widget/upload_prices.dart';
import 'package:easy_sell/services/auto_sync.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../constants/colors.dart';
import '../../database/my_database.dart';
import '../../services/excel_service.dart';
import '../../services/https_services.dart';
import '../../utils/utils.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_input_table.dart';
import '../../widgets/app_search_field.dart';

class PricesScreen extends StatefulWidget {
  const PricesScreen({super.key});

  @override
  State<PricesScreen> createState() => _PricesScreenState();
}

class _PricesScreenState extends State<PricesScreen> {
  MyDatabase database = Get.find<MyDatabase>();
  List<ProductWithPrices> _productWithPricesList = [];
  List<ProductWithPrices> filteredList = [];
  int limit = 100;
  int offset = 0;
  int total = 0;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    getTotal();
    getAllIncomePrice();
  }

  void getAllIncomePrice() async {
    setState(() {
      loading = true;
    });
    List<ProductData> products = await database.productDao.getAll();
    List<PriceData> allPrices = await database.priceDao.getAll();
    var response = await HttpServices.post('/report/last-product-income-price', {});
    var json = jsonDecode(response.body);
    for (var item in json) {
      ProductIncomePrice incomePrice = ProductIncomePrice.fromJson(item);
      ProductData? product = products.firstWhereOrNull((element) => element.serverId == item['product']['id']);
      if (product != null) {
        incomePrice.product = product;
        List<PriceData> prices = allPrices.where((element) => element.productId == product.id).toList();
        _productWithPricesList.add(ProductWithPrices(prices: prices, incomePrice: incomePrice));
      }
    }
    if (mounted) {
      setState(() {
        filteredList = _productWithPricesList;
        loading = false;
      });
    }
  }

  void getTotal() async {
    int total_ = await database.productDao.getTotal();
    setState(() {
      total = total_;
    });
  }

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  void search(String term) async {
    if (term.isEmpty) {
      setState(() {
        filteredList = _productWithPricesList;
        total = filteredList.length;
      });
      return;
    }
    List<ProductWithPrices> result = _productWithPricesList.where((element) {
      return element.incomePrice.product.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          (element.incomePrice.product.vendorCode ?? '').toLowerCase().contains(_searchController.text.toLowerCase()) ||
          (element.incomePrice.product.code ?? '').toLowerCase().contains(_searchController.text.toLowerCase());
    }).toList();
    setState(() {
      filteredList = result;
      total = filteredList.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black12,
        leading: AppButton(
          onTap: () => Get.back(),
          width: 50,
          height: 50,
          margin: const EdgeInsets.all(7),
          color: AppColors.appColorGrey700.withOpacity(0.5),
          hoverColor: AppColors.appColorGreen300,
          colorOnClick: AppColors.appColorGreen700,
          splashColor: AppColors.appColorGreen700,
          borderRadius: BorderRadius.circular(13),
          hoverRadius: BorderRadius.circular(13),
          child: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.appColorWhite),
        ),
        actions: [
          AppButton(
            onTap: () async {
              await showDialog(
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
                  content: SizedBox(width: MediaQuery.of(context).size.width, child: const UploadPricesExcel()),
                  backgroundColor: Colors.black,
                ),
              );
            },
            tooltip: 'Text ga yuklash',
            width: 35,
            height: 35,
            margin: const EdgeInsets.all(7),
            hoverColor: AppColors.appColorGreen300,
            colorOnClick: AppColors.appColorGreen700,
            splashColor: AppColors.appColorGreen700,
            borderRadius: BorderRadius.circular(10),
            hoverRadius: BorderRadius.circular(10),
            child: const Icon(Icons.cloud_upload_outlined, color: Colors.yellow, size: 25),
          ),
          AppButton(
            onTap: () async {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => AppInputTable(
                    callback: (List<TableResult> result) async {
                      try {
                        const List<String> selectedFields = ['vendor_code', 'code'];
                        var req = [];
                        List<TableResult> error = [];
                        for (TableResult item in result) {
                          ProductData? product = await database.productDao.findByTableResults(item, selectedFields);
                          if (product != null) {
                            int priceIndex = item.fields.indexOf('price');
                            double price = double.parse(item.values[priceIndex]);
                            req.add({
                              "productId": product.serverId,
                              "price": price,
                            });
                          } else {
                            error.add(item);
                          }
                        }
                        var res = await HttpServices.post("/price/set/all", req);
                        if (res.statusCode == 200) {
                          await downloadFunctions.getPrices('price');
                          if (error.isNotEmpty) {
                            if (context.mounted) {
                              showAppAlertDialog(
                                context,
                                title: 'Xatolik(${error.length} ta)',
                                message:
                                'Quyidagi mahsulotlar topilmadi: \n${error.map((e) => e.values.join(" | ")).toList().join('\n')}',
                                buttonLabel: 'Ok',
                                cancelLabel: 'Bekor qilish',
                                messageWidget: Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          Clipboard.setData(
                                              ClipboardData(text: error.map((e) => e.values.join(", ")).toList().join('\n')));
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
                                        List header = ['Taminotchi Artikuli', 'Artikul', 'Narx'];
                                        await ExcelService.createExcelFile([header, ...error.map((e) => e.values).toList()],
                                            'Topilmagan Narxlar ${formatDate(DateTime.now()).toString()}', context);
                                      },
                                      icon: Icon(Icons.downloading, color: AppColors.appColorWhite, size: 25),
                                    ),
                                  ],
                                ),
                              );
                            }
                          } else {
                            if (context.mounted) {
                              showAppAlertDialog(
                                context,
                                title: 'Muvaffaqiyatli',
                                message: 'Narxlar muvaffaqiyatli saqlandi',
                                cancelLabel: "OK",
                              );
                            }
                          }
                        }
                      } catch (e) {
                        if (context.mounted) {
                          showAppAlertDialog(context,
                              title: 'Xatolik', message: e.toString(), buttonLabel: 'Ok', cancelLabel: 'Bekor qilish');
                        }
                      }
                    },
                    defaultFieldsForHeader: [
                      TableField(
                        label: 'Taminotchi Artikuli',
                        value: 'vendor_code',
                      ),
                      TableField(
                        label: 'Artikul',
                        value: 'code',
                      ),
                      TableField(
                        label: 'Narx',
                        value: 'price',
                      ),
                    ],
                  ),
              );
            },
            width: 35,
            height: 35,
            margin: const EdgeInsets.all(7),
            hoverColor: AppColors.appColorGreen300,
            colorOnClick: AppColors.appColorGreen700,
            splashColor: AppColors.appColorGreen700,
            borderRadius: BorderRadius.circular(10),
            hoverRadius: BorderRadius.circular(10),
            child: Icon(Icons.paste_outlined, color: AppColors.appColorWhite, size: 25),
          ),
          AppButton(
            onTap: () async {
              List header = ['Mahsulot', 'Taminotchi artikuli', 'Artikul', 'Sotuv narxi', 'Kirim narxi'];
              List data = _productWithPricesList.map((e) {
                return [
                  e.incomePrice.product.name,
                  e.incomePrice.product.vendorCode,
                  e.incomePrice.product.code,
                  e.prices.isEmpty ? '' : e.prices.first.value.toStringAsFixed(0),
                  e.incomePrice.price.toStringAsFixed(0),
                ];
              }).toList();
              // txt file
              await ExcelService.createTxtFile([header, ...data], 'Maxsulot savdo xisoboti', context);
            },
            tooltip: 'Text ga yuklash',
            width: 35,
            height: 35,
            margin: const EdgeInsets.all(7),
            hoverColor: AppColors.appColorGreen300,
            colorOnClick: AppColors.appColorGreen700,
            splashColor: AppColors.appColorGreen700,
            borderRadius: BorderRadius.circular(10),
            hoverRadius: BorderRadius.circular(10),
            child: Icon(Icons.text_snippet_outlined, color: AppColors.appColorWhite, size: 21),
          ),
          AppButton(
            onTap: () async {
              List header = ['Mahsulot', 'Taminotchi artikuli', 'Artikul', 'Sotuv narxi', 'Kirim narxi'];
              List data = _productWithPricesList.map((e) {
                return [
                  e.incomePrice.product.name,
                  e.incomePrice.product.vendorCode,
                  e.incomePrice.product.code,
                  e.prices.isEmpty ? '' : e.prices.first.value.toStringAsFixed(0),
                  e.incomePrice.price.toStringAsFixed(0),
                ];
              }).toList();
              await ExcelService.createExcelFile([header, ...data], 'Narxlar ${formatDate(DateTime.now()).toString()}', context);
            },
            tooltip: 'Excel ga yuklash',
            width: 35,
            height: 35,
            margin: const EdgeInsets.all(7),
            hoverColor: AppColors.appColorGreen300,
            colorOnClick: AppColors.appColorGreen700,
            splashColor: AppColors.appColorGreen700,
            borderRadius: BorderRadius.circular(10),
            hoverRadius: BorderRadius.circular(10),
            child: Icon(Icons.downloading, color: AppColors.appColorWhite, size: 25),
          ),
        ],
        title: Text('Narxlar', style: TextStyle(color: AppColors.appColorWhite)),
        centerTitle: false,
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        padding: const EdgeInsets.only(right: 10, left: 10, bottom: 10, top: 65),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xFF26525f), Color(0xFF0f2228)],
          ),
        ),
        child: Column(
          children: [
            const PricesItemInfo(),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppColors.appColorBlackBg),
                child: loading
                    ? Center(child: CircularProgressIndicator(color: AppColors.appColorWhite))
                    : ListView.builder(
                        itemExtent: 50,
                        padding: const EdgeInsets.all(0),
                        itemCount: filteredList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return PricesItem(
                            index: index,
                            product: filteredList[index],
                          );
                        },
                      ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.appColorBlackBg,
                border: Border.all(color: AppColors.appColorGrey700.withOpacity(0.5), width: 1),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(17),
                  bottomRight: Radius.circular(17),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: AppSearchBar(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      focusedColor: Colors.transparent,
                      searchEngine: (
                        String searchTerm, {
                        bool isEmptySearch = false,
                      }) async {
                        search(searchTerm.trim());
                      },
                      onEditingComplete: () async {
                        search(_searchController.text.trim());
                      },
                      searchWhenEmpty: true,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          flex: 0,
                          child: Text('${(offset) * limit}-${(offset + 1) * limit} / $total',
                              style: TextStyle(color: AppColors.appColorWhite)),
                        ),
                        const SizedBox(width: 20),
                        AppButton(
                          onTap: () {
                            if (offset == 0) return;
                            setState(() {
                              offset--;
                            });
                            // search(limit: limit, offset: offset);
                          },
                          width: 30,
                          height: 30,
                          borderRadius: BorderRadius.circular(10),
                          hoverRadius: BorderRadius.circular(10),
                          hoverColor: AppColors.appColorGreen300,
                          child: Center(child: Icon(Icons.arrow_back_ios_rounded, color: AppColors.appColorWhite, size: 23)),
                        ),
                        const SizedBox(width: 10),
                        AppButton(
                          onTap: () {
                            if ((offset + 1) * limit >= total) return;
                            setState(() {
                              offset++;
                            });
                            // search(limit: limit, offset: offset);
                          },
                          width: 30,
                          height: 30,
                          borderRadius: BorderRadius.circular(10),
                          hoverRadius: BorderRadius.circular(10),
                          hoverColor: AppColors.appColorGreen300,
                          child: Center(child: Icon(Icons.arrow_forward_ios_rounded, color: AppColors.appColorWhite, size: 23)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ProductWithPrices {
  List<PriceData> prices;
  ProductIncomePrice incomePrice;

  ProductWithPrices({required this.prices, required this.incomePrice});
}
