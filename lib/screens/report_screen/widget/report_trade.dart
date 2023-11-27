import 'dart:convert';
import 'package:easy_sell/database/model/trade_dto.dart';
import 'package:easy_sell/database/my_database.dart';
import 'package:easy_sell/screens/report_screen/widget/report_header.dart';
import 'package:easy_sell/screens/report_screen/widget/update_trade_dialog.dart';
import 'package:easy_sell/services/https_services.dart';
import 'package:easy_sell/utils/translator.dart';
import 'package:easy_sell/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
import '../../../constants/colors.dart';
import '../../../database/model/trade_struct.dart';
import '../../../services/excel_service.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_calendar_dialog.dart';
import '../../../widgets/app_input_underline.dart';
import '../../../widgets/app_showmenu.dart';
import '../../sell_screen/screens/trade_history_screen/widgets/trade_history_dialog.dart';

class ReportTradeSide extends StatefulWidget {
  const ReportTradeSide({super.key});

  @override
  State<ReportTradeSide> createState() => _ReportTradeSideState();
}

class _ReportTradeSideState extends State<ReportTradeSide> {
  final TextEditingController _dateController = TextEditingController();
  DateTime? _startDate = DateTime.now();
  DateTime? _endDate = DateTime.now();
  int organizationId = -1;
  bool loading = false;
  int size = 1000000000;
  int total = 0;
  List<TradeStruct> trades = [];
  List<TradeStruct> fullTrades = [];
  List<TradeStruct> duplicateTrades = [];
  List<TradeStruct> wrongPaymentTrades = [];
  String? errorMessage;
  int activeIndex = 0;
  bool descending = false;

  @override
  void initState() {
    super.initState();
    getOrganizationId();
  }

