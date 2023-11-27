import 'dart:async';
import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dio/dio.dart';
import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:easy_sell/constants/colors.dart';
import 'package:easy_sell/database/model/exchange_rate_dto.dart';
import 'package:easy_sell/generated/assets.dart';
import 'package:easy_sell/screens/home_screen/report/report_dialog.dart';
import 'package:easy_sell/screens/home_screen/widget/add_sessions_dialog.dart';
import 'package:easy_sell/screens/sync_screen/downlaod_functions.dart';
import 'package:easy_sell/screens/sync_screen/upload_functions.dart';
import 'package:easy_sell/services/https_services.dart';
import 'package:easy_sell/services/storage_services.dart';
import 'package:easy_sell/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';
import '../../constants/user_role.dart';
import '../../database/my_database.dart';
import '../../utils/routes.dart';
import '../../widgets/app_barcode.dart';
import '../../widgets/app_button.dart';
import '../warehouse_stock_screen/warehouse_stock_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  EmployeeData? _employee;
  MyDatabase database = Get.find<MyDatabase>();
  bool sessionStarted = false;
  Storage storage = Storage();
  Map user = {
    "organization": {"type": null},
    "roles": [],
  };

  DateTime lastSync = DateTime.now();

  DateTime? sessionStartedTime;
  UserRole currentRole = UserRole.USER;
  double exchangeRate = 0;
  late UploadFunctions uploadFunctions;
  late DownloadFunctions downloadFunctions;
  bool loading = false;
  List<ExchangeRateDataStruct> exchangeRateList = [];
  double currentRateValue = 0;

  @override
  void initState() {
    super.initState();
    downloadFunctions = DownloadFunctions(database: database, progress: {}, setter: setter);
    uploadFunctions = UploadFunctions(database: database, progress: {}, setter: setter);
    getExchangeRateList();
    getAllIfLogin();
    _getData();
    getLastSync();
    checkerLastSyncTime();
  }

  void getExchangeRateList() async {
    try {
      var res = await HttpServices.get("/exchange-rate/all");
      var json = jsonDecode(res.body)["data"];
      List<ExchangeRateDataStruct> list = [];
      for (var item in json) {
        list.add(ExchangeRateDataStruct.fromJson(item));
      }
      setState(() {
        exchangeRateList = list;
      });
    } catch (e) {
      print(e);
    }
  }

  void reload() {
    setState(() {});
  }

  void getAllIfLogin() async {
    try {
      setState(() {
        loading = true;
      });
      String prevRoute = Get.previousRoute;
      if (prevRoute == Routes.LOGIN) {
        await downloadFunctions.getAll(cancelToken: CancelToken(), fromStart: true);
        getSessionStartedTime();
      }
      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }

  void getLastSync() async {
    try {
      String lastSyncString = await storage.read('lastSync') ?? '';
      setState(() {
        lastSync = DateTime.parse(lastSyncString.isNotEmpty ? lastSyncString : DateTime.now().toString());
      });
    } catch (e) {
      print(e);
    }
  }

  void setter(Function fn) {}

  void _getData() async {
    var _user = await storage.read('user');
    if (_user != null) {
      setState(() {
        user = jsonDecode(_user);
      });
    }

    getSessionStartedTime();
  }

  Future<void> getSessionStartedTime() async {
    PosSessionData? data = await database.posSessionDao.getLastSession();
    EmployeeData? employee = await database.employeeDao.getById(data?.cashier ?? 0);
    setState(() {
      sessionStartedTime = data?.startTime;
      sessionStarted = (data == null) || (data.endTime != null) ? false : true;
      _employee = employee;
    });
  }

  void checkerLastSyncTime() {
    getLastSync();
    Timer(const Duration(minutes: 1), () {
      checkerLastSyncTime();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    List<Map<String, dynamic>> getMainButton = [
      {
        'role': [UserRole.CASHIER],
        'onTap': sessionStarted
            ? () => Get.toNamed(Routes.KASSA)
            : () => showAppSnackBar(context, 'Xatolik: Siz hali smenani ochmagansiz', 'OK', isError: true),
        'width': 285.0,
        'height': 85.0,
        'margin': const EdgeInsets.all(5),
        'borderRadius': BorderRadius.circular(30),
        'hoverRadius': BorderRadius.circular(30),
        'color': AppColors.appColorBlackBg,
        'hoverColor': AppColors.appColorBlackBgHover,
        'colorOnClick': AppColors.appColorBlackBg,
        'child': Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Image.asset(Assets.imagesPos, width: 60, height: 60),
              const SizedBox(width: 10),
              Text('Kassa',
                  style: TextStyle(color: AppColors.appColorWhite, fontWeight: FontWeight.w500, fontSize: 30, letterSpacing: 2)),
            ],
          ),
        ),
      },
      {
        'role': [UserRole.ADMIN, UserRole.CASHIER],
        'onTap': () => Get.toNamed(Routes.CLIENT),
        'width': 285.0,
        'height': 85.0,
        'margin': const EdgeInsets.all(5),
        'borderRadius': BorderRadius.circular(30),
        'hoverRadius': BorderRadius.circular(30),
        'color': AppColors.appColorBlackBg,
        'hoverColor': AppColors.appColorBlackBgHover,
        'colorOnClick': AppColors.appColorBlackBg,
        'child': Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Image.asset(Assets.imagesCustomers, width: 60, height: 70),
              const SizedBox(width: 10),
              Text('Mijozlar',
                  style: TextStyle(color: AppColors.appColorWhite, fontWeight: FontWeight.w500, fontSize: 30, letterSpacing: 2)),
            ],
          ),
        ),
      },
      {
        'role': [UserRole.ADMIN, UserRole.DIRECTOR, UserRole.STOREKEEPER, UserRole.MANAGER, UserRole.FINANCE],
        'onTap': () => Get.toNamed(Routes.SUPPLIER),
        'width': 285.0,
        'height': 85.0,
        'margin': const EdgeInsets.all(5),
        'borderRadius': BorderRadius.circular(30),
        'hoverRadius': BorderRadius.circular(30),
        'color': AppColors.appColorBlackBg,
        'hoverColor': AppColors.appColorBlackBgHover,
        'colorOnClick': AppColors.appColorBlackBg,
        'child': Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Image.asset(Assets.imagesSupplier, width: 60, height: 70),
              const SizedBox(width: 10),
              Text("Ta'minot",
                  style: TextStyle(color: AppColors.appColorWhite, fontWeight: FontWeight.w500, fontSize: 30, letterSpacing: 2)),
            ],
          ),
        ),
      },
      {
        'role': [UserRole.ADMIN, UserRole.DIRECTOR, UserRole.STOREKEEPER, UserRole.MANAGER, UserRole.ANALYST, UserRole.FINANCE],
        'onTap': () => Get.toNamed(Routes.WAREHOUSE),
        'width': 285.0,
        'height': 85.0,
        'margin': const EdgeInsets.all(5),
        'borderRadius': BorderRadius.circular(30),
        'hoverRadius': BorderRadius.circular(30),
        'color': AppColors.appColorBlackBg,
        'hoverColor': AppColors.appColorBlackBgHover,
        'colorOnClick': AppColors.appColorBlackBg,
        'child': Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Image.asset(Assets.imagesStockBuy, width: 60, height: 55),
              const SizedBox(width: 10),
              Text('Sotib Olish',
                  style: TextStyle(color: AppColors.appColorWhite, fontWeight: FontWeight.w500, fontSize: 30, letterSpacing: 2)),
            ],
          ),
        ),
      },
      {
        'role': [UserRole.ADMIN, UserRole.DIRECTOR, UserRole.STOREKEEPER, UserRole.MANAGER, UserRole.ANALYST, UserRole.FINANCE],
        'onTap': () => Get.to(() => const WarehouseStockScreen()),
        'width': 285.0,
        'height': 85.0,
        'margin': const EdgeInsets.all(5),
        'borderRadius': BorderRadius.circular(30),
        'hoverRadius': BorderRadius.circular(30),
        'color': AppColors.appColorBlackBg,
        'hoverColor': AppColors.appColorBlackBgHover,
        'colorOnClick': AppColors.appColorBlackBg,
        'child': Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Image.asset(Assets.imagesStock, width: 60, height: 55),
              const SizedBox(width: 10),
              Text('Qoldiq',
                  style: TextStyle(color: AppColors.appColorWhite, fontWeight: FontWeight.w500, fontSize: 30, letterSpacing: 2)),
            ],
          ),
        ),
      },
      user['organization']['type'] == 'RETAIL'
          ? {}
          : {
              'role': [UserRole.ADMIN, UserRole.DIRECTOR, UserRole.STOREKEEPER, UserRole.ANALYST, UserRole.FINANCE],
              'onTap': () => Get.toNamed(Routes.MOVE_PRODUCT),
              'width': 285.0,
              'height': 85.0,
              'margin': const EdgeInsets.all(5),
              'borderRadius': BorderRadius.circular(30),
              'hoverRadius': BorderRadius.circular(30),
              'color': AppColors.appColorBlackBg,
              'hoverColor': AppColors.appColorBlackBgHover,
              'colorOnClick': AppColors.appColorBlackBg,
              'child': Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Image.asset(Assets.imagesMove, width: 57, height: 60),
                    const SizedBox(width: 10),
                    Text('Yuk Harakati',
                        style: TextStyle(
                            color: AppColors.appColorWhite, fontWeight: FontWeight.w500, fontSize: 30, letterSpacing: 2)),
                  ],
                ),
              ),
            },
      {
        'role': [UserRole.ADMIN, UserRole.DIRECTOR, UserRole.MANAGER, UserRole.SUPERVISOR, UserRole.FINANCE],
        'onTap': () => Get.toNamed(Routes.FINANCE),
        'width': 285.0,
        'height': 85.0,
        'margin': const EdgeInsets.all(5),
        'borderRadius': BorderRadius.circular(30),
        'hoverRadius': BorderRadius.circular(30),
        'color': AppColors.appColorBlackBg,
        'hoverColor': AppColors.appColorBlackBgHover,
        'colorOnClick': AppColors.appColorBlackBg,
        'child': Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Image.asset(Assets.imagesCoins, width: 60, height: 55),
              const SizedBox(width: 10),
              Text('Moliya',
                  style: TextStyle(color: AppColors.appColorWhite, fontWeight: FontWeight.w500, fontSize: 29, letterSpacing: 2)),
            ],
          ),
        ),
      },
      {
        'role': [UserRole.ADMIN, UserRole.DIRECTOR, UserRole.CASHIER, UserRole.MANAGER, UserRole.SUPERVISOR, UserRole.FINANCE],
        'onTap': () => Get.toNamed(Routes.MONEY_SEND),
        'width': 285.0,
        'height': 85.0,
        'margin': const EdgeInsets.all(5),
        'borderRadius': BorderRadius.circular(30),
        'hoverRadius': BorderRadius.circular(30),
        'color': AppColors.appColorBlackBg,
        'hoverColor': AppColors.appColorBlackBgHover,
        'colorOnClick': AppColors.appColorBlackBg,
        'child': Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Image.asset(Assets.imagesMoneyTransfer, width: 60, height: 55),
              const SizedBox(width: 10),
              Text('Pul o\'tkazish',
                  style: TextStyle(color: AppColors.appColorWhite, fontWeight: FontWeight.w500, fontSize: 30, letterSpacing: 2)),
            ],
          ),
        ),
      },
      {
        'role': [UserRole.ADMIN, UserRole.DIRECTOR, UserRole.STOREKEEPER, UserRole.FINANCE],
        'onTap': () => Get.toNamed(Routes.CATEGORY),
        'width': 285.0,
        'height': 85.0,
        'margin': const EdgeInsets.all(5),
        'borderRadius': BorderRadius.circular(30),
        'hoverRadius': BorderRadius.circular(30),
        'color': AppColors.appColorBlackBg,
        'hoverColor': AppColors.appColorBlackBgHover,
        'colorOnClick': AppColors.appColorBlackBg,
        'child': Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Image.asset(Assets.imagesCategory, width: 60, height: 55),
              const SizedBox(width: 10),
              Text('Kategoriya',
                  style: TextStyle(color: AppColors.appColorWhite, fontWeight: FontWeight.w500, fontSize: 30, letterSpacing: 2)),
            ],
          ),
        ),
      },
      {
        'role': [UserRole.ADMIN, UserRole.MANAGER, UserRole.ANALYST, UserRole.FINANCE],
        'onTap': () => Get.toNamed(Routes.PRICES),
        'width': 285.0,
        'height': 85.0,
        'margin': const EdgeInsets.all(5),
        'borderRadius': BorderRadius.circular(30),
        'hoverRadius': BorderRadius.circular(30),
        'color': AppColors.appColorBlackBg,
        'hoverColor': AppColors.appColorBlackBgHover,
        'colorOnClick': AppColors.appColorBlackBg,
        'child': Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Image.asset(Assets.imagesPrices, width: 60, height: 70),
              const SizedBox(width: 10),
              Text('Narxlar',
                  style: TextStyle(color: AppColors.appColorWhite, fontWeight: FontWeight.w500, fontSize: 30, letterSpacing: 2)),
            ],
          ),
        ),
      },
      {
        'role': [UserRole.ADMIN, UserRole.MANAGER, UserRole.FINANCE],
        'onTap': () => Get.toNamed(Routes.PARTNER),
        'width': 285.0,
        'height': 85.0,
        'margin': const EdgeInsets.all(5),
        'borderRadius': BorderRadius.circular(30),
        'hoverRadius': BorderRadius.circular(30),
        'color': AppColors.appColorBlackBg,
        'hoverColor': AppColors.appColorBlackBgHover,
        'colorOnClick': AppColors.appColorBlackBg,
        'child': Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Image.asset(Assets.imagesPartner, width: 60, height: 70),
              const SizedBox(width: 10),
              Text('Xamkorlar',
                  style: TextStyle(color: AppColors.appColorWhite, fontWeight: FontWeight.w500, fontSize: 30, letterSpacing: 2)),
            ],
          ),
        ),
      },
      // {
      //   'role': [UserRole.ADMIN, UserRole.MANAGER],
      //   'onTap': () => Get.toNamed(Routes.CURRENCY),
      //   'width': 285.0,
      //   'height': 85.0,
      //   'margin': const EdgeInsets.all(5),
      //   'borderRadius': BorderRadius.circular(30),
      //   'hoverRadius': BorderRadius.circular(30),
      //   'color': AppColors.appColorBlackBg,
      //   'hoverColor': AppColors.appColorBlackBgHover,
      //   'colorOnClick': AppColors.appColorBlackBg,
      //   'child': Padding(
      //     padding: const EdgeInsets.symmetric(horizontal: 15),
      //     child: Row(
      //       children: [
      //         Image.asset(Assets.imagesCurrency, width: 60, height: 70),
      //         const SizedBox(width: 10),
      //         Text('Valyuta',
      //             style: TextStyle(color: AppColors.appColorWhite, fontWeight: FontWeight.w500, fontSize: 30, letterSpacing: 2)),
      //       ],
      //     ),
      //   ),
      // },
      {
        'role': [UserRole.ADMIN],
        'onTap': () => Get.toNamed(Routes.ADMIN_PANEL),
        'width': 285.0,
        'height': 85.0,
        'margin': const EdgeInsets.all(5),
        'borderRadius': BorderRadius.circular(30),
        'hoverRadius': BorderRadius.circular(30),
        'color': AppColors.appColorBlackBg,
        'hoverColor': AppColors.appColorBlackBgHover,
        'colorOnClick': AppColors.appColorBlackBg,
        'child': Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Image.asset(Assets.imagesAdminPanel, width: 60, height: 70),
              const SizedBox(width: 10),
              Text('Admin Panel',
                  style: TextStyle(color: AppColors.appColorWhite, fontWeight: FontWeight.w500, fontSize: 30, letterSpacing: 2)),
            ],
          ),
        ),
      },
      {
        'role': [
          UserRole.ADMIN,
          UserRole.DIRECTOR,
          UserRole.CASHIER,
          UserRole.STOREKEEPER,
          UserRole.MANAGER,
          UserRole.SUPERVISOR,
          UserRole.ANALYST,
          UserRole.FINANCE
        ],
        'onTap': () async {
          var result = await Get.toNamed(Routes.SYNC);
          if (result == true) {
            getSessionStartedTime();
          }
          return result;
        },
        'width': 285.0,
        'height': 85.0,
        'margin': const EdgeInsets.all(5),
        'borderRadius': BorderRadius.circular(30),
        'hoverRadius': BorderRadius.circular(30),
        'color': AppColors.appColorBlackBg,
        'hoverColor': AppColors.appColorBlackBgHover,
        'colorOnClick': AppColors.appColorBlackBg,
        'child': Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Image.asset(Assets.imagesSync, width: 60, height: 70),
              const SizedBox(width: 10),
              Text('Sinxronlash',
                  style: TextStyle(color: AppColors.appColorWhite, fontWeight: FontWeight.w500, fontSize: 30, letterSpacing: 2)),
            ],
          ),
        ),
      },
      {
        'role': [UserRole.ADMIN, UserRole.DIRECTOR, UserRole.MANAGER, UserRole.SUPERVISOR, UserRole.ANALYST, UserRole.FINANCE],
        'onTap': () => Get.toNamed(Routes.REPORT),
        'width': 285.0,
        'height': 85.0,
        'margin': const EdgeInsets.all(5),
        'borderRadius': BorderRadius.circular(30),
        'hoverRadius': BorderRadius.circular(30),
        'color': AppColors.appColorBlackBg,
        'hoverColor': AppColors.appColorBlackBgHover,
        'colorOnClick': AppColors.appColorBlackBg,
        'child': Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Image.asset(Assets.imagesAnalytic, width: 60, height: 70),
              const SizedBox(width: 10),
              Text('Xisobot',
                  style: TextStyle(color: AppColors.appColorWhite, fontWeight: FontWeight.w500, fontSize: 30, letterSpacing: 2)),
            ],
          ),
        ),
      },
      {
        'role': [
          UserRole.ADMIN,
          UserRole.DIRECTOR,
          UserRole.CASHIER,
          UserRole.STOREKEEPER,
          UserRole.MANAGER,
          UserRole.SUPERVISOR,
        ],
        'onTap': () async {
          var result = await Get.toNamed(Routes.SETTINGS);
          if (result == true) {
            getSessionStartedTime();
          }
          return result;
        },
        'width': 285.0,
        'height': 85.0,
        'margin': const EdgeInsets.all(5),
        'borderRadius': BorderRadius.circular(30),
        'hoverRadius': BorderRadius.circular(30),
        'color': AppColors.appColorBlackBg,
        'hoverColor': AppColors.appColorBlackBgHover,
        'colorOnClick': AppColors.appColorBlackBg,
        'child': Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Image.asset(Assets.imagesSettings, width: 60, height: 70),
              const SizedBox(width: 10),
              Text('Sozlamalar',
                  style: TextStyle(color: AppColors.appColorWhite, fontWeight: FontWeight.w500, fontSize: 30, letterSpacing: 2)),
            ],
          ),
        ),
      },
    ];

    List<Map<String, dynamic>> filteredButtons = getMainButton.where((button) {
      List<UserRole> roles = button['role'] as List<UserRole>;
      dynamic userRoles = user['roles'];
      if (userRoles == null) {
        return false;
      }
      return roles.any((role) => userRoles.contains(role.name));
    }).toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black12,
        automaticallyImplyLeading: false,
        actions: [
          if (loading)
            const Row(children: [
              Text("Malumotlar yuklanmoqda", style: TextStyle(color: Colors.white)),
              SizedBox(width: 10),
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            ]),
          IconButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => DriftDbViewer(database))),
            icon: Icon(UniconsLine.database, color: AppColors.appColorWhite),
          ),
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => const PrintBarcode(
                  barcode: "",
                  vendorCode: "",
                ),
              );
              // String code = generateEan13Code('200000000001');
              // print(code);
              // buildBarcodePdf();
            },
            icon: Icon(UniconsLine.print, color: AppColors.appColorWhite),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 70, bottom: 5),
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.imagesLoginBg),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black12, BlendMode.dstOver),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      width: 585,
                      height: 160,
                      margin: const EdgeInsets.only(bottom: 5, right: 5),
                      padding: const EdgeInsets.only(right: 5, left: 15, top: 5, bottom: 5),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: AppColors.appColorBlackBg),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(Assets.imagesProfile),
                              const SizedBox(width: 10),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Tooltip(
                                        message: '${user['name'] ?? '-'}',
                                        child: SizedBox(
                                          width: 300,
                                          child: Text(
                                            '${user['name'] ?? '-'}',
                                            style: TextStyle(
                                              color: AppColors.appColorWhite,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20,
                                              letterSpacing: 3,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  SizedBox(
                                    width: 200,
                                    height: 40,
                                    child: DefaultTextStyle(
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        fontFamily: 'Horizon',
                                        color: Colors.white,
                                        backgroundColor: Colors.black,
                                      ),
                                      child: (exchangeRateList.isEmpty)
                                          ? const Text('')
                                          : AnimatedTextKit(
                                              repeatForever: true,
                                              stopPauseOnTap: true,
                                              animatedTexts: [
                                                RotateAnimatedText(
                                                  '1 ${exchangeRateList.first.fromCurrency.abbreviation} = ${formatNumber(exchangeRateList.first.rate)} ${exchangeRateList.first.currency.abbreviation}',
                                                  textStyle: const TextStyle(color: Colors.white),
                                                  transitionHeight: 40,
                                                  alignment: Alignment.topLeft,
                                                )
                                              ],
                                              // animatedTexts: exchangeRateList
                                              //     .map((e) => RotateAnimatedText(
                                              //           '1 ${e.fromCurrency.abbreviation} = ${formatNumber(e.rate)} ${e.currency.abbreviation}',
                                              //           textStyle: const TextStyle(color: Colors.white),
                                              //           transitionHeight: 40,
                                              //           alignment: Alignment.topLeft,
                                              //         ))
                                              //     .toList(),
                                              onTap: () {
                                                print(exchangeRateList.last);
                                                print("Tap Event");
                                              },
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Row(
                              children: [
                                AppButton(
                                  tooltip: '${DateTime.now().difference(lastSync).inMinutes} daqiqa',
                                  onTap: () async {
                                    try {
                                      await uploadFunctions.getAll(cancelToken: CancelToken());
                                      await downloadFunctions.getAll(cancelToken: CancelToken());
                                      await storage.write('lastSync', DateTime.now().toString());
                                      getLastSync();
                                      if (context.mounted) {
                                        showAppSnackBar(context, 'Sinxronizatsiya muvaffaqiyatli amalga oshirildi', 'OK');
                                      }
                                    } catch (e) {
                                      showAppSnackBar(context, 'Xatolik: ${e.toString()}', 'OK', isError: true);
                                    }
                                  },
                                  width: 100,
                                  height: 50,
                                  hoverRadius: BorderRadius.circular(15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          formatLastSync(lastSync),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style:
                                              const TextStyle(color: Colors.white70, fontWeight: FontWeight.w500, fontSize: 15),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Icon(UniconsLine.sync, color: AppColors.appColorWhite, size: 21),
                                    ],
                                  ),
                                ),
                                AppButton(
                                  tooltip: 'Chiqish',
                                  onTap: () {
                                    showAppAlertDialog(
                                      context,
                                      title: 'Diqqat!',
                                      message: 'Siz tizimdan chiqmoqchimisiz?',
                                      onConfirm: logOut,
                                      cancelLabel: 'Yo\'q',
                                      buttonLabel: 'Tasdiqlash',
                                      messageWidget: const Text(
                                        "\n⛔ Synxronizatsiya qilinmagan barcha malumotlar \n o\'chib ketadi va qayta tiklab bo\'lmaydi\n",
                                        style: TextStyle(color: Colors.redAccent, fontSize: 16),
                                      ),
                                      colorButton: Colors.red,
                                    );
                                  },
                                  width: 50,
                                  height: 50,
                                  hoverRadius: BorderRadius.circular(15),
                                  child: Icon(UniconsLine.exit, color: AppColors.appColorWhite, size: 25),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 285,
                      height: 160,
                      margin: const EdgeInsets.only(bottom: 5, left: 5),
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: AppColors.appColorBlackBg),
                      child: (user['roles'].any((role) => [UserRole.CASHIER.name].contains(role)))
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  children: [
                                    Icon(UniconsLine.user_nurse, color: AppColors.appColorWhite, size: 25),
                                    Text(
                                      sessionStarted == true
                                          ? 'Xodim:  ${_employee?.firstName} ${_employee?.lastName}'
                                          : 'Xodim: Tanlanmagan',
                                      style: TextStyle(color: AppColors.appColorWhite, fontSize: 16),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(UniconsLine.clock, color: AppColors.appColorWhite, size: 25),
                                    Text(
                                      sessionStarted == true
                                          ? 'Start vaqti: ${formatDateTime(sessionStartedTime)}'
                                          : 'Start vaqti: -',
                                      style: TextStyle(color: AppColors.appColorWhite, fontSize: 16),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    AppButton(
                                      tooltip: 'Smenani ${sessionStarted == true ? 'yopish' : 'boshlash'}',
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AddSessionDialog(
                                              sessionStarted: sessionStarted,
                                              employee: _employee,
                                              setSession: (value) {
                                                setState(() {
                                                  sessionStarted = value['sessionStarted'];
                                                  _employee = value['employee'];
                                                  sessionStartedTime = value['sessionStartedTime'];
                                                });
                                              },
                                            );
                                          },
                                        );
                                      },
                                      width: 200,
                                      height: 40,
                                      color: !sessionStarted
                                          ? AppColors.appColorGreen300.withOpacity(0.8)
                                          : AppColors.appColorRed300.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(15),
                                      hoverRadius: BorderRadius.circular(15),
                                      hoverColor: sessionStarted ? AppColors.appColorRed400 : AppColors.appColorGreen400,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Smenani ${sessionStarted == true ? 'yopish' : 'boshlash'}',
                                            style: TextStyle(color: AppColors.appColorWhite, fontSize: 16),
                                          ),
                                          Icon(
                                            sessionStarted
                                                ? Icons.remove_shopping_cart_outlined
                                                : Icons.add_shopping_cart_rounded,
                                            color: AppColors.appColorWhite,
                                            size: 25,
                                          ),
                                        ],
                                      ),
                                    ),
                                    AppButton(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => const AlertDialog(
                                            elevation: 0,
                                            contentPadding: EdgeInsets.zero,
                                            backgroundColor: Colors.transparent,
                                            surfaceTintColor: Colors.transparent,
                                            insetPadding: EdgeInsets.zero,
                                            content: ReportWidget(),
                                          ),
                                        );
                                      },
                                      height: 40,
                                      width: 40,
                                      hoverRadius: BorderRadius.circular(12),
                                      child: const Icon(Icons.point_of_sale_rounded, color: Colors.blue, size: 28),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('In',
                                      style: TextStyle(
                                          color: AppColors.appColorWhite,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 60,
                                          letterSpacing: 3)),
                                  Text('Sell',
                                      style: TextStyle(
                                          color: AppColors.appColorGreen300,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 60,
                                          letterSpacing: 3)),
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    width: 892,
                    child: GridView.builder(
                      padding: const EdgeInsets.all(0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 0,
                        childAspectRatio: 3,
                      ),
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: filteredButtons.length,
                      itemBuilder: (context, i) {
                        Map<String, dynamic> button = filteredButtons[i];
                        return AppButton(
                          onTap: button['onTap'],
                          width: button['width'] ?? screenWidth / 3.5,
                          height: button['height'],
                          margin: button['margin'],
                          borderRadius: button['borderRadius'],
                          hoverRadius: button['hoverRadius'],
                          color: button['color'],
                          hoverColor: button['hoverColor'],
                          colorOnClick: button['colorOnClick'],
                          child: button['child'],
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  String formatLastSync(DateTime lastSync) {
    String result = "";
    Duration duration = DateTime.now().difference(lastSync);
    if (duration.inDays > 0) {
      result += '${duration.inDays} kun ';
      return result;
    }
    if (duration.inHours > 0) {
      result += '${duration.inHours % 24} soat ';
      return result;
    }
    if (duration.inMinutes > 0) {
      result += '${duration.inMinutes % 60} daqiqa';
      return result;
    }
    if (duration.inSeconds > 0) {
      result += '${duration.inSeconds % 60} soniya';
      return result;
    }
    return result;
  }

  logOut() async {
    await Storage().deleteKeys(['token', 'user', 'lastSync', 'topProducts']);
    await database.dropDatabase();
    Get.offAllNamed(Routes.LOGIN);
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}
