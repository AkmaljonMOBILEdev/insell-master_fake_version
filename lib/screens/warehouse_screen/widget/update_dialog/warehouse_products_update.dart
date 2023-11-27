import 'dart:convert';

import 'package:easy_sell/database/model/currency_dto.dart';
import 'package:easy_sell/database/model/product_dto.dart';
import 'package:easy_sell/database/model/product_income_document.dart';
import 'package:easy_sell/screens/warehouse_screen/widget/update_dialog/update_header.dart';
import 'package:easy_sell/screens/warehouse_screen/widget/update_dialog/update_item.dart';
import 'package:easy_sell/services/https_services.dart';
import 'package:easy_sell/widgets/app_input_underline.dart';
import 'package:flutter/material.dart';

import '../../../../constants/colors.dart';
import '../../../../services/auto_sync.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/app_search_field.dart';

class WarehouseProductsUpdate extends StatefulWidget {
  const WarehouseProductsUpdate(
      {super.key, required this.productIncomeDocument, required this.setter, required this.onTapProduct});

  final ProductIncomeDocumentDto productIncomeDocument;
  final Function(ProductIncomeDocumentDto) setter;
  final void Function(ProductDTO product, {double amount, double price}) onTapProduct;

  @override
  State<WarehouseProductsUpdate> createState() => _WarehouseProductsUpdateState();
}

class _WarehouseProductsUpdateState extends State<WarehouseProductsUpdate> {
  ProductIncomeDocumentDto get productIncomeDocument => widget.productIncomeDocument;

  set productIncomeDocument(ProductIncomeDocumentDto val) {
    widget.setter(val);
  }

  List<ProductDTO> _searchList = [];
  final _searchController = TextEditingController();
  ScrollController listScrollController = ScrollController();
  final _focusNode = FocusNode();

  void onTapProduct(ProductDTO product) {
    widget.onTapProduct(product);
    setState(() {
      _searchController.text = '';
      _searchList = [];
    });
  }

  @override
  void initState() {
    super.initState();
    getAllCurrency();
  }

  List<CurrencyDataStruct> currencies = [];

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              flex: 5,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: AppInputUnderline(
                    onChanged: (val) {
                      int index = productIncomeDocument.productIncomes.indexWhere((element) {
                        return element.product.code == val || element.product.name == val || element.product.vendorCode == val;
                      });
                      if (index != -1) {
                        listScrollController.animateTo(
                          index * 60.0,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    hintText: 'Qidiruv...',
                    outlineBorder: true,
                    prefixIcon: Icons.settings_applications_rounded,
                  )),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: UpdateHeader(
            layouts: [8, 4, 4, 1, 2, 2, 2, 2, 2, 1],
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
                color: AppColors.appColorBlackBg,
                border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
                borderRadius: BorderRadius.circular(15)),
            child: ListView.builder(
              controller: listScrollController,
              cacheExtent: 10,
              itemExtent: 60,
              itemBuilder: (context, index) {
                ProductIncomeDto productIncome = productIncomeDocument.productIncomes[index];
                return UpdateItem(
                  layout: const [8, 4, 4, 1, 2, 2, 2, 2, 2, 1],
                  product: productIncome,
                  index: index,
                  currencies: currencies,
                  onRemove: () {
                    setState(() {
                      productIncomeDocument.productIncomes.remove(productIncome);
                    });
                    widget.setter(productIncomeDocument);
                  },
                );
              },
              itemCount: productIncomeDocument.productIncomes.length,
            ),
          ),
        ),
        if (_searchList.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
              color: Colors.white12,
              borderRadius: BorderRadius.circular(10),
            ),
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
        AppSearchBar(
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
            onTapProduct(_searchList[0]);
            setState(() {
              _searchController.text = '';
              _searchList = [];
            });
          },
          searchWhenEmpty: false,
        ),
        const SizedBox(height: 2)
      ],
    );
  }
}
