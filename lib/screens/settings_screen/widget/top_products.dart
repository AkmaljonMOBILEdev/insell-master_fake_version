import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../database/model/product_dto.dart';
import '../../../database/my_database.dart';
import '../../../services/storage_services.dart';
import '../../../utils/utils.dart';
import '../../../widgets/app_search_field.dart';

class TopProductsWidget extends StatefulWidget {
  const TopProductsWidget({super.key});

  @override
  State<TopProductsWidget> createState() => _TopProductsWidgetState();
}

class _TopProductsWidgetState extends State<TopProductsWidget> {
  MyDatabase database = Get.find<MyDatabase>();
  List<ProductDTO> topProducts = [];
  Storage storage = Storage();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<ProductDTO> _searchList = [];

  @override
  void initState() {
    super.initState();
    getTopProducts();
  }

  void getTopProducts() async {
    String? topProductsList = await storage.read('topProducts');
    if (topProductsList == null) {
      await storage.write('topProducts', jsonEncode([]));
    }
    if (topProductsList != null) {
      List<int> topProductsIds = jsonDecode(topProductsList).cast<int>();
      topProducts = await database.productDao.getTopProducts(topProductsIds);
      setState(() {
        topProducts = topProducts;
      });
    }
  }

  void onSelectedProduct(ProductDTO product) async {
    String? topProductsList = await storage.read('topProducts');
    if (topProductsList != null) {
      List<int> topProductsIds = jsonDecode(topProductsList).cast<int>();
      if (!topProductsIds.contains(product.productData.id)) {
        topProductsIds.add(product.productData.id);
        await storage.write('topProducts', jsonEncode(topProductsIds));
      }
    } else {
      await storage.write('topProducts', jsonEncode([product.productData.id]));
    }
    getTopProducts();
  }

  void removeTopProduct(ProductDTO product) async {
    String? topProductsList = await storage.read('topProducts');
    if (topProductsList != null) {
      List<int> topProductsIds = jsonDecode(topProductsList).cast<int>();
      if (topProductsIds.contains(product.productData.id)) {
        topProductsIds.remove(product.productData.id);
        await storage.write('topProducts', jsonEncode(topProductsIds));
      }
    }
    getTopProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_searchList.isNotEmpty)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _searchList
                  .map(
                    (product) => Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: AppColors.appColorGrey700, width: 1),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(5),
                        onTap: () async {
                          onSelectedProduct(product);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                          decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(5)),
                          child: Text(product.productData.name, style: TextStyle(color: AppColors.appColorGreen400)),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        // Search products result
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.appColorGrey700.withOpacity(0.5), width: 1),
            borderRadius: BorderRadius.circular(5),
          ),
          child: AppSearchBar(
            padding: const EdgeInsets.all(4),
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
            focusNode: _searchFocusNode,
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
              onSelectedProduct(_searchList[0]);
              setState(() {
                _searchController.text = '';
                _searchList = [];
              });
            },
            searchWhenEmpty: false,
          ),
        ),
        const SizedBox(height: 10),
        // Top products
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Top maxsulotlar',
                  style: TextStyle(color: AppColors.appColorWhite, fontSize: 18, fontWeight: FontWeight.w500)),
              Text('${topProducts.length} ta',
                  style: TextStyle(color: AppColors.appColorWhite, fontSize: 18, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: 250,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Wrap(
              runSpacing: 5,
              spacing: 5,
              children: topProducts.map(
                (product) {
                  return IntrinsicWidth(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: AppColors.appColorGrey700, width: 1),
                      ),
                      child: InkWell(
                        child: Row(
                          children: [
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(product.productData.name,
                                        style: TextStyle(color: AppColors.appColorWhite, fontSize: 15)),
                                    Text(product.productData.code ?? "",
                                        style: TextStyle(color: AppColors.appColorGrey300, fontSize: 12)),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(width: 15),
                            IconButton(
                              splashRadius: 10,
                              padding: const EdgeInsets.all(0),
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                removeTopProduct(product);
                              },
                              icon: Icon(Icons.close_rounded, color: AppColors.appColorRed400, size: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
