import 'dart:convert';

import 'package:easy_sell/database/model/season_dto.dart';
import 'package:easy_sell/screens/season_screen/widget/season_item.dart';
import 'package:easy_sell/screens/season_screen/widget/season_item_info.dart';
import 'package:easy_sell/screens/season_screen/widget/season_right_containers.dart';
import 'package:easy_sell/services/https_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/colors.dart';
import '../../database/my_database.dart';
import '../../widgets/app_button.dart';

class SeasonScreen extends StatefulWidget {
  const SeasonScreen({Key? key}) : super(key: key);

  @override
  State<SeasonScreen> createState() => _SeasonScreenState();
}

class _SeasonScreenState extends State<SeasonScreen> {
  MyDatabase database = Get.find<MyDatabase>();
  bool loading = false;
  int offset = 0;
  int limit = 50;
  bool _sortByName = false;
  List<Season> list = [];

  @override
  void initState() {
    super.initState();
    getSeasons();
  }

  void getSeasons() async {
    setState(() {
      loading = true;
    });
    var response = await HttpServices.get("/season/all");
    var responseJson = jsonDecode(response.body);
    List<Season> seasons = [];
    for (var item in responseJson['data']) {
      seasons.add(Season.fromJson(item));
    }
    setState(() {
      list = seasons;
      loading = false;
    });
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
        title: Text("Mavsumlar", style: TextStyle(color: AppColors.appColorWhite)),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SeasonItemInfo(
                  sortByName: () {}, // sortByName,
                  sorted: _sortByName,
                ),
                Expanded(
                  child: Container(
                    width: screenWidth / 1.38,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(borderRadius: const BorderRadius.only(), color: AppColors.appColorBlackBg),
                    child: loading
                        ? Center(child: CircularProgressIndicator(color: AppColors.appColorGreen400))
                        : list.isEmpty
                            ? Center(
                                child: Text('Mavsumlar ro\'yxati bo\'sh', style: TextStyle(color: AppColors.appColorWhite)),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.all(0),
                                itemCount: list.length,
                                itemBuilder: (BuildContext context, index) {
                                  return SeasonItem(
                                    item: list[index],
                                    index: index,
                                  );
                                },
                              ),
                  ),
                ),
              ],
            ),
            SeasonRightContainers(
              allSeasons: list.length,
              callback: () {
                getSeasons();
              },
            )
          ],
        ),
      ),
    );
  }
}
