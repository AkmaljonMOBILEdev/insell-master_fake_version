import 'dart:convert';

import 'package:easy_sell/database/model/supplier_dto.dart';
import 'package:easy_sell/screens/supplier_screen/screens/supplier_organization_screen/supplier_organization.dart';
import 'package:easy_sell/screens/supplier_screen/widget/supplier_item.dart';
import 'package:easy_sell/screens/supplier_screen/widget/supplier_item_info.dart';
import 'package:easy_sell/screens/supplier_screen/widget/supplier_right_containers.dart';
import 'package:easy_sell/services/https_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../../database/my_database.dart';
import '../../services/excel_service.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_pagination_and_search.dart';
import '../settings_screen/widget/supplier_segment.dart';

class SupplierScreen extends StatefulWidget {
  const SupplierScreen({Key? key}) : super(key: key);

  @override
  State<SupplierScreen> createState() => _SupplierScreenState();
}

class _SupplierScreenState extends State<SupplierScreen> {
  MyDatabase database = Get.find<MyDatabase>();
  bool loading = false;
  int offset = 0;
  int limit = 50;
  int? selectedRegionId;

  @override
  void initState() {
    super.initState();
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
        title: Text("Ta'minot", style: TextStyle(color: AppColors.appColorWhite)),
        centerTitle: false,
        actions: [
          Tooltip(
            message: 'Excelga yuklash',
            child: AppButton(
              onTap: () async {
                List<SupplierDto> all = [];
                List header = ['ID', 'Ism', 'Sana', 'Telefon raqam', 'Manzil'];
                List data = all.map((e) => [e.id, e.name, e.createdAt, e.phoneNumber, e.address]).toList();
                await ExcelService.createExcelFile([header, ...data], 'Ta\'minotchilar', context);
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
          AppButton(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => AddSupplierSegmentDialog(
                        value: null,
                        onAdd: () {
                          setState(() {});
                        },
                      ));
            },
            width: 200,
            height: 35,
            margin: const EdgeInsets.all(7),
            color: AppColors.appColorGreen700,
            borderRadius: BorderRadius.circular(12),
            hoverRadius: BorderRadius.circular(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: AppColors.appColorWhite, size: 21),
                const SizedBox(width: 5),
                Text('Segment qo\'shish', style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
              ],
            ),
          ),
          AppButton(
            onTap: () {
              Get.to(() => const SupplierOrganizationScreen());
            },
            width: 200,
            height: 35,
            margin: const EdgeInsets.all(7),
            color: AppColors.appColorGreen700,
            borderRadius: BorderRadius.circular(12),
            hoverRadius: BorderRadius.circular(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: AppColors.appColorWhite, size: 21),
                const SizedBox(width: 5),
                Text('Organizatsiya qo\'shish', style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
              ],
            ),
          ),
          const SizedBox(width: 10),
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
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          FutureBuilder(
              future: HttpServices.get("/supplier/all"),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  var responseJson = jsonDecode(snapshot.data.body.toString());
                  List<SupplierDto> suppliers = [];
                  int suppliersCount = 0;
                  for (var item in responseJson['data']) {
                    suppliers.add(SupplierDto.fromJson(item));
                  }
                  suppliersCount = responseJson['totalElements'];
                  if (selectedRegionId != null) {
                    suppliers = suppliers.where((element) => element.region?.id == selectedRegionId).toList();
                  }
                  return Column(
                    children: [
                      SupplierItemInfo(
                        sortByName: () {},
                        sorted: false,
                      ),
                      Expanded(
                        child: Container(
                          width: screenWidth / 1.38,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(borderRadius: const BorderRadius.only(), color: AppColors.appColorBlackBg),
                          child: ListView.builder(
                            padding: const EdgeInsets.all(0),
                            itemCount: suppliers.length,
                            itemBuilder: (BuildContext context, index) {
                              return SupplierItem(
                                supplier: suppliers[index],
                                index: index,
                                callback: () => setState(() {}),
                              );
                            },
                          ),
                        ),
                      ),
                      AppPaginationAndSearchWidget(
                        width: screenWidth / 1.38 - 26,
                        length: suppliers.length,
                        resultLength: suppliersCount,
                        nextPage: () {
                          if (suppliersCount > (offset + 1) * limit) {
                            setState(() {
                              offset++;
                            });
                          }
                        },
                        prevPage: () {
                          if (offset > 0) {
                            setState(() {
                              offset--;
                            });
                          }
                        },
                        limit: limit,
                        search: (String value) async {},
                      ),
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              }),
          SupplierRightContainers(
            allSuppliersLength: 0,
            callback: () {
              setState(() {});
            },
            getByRegion: (int? regionId) async {
              setState(() {
                selectedRegionId = regionId;
              });
            },
          )
        ]),
      ),
    );
  }
}