  void getData() async {
    try {
      setState(() {
        loading = true;
        showDuplicates = false;
        duplicateTrades = [];
        wrongPaymentTrades = [];
      });
      var response = await HttpServices.get(
        "/trade/report/all/organization/$organizationId?page=0&size=$size&from=${formatDate(_startDate, format: "yyyy-MM-dd")}&to=${formatDate(_endDate, format: "yyyy-MM-dd")}",
      );
      var json = jsonDecode(response.body);
      var data = json['data'];
      trades = [];
      for (var item in data) {
        trades.add(TradeStruct.fromJson(item));
      }
      total = json['totalElements'];
      detectDuplicateTrades();
      detectWrongPaymentTrades();
      setState(() {
        fullTrades = trades;
        loading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = e.toString();
          loading = false;
        });
      }
    }
  }

  void detectDuplicateTrades() {
    List<TradeStruct> duplicateTradesFind = [];
    for (var i = 0; i < trades.length; i++) {
      List<TradeStruct> findTrade = trades.where((element) => checkTradeDuplicate(trades[i], element)).toList();
      //check if trade has in duplicateTradesFind list
      if (findTrade.length > 1) {
        bool has = false;
        for (var j = 0; j < duplicateTradesFind.length; j++) {
          if (duplicateTradesFind[j].id == trades[i].id) {
            has = true;
            break;
          }
        }
        if (!has) {
          duplicateTradesFind.add(trades[i]);
        }
      }
    }
    duplicateTradesFind.sort((a, b) => a.createdTime!.compareTo(b.createdTime!));
    setState(() {
      duplicateTrades = duplicateTradesFind;
    });
  }

  void detectWrongPaymentTrades() {
    List<TradeStruct> wrongPaymentTradesFind = [];
    for (var i = 0; i < trades.length; i++) {
      if (checkWrongPaymentTrades(trades[i])) {
        wrongPaymentTradesFind.add(trades[i]);
      }
    }
    setState(() {
      wrongPaymentTrades = wrongPaymentTradesFind;
    });
  }

  void getOrganizationId() async {
    var json = jsonDecode((await HttpServices.get('/user/get-me')).body);
    setState(() {
      organizationId = json['organization']['id'];
    });
  }

  bool showDuplicates = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 300,
                  child: AppInputUnderline(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AppCalendarDialog(
                            callback: (DateTime startDate, DateTime? endDate) {
                              setState(() {
                                _startDate = startDate;
                                _endDate = endDate;
                              });
                            },
                          );
                        },
                      );
                    },
                    controller: _dateController,
                    hintText: "Vaqt oralig'ini tanlang",
                    hintTextColor: AppColors.appColorGrey400,
                    prefixIcon: UniconsLine.calendar_alt,
                    iconSize: 25,
                    keyboardType: TextInputType.number,
                    inputFormatters: [AppTextInputFormatter()],
                  ),
                ),
                Row(
                  children: _startDate != null || _endDate != null
                      ? [
                          Text(
                            'Jami: ${formatNumber(total)}',
                            style: TextStyle(fontSize: 14, color: AppColors.appColorWhite),
                          ),
                          const SizedBox(width: 10),
                          duplicateTrades.isNotEmpty || wrongPaymentTrades.isNotEmpty
                              ? IconButton(
                                  onPressed: () {
                                    List<MenuItemStruct> menuItems = [
                                      MenuItemStruct(
                                        widget: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.looks_two_outlined, color: Colors.orangeAccent, size: 20),
                                              const SizedBox(width: 10),
                                              Text('Takrorlangan savdolar', style: TextStyle(color: AppColors.appColorWhite)),
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          showDialog(
                                            builder: (context) => AlertDialog(
                                              backgroundColor: Colors.black,
                                              title: Row(
                                                children: [
                                                  Text('Takrorlangan savdolar', style: TextStyle(color: AppColors.appColorWhite)),
                                                  const SizedBox(width: 10),
                                                  Text('(${duplicateTrades.length}) ta', style: TextStyle(color: AppColors.appColorWhite)),
                                                  const Spacer(),
                                                  IconButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    icon: const Icon(Icons.close, color: Colors.redAccent, size: 20),
                                                  ),
                                                ],
                                              ),
                                              content: SizedBox(
                                                width: MediaQuery.of(context).size.width - 100,
                                                height: MediaQuery.of(context).size.height - 100,
                                                child: ListView.separated(
                                                  shrinkWrap: true,
                                                  padding: const EdgeInsets.only(left: 5, top: 5),
                                                  itemCount: duplicateTrades.length,
                                                  itemBuilder: (context, index) {
                                                    return TradeItem(trade: duplicateTrades[index]);
                                                  },
                                                  separatorBuilder: (context, index) =>
                                                      Divider(color: AppColors.appColorGrey700.withOpacity(0.5), thickness: 1, height: 0),
                                                ),
                                              ),
                                            ),
                                            context: context,
                                          );
                                        },
                                        enabled: duplicateTrades.isNotEmpty,
                                      ),
                                      MenuItemStruct(
                                        widget: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Icon(Icons.money_off, color: AppColors.appColorRed300, size: 20),
                                              const SizedBox(width: 10),
                                              Text('Noto\'g\'ri To\'lovlar', style: TextStyle(color: AppColors.appColorWhite)),
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          showDialog(
                                            builder: (context) => AlertDialog(
                                              backgroundColor: Colors.black,
                                              title: Row(
                                                children: [
                                                  Text("Noto'g'ri To'lovlar", style: TextStyle(color: AppColors.appColorWhite)),
                                                  const SizedBox(width: 10),
                                                  Text('(${wrongPaymentTrades.length}) ta', style: TextStyle(color: AppColors.appColorWhite)),
                                                  const Spacer(),
                                                  IconButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    icon: const Icon(Icons.close, color: Colors.redAccent, size: 20),
                                                  ),
                                                ],
                                              ),
                                              content: SizedBox(
                                                width: MediaQuery.of(context).size.width - 100,
                                                height: MediaQuery.of(context).size.height - 100,
                                                child: ListView.separated(
                                                  shrinkWrap: true,
                                                  padding: const EdgeInsets.only(left: 5, top: 5),
                                                  itemCount: wrongPaymentTrades.length,
                                                  itemBuilder: (context, index) {
                                                    return TradeItem(trade: wrongPaymentTrades[index]);
                                                  },
                                                  separatorBuilder: (context, index) =>
                                                      Divider(color: AppColors.appColorGrey700.withOpacity(0.5), thickness: 1, height: 0),
                                                ),
                                              ),
                                            ),
                                            context: context,
                                          );
                                        },
                                        enabled: wrongPaymentTrades.isNotEmpty,
                                      ),
                                    ];
                                    showAppMenu(
                                      context,
                                      menuItems,
                                      top: 100,
                                      left: 50,
                                    );
                                  },
                                  icon: const Icon(Icons.notification_important_sharp, color: Colors.redAccent, size: 20))
                              : Container(),
                          trades.isNotEmpty
                              ? AppButton(
                                  onTap: () async {
                                    List header = [
                                      'Kassa',
                                      'Kassir',
                                      'Savdo',
                                      'Skidka',
                                      'To\'lov',
                                      'Naqd',
                                      'Karta',
                                      'Bank',
                                      'Cashback',
                                      'Vaqti',
                                      'Status',
                                    ];
                                    List data = trades
                                        .map((e) => [
                                              e.posSession?.pos.name ?? '',
                                              '${e.posSession?.cashier.firstName} ${e.posSession?.cashier.lastName}',
                                              e.total,
                                              e.discount,
                                              e.totalInvoice,
                                              e.cash,
                                              e.card,
                                              e.bank,
                                              e.cashback,
                                              e.createdTime,
                                              e.status,
                                            ])
                                        .toList();
                                    await ExcelService.createExcelFile([header, ...data], 'Savdo xisoboti', context);
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
                                )
                              : const SizedBox(),
                          const SizedBox(width: 10),
                          Container(
                            height: 30,
                            width: 250,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: AppColors.appColorGrey400.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${formatDate(_startDate)}  -  ${formatDate(_endDate)}',
                                  style: TextStyle(color: AppColors.appColorWhite, fontSize: 14),
                                ),
                                AppButton(
                                  onTap: () {
                                    setState(() {
                                      _startDate = null;
                                      _endDate = null;
                                    });
                                  },
                                  width: 30,
                                  child: Icon(Icons.close_rounded, color: AppColors.appColorWhite, size: 20),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          (organizationId == -1)
                              ? Container()
                              : AppButton(
                                  onTap: getData,
                                  tooltip: 'Xisobotni shakillantirish',
                                  width: 50,
                                  height: 30,
                                  color: AppColors.appColorGreen400.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(10),
                                  hoverRadius: BorderRadius.circular(10),
                                  child: Icon(Icons.search, color: AppColors.appColorWhite, size: 20),
                                ),
                        ]
                      : [],
                ),
              ],
            ),
          ),
          Divider(color: AppColors.appColorGrey700.withOpacity(0.5), thickness: 1, height: 0),
          const SizedBox(height: 10),
          Expanded(
            flex: 0,
            child: ReportHeader(
              backgroundColor: AppColors.appColorGrey700.withOpacity(0.5),
              headers: [
                HeaderStruct(
                    title: 'Kassa nomi',
                    index: 0,
                    activeIndex: activeIndex,
                    desc: descending,
                    sort: () {
                      setState(() {
                        activeIndex = 0;
                        descending = !descending;
                        trades.sort((a, b) =>
                            descending ? a.posSession!.pos.name.compareTo(b.posSession!.pos.name) : b.posSession!.pos.name.compareTo(a.posSession!.pos.name));
                      });
                    }),
                HeaderStruct(
                    title: 'Kassir',
                    index: 1,
                    activeIndex: activeIndex,
                    desc: descending,
                    sort: () {
                      setState(() {
                        activeIndex = 1;
                        descending = !descending;
                        trades.sort((a, b) => descending
                            ? a.posSession!.cashier.firstName.compareTo(b.posSession!.cashier.firstName)
                            : b.posSession!.cashier.firstName.compareTo(a.posSession!.cashier.firstName));
                      });
                    }),
                HeaderStruct(
                    title: 'Savdo',
                    index: 2,
                    activeIndex: activeIndex,
                    desc: descending,
                    sort: () {
                      setState(() {
                        activeIndex = 2;
                        descending = !descending;
                        trades.sort((a, b) => descending ? a.total.compareTo(b.total) : b.total.compareTo(a.total));
                      });
                    }),
                HeaderStruct(
                    title: 'Skidka',
                    index: 3,
                    activeIndex: activeIndex,
                    desc: descending,
                    sort: () {
                      setState(() {
                        activeIndex = 3;
                        descending = !descending;
                        trades.sort((a, b) => descending ? a.discount!.compareTo(b.discount!) : b.discount!.compareTo(a.discount!));
                      });
                    }),
                HeaderStruct(
                    title: "To'lov",
                    index: 4,
                    activeIndex: activeIndex,
                    desc: descending,
                    sort: () {
                      setState(() {
                        activeIndex = 4;
                        descending = !descending;
                        trades.sort((a, b) => descending ? a.totalInvoice.compareTo(b.totalInvoice) : b.totalInvoice.compareTo(a.totalInvoice));
                      });
                    }),
                HeaderStruct(
                    title: 'Naqd',
                    index: 5,
                    activeIndex: activeIndex,
                    desc: descending,
                    sort: () {
                      setState(() {
                        activeIndex = 5;
                        descending = !descending;
                        trades.sort((a, b) => descending ? a.cash.compareTo(b.cash) : b.cash.compareTo(a.cash));
                      });
                    }),
                HeaderStruct(
                    title: 'Karta',
                    index: 6,
                    activeIndex: activeIndex,
                    desc: descending,
                    sort: () {
                      setState(() {
                        activeIndex = 6;
                        descending = !descending;
                        trades.sort((a, b) => descending ? a.card.compareTo(b.card) : b.card.compareTo(a.card));
                      });
                    }),
                HeaderStruct(
                    title: 'Bank',
                    index: 7,
                    activeIndex: activeIndex,
                    desc: descending,
                    sort: () {
                      setState(() {
                        activeIndex = 7;
                        descending = !descending;
                        trades.sort((a, b) => descending ? a.bank.compareTo(b.bank) : b.bank.compareTo(a.bank));
                      });
                    }),
                HeaderStruct(
                    title: 'Cashback',
                    index: 8,
                    activeIndex: activeIndex,
                    desc: descending,
                    sort: () {
                      setState(() {
                        activeIndex = 8;
                        descending = !descending;
                        trades.sort((a, b) => descending ? a.cashback.compareTo(b.cashback) : b.cashback.compareTo(a.cashback));
                      });
                    }),
                HeaderStruct(
                    title: 'Vaqti',
                    index: 9,
                    activeIndex: activeIndex,
                    desc: descending,
                    sort: () {
                      setState(() {
                        activeIndex = 9;
                        descending = !descending;
                        trades.sort((a, b) => descending ? a.createdTime!.compareTo(b.createdTime!) : b.createdTime!.compareTo(a.createdTime!));
                      });
                    }),
                HeaderStruct(
                    title: 'Status',
                    index: 11,
                    activeIndex: activeIndex,
                    desc: descending,
                    sort: () {
                      setState(() {
                        activeIndex = 11;
                        descending = !descending;
                        trades.sort((a, b) => descending ? a.status.compareTo(b.status) : b.status.compareTo(a.status));
                      });
                    }),
                HeaderStruct(title: 'O\'chirish', index: 11, activeIndex: activeIndex, desc: descending, sort: () {}),
              ],
            ),
          ),
          Expanded(
            flex: 10,
            child: loading
                ? Center(child: CircularProgressIndicator(color: AppColors.appColorGreen400))
                : errorMessage != null
                    ? Center(child: Text(errorMessage ?? "", style: TextStyle(color: AppColors.appColorRed400)))
                    : ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(left: 5, top: 5),
                        itemCount: trades.length,
                        itemBuilder: (context, index) {
                          return TradeItem(trade: trades[index]);
                        },
                        separatorBuilder: (context, index) => Divider(color: AppColors.appColorGrey700.withOpacity(0.5), thickness: 1, height: 0),
                      ),
          ),
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(color: AppColors.appColorGrey700.withOpacity(0.5), borderRadius: BorderRadius.circular(15)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.keyboard_double_arrow_up_rounded, color: AppColors.appColorGreen400, size: 23),
                            Text('Savdolar soni: ', style: TextStyle(color: AppColors.appColorWhite.withOpacity(0.7), fontSize: 16)),
                            Text('${trades.where((el) => el.isReturned == false).length}', style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(width: 50),
                        Row(
                          children: [
                            Icon(Icons.keyboard_double_arrow_down_rounded, color: AppColors.appColorRed300, size: 23),
                            Text('Vozvratlar soni: ', style: TextStyle(color: AppColors.appColorWhite.withOpacity(0.7), fontSize: 16)),
                            Text('${trades.where((el) => el.isReturned == true).length}', style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.person, color: Colors.blueGrey, size: 23),
                            Text('Mijozlar soni: ', style: TextStyle(color: AppColors.appColorWhite.withOpacity(0.7), fontSize: 16)),
                            Text('${trades.where((el) => el.client != null).length}', style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(width: 50),
                        Row(
                          children: [
                            const Icon(Icons.person_2_outlined, color: Colors.lightBlue, size: 23),
                            Text('Haridorlar soni: ', style: TextStyle(color: AppColors.appColorWhite.withOpacity(0.7), fontSize: 16)),
                            Text('${trades.where((el) => el.isReturned == false).length - trades.where((el) => el.client != null).length}', style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const VerticalDivider(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(UniconsLine.shopping_cart_alt, color: AppColors.appColorGreen400, size: 23),
                            Text('Umumiy savdo: ', style: TextStyle(color: AppColors.appColorWhite.withOpacity(0.7), fontSize: 16)),
                            Text(formatNumber(trades.where((el) => !el.isReturned && !el.deleted).fold(0.0, (value, el) => value + el.productsInTrade.fold(0.0, (value, el) => value + el.amount * el.price))), style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(width: 50),
                        Row(
                          children: [
                            Icon(Icons.arrow_upward_rounded, color: AppColors.appColorRed300, size: 23),
                            Text('Umumiy vozvrat: ', style: TextStyle(color: AppColors.appColorWhite.withOpacity(0.7), fontSize: 16)),
                            Text(formatNumber(trades.where((el) => el.isReturned && !el.deleted).fold(0.0, (value, el) => value + el.productsInTrade.fold(0.0, (value, el) => value + el.amount * el.price))), style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.arrow_downward_rounded, color: AppColors.appColorGreen400, size: 23),
                            Text('Umumiy kirim: ', style: TextStyle(color: AppColors.appColorWhite.withOpacity(0.7), fontSize: 16)),
                            Text(formatNumber(trades.where((element) => !element.deleted && !element.isReturned).fold(0.0, (value, el) => value + el.totalInvoice)), style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(width: 50),
                        Row(
                          children: [
                            const Icon(Icons.percent_rounded, color: Colors.amber, size: 23),
                            Text('Umumiy skidka: ', style: TextStyle(color: AppColors.appColorWhite.withOpacity(0.7), fontSize: 16)),
                            Text(formatNumber(trades.where((element) => !element.deleted && !element.isReturned).fold(0.0, (value, el) => value + (el.discount ?? 0))), style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const VerticalDivider(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(UniconsLine.money_bill, color: Colors.blue, size: 23),
                            Text('Naqd : ', style: TextStyle(color: AppColors.appColorWhite.withOpacity(0.7), fontSize: 16)),
                            Text(formatNumber(trades.fold(0.0, (value, el) => value + el.cash)), style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(width: 50),
                        Row(
                          children: [
                            Icon(UniconsLine.credit_card, color: AppColors.appColorGreen400, size: 23),
                            Text('Karta : ', style: TextStyle(color: AppColors.appColorWhite.withOpacity(0.7), fontSize: 16)),
                            Text(formatNumber(trades.fold(0.0, (value, el) => value + el.card)), style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.other_houses_rounded, color: Colors.orange, size: 23),
                            Text('Bank : ', style: TextStyle(color: AppColors.appColorWhite.withOpacity(0.7), fontSize: 16)),
                            Text(formatNumber(trades.fold(0.0, (value, el) => value + el.bank)), style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(width: 15),
                        Row(
                          children: [
                            const Icon(UniconsLine.percentage, color: Colors.amber, size: 23),
                            Text('Cashback : ', style: TextStyle(color: AppColors.appColorWhite.withOpacity(0.7), fontSize: 16)),
                            Text(formatNumber(trades.fold(0.0, (value, el) => value + el.cashback)), style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(width: 15),
                        Row(
                          children: [
                            Icon(UniconsLine.receipt, color: AppColors.appColorGrey400, size: 23),
                            Text('O\'rta chek : ', style: TextStyle(color: AppColors.appColorWhite.withOpacity(0.7), fontSize: 16)),
                            Text(formatNumber(trades.fold(0.0, (value, el) => value + el.productsInTrade.fold(0.0, (value, el) => value + el.amount * el.price)) / trades.where((el) => el.isReturned == false).length), style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool checkTradeDuplicate(TradeStruct trade1, TradeStruct trade2) {
    bool duplicate = trade1.createdTime == trade2.createdTime &&
        trade1.totalInvoice == trade2.totalInvoice &&
        trade1.total == trade2.total &&
        trade1.cash == trade2.cash &&
        trade1.card == trade2.card &&
        trade1.bank == trade2.bank &&
        trade1.cashback == trade2.cashback;
    return duplicate;
  }

  bool checkWrongPaymentTrades(TradeStruct trade) {
    if (trade.isReturned) return false;
    return trade.total - (trade.discount ?? 0) != trade.totalInvoice;
  }
}

class TradeItem extends StatefulWidget {
  const TradeItem({super.key, required this.trade});

  final TradeStruct trade;

  @override
  State<TradeItem> createState() => _TradeItemState();
}

class _TradeItemState extends State<TradeItem> {
  TradeStruct get trade => widget.trade;

  double get total => trade.total;

  double get discount => trade.discount ?? 0.0;

  double get totalInvoice => trade.totalInvoice;

  double get cash => trade.cash;

  double get card => trade.card;

  double get bank => trade.bank;

  double get cashback => trade.cashback;

  String get status => trade.status;

  Function get deleteTrade => trade.deleteTrade;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: const BoxDecoration(color: Colors.white12),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "#${trade.id} ${trade.posSession?.pos.name}",
                  style: TextStyle(color: AppColors.appColorWhite, fontSize: 12),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${trade.posSession?.cashier.firstName} ${trade.posSession?.cashier.lastName}',
                  style: TextStyle(color: AppColors.appColorWhite, fontSize: 14),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatNumber(total),
                  style: TextStyle(color: AppColors.appColorWhite, fontSize: 14),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatNumber(discount),
                  style: TextStyle(color: AppColors.appColorWhite, fontSize: 14),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatNumber(totalInvoice),
                  style: TextStyle(color: AppColors.appColorWhite, fontSize: 14),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatNumber(cash),
                  style: TextStyle(color: AppColors.appColorWhite, fontSize: 14),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatNumber(card),
                  style: TextStyle(color: AppColors.appColorWhite, fontSize: 14),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatNumber(bank),
                  style: TextStyle(color: AppColors.appColorWhite, fontSize: 14),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatNumber(cashback),
                  style: TextStyle(color: AppColors.appColorWhite, fontSize: 14),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(formatDateTime(widget.trade.createdTime), style: TextStyle(color: AppColors.appColorWhite, fontSize: 14)),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: status == 'SUCCESS'
                          ? AppColors.appColorGreen700
                          : status == 'DELETED'
                              ? Colors.redAccent
                              : Colors.blueGrey,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(translate(status), style: TextStyle(color: AppColors.appColorWhite, fontSize: 14))),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppButton(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return UpdateTradeDialog(trade: widget.trade);
                      },
                    );
                  },
                  width: 28,
                  height: 28,
                  color: AppColors.appColorGrey400.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                  hoverRadius: BorderRadius.circular(8),
                  child: Icon(Icons.edit, color: AppColors.appColorWhite, size: 20),
                ),
                const SizedBox(width: 5),
                AppButton(
                  onTap: () {
                    showAppAlertDialog(context,
                        title: 'Diqqat',
                        message: 'Siz rostdan ham ushbu savdoni o\'chirmoqchimisiz?',
                        buttonLabel: 'Ha',
                        cancelLabel: 'Yo\'q', onConfirm: () async {
                      bool deleted = await deleteTrade();
                      if (deleted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text('Savdo muvaffaqiyatli o\'chirildi'),
                          backgroundColor: AppColors.appColorGreen700,
                        ));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text('Savdo o\'chirishda xatolik yuz berdi'),
                          backgroundColor: AppColors.appColorRed400,
                        ));
                      }
                    });
                  },
                  width: 28,
                  height: 28,
                  color: AppColors.appColorRed400,
                  borderRadius: BorderRadius.circular(8),
                  hoverRadius: BorderRadius.circular(8),
                  child: Icon(Icons.delete, color: AppColors.appColorWhite, size: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PosTradeStruct {
  POSData? pos;
  List<TradeStruct> trades = [];

  PosTradeStruct({this.pos, required this.trades});
}
