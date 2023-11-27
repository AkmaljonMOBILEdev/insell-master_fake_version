import 'package:easy_sell/database/model/product_income_dto.dart';
import 'package:easy_sell/database/table/product_income_table.dart';
import 'package:easy_sell/screens/warehouse_screen/screens/history_screen/warehouse_history_screen.dart';
import 'package:easy_sell/screens/warehouse_screen/screens/return_to_supplier/return_to_supplier.dart';
import 'package:easy_sell/screens/warehouse_screen/widget/warehouse_right_containers.dart';
import 'package:easy_sell/services/storage_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/colors.dart';
import '../../services/excel_service.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/app_button.dart';
import '../warehouse_stock_screen/warehouse_stock_screen.dart';

class WarehouseScreen extends StatefulWidget {
  const WarehouseScreen({Key? key}) : super(key: key);

  @override
  State<WarehouseScreen> createState() => _WarehouseScreenState();
}

class _WarehouseScreenState extends State<WarehouseScreen> {
  bool loading = false;
  int offset = 0;
  int limit = 50;
  int total = 0;
  Storage storage = Storage();
  bool _isCashier = false;
  bool updated = false;

  @override
  void initState() {
    super.initState();
    _getUserRole();
  }

  void _getUserRole() async {
    var userRole = await storage.read('role');
    if (userRole == 'amikoCashier') {
      setState(() {
        _isCashier = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: AppBarWidget(
          onTapBack: () => Get.back(),
          centerTitle: false,
          backgroundColor: Colors.black12,
          title: Text('Sklad', style: TextStyle(color: AppColors.appColorWhite)),
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
                        List<ProductIncomeDTO> all = [];
                        List header = ['ID', 'Nomi', 'Kodi', 'Qoldiq', "Kirish narxi"];
                        List data = [];
                        for (var element in all) {
                          // double balance = await database.balanceDao.getAmountByProductId(element.product.productData.id);
                          // double price_ = await database.productIncomeDao.lastPriceByProductId(element.product.productData.id);
                          String vendorCode = (element.product.productData.vendorCode != null &&
                                  element.product.productData.vendorCode!.isNotEmpty)
                              ? (element.product.productData.vendorCode ?? "")
                              : (element.product.productData.code ?? "");
                          List row = [
                            element.product.productData.id,
                            element.product.productData.name,
                            vendorCode,
                            0,
                            "0 ${element.currency == ProductIncomeCurrency.USD ? " \$" : " so'm"}"
                          ];
                          data.add(row);
                        }
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
            _isCashier
                ? const SizedBox()
                : AppButton(
                    onTap: () {
                      Get.to(() => const ReturnToSupplierScreen());
                    },
                    width: 200,
                    height: 35,
                    margin: const EdgeInsets.all(5),
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.circular(12),
                    hoverRadius: BorderRadius.circular(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.settings_backup_restore, color: AppColors.appColorWhite, size: 21),
                        const SizedBox(width: 5),
                        Text('Taminotchiga Vazvrat', style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
                      ],
                    ),
                  ),
            AppButton(
              onTap: () {
                Get.to(() => const WarehouseStockScreen());
              },
              width: 180,
              height: 35,
              margin: const EdgeInsets.all(5),
              color: AppColors.appColorGreen400,
              borderRadius: BorderRadius.circular(12),
              hoverRadius: BorderRadius.circular(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.warehouse_rounded, color: AppColors.appColorWhite, size: 21),
                  const SizedBox(width: 5),
                  Text('Maxsulot qoldig\'i', style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
                ],
              ),
            ),
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
            WarehouseHistoryScreen(updated: updated),
            const SizedBox(width: 20),
            WarehouseRightContainers(
              getAll: () {
                setState(() {
                  updated = true;
                });
              },
              isCashier: _isCashier,
            )
          ],
        ),
      ),
    );
  }
}
