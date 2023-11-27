import 'dart:convert';

import 'package:easy_sell/database/model/price_rounded_dto.dart';
import 'package:easy_sell/database/model/price_set_dto.dart';
import 'package:easy_sell/database/my_database.dart';
import 'package:easy_sell/screens/prices_screen/screens/price_settings_screen/widget/add_price_rounding_dialog.dart';
import 'package:easy_sell/screens/prices_screen/screens/price_settings_screen/widget/add_set_price_dialog.dart';
import 'package:easy_sell/screens/prices_screen/screens/price_settings_screen/widget/price_rounding_item_info.dart';
import 'package:easy_sell/screens/prices_screen/screens/price_settings_screen/widget/price_round_item.dart';
import 'package:easy_sell/screens/prices_screen/screens/price_settings_screen/widget/set_price_item.dart';
import 'package:easy_sell/screens/prices_screen/screens/price_settings_screen/widget/set_price_item_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';
import '../../../../constants/colors.dart';
import '../../../../services/https_services.dart';
import '../../../../widgets/app_button.dart';

class PriceSettingsScreen extends StatefulWidget {
  const PriceSettingsScreen({Key? key}) : super(key: key);

  @override
  State<PriceSettingsScreen> createState() => _PriceSettingsScreenState();
}

class _PriceSettingsScreenState extends State<PriceSettingsScreen> {
  MyDatabase database = Get.find<MyDatabase>();


  @override
  Widget build(BuildContext context) {
    // height size
    double height = MediaQuery.of(context).size.height;

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
        title: Text('Narx so\'zlamalari', style: TextStyle(color: AppColors.appColorWhite)),
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
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      AppButton(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AddPriceRoundingDialog(callback: () {
                                setState(() {});
                              });
                            },
                          );
                        },
                        width: 150,
                        height: 30,
                        color: AppColors.appColorGreen400,
                        margin: const EdgeInsets.only(bottom: 10),
                        borderRadius: BorderRadius.circular(10),
                        hoverRadius: BorderRadius.circular(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(UniconsLine.balance_scale, color: AppColors.appColorWhite, size: 22),
                            const SizedBox(width: 5),
                            Text('Narx yaxlitlash',
                                style: TextStyle(color: AppColors.appColorWhite, fontSize: 16, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      AppButton(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AddSetPriceRoundingDialog(
                                callback: () {
                                  setState(() {});
                                },
                              );
                            },
                          );
                        },
                        width: 150,
                        height: 30,
                        color: AppColors.appColorGreen400,
                        margin: const EdgeInsets.only(bottom: 10, left: 5),
                        borderRadius: BorderRadius.circular(10),
                        hoverRadius: BorderRadius.circular(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(UniconsLine.money_bill, color: AppColors.appColorWhite, size: 22),
                            const SizedBox(width: 5),
                            Text('Narx o\'rnatish',
                                style: TextStyle(color: AppColors.appColorWhite, fontSize: 16, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            // const AddBoxItemInfo(),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const PriceRoundingItemInfo(),
                      Container(
                        height: height - 145,
                        padding: const EdgeInsets.symmetric(horizontal: 7),
                        decoration: BoxDecoration(
                          color: AppColors.appColorBlackBg,
                          borderRadius:
                              const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                        ),
                        child: FutureBuilder(
                          future: HttpServices.get("/settings/rounding/all"),
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              var snapshotData = snapshot.data;
                              var responseJson = jsonDecode(snapshotData.body);
                              List<PriceRoundedDto> roundingList = [];
                              if (responseJson != null) {
                                for (var rounding in responseJson['data']) {
                                  roundingList.add(PriceRoundedDto.fromJson(rounding));
                                }
                              }
                              return ListView.builder(
                                padding: const EdgeInsets.all(0),
                                itemCount: roundingList.length,
                                itemBuilder: (context, index) {
                                  // print(roundingList[index].id);
                                  return PriceRoundItem(
                                    roundedDto: roundingList[index],
                                    index: index,
                                    callback: () => setState(() {}),
                                  );
                                  //Text(roundingList[index].id.toString(), style: TextStyle(color: AppColors.appColorWhite, fontSize: 18, fontWeight: FontWeight.w500));
                                },
                              );
                            } else {
                              return Center(child: CircularProgressIndicator(color: AppColors.appColorWhite));
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      const SetPriceItemInfo(),
                      Container(
                        height: height - 145,
                        margin: const EdgeInsets.only(left: 5),
                        padding: const EdgeInsets.symmetric(horizontal: 7),
                        decoration: BoxDecoration(
                          color: AppColors.appColorBlackBg,
                          borderRadius:
                              const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                        ),
                        child: FutureBuilder(
                          future: HttpServices.get("/settings/set-price/all"),
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              var snapshotData = snapshot.data;
                              var responseJson = jsonDecode(snapshotData.body);
                              List<PriceSetDto> setPriceList = [];
                              if (responseJson != null) {
                                for (var rounding in responseJson['data']) {
                                  setPriceList.add(PriceSetDto.fromJson(rounding));
                                }
                              }
                              return ListView.builder(
                                padding: const EdgeInsets.all(0),
                                itemCount: setPriceList.length,
                                itemBuilder: (context, index) {
                                  return SetPriceItem(
                                    setPriceDto: setPriceList[index],
                                    index: index,
                                    callback: () => setState(() {}),
                                  );
                                  //Text(roundingList[index].id.toString(), style: TextStyle(color: AppColors.appColorWhite, fontSize: 18, fontWeight: FontWeight.w500));
                                },
                              );
                            } else {
                              return Center(child: CircularProgressIndicator(color: AppColors.appColorWhite));
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
