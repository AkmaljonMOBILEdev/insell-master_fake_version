import 'dart:convert';
import 'package:easy_sell/database/my_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../constants/colors.dart';
import '../../../../../database/model/outgoing_dto.dart';
import '../../../../../services/https_services.dart';
import '../../../../../widgets/app_button.dart';
import '../outgoing_item.dart';
import 'outgoin_item_info.dart';

class PayToAnotherCashScreen extends StatefulWidget {
  const PayToAnotherCashScreen({Key? key}) : super(key: key);

  @override
  State<PayToAnotherCashScreen> createState() => _PayToAnotherCashScreenState();
}

class _PayToAnotherCashScreenState extends State<PayToAnotherCashScreen> {
  MyDatabase database = Get.find<MyDatabase>();

  @override
  Widget build(BuildContext context) {
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
        title: Text('Boshqa kassaga chiqim', style: TextStyle(color: AppColors.appColorWhite)),
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
                  child: Column(
                    children: [
                      const OutgoingItemInfo(),
                      Container(
                        height: height - 105,
                        padding: const EdgeInsets.symmetric(horizontal: 7),
                        decoration: BoxDecoration(
                          color: AppColors.appColorBlackBg,
                          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                        ),
                        child:
                        FutureBuilder(
                          future: HttpServices.get("/consumption/pos-consumption/all"),
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              var snapshotData = snapshot.data;
                              var responseJson = jsonDecode(snapshotData.body);
                              List<OutgoingDto> outgoingList = [];
                              if (responseJson != null) {
                                for (var rounding in responseJson['data']) {
                                  outgoingList.add(OutgoingDto.fromJson(rounding));
                                }
                              }
                              return ListView.builder(
                                padding: const EdgeInsets.all(0),
                                itemCount: outgoingList.length,
                                itemBuilder: (context, index) {
                                  return OutgoingItem(
                                    outgoingDto: outgoingList[index],
                                    index: index,
                                    callback: () => setState(() {}),
                                  );
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
            ),
          ],
        ),
      ),
    );
  }
}
