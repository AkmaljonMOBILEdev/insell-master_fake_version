import 'dart:convert';
import 'package:easy_sell/database/model/income_dto.dart';
import 'package:easy_sell/database/my_database.dart';
import 'package:easy_sell/screens/finance_screen/incomes_screen/widget/income_screens/wrapper_screen_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../constants/colors.dart';
import '../../../../../services/https_services.dart';
import '../../../../../widgets/app_button.dart';
import '../../../../../widgets/app_pagination_and_search.dart';
import '../../../finance_screen.dart';
import '../../../outgoings_screen/widgets/outgoings_screens/outgoin_item_info.dart';

class IncomeWrapperScreen extends StatefulWidget {
  const IncomeWrapperScreen({Key? key, required this.route, required this.screenName, required this.itemType}) : super(key: key);
  final String route;
  final String screenName;
  final IncomeWrapperScreenType itemType;

  @override
  State<IncomeWrapperScreen> createState() => _IncomeWrapperScreenState();
}

class _IncomeWrapperScreenState extends State<IncomeWrapperScreen> {
  MyDatabase database = Get.find<MyDatabase>();
  int page = 0;
  int size = 20;
  int totalElements = 0;

  @override
  void initState() {
    super.initState();
    getTotals();
  }

  void getTotals() async {
    var response = await HttpServices.get(widget.route);
    var responseJson = jsonDecode(response.body);
    setState(() {
      totalElements = responseJson['totalElements'];
    });
  }

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
        title: Text(widget.screenName, style: TextStyle(color: AppColors.appColorWhite)),
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
                        height: height - 170,
                        padding: const EdgeInsets.symmetric(horizontal: 7),
                        decoration: BoxDecoration(
                          color: AppColors.appColorBlackBg,
                        ),
                        child: FutureBuilder(
                          future: HttpServices.get("${widget.route}?page=$page&size=$size"),
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              var snapshotData = snapshot.data;
                              var responseJson = jsonDecode(snapshotData.body);
                              List<IncomeDto> incomeList = [];
                              if (responseJson != null) {
                                for (var income in responseJson['data']) {
                                  incomeList.add(IncomeDto.fromJson(income));
                                }
                              }
                              return ListView.builder(
                                padding: const EdgeInsets.all(0),
                                itemCount: incomeList.length,
                                itemBuilder: (context, index) {
                                  return WrapperScreenItem(
                                    type: widget.itemType,
                                    income: incomeList[index],
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
                      AppPaginationAndSearchWidget(
                        width: Get.width,
                        length: totalElements,
                        resultLength: size,
                        nextPage: () {
                          if (totalElements > (page + 1) * size) {
                            setState(() {
                              page++;
                            });
                          }
                        },
                        prevPage: () {
                          if (page > 0) {
                            setState(() {
                              page--;
                            });
                          }
                        },
                        limit: size,
                        search: (String value) async {
                          // setState(() {
                          //   searchText = value;
                          // });
                        },
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
