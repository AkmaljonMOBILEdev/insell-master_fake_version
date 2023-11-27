import 'package:easy_sell/screens/report_screen/widget/full_info_trade_product.dart';
import 'package:easy_sell/screens/report_screen/widget/report_client_side.dart';
import 'package:easy_sell/screens/report_screen/widget/report_pos_info.dart';
import 'package:easy_sell/screens/report_screen/widget/report_product_side.dart';
import 'package:easy_sell/screens/report_screen/widget/report_session_side.dart';
import 'package:easy_sell/screens/report_screen/widget/report_trade.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';
import '../../constants/colors.dart';
import '../../database/my_database.dart';
import '../../database/table/invoice_table.dart';
import '../../services/money_calculator_service.dart';
import '../../widgets/app_button.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  MyDatabase database = Get.find<MyDatabase>();
  late MoneyCalculatorService moneyCalculatorService;
  double totalCardMoney = 0;
  double totalCashMoney = 0;
  double totalBankMoney = 0;
  int? activeIndex;

  Widget innerWidget = Expanded(
    child: Center(
      child: Text(
        'Yon Paneldan Tanlang',
        style: TextStyle(color: AppColors.appColorWhite, fontSize: 20),
      ),
    ),
  );

  @override
  void initState() {
    super.initState();
    moneyCalculatorService = MoneyCalculatorService(database: database);
    calculator();
  }

  @override
  Widget build(BuildContext context) {
    List<ListTile> getSettingsItems = [
      ListTile(
        title: Tooltip(message: 'Mijoz savdo hisoboti', child: Icon(UniconsLine.users_alt, color: AppColors.appColorWhite)),
        onTap: () {
          setState(() {
            activeIndex = 0;
            innerWidget = const ReportClientsSide();
          });
        },
      ),
      ListTile(
        title: Tooltip(message: 'Maxsulot savdo hisoboti', child: Icon(UniconsLine.box, color: AppColors.appColorWhite)),
        onTap: () {
          setState(() {
            activeIndex = 1;
            innerWidget = const ReportProductSide();
          });
        },
      ),
      ListTile(
        title: Tooltip(message: 'Kassa holati', child: Icon(UniconsLine.postcard, color: AppColors.appColorWhite)),
        onTap: () {
          setState(() {
            activeIndex = 2;
            innerWidget = const ReportPosSide();
          });
        },
      ),
      ListTile(
        title: Tooltip(message: 'Savdo hisoboti', child: Icon(Icons.shopping_cart_outlined, color: AppColors.appColorWhite)),
        onTap: () {
          setState(() {
            activeIndex = 3;
            innerWidget = const ReportTradeSide();
          });
        },
      ),
      ListTile(
        title: Tooltip(message: 'Sessiya hisoboti', child: Icon(UniconsLine.user_nurse, color: AppColors.appColorWhite)),
        onTap: () {
          setState(() {
            activeIndex = 4;
            innerWidget = const ReportTradesByPosSession();
          });
        },
      ),
      ListTile(
        title: const Tooltip(message: 'Umumiy hisobot', child: Icon(Icons.info_outline, color: Colors.blueAccent)),
        onTap: () {
          setState(() {
            activeIndex = 5;
            innerWidget = const ReportTradeFullInfo();
          });
        },
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
        title: Text('Xisobot', style: TextStyle(color: AppColors.appColorWhite)),
        centerTitle: false,
        actions: [
          Text(pageName(activeIndex ?? -1), style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
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
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                decoration: BoxDecoration(color: AppColors.appColorBlackBg, borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 67,
                            child: ListView.separated(
                              scrollDirection: Axis.vertical,
                              separatorBuilder: (context, index) {
                                return Divider(color: AppColors.appColorGrey700.withOpacity(0.5), thickness: 1, height: 0);
                              },
                              padding: const EdgeInsets.all(0),
                              itemCount: getSettingsItems.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  width: 20,
                                  height: 50,
                                  margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: activeIndex == index ? AppColors.appColorGrey700.withOpacity(0.4) : Colors.transparent,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: getSettingsItems[index],
                                );
                              },
                            ),
                          ),
                          VerticalDivider(color: AppColors.appColorGrey700, thickness: 1, width: 0),
                          const SizedBox(width: 5),
                          Flexible(
                            flex: 15,
                            child: Column(
                              children: [
                                innerWidget,
                              ],
                            ),
                          ),
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

  void calculator() async {
    totalCardMoney = await moneyCalculatorService.calculatePos(invoiceType: InvoiceType.CARD);
    totalCashMoney = await moneyCalculatorService.calculatePos(invoiceType: InvoiceType.CASH);
    totalBankMoney = await moneyCalculatorService.calculatePos(invoiceType: InvoiceType.TRANSFER);
    setState(() {});
  }

  String pageName(int i) {
    switch (i) {
      case 0:
        return 'Mijoz Savdo Hisoboti';
      case 1:
        return 'Maxsulot Savdo Hisoboti';
      case 2:
        return 'Kassa holati';
      case 3:
        return 'Savdo Hisoboti';
      case 4:
        return 'Sessiya Hisoboti';
      case 5:
        return 'Umumiy Hisobot';
      default:
        return '';
    }
  }
}
