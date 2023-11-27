import 'package:dio/dio.dart';
import 'package:easy_sell/screens/sync_screen/downlaod_functions.dart';
import 'package:easy_sell/screens/sync_screen/upload_functions.dart';
import 'package:easy_sell/utils/utils.dart';
import 'package:easy_sell/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';
import '../../constants/colors.dart';
import '../../database/my_database.dart';
import '../../widgets/app_button.dart';

class SyncScreen extends StatefulWidget {
  const SyncScreen({Key? key}) : super(key: key);

  @override
  State<SyncScreen> createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {
  MyDatabase database = Get.find<MyDatabase>();
  late DownloadFunctions downloading;
  late UploadFunctions uploading;
  final Map<String, dynamic> downloadProgress = {
    'regions': {
      'total': 0,
      'current': 0,
      'status': '',
      'isFinished': false,
      'isActivate': false,
    },
    'employee': {
      'total': 0,
      'current': 0,
      'status': '',
      'isFinished': false,
      'isActivate': false,
    },
    'category': {
      'total': 0,
      'current': 0,
      'status': '',
      'isFinished': false,
      'isActivate': false,
    },
    'product': {
      'total': 0,
      'current': 0,
      'status': '',
      'isFinished': false,
      'isActivate': false,
    },
    'suppliers': {
      'total': 0,
      'current': 0,
      'status': '',
      'isFinished': false,
      'isActivate': false,
    },
    'price': {
      'total': 0,
      'current': 0,
      'status': '',
      'isFinished': false,
      'isActivate': false,
    },
    'customer': {
      'total': 0,
      'current': 0,
      'status': '',
      'isFinished': false,
      'isActivate': false,
    },
    'barcode': {
      'total': 0,
      'current': 0,
      'status': '',
      'isFinished': false,
      'isActivate': false,
    },
    'shops': {
      'total': 0,
      'current': 0,
      'status': '',
      'isFinished': false,
      'isActivate': false,
    },
    'income': {
      'total': 0,
      'current': 0,
      'status': '',
      'isFinished': false,
      'isActivate': false,
    },
    'outcome': {
      'total': 0,
      'current': 0,
      'status': '',
      'isFinished': false,
      'isActivate': false,
    },
    'exchangeRate': {
      'total': 0,
      'current': 0,
      'status': '',
      'isFinished': false,
      'isActivate': false,
    },
    'expenseType': {
      'total': 0,
      'current': 0,
      'status': '',
      'isFinished': false,
      'isActivate': false,
    },
    'expense': {
      'total': 0,
      'current': 0,
      'status': '',
      'isFinished': false,
      'isActivate': false,
    },
    'posTransfer': {
      'total': 0,
      'current': 0,
      'status': '',
      'isFinished': false,
      'isActivate': false,
    },
    'session': {
      'total': 0,
      'current': 0,
      'status': '',
      'isFinished': false,
      'isActivate': false,
    },
    'productIncome': {
      'total': 0,
      'current': 0,
      'status': '',
      'isFinished': false,
      'isActivate': false,
    },
    'balance': {
      'total': 0,
      'current': 0,
      'status': '',
      'isFinished': false,
      'isActivate': false,
    },
    'supplierDebt': {
      'total': 0,
      'current': 0,
      'status': '',
      'isFinished': false,
      'isActivate': false,
    },
    'clientDebt': {
      'total': 0,
      'current': 0,
      'status': '',
      'isFinished': false,
      'isActivate': false,
    },
    'transfer': {
      'total': 0,
      'current': 0,
      'status': '',
      'isFinished': false,
      'isActivate': false,
    },
    'trade': {
      'total': 0,
      'current': 0,
      'status': '',
      'isFinished': false,
      'isActivate': false,
    },
  };

  final Map<String, dynamic> uploadProgress = {
    'sessions': {
      'total': 0,
      'current': 0,
      'status': '',
    },
    'category': {
      'total': 0,
      'current': 0,
      'status': '',
    },
    'product': {
      'total': 0,
      'current': 0,
      'status': '',
    },
    'customer': {
      'total': 0,
      'current': 0,
      'status': '',
    },
    'supplier': {
      'total': 0,
      'current': 0,
      'status': '',
    },
    'transfer': {
      'total': 0,
      'current': 0,
      'status': '',
    },
    'productIncome': {
      'total': 0,
      'current': 0,
      'status': '',
    },
    'trade': {
      'total': 0,
      'current': 0,
      'status': '',
    },
    'exchangeRate': {
      'total': 0,
      'current': 0,
      'status': '',
    },
    'expenseType': {
      'total': 0,
      'current': 0,
      'status': '',
    },
    'income': {
      'total': 0,
      'current': 0,
      'status': '',
    },
    'outcome': {
      'total': 0,
      'current': 0,
      'status': '',
    },
    'expense': {
      'total': 0,
      'current': 0,
      'status': '',
    },
  };
  List<Map<String, dynamic>> downloadItemsList = [];
  List<Map<String, dynamic>> uploadItemsList = [];

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() {
    downloading = DownloadFunctions(database: database, progress: downloadProgress, setter: setState);
    uploading = UploadFunctions(database: database, progress: uploadProgress, setter: setState);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    downloadItemsList = [
      {
        'field': 'regions',
        'onPressed': () {
          downloading.getRegions('regions');
        },
        'icon': Icon(UniconsLine.map_pin, color: AppColors.appColorWhite),
        'text': 'Regionlar',
        'loading': false,
      },
      {
        'field': 'employee',
        'onPressed': () {
          downloading.getEmployee('employee');
        },
        'icon': Icon(UniconsLine.user_nurse, color: AppColors.appColorWhite),
        'text': 'Xodimlar',
        'loading': false,
      },
      {
        'field': 'category',
        'onPressed': () {
          downloading.getCategories('category');
        },
        'icon': Icon(Icons.category, color: AppColors.appColorWhite),
        'text': 'Kategoriyalar',
        'loading': false,
      },
      {
        'field': 'product',
        'onPressed': () {
          downloading.getProducts('product');
        },
        'icon': Icon(UniconsLine.shopping_bag, color: AppColors.appColorWhite),
        'text': 'Maxsulot',
        'loading': false,
      },
      {
        'field': 'price',
        'onPressed': () {
          downloading.getPrices('price');
        },
        'icon': Icon(UniconsLine.money_bill, color: AppColors.appColorWhite),
        'text': 'Narxlar',
        'loading': false,
      },
      {
        'field': 'customer',
        'onPressed': () {
          downloading.getClients('customer');
        },
        'icon': Icon(UniconsLine.users_alt, color: AppColors.appColorWhite),
        'text': 'Mijozlar',
        'loading': false,
      },
      {
        'field': 'barcode',
        'onPressed': () {
          downloading.getBarcodes('barcode');
        },
        'icon': Icon(UniconsLine.qrcode_scan, color: AppColors.appColorWhite),
        'text': 'Barkodlar',
        'loading': false,
      },
      {
        'field': 'session',
        'onPressed': () {
          downloading.getSessions('session');
        },
        'icon': Icon(Icons.sensors_sharp, color: AppColors.appColorWhite),
        'text': 'Sessiyalar',
        'loading': false,
      },
      {
        'field': 'trade',
        'onPressed': () {
          downloading.getTrades('trade');
        },
        'icon': Icon(Icons.shopping_cart, color: AppColors.appColorWhite),
        'text': 'Savdolar',
        'loading': false,
      },
    ];
    uploadItemsList = [
      {
        'field': 'sessions',
        'onPressed': () {
          uploading.uploadSessions('sessions');
        },
        'icon': Icon(Icons.sensors_sharp, color: AppColors.appColorWhite),
        'text': 'Sessiyalar',
        'loading': false,
      },
      {
        'field': 'category',
        'onPressed': () {
          uploading.uploadCategories('category');
        },
        'icon': Icon(Icons.category, color: AppColors.appColorWhite),
        'text': 'Kategoriyalar',
        'loading': false,
      },
      {
        'field': 'product',
        'onPressed': () {
          uploading.uploadProducts('product');
        },
        'icon': Icon(UniconsLine.shopping_bag, color: AppColors.appColorWhite),
        'text': 'Maxsulot',
        'loading': false,
      },
      {
        'field': 'customer',
        'onPressed': () {
          uploading.uploadCustomers('customer');
        },
        'icon': Icon(UniconsLine.users_alt, color: AppColors.appColorWhite),
        'text': 'Mijozlar',
        'loading': false,
      },
      {
        'field': 'trade',
        'onPressed': () {
          try {
            uploading.uploadTrades('trade');
          } catch (e) {
            rethrow;
          }
        },
        'icon': Icon(UniconsLine.shopping_cart, color: AppColors.appColorWhite),
        'text': 'Savdo',
        'loading': false,
      },
    ];
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: AppBarWidget(
          onTapBack: () {
            Navigator.pop(context, true);
          },
          centerTitle: false,
          backgroundColor: Colors.black12,
          title: Text('Sinxronlash', style: TextStyle(color: AppColors.appColorWhite)),
          actions: [
            Icon(UniconsLine.database, color: AppColors.appColorRed400, size: 21),
            AppButton(
              onTap: () => setState(() {}),
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
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: AppColors.appColorBlackBg),
          child: Row(children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.grey.shade900),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: AppButton(
                        tooltip: 'Yuklash',
                        onTap: () async {
                          try {
                            bool isDownloading = false;
                            downloadProgress.forEach((key, value) {
                              if (value['isActivate'] == true) {
                                isDownloading = true;
                              }
                            });
                            if (isDownloading) {
                              showAppSnackBar(context, 'Fayl yuklanmoqda... Kutib turing', 'Ok', isError: true);
                              return;
                            }

                            CancelToken cancelToken = CancelToken();
                            await downloading.getAll(cancelToken: cancelToken);
                          } catch (e) {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            showAppSnackBar(context, e.toString(), 'Ok', isError: true);
                          }
                        },
                        width: 200,
                        height: 40,
                        color: AppColors.appColorGreen300.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(15),
                        hoverRadius: BorderRadius.circular(15),
                        hoverColor: AppColors.appColorGreen400,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Serverdan yuklash', style: TextStyle(color: AppColors.appColorWhite, fontSize: 18)),
                            const VerticalDivider(),
                            PopupMenuButton(
                              itemBuilder: (BuildContext context) {
                                return [
                                  PopupMenuItem(
                                    value: 'all',
                                    child: Text('Barchasini yuklash', style: TextStyle(color: AppColors.appColorWhite)),
                                  ),
                                ];
                              },
                              onSelected: (value) async {
                                try {
                                  bool isDownloading = false;
                                  downloadProgress.forEach((key, value) {
                                    if (value['isActivate'] == true) {
                                      isDownloading = true;
                                    }
                                  });
                                  if (isDownloading) {
                                    showAppSnackBar(context, 'Fayl yuklanmoqda... Kutib turing', 'Ok', isError: true);
                                    return;
                                  }

                                  CancelToken cancelToken = CancelToken();
                                  await downloading.getAll(cancelToken: cancelToken, fromStart: true);
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                    showAppSnackBar(context, e.toString(), 'Ok', isError: true);
                                  }
                                }
                              },
                              offset: const Offset(0, 50),
                              color: AppColors.appColorBlackBgHover.withOpacity(0.8),
                              child: Icon(Icons.file_download_outlined, color: AppColors.appColorWhite, size: 25),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(0),
                        itemCount: downloadItemsList.length,
                        itemBuilder: (BuildContext context, index) {
                          return Container(
                            height: 60,
                            margin: const EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(color: AppColors.appColorGrey700, borderRadius: BorderRadius.circular(15)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  padding: const EdgeInsets.all(10),
                                  decoration:
                                      BoxDecoration(color: AppColors.appColorGreen300, borderRadius: BorderRadius.circular(30)),
                                  child: IconButton(
                                    icon: downloadItemsList[index]['icon'],
                                    onPressed: downloadProgress[downloadItemsList[index]['field']]['isActivate'] == true
                                        ? null
                                        : downloadItemsList[index]['onPressed'],
                                    style: ButtonStyle(
                                      splashFactory: NoSplash.splashFactory,
                                      padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
                                      backgroundColor: MaterialStateProperty.all(Colors.transparent),
                                      shape: MaterialStateProperty.all(const CircleBorder()),
                                    ),
                                    constraints: const BoxConstraints(),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${downloadItemsList[index]['text']}',
                                        style: TextStyle(color: AppColors.appColorWhite, fontSize: 18)),
                                    SizedBox(
                                      width: screenWidth / 2.7,
                                      child: LinearProgressIndicator(
                                        color: AppColors.appColorGreen300,
                                        value: downloadProgress[downloadItemsList[index]['field']]['total'] == null
                                            ? null
                                            : percentCalculator(downloadProgress[downloadItemsList[index]['field']]),
                                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.appColorGreen300),
                                        minHeight: 5,
                                        backgroundColor: AppColors.appColorBlackBg.withOpacity(0.6),
                                        semanticsValue: 'Loading',
                                        semanticsLabel: 'Loading',
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(downloadProgress[downloadItemsList[index]['field']]['status'],
                                            style: TextStyle(color: AppColors.appColorWhite, fontSize: 12)),
                                        if (percentCalculator(downloadProgress[downloadItemsList[index]['field']]) != 0)
                                          Text(
                                            " (${(percentCalculator(downloadProgress[downloadItemsList[index]['field']]) * 100).toStringAsFixed(0)}%)",
                                            style: TextStyle(color: AppColors.appColorWhite, fontSize: 12),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.grey.shade900),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: AppButton(
                        tooltip: 'Yuklash',
                        onTap: () async {
                          try {
                            bool isUploading = false;
                            uploadProgress.forEach((key, value) {
                              if (value['isActivate'] == true) {
                                isUploading = true;
                              }
                            });
                            if (isUploading) {
                              showAppSnackBar(context, 'Fayl yuklanmoqda... Kutib turing', 'Ok', isError: false);
                              return;
                            }
                            CancelToken cancelToken = CancelToken();
                            uploading.getAll(cancelToken: cancelToken);
                          } catch (e) {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            showAppSnackBar(context, e.toString(), 'Ok', isError: true);
                          }
                        },
                        width: 190,
                        height: 40,
                        color: AppColors.appColorGreen300.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(15),
                        hoverRadius: BorderRadius.circular(15),
                        hoverColor: AppColors.appColorGreen400,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Serverga yuklash', style: TextStyle(color: AppColors.appColorWhite, fontSize: 18)),
                            Icon(Icons.file_upload_outlined, color: AppColors.appColorWhite, size: 25),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(0),
                        itemCount: uploadItemsList.length,
                        itemBuilder: (BuildContext context, index) {
                          return Container(
                            height: 60,
                            margin: const EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(color: AppColors.appColorGrey700, borderRadius: BorderRadius.circular(15)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    padding: const EdgeInsets.all(10),
                                    decoration:
                                        BoxDecoration(color: AppColors.appColorGreen300, borderRadius: BorderRadius.circular(30)),
                                    child: IconButton(
                                      icon: uploadItemsList[index]['icon'],
                                      onPressed: uploadProgress[uploadItemsList[index]['field']]['isActivate'] == true
                                          ? null
                                          : uploadItemsList[index]['onPressed'],
                                      constraints: const BoxConstraints(),
                                      style: ButtonStyle(
                                        splashFactory: NoSplash.splashFactory,
                                        padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
                                        backgroundColor: MaterialStateProperty.all(Colors.transparent),
                                        shape: MaterialStateProperty.all(const CircleBorder()),
                                      ),
                                    )),
                                const SizedBox(width: 15),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${uploadItemsList[index]['text']}',
                                        style: TextStyle(color: AppColors.appColorWhite, fontSize: 18)),
                                    SizedBox(
                                      width: screenWidth / 2.7,
                                      child: LinearProgressIndicator(
                                        color: AppColors.appColorGreen300,
                                        value: uploadProgress[uploadItemsList[index]['field']]['total'] == null
                                            ? null
                                            : percentCalculator(uploadProgress[uploadItemsList[index]['field']]),
                                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.appColorGreen300),
                                        minHeight: 5,
                                        backgroundColor: AppColors.appColorBlackBg.withOpacity(0.6),
                                        semanticsValue: 'Loading',
                                        semanticsLabel: 'Loading',
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(uploadProgress[uploadItemsList[index]['field']]['status'],
                                            style: TextStyle(color: AppColors.appColorWhite, fontSize: 11)),
                                        if (percentCalculator(uploadProgress[uploadItemsList[index]['field']]) != 0)
                                          Text(
                                            "(${(percentCalculator(uploadProgress[uploadItemsList[index]['field']]) * 100).toStringAsFixed(0)}%)",
                                            style: TextStyle(color: AppColors.appColorWhite, fontSize: 11),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  double percentCalculator(Map progressData) {
    if (progressData['total'] != 0) {
      if (progressData['total'] == null) return 0;
      return progressData['current'] / progressData['total'];
    }
    return 0;
  }

  @override
  void dispose() {
    super.dispose();
    uploadProgress.clear();
    downloadProgress.clear();
  }
}
