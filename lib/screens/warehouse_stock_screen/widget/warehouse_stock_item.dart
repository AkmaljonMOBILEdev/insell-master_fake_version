import 'package:easy_sell/database/model/page_dto.dart';
import 'package:easy_sell/database/model/product_dto.dart';
import 'package:easy_sell/database/my_database.dart';
import 'package:easy_sell/screens/warehouse_stock_screen/widget/warehouse_stock_header.dart';
import 'package:easy_sell/services/auto_sync.dart';
import 'package:easy_sell/utils/utils.dart';
import 'package:easy_sell/widgets/app_pagination_and_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constants/colors.dart';
import '../../../../database/model/product_income_document.dart';

class WarehouseStockItemsScreen extends StatefulWidget {
  const WarehouseStockItemsScreen(
      {Key? key, this.updated, this.remainders})
      : super(key: key);
  final bool? updated;
  final List<Map>? remainders;

  @override
  State<WarehouseStockItemsScreen> createState() =>
      _WarehouseStockItemsScreenState();
}

class _WarehouseStockItemsScreenState extends State<WarehouseStockItemsScreen> {
  int page = 0;
  int size = 25;
  int total = 0;
  String search = "";

  @override
  void initState() {
    super.initState();
    getAll();
  }

  void getAll() async {
    total = await database.productDao.getAllProductsCount();
    setState(() {});
  }

  Future<List<ProductDTO>> getAllProducts() async {
    PageDto<ProductDTO> products =
        await database.productDao.getAllProductsByLimitOrSearchPage(
      limit: size,
      offset: page,
      search: search,
    );
    if (total != products.total) {
      setState(() {
        total = products.total;
      });
    }
    return products.data;
  }

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: Column(
        children: [
          const WarehouseStockItemsInfo(),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: AppColors.appColorBlackBg),
              child: FutureBuilder(
                future: getAllProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                        child: Text('Error: ${snapshot.error}',
                            style: TextStyle(color: AppColors.appColorWhite)));
                  }
                  if (snapshot.data == null) {
                    return Center(
                        child: Text('Error: ${snapshot.data}',
                            style: TextStyle(color: AppColors.appColorWhite)));
                  }
                  List<ProductData> productsList =
                      (snapshot.data ?? []).map((e) => e.productData).toList();
                  // if(total != snapshot.data!.total) {
                  // setState(() {
                  //   total = snapshot.data!.total;
                  // });
                  // }
                  return productsList.isEmpty
                      ? Center(
                          child: Text('Ma\'lumot mavjud emas',
                              style: TextStyle(color: AppColors.appColorWhite)))
                      : ListView.builder(
                          padding: const EdgeInsets.all(0),
                          itemCount: productsList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                SizedBox(
                                  height: 35,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 0,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 2,
                                                        horizontal: 6),
                                                decoration: BoxDecoration(
                                                    color: AppColors
                                                        .appColorGreen700,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: Text('${index + 1}',
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .appColorWhite)),
                                              ),
                                            ),
                                            const SizedBox(width: 20),
                                            Expanded(
                                              child: Text(
                                                  productsList[index].name,
                                                  style: TextStyle(
                                                      color: AppColors
                                                          .appColorWhite,
                                                      fontSize: 13)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                "${productsList[index].vendorCode}",
                                                style: TextStyle(
                                                    color: AppColors
                                                        .appColorWhite)),
                                            const SizedBox(width: 10)
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                (productsList[index].code ??
                                                    ""),
                                                style: TextStyle(
                                                    color:
                                                        AppColors.appColorWhite,
                                                    fontSize: 13)),
                                            const SizedBox(width: 10)
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: Text(
                                              formatNumber(
                                                widget.remainders!.firstWhereOrNull(
                                                            (element) =>
                                                                element['id'] ==
                                                                productsList[
                                                                        index]
                                                                    .serverId)?[
                                                        'amount'] ??
                                                    0,
                                              ),
                                              style: TextStyle(
                                                  color:
                                                      AppColors.appColorWhite)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(height: 1, color: Colors.white24),
                              ],
                            );
                          },
                        );
                },
              ),
            ),
          ),
          AppPaginationAndSearchWidget(
            width: MediaQuery.of(context).size.width,
            length: total,
            nextPage: () {
              if ((page + 1) * size > total) {
                return;
              }
              setState(() {
                page++;
              });
            },
            prevPage: () {
              if (page < 1) {
                return;
              }
              setState(() {
                page--;
              });
            },
            limit: size,
            search: (String arg) async {
              setState(() {
                search = arg;
              });
            },
            resultLength: size,
            label: '$total dan ${page * size} - ${(page + 1) * size}',
          ),
        ],
      ),
    );
  }

  double calculateTotal(ProductIncomeDocumentDto productIncomeDocumentDto) {
    double total = 0;

    /// TODO: Add Price type
    return total;
  }
}
