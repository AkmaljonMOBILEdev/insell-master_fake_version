import 'package:easy_sell/database/model/product_dto.dart';
import 'package:easy_sell/screens/sync_screen/downlaod_functions.dart';
import 'package:easy_sell/screens/sync_screen/syn_enums.dart';
import 'package:easy_sell/screens/sync_screen/upload_functions.dart';
import 'package:easy_sell/screens/warehouse_screen/screens/product_screen/widget/product_item.dart';
import 'package:easy_sell/screens/warehouse_screen/screens/product_screen/widget/product_item_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';
import '../../../../constants/colors.dart';
import '../../../../database/my_database.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_pagination_and_search.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  MyDatabase database = Get.find<MyDatabase>();
  List<ProductDTO> _productsList = [];
  int _productsCount = 0;
  bool _isSynced = false;
  bool loading = false;
  int offset = 0;
  int limit = 20;
  bool _sortByName = false;
  late UploadFunctions uploadFunctions;
  late DownloadFunctions downloadFunctions;

  @override
  void initState() {
    super.initState();
    uploadFunctions = UploadFunctions(database: database, setter: (fn) {}, progress: {});
    downloadFunctions = DownloadFunctions(database: database, setter: (fn) {}, progress: {});
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width * 0.98;
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
        title: Text("Maxsulotlar", style: TextStyle(color: AppColors.appColorWhite)),
        centerTitle: false,
        actions: [
          Icon(UniconsLine.database, color: AppColors.appColorRed400, size: 21),
          AppButton(
            onTap: () {
              setState(() {
                _isSynced = !_isSynced;
              });
            },
            width: 35,
            height: 35,
            margin: const EdgeInsets.all(7),
            color: AppColors.appColorGrey700.withOpacity(0.5),
            hoverColor: AppColors.appColorGreen300,
            colorOnClick: AppColors.appColorGreen700,
            splashColor: AppColors.appColorGreen700,
            borderRadius: BorderRadius.circular(30),
            hoverRadius: BorderRadius.circular(30),
            child: Icon(Icons.cloud_upload_outlined, color: AppColors.appColorWhite, size: 21),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(right: 10, left: 10, bottom: 10, top: 65),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xFF26525f), Color(0xFF0f2228)],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                ProductItemInfo(
                  width: screenWidth,
                  sortByName: sortByName,
                  sorted: _sortByName,
                ),
                Expanded(
                  child: Container(
                    width: screenWidth,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: AppColors.appColorBlackBg),
                    child: loading
                        ? Center(child: CircularProgressIndicator(color: AppColors.appColorGreen400))
                        : _productsList.isEmpty
                            ? Center(
                                child: Text(
                                  'Mahsulotlar ro\'yxati bo\'sh',
                                  style: TextStyle(color: AppColors.appColorWhite),
                                ),
                              )
                            : ListView.separated(
                                padding: const EdgeInsets.all(0),
                                itemCount: _productsList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ProductItem(
                                    product: _productsList[index],
                                    index: index,
                                    callback: () async {
                                      await uploadFunctions.autoUpload(UploadTypes.CUSTOMERS);
                                      await downloadFunctions.getProducts('');
                                      await _getData();
                                    },
                                  );
                                },
                                separatorBuilder: (BuildContext context, int index) {
                                  return const Divider(height: 1, color: Colors.white24);
                                },
                              ),
                  ),
                ),
                AppPaginationAndSearchWidget(
                  width: screenWidth - 25,
                  length: _productsCount,
                  resultLength: _productsList.length,
                  nextPage: () {
                    if (_productsCount > (offset + 1) * limit) {
                      setState(() {
                        offset++;
                      });
                      _getData();
                    }
                  },
                  prevPage: () {
                    if (offset > 0) {
                      setState(() {
                        offset--;
                      });
                      _getData();
                    }
                  },
                  limit: limit,
                  search: (String value) async {
                    await _getData(search: value);
                  },
                ),
              ],
            ),
            // ProductRightContainers(
            //   callback: () => setState(() {
            //     _getData();
            //   }),
            //   allProductsLength: _productsCount,
            // ),
          ],
        ),
      ),
    );
  }

  // sort products by name
  void sortByName() {
    setState(() {
      if (_sortByName) {
        _productsList.sort((a, b) => a.productData.name.compareTo(b.productData.name));
      } else {
        _productsList.sort((a, b) => b.productData.name.compareTo(a.productData.name));
      }
      _sortByName = !_sortByName;
    });
  }

  Future<void> _getData({String search = ""}) async {
    setState(() {
      loading = true;
    });

    List<ProductDTO> productsList =
        await database.productDao.getAllProductsByLimitOrSearch(limit: limit, offset: offset, search: search);
    int productsCount = await database.productDao.getAllProductsCount();
    bool hasUnSynced = await database.productDao.hasUnSyncedProduct();
    if (!mounted) return;
    setState(() {
      _isSynced = !hasUnSynced;
      _productsList = productsList;
      _productsCount = productsCount;
      loading = false;
    });
  }
}
