import 'dart:convert';
import 'dart:io';
import 'package:easy_sell/constants/user_role.dart';
import 'package:easy_sell/screens/settings_screen/screens/discount_settings_screen/discount_settings_screen.dart';
import 'package:easy_sell/screens/settings_screen/widget/client_type.dart';
import 'package:easy_sell/screens/settings_screen/widget/currency_widget.dart';
import 'package:easy_sell/screens/settings_screen/widget/exchange_rate.dart';
import 'package:easy_sell/screens/settings_screen/widget/expense_type_widget.dart';
import 'package:easy_sell/screens/settings_screen/widget/price_type.dart';
import 'package:easy_sell/screens/settings_screen/widget/return_trade_expense_type_widget.dart';
import 'package:easy_sell/screens/settings_screen/widget/supplier_segment.dart';
import 'package:easy_sell/screens/settings_screen/widget/top_products.dart';
import 'package:easy_sell/services/storage_services.dart';
import 'package:easy_sell/widgets/app_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';
import '../../constants/colors.dart';
import '../../utils/routes.dart';
import '../../widgets/app_button.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Storage storage = Storage();
  List<String> receiptPrintersList = ['Printer tanlanmagan'];
  String _selectedReceiptPrinter = 'Printer tanlanmagan';

  List<String> codePrintersList = ['Printer tanlanmagan'];
  String _selectedCodePrinter = 'Printer tanlanmagan';

  List<String> pricePrintersList = ['Printer tanlanmagan'];
  String _selectedPricePrinter = 'Printer tanlanmagan';
  bool _loading = false;
  bool online = true;
  bool checkoutInSell = false;
  List<UserRole> editRoles = [UserRole.ADMIN];
  List<UserRole> userRoles = [];

  @override
  void initState() {
    super.initState();
    getPrintersList();
    setOnlineStatus();
    setCheckoutInSell();
    getMe();
  }

  void getMe() async {
    var userString = await storage.read('user') ?? '';
    var user = jsonDecode(userString);
    var roles = user['roles'];
    setState(() {
      userRoles = roles.map<UserRole>((e) => UserRole.fromString(e)).toList();
    });
  }

  void setOnlineStatus() async {
    await storage.write('online', 'on');
    var status = await storage.read('online');
    setState(() {
      if (status == 'on') {
        online = true;
      } else {
        online = false;
      }
    });
  }

  void setCheckoutInSell() async {
    var checkout = await storage.read('checkoutInSell');
    setState(() {
      if (checkout == 'on') {
        checkoutInSell = true;
      } else {
        checkoutInSell = false;
      }
    });
  }

  void getPrintersList() async {
    setState(() {
      _loading = true;
    });
    List<String> printers = [];
    if (Platform.isWindows) {
      ProcessResult results = await Process.run('wmic', ['printer', 'get', 'name']);
      for (var element in results.stdout.toString().trim().split('\n')) {
        if (element.isNotEmpty && element.trim() != 'Name' && element.trim() != '') {
          if (printers.contains(element)) return;
          printers.add(element.trim());
        }
      }
    } else {
      ProcessResult results = await Process.run('lpstat', ['-a']);
      for (var element in results.stdout.toString().replaceAll(" ", '').split('\n')) {
        if (element.isNotEmpty && element != 'Name') {
          printers.add(element.replaceAll(', ', ''));
        }
      }
    }
    String selectedReceiptPrinter = await storage.read('receiptPrinter') ?? "Printer tanlanmagan";
    if (!printers.contains(selectedReceiptPrinter)) {
      printers.insert(0, selectedReceiptPrinter);
    }
    String selectedCodePrinter = await storage.read('codePrinter') ?? "Printer tanlanmagan";
    if (!printers.contains(selectedCodePrinter)) {
      printers.insert(0, selectedCodePrinter);
    }
    String selectedPricePrinter = await storage.read('pricePrinter') ?? "Printer tanlanmagan";
    if (!printers.contains(selectedPricePrinter)) {
      printers.insert(0, selectedPricePrinter);
    }
    setState(() {
      receiptPrintersList = printers;
      codePrintersList = printers;
      pricePrintersList = printers;
      _selectedReceiptPrinter = selectedReceiptPrinter;
      _selectedCodePrinter = selectedCodePrinter;
      _selectedPricePrinter = selectedPricePrinter;
      _loading = false;
    });
  }

  Widget? innerWidget;
  int activeIndex = -1;

  @override
  Widget build(BuildContext context) {
    List<SettingListItem> getSettingsItems = [
      SettingListItem(
          icon: Icons.clear_all,
          title: 'Top mahsulotlar',
          onTap: () {
            setState(() {
              innerWidget = const TopProductsWidget();
              activeIndex = 0;
            });
          },
          canSee: [...editRoles, UserRole.CASHIER].any((element) => userRoles.contains(element))),
      SettingListItem(
          icon: Icons.merge_type,
          title: 'Xaratajat turlari',
          onTap: () {
            setState(() {
              innerWidget = const ExpenseTypeWidget();
              activeIndex = 1;
            });
          },
          canSee: [...editRoles].any((element) => userRoles.contains(element))),
      SettingListItem(
          icon: Icons.verified_user_outlined,
          title: 'Klient statuslari',
          onTap: () {
            setState(() {
              innerWidget = const ClientTypesWidget();
              activeIndex = 2;
            });
          },
          canSee: [...editRoles].any((element) => userRoles.contains(element))),
      SettingListItem(
          canSee: [...editRoles].any((element) => userRoles.contains(element)),
          icon: UniconsLine.exchange,
          title: 'Konvertatsiya',
          onTap: () {
            setState(() {
              innerWidget = const ExchangeRateHistory();
              activeIndex = 3;
            });
          }),
      SettingListItem(
          canSee: [...editRoles].any((element) => userRoles.contains(element)),
          icon: Icons.currency_exchange,
          title: 'Valyuta',
          onTap: () {
            setState(() {
              innerWidget = const CurrencyAddListWidget();
              activeIndex = 4;
            });
          }),
      SettingListItem(
          canSee: [...editRoles].any((element) => userRoles.contains(element)),
          icon: Icons.supervised_user_circle_outlined,
          title: 'Taminotchi Segmenti',
          onTap: () {
            setState(() {
              innerWidget = const SupplierSegment();
              activeIndex = 5;
            });
          }),
      SettingListItem(
          canSee: [...editRoles].any((element) => userRoles.contains(element)),
          icon: Icons.arrow_upward_outlined,
          title: 'Chiqim turlari',
          onTap: () {
            setState(() {
              innerWidget = const ReturnTradeExpenseTypeWidget();
              activeIndex = 6;
            });
          }),
      SettingListItem(
          canSee: [...editRoles].any((element) => userRoles.contains(element)),
          icon: Icons.price_check,
          title: 'Narx turlari',
          onTap: () {
            setState(() {
              innerWidget = const PriceTypeWidget();
              activeIndex = 7;
            });
          }),
      SettingListItem(
        canSee: [...editRoles].any((element) => userRoles.contains(element)),
        icon: Icons.calculate_outlined,
        title: 'Narxlar kalkulyatori',
        onTap: () => Get.toNamed(Routes.MONEY_SETTINGS),
        isLink: true,
      ),
      SettingListItem(
        canSee: [...editRoles].any((element) => userRoles.contains(element)),
        icon: Icons.percent_outlined,
        title: 'Cashback',
        onTap: () => Get.toNamed(Routes.CASHBACK_SETTINGS),
        isLink: true,
      ),
      SettingListItem(
        canSee: [...editRoles].any((element) => userRoles.contains(element)),
        icon: Icons.discount,
        title: 'Chegirmalar',
        onTap: () => Get.to(() => const DiscountSettingsScreen()),
        isLink: true,
      ),
    ];
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
        title: Text('Sozlamalar', style: TextStyle(color: AppColors.appColorWhite)),
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
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: AppColors.appColorBlackBg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(UniconsLine.print, color: AppColors.appColorGreen400),
                          const SizedBox(width: 5),
                          Text('Chek printerini tanlang', style: TextStyle(color: AppColors.appColorWhite, fontSize: 17)),
                        ],
                      ),
                      _loading
                          ? CircularProgressIndicator(color: AppColors.appColorGreen400)
                          : SizedBox(
                              height: 40,
                              width: 300,
                              child: AppDropDown(
                                underlineColor: Colors.transparent,
                                dropDownItems: receiptPrintersList,
                                selectedValue: _selectedReceiptPrinter,
                                onChanged: (value) {
                                  _selectedReceiptPrinter = value.trim();
                                  storage.write('receiptPrinter', value.trim());
                                },
                              ),
                            ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(UniconsLine.print, color: Colors.blue),
                          const SizedBox(width: 5),
                          Text('Shtrix printerini tanlang', style: TextStyle(color: AppColors.appColorWhite, fontSize: 17)),
                        ],
                      ),
                      _loading
                          ? CircularProgressIndicator(color: AppColors.appColorGreen400)
                          : SizedBox(
                              height: 40,
                              width: 300,
                              child: AppDropDown(
                                underlineColor: Colors.transparent,
                                dropDownItems: codePrintersList,
                                selectedValue: _selectedCodePrinter,
                                onChanged: (value) {
                                  _selectedCodePrinter = value.trim();
                                  storage.write('codePrinter', value.trim());
                                },
                              ),
                            ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(UniconsLine.print, color: Colors.white),
                          const SizedBox(width: 5),
                          Text('Narx Etiketka printerini tanlang',
                              style: TextStyle(color: AppColors.appColorWhite, fontSize: 17)),
                        ],
                      ),
                      _loading
                          ? CircularProgressIndicator(color: AppColors.appColorGreen400)
                          : SizedBox(
                              height: 40,
                              width: 300,
                              child: AppDropDown(
                                underlineColor: Colors.transparent,
                                dropDownItems: pricePrintersList,
                                selectedValue: _selectedPricePrinter,
                                onChanged: (value) {
                                  _selectedPricePrinter = value.trim();
                                  storage.write('pricePrinter', value.trim());
                                },
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: AppColors.appColorBlackBg),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: ListView.separated(
                              separatorBuilder: (context, index) {
                                return getSettingsItems[index].canSee == true
                                    ? Divider(color: AppColors.appColorGrey700.withOpacity(0.5), thickness: 1)
                                    : Container();
                              },
                              padding: const EdgeInsets.all(0),
                              itemCount: getSettingsItems.length,
                              itemBuilder: (context, index) {
                                return Container(
                                    decoration: BoxDecoration(
                                      color:
                                          activeIndex == index ? AppColors.appColorGrey700.withOpacity(0.4) : Colors.transparent,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: getSettingsItems[index]);
                              },
                            ),
                          ),
                          VerticalDivider(color: AppColors.appColorGrey700.withOpacity(0.5), thickness: 1),
                          Expanded(
                              flex: 3,
                              child: Column(
                                children: [
                                  innerWidget ??
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            'Yon Paneldan Tanlang',
                                            style: TextStyle(color: AppColors.appColorWhite, fontSize: 20),
                                          ),
                                        ),
                                      ),
                                ],
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function onTap;
  final bool? isLink;
  final bool? canSee;

  const SettingListItem(
      {super.key, required this.icon, required this.title, required this.onTap, this.isLink = false, this.canSee = false});

  @override
  Widget build(BuildContext context) {
    return (canSee == true)
        ? ListTile(
            leading: Icon(icon, color: Colors.white70),
            title: Text(title, style: TextStyle(color: AppColors.appColorWhite)),
            trailing:
                Icon(isLink == true ? UniconsLine.external_link_alt : Icons.keyboard_arrow_right, color: AppColors.appColorWhite),
            onTap: () => onTap(),
          )
        : Container();
  }
}
