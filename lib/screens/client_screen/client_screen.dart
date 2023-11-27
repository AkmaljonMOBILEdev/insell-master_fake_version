import 'dart:convert';

import 'package:easy_sell/screens/client_screen/widget/client_item.dart';
import 'package:easy_sell/screens/client_screen/widget/client_item_info.dart';
import 'package:easy_sell/services/excel_service.dart';
import 'package:easy_sell/services/https_services.dart';
import 'package:easy_sell/widgets/app_pagination_and_search.dart';
import 'package:easy_sell/screens/client_screen/widget/client_right_containers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';
import '../../constants/colors.dart';
import '../../database/model/client_dto.dart';
import '../../database/my_database.dart';
import '../../widgets/app_button.dart';

class ClientScreen extends StatefulWidget {
  const ClientScreen({Key? key}) : super(key: key);

  @override
  State<ClientScreen> createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  MyDatabase database = Get.find<MyDatabase>();
  bool loading = false;
  int offset = 0;
  int limit = 25;
  bool _isSynced = false;
  String searchText = '';
  int? selectedRegionId;

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
        title: Text('Mijozlar', style: TextStyle(color: AppColors.appColorWhite)),
        centerTitle: false,
        actions: [
          AppButton(
            onTap: () async {
              List<ClientData> all = await database.clientDao.getAllClients();
              List header = ['ID', 'Ism', 'Sana', 'Telefon raqam', 'Manzil'];
              List data = all.map((e) => [e.id, e.name, e.createdAt, e.phoneNumber1, e.address]).toList();
              await ExcelService.createExcelFile([header, ...data], 'Mijozlar', context);
            },
            tooltip: 'Excelga yuklash',
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
          Icon(UniconsLine.database, color: _isSynced == false ? AppColors.appColorRed400 : AppColors.appColorGreen400, size: 21),
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
          constraints: const BoxConstraints.expand(),
          padding: const EdgeInsets.only(right: 10, left: 10, bottom: 10, top: 65),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0xFF26525f), Color(0xFF0f2228)],
            ),
          ),
          child: FutureBuilder(
            future: HttpServices.get("/client/all?page=$offset&size=$limit&search=$searchText"),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                var snapshotData = snapshot.data;
                var responseJson = jsonDecode(snapshotData.body);
                List<ClientDto> clientsList = [];
                int clientsCount = 0;
                if (responseJson != null) {
                  clientsCount = responseJson['totalElements'];
                  for (var client in responseJson['data']) {
                    clientsList.add(ClientDto.fromJson(client));
                  }
                }
                if (selectedRegionId != null) {
                  clientsList = clientsList.where((element) => element.region?.id == selectedRegionId).toList();
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        ClientItemInfo(
                          sortByName: () {},
                          sorted: false,
                        ),
                        Expanded(
                          child: Container(
                            width: screenWidth / 1.38,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(borderRadius: const BorderRadius.only(), color: AppColors.appColorBlackBg),
                            child: loading
                                ? Center(child: CircularProgressIndicator(color: AppColors.appColorGreen400))
                                : clientsList.isEmpty
                                    ? Center(
                                        child: Text(
                                          'Mijozlar ro\'yxati bo\'sh',
                                          style: TextStyle(color: AppColors.appColorWhite),
                                        ),
                                      )
                                    : ListView.builder(
                                        padding: const EdgeInsets.all(0),
                                        itemCount: clientsList.length,
                                        itemBuilder: (BuildContext context, index) {
                                          return ClientItem(
                                            client: clientsList[index],
                                            index: index,
                                            callback: () {},
                                          );
                                        },
                                      ),
                          ),
                        ),
                        AppPaginationAndSearchWidget(
                          length: clientsCount,
                          resultLength: clientsList.length,
                          nextPage: () {
                            if (clientsCount > (offset) * limit) {
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
                          search: (String value) async {
                            setState(() {
                              searchText = value;
                            });
                          },
                        ),
                      ],
                    ),
                    ClientRightContainers(
                      callback: () {
                        setState(() {});
                      },
                      getByRegion: (int regionId) {
                        setState(() {
                          selectedRegionId = regionId;
                        });
                      },
                      allClientsLength: clientsCount,
                    )
                  ],
                );
              } else {
                return Center(child: CircularProgressIndicator(color: AppColors.appColorWhite));
              }
            },
          )),
    );
  }
}
