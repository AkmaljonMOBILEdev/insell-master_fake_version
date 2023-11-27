import 'dart:convert';

import 'package:easy_sell/database/my_database.dart';
import 'package:easy_sell/screens/transfer_product_screen/widget/transfer_product_item.dart';
import 'package:easy_sell/screens/transfer_product_screen/widget/transfer_product_items_info.dart';
import 'package:easy_sell/screens/transfer_product_screen/widget/transfer_right_containers.dart';
import 'package:easy_sell/services/https_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/colors.dart';
import '../../database/model/transfer_dto.dart';
import '../../services/excel_service.dart';
import '../../utils/utils.dart';
import '../../widgets/app_button.dart';
import '../warehouse_screen/widget/warehouse_notification_local_dialog.dart';
import '../warehouse_screen/widget/warehouse_notification_local_item.dart';

class MoveProductScreen extends StatefulWidget {
  const MoveProductScreen({super.key});

  @override
  State<MoveProductScreen> createState() => _MoveProductScreenState();
}

class _MoveProductScreenState extends State<MoveProductScreen> {
  MyDatabase database = Get.find<MyDatabase>();
  int limit = 50;
  int offset = 0;
  String notificationStatus = "";

  void onOpenNotificationFromLocal(TransferDto e, {required BuildContext context, required Function update}) {
    showDialog(
      context: context,
      builder: (alertContext) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            Column(
              children: [
                Text("Mahsulotlar", style: TextStyle(color: AppColors.appColorWhite), textAlign: TextAlign.center),
                Text("${e.description}",
                    style: TextStyle(color: AppColors.appColorWhite, fontSize: 12), textAlign: TextAlign.center),
              ],
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () async {
                    List<ProductOutcome> all = e.products;
                    List header = ['Mahsulot', 'Taminotchi artikuli', 'Artikul', 'Miqdori'];
                    List data = all.map((e) => [e.product.name, e.product.vendorCode, e.product.code, e.amount]).toList();
                    await ExcelService.createExcelFile(
                        [header, ...data], 'Peremesheniya ${formatDate(e.createdTime).toString()}', context);
                  },
                  icon: Icon(Icons.downloading, color: AppColors.appColorWhite, size: 25),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(alertContext),
                  icon: Icon(Icons.highlight_off_rounded, color: AppColors.appColorRed400, size: 25),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.black.withOpacity(0.9),
        content: WarehouseNotificationLocalDialog(
          item: e,
          onClose: update,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

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
        title: Text('Maxsulotlar harakati', style: TextStyle(color: AppColors.appColorWhite)),
        centerTitle: false,
        actions: [
          FutureBuilder(
              future: HttpServices.get("/products-transfer/all-pending"),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox();
                }
                if (snapshot.hasError) {
                  return const SizedBox();
                }
                if (snapshot.hasData) {
                  if (snapshot.data?.statusCode != 200) return const SizedBox();
                  List<TransferDto> fromLocal = [];
                  var json = jsonDecode(snapshot.data?.body ?? "");
                  for (var element in json) {
                    fromLocal.add(TransferDto.fromJson(element));
                  }
                  return AppButton(
                    tooltip: notificationStatus == "error" ? "Internetga ulanmagan" : null,
                    onTap: notificationStatus == "error"
                        ? null
                        : () {
                            showMenu(
                              context: context,
                              color: Colors.black,
                              constraints: const BoxConstraints(maxWidth: 600, maxHeight: 500),
                              position: const RelativeRect.fromLTRB(100, 50, 50, 0),
                              elevation: 1,
                              surfaceTintColor: Colors.black,
                              shadowColor: Colors.white24,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              items: [
                                const PopupMenuItem(
                                  onTap: null,
                                  enabled: false,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Bildirishnomalar",
                                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                ...fromLocal
                                    .map(
                                      (e) => PopupMenuItem(
                                        child: WareHouseLocalNotificationItem(
                                          item: e,
                                          index: fromLocal.indexOf(e) + 1,
                                          onPressed: () {
                                            onOpenNotificationFromLocal(e, context: context, update: () {
                                              Get.back();
                                              setState(() {});
                                            });
                                          },
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ],
                            );
                          },
                    width: 40,
                    height: 40,
                    margin: const EdgeInsets.all(7),
                    color: Colors.transparent,
                    hoverColor: AppColors.appColorGreen300,
                    colorOnClick: AppColors.appColorGreen700,
                    splashColor: AppColors.appColorGreen700,
                    borderRadius: BorderRadius.circular(15),
                    hoverRadius: BorderRadius.circular(15),
                    child: Center(
                      child: Badge(
                        smallSize: 10,
                        label: notificationStatus == "error"
                            ? null
                            : Text(fromLocal.length.toString(), style: const TextStyle(color: Colors.white, fontSize: 10)),
                        child: notificationStatus == "error"
                            ? const Icon(Icons.notifications_off, color: Colors.white, size: 23)
                            : const Icon(Icons.notifications, color: Colors.white, size: 23),
                      ),
                    ),
                  );
                }
                return const SizedBox();
              }),
        ],
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const MoveProductItemsInfo(),
                Expanded(
                  child: Container(
                      width: screenWidth / 1.38,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: AppColors.appColorBlackBg),
                      child: FutureBuilder(
                        future: HttpServices.get("/products-transfer/all"),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            List<TransferDto> transferList = [];
                            var responseJson = jsonDecode(snapshot.data.body);
                            for (var item in responseJson['data']) {
                              transferList.add(TransferDto.fromJson(item));
                            }
                            if (transferList.isEmpty) {
                              return Center(
                                  child: Text("Ma'lumotlar mavjud emas", style: TextStyle(color: AppColors.appColorWhite)));
                            }
                            return ListView.builder(
                              padding: const EdgeInsets.all(0),
                              itemCount: transferList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return MoveProductItem(
                                  index: index,
                                  transferItem: transferList[index],
                                  update: () {
                                    setState(() {});
                                  },
                                );
                              },
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                "Xatolik yuz berdi: ${snapshot.error}",
                                style: TextStyle(color: AppColors.appColorWhite),
                              ),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      )),
                ),
              ],
            ),
            MoveRightContainers(
              close: () {
                setState(() {});
                Get.back();
              },
            )
          ],
        ),
      ),
    );
  }
}
