import 'dart:convert';

import 'package:easy_sell/screens/warehouse_stock_screen/widget/warehouse_stock_item.dart';
import 'package:easy_sell/services/storage_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/colors.dart';
import '../../database/model/product_dto.dart';
import '../../services/auto_sync.dart';
import '../../services/excel_service.dart';
import '../../services/https_services.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/app_button.dart';

class WarehouseStockScreen extends StatefulWidget {
  const WarehouseStockScreen({Key? key}) : super(key: key);

  @override
  State<WarehouseStockScreen> createState() => _WarehouseStockScreenState();
}

class _WarehouseStockScreenState extends State<WarehouseStockScreen> {
  bool loading = false;
  int offset = 0;
  int limit = 50;
  int total = 0;
  Storage storage = Storage();
  bool _isCashier = false;
  bool updated = false;
  List<Map> _remainders = [];
  List<ProductDTO> _products = [];

  @override
  void initState() {
    super.initState();
    asyncInitialization();
  }

  void asyncInitialization() async {
    setState(() {
      loading = true;
    });
    await _getUserRole();
    await getProducts();
    await getRemainders();
    setState(() {
      loading = false;
    });
  }

  Future<void> _getUserRole() async {
    var userRole = await storage.read('role');
    if (userRole == 'amikoCashier') {
      setState(() {
        _isCashier = true;
      });
    }
  }

  Future<void> getProducts() async {
    List<ProductDTO> pro = await database.productDao.getAllProducts(); //withPrice: true
    _products.addAll(pro);
    print("LIST FIRST: ${_products.length}");
  }

  Future<void> getRemainders() async {
    try {
      final response = await HttpServices.get("/product/all/remainder");
      if (response.statusCode == 200) {
        setState(() {
          _remainders = List<Map>.from(jsonDecode(response.body));
        });
      } else {
        print('error');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(55),
          child: AppBarWidget(
            onTapBack: () => Get.back(),
            centerTitle: false,
            backgroundColor: Colors.black12,
            title: Text('Maxsulot qoldig\'i', style: TextStyle(color: AppColors.appColorWhite)),
          ),
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
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: AppColors.appColorBlackBg),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: AppBarWidget(
          onTapBack: () => Get.back(),
          centerTitle: false,
          backgroundColor: Colors.black12,
          title: Text('Maxsulot qoldig\'i', style: TextStyle(color: AppColors.appColorWhite)),
          actions: [
            // AppButton(
            //   onTap: () => Get.toNamed(Routes.PRODUCT_EXPENSES),
            //   width: 130,
            //   height: 40,
            //   margin: const EdgeInsets.all(7),
            //   color: AppColors.appColorGreen400,
            //   hoverColor: AppColors.appColorGreen300,
            //   colorOnClick: AppColors.appColorGreen700,
            //   splashColor: AppColors.appColorGreen700,
            //   borderRadius: BorderRadius.circular(15),
            //   hoverRadius: BorderRadius.circular(15),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Icon(Icons.arrow_upward_rounded, color: AppColors.appColorWhite, size: 23),
            //       const SizedBox(width: 5),
            //       Text('Xarajatlar', style: TextStyle(color: AppColors.appColorWhite, fontSize: 16, fontWeight: FontWeight.w500))
            //     ],
            //   ),
            // ),
            _isCashier
                ? const SizedBox()
                : Tooltip(
                    message: 'Excelga yuklash',
                    child: AppButton(
                      onTap: () async {
                        List<ProductDTO> all = _products;
                        List header = ['ID', 'Nomi', 'Kodi', 'Qoldiq']; //"Kirish narxi"
                        List data = all
                            .map(
                              (e) => [
                                e.productData.serverId,
                                e.productData.name,
                                e.productData.vendorCode,
                                _remainders.firstWhereOrNull((element) => element['id'] == e.productData.serverId)?['amount'] ?? 0,
                              ],
                            )
                            .toList();

                        await ExcelService.createExcelFile([header, ...data], 'Sklad', context);
                      },
                      width: 35,
                      height: 35,
                      margin: const EdgeInsets.all(7),
                      hoverColor: AppColors.appColorGreen300,
                      colorOnClick: AppColors.appColorGreen700,
                      splashColor: AppColors.appColorGreen700,
                      borderRadius: BorderRadius.circular(30),
                      hoverRadius: BorderRadius.circular(30),
                      child: Icon(Icons.downloading, color: AppColors.appColorWhite, size: 21),
                    ),
                  ),
            // AppButton(
            //   onTap: () => Get.toNamed(Routes.PRODUCT),
            //   width: 130,
            //   height: 40,
            //   margin: const EdgeInsets.all(7),
            //   color: AppColors.appColorGreen400,
            //   hoverColor: AppColors.appColorGreen300,
            //   colorOnClick: AppColors.appColorGreen700,
            //   splashColor: AppColors.appColorGreen700,
            //   borderRadius: BorderRadius.circular(15),
            //   hoverRadius: BorderRadius.circular(15),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Icon(UniconsLine.shopping_bag, color: AppColors.appColorWhite, size: 23),
            //       const SizedBox(width: 5),
            //       Text('Maxsulotlar', style: TextStyle(color: AppColors.appColorWhite, fontSize: 16, fontWeight: FontWeight.w500))
            //     ],
            //   ),
            // ),
          ],
        ),
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
            WarehouseStockItemsScreen(
              updated: updated,
              remainders: _remainders,
            ),
          ],
        ),
      ),
    );
  }
}
