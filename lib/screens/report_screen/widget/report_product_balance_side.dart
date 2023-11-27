import 'dart:convert';
import 'package:easy_sell/screens/report_screen/widget/report_header.dart';
import 'package:easy_sell/services/https_services.dart';
import 'package:easy_sell/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
import '../../../constants/colors.dart';
import '../../../database/model/client_dto.dart';
import '../../../database/model/trade_struct.dart';
import '../../../services/excel_service.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_calendar_dialog.dart';
import '../../../widgets/app_input_underline.dart';
import '../../../widgets/app_report_card_item.dart';

class ReportProductBalanceSide extends StatefulWidget {
  const ReportProductBalanceSide({super.key});

  @override
  State<ReportProductBalanceSide> createState() => _ReportProductBalanceSideState();
}

class _ReportProductBalanceSideState extends State<ReportProductBalanceSide> {
  final TextEditingController _dateController = TextEditingController();
  DateTime? _startDate = DateTime.now();
  DateTime? _endDate = DateTime.now();
  int organizationId = -1;
  bool loading = false;
  int size = 1000000000;
  int total = 0;
  List<TradeStruct> trades = [];
  List<ClientTradeStruct> clientTrades = [];
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
      });
      var response = await HttpServices.get(
          "/trade/report/all/organization/$organizationId?page=0&size=$size&from=${formatDate(_startDate, format: "yyyy-MM-dd")}&to=${formatDate(_endDate, format: "yyyy-MM-dd")}");

      var json = jsonDecode(response.body);
      var data = json['data'];
      trades = [];
      for (var item in data) {
        trades.add(TradeStruct.fromJson(item));
      }
      List<ClientTradeStruct> tempClientTrades = [];
      ClientTradeStruct emptyClientTrade = ClientTradeStruct(client: null, trades: []);
      for (var trade in trades) {
        bool isExist = false;
        if (trade.client == null) {
          emptyClientTrade.trades.add(trade);
          continue;
        }
        for (var clientTrade in tempClientTrades) {
          if (clientTrade.client?.id == trade.client?.id) {
            clientTrade.trades.add(trade);
            isExist = true;
            break;
          }
        }
        if (!isExist) {
          tempClientTrades.add(ClientTradeStruct(client: trade.client, trades: [trade]));
        }
      }
      tempClientTrades.add(emptyClientTrade);
      clientTrades = tempClientTrades;

      total = json['totalElements'];
      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        loading = false;
      });
    }
  }

  void getOrganizationId() async {
    var json = jsonDecode((await HttpServices.get('/user/get-me')).body);
    if (mounted) {
      setState(() {
        organizationId = json['organization']['id'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<AppReportCardItem> getCardItems = [
      AppReportCardItem(
        icon: Icon(Icons.play_arrow_rounded, color: AppColors.appColorGreen400, size: 30),
        title: "Kun boshiga",
        resultLabel: '15 000',
      ),
      AppReportCardItem(
        icon: Icon(Icons.keyboard_arrow_up, color: AppColors.appColorRed300, size: 30),
        title: "Chiqim",
        resultLabel: '15 000',
      ),
      AppReportCardItem(
        icon: Icon(Icons.keyboard_arrow_down, color: AppColors.appColorGreen400, size: 30),
        title: "Kirim",
        resultLabel: '15 000',
      ),
      AppReportCardItem(
        icon: Icon(Icons.stop_rounded, color: Colors.orange, size: 30),
        title: "Kun oxiriga",
        resultLabel: '15 000',
      ),
    ];

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
                            style: TextStyle(fontSize: 16, color: AppColors.appColorWhite),
                          ),
                          const SizedBox(width: 10),
                          clientTrades.isNotEmpty
                              ? AppButton(
                                  onTap: () async {},
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
                                  style: TextStyle(color: AppColors.appColorWhite, fontSize: 16),
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
          SizedBox(
            height: 130,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: getCardItems.length,
              itemBuilder: (context, index) {
                return getCardItems[index];
              },
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            flex: 0,
            child: ReportHeader(
              backgroundColor: AppColors.appColorGrey700.withOpacity(0.5),
              headers: [
                HeaderStruct(
                  title: 'Mijoz nomi',
                  index: 0,
                  activeIndex: activeIndex,
                  desc: descending,
                  sort: () {
                    if (descending) {
                      clientTrades.sort((a, b) => b.client?.name.compareTo(a.client?.name ?? "") ?? 0);
                    } else {
                      clientTrades.sort((a, b) => a.client?.name.compareTo(b.client?.name ?? "") ?? 0);
                    }
                    setState(() {
                      descending = !descending;
                      activeIndex = 0;
                    });
                  },
                ),
                HeaderStruct(
                  title: 'Savdo',
                  index: 1,
                  activeIndex: activeIndex,
                  desc: descending,
                  sort: () {
                    if (descending) {
                      clientTrades.sort((a, b) => b.trades
                          .fold(
                              0.0,
                              (previousValue, element) =>
                                  previousValue +
                                  element.productsInTrade
                                      .fold(0.0, (previousValue, element) => previousValue + element.amount * element.price))
                          .compareTo(a.trades.fold(
                              0.0,
                              (previousValue, element) =>
                                  previousValue +
                                  element.productsInTrade
                                      .fold(0.0, (previousValue, element) => previousValue + element.amount * element.price))));
                    } else {
                      clientTrades.sort((a, b) => a.trades
                          .fold(
                              0.0,
                              (previousValue, element) =>
                                  previousValue +
                                  element.productsInTrade
                                      .fold(0.0, (previousValue, element) => previousValue + element.amount * element.price))
                          .compareTo(b.trades.fold(
                              0.0,
                              (previousValue, element) =>
                                  previousValue +
                                  element.productsInTrade
                                      .fold(0.0, (previousValue, element) => previousValue + element.amount * element.price))));
                    }
                    setState(() {
                      descending = !descending;
                      activeIndex = 1;
                    });
                  },
                ),
                HeaderStruct(
                  title: ' To\'lov',
                  index: 2,
                  activeIndex: activeIndex,
                  desc: descending,
                  sort: () {
                    if (descending) {
                      clientTrades.sort((a, b) => b.trades
                          .fold(
                              0.0,
                              (previousValue, element) =>
                                  previousValue +
                                  element.invoices.fold(0.0, (previousValue, element) => previousValue + element.amount))
                          .compareTo(a.trades.fold(
                              0.0,
                              (previousValue, element) =>
                                  previousValue +
                                  element.invoices.fold(0.0, (previousValue, element) => previousValue + element.amount))));
                    } else {
                      clientTrades.sort((a, b) => a.trades
                          .fold(
                              0.0,
                              (previousValue, element) =>
                                  previousValue +
                                  element.invoices.fold(0.0, (previousValue, element) => previousValue + element.amount))
                          .compareTo(b.trades.fold(
                              0.0,
                              (previousValue, element) =>
                                  previousValue +
                                  element.invoices.fold(0.0, (previousValue, element) => previousValue + element.amount))));
                    }
                    setState(() {
                      descending = !descending;
                      activeIndex = 2;
                    });
                  },
                ),
                HeaderStruct(
                  title: ' Umumiy soni',
                  index: 3,
                  activeIndex: activeIndex,
                  desc: descending,
                  sort: () {
                    if (descending) {
                      clientTrades.sort((a, b) => b.trades.length.compareTo(a.trades.length));
                    } else {
                      clientTrades.sort((a, b) => a.trades.length.compareTo(b.trades.length));
                    }
                    setState(() {
                      descending = !descending;
                      activeIndex = 3;
                    });
                  },
                ),
                HeaderStruct(
                  title: ' Ortacha chek',
                  index: 4,
                  activeIndex: activeIndex,
                  desc: descending,
                  sort: () {
                    // if (descending) {
                    //
                    // }
                    // setState(() {
                    //   descending = !descending;
                    //   activeIndex = 3;
                    // });
                  },
                ),
              ],
            ),
          ),
          loading
              ? Center(child: CircularProgressIndicator(color: AppColors.appColorGreen400))
              : errorMessage != null
                  ? Center(child: Text(errorMessage ?? "", style: TextStyle(color: AppColors.appColorRed400)))
                  : Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.only(left: 5, top: 5),
                        itemCount: clientTrades.length,
                        itemBuilder: (context, index) {
                          return TradeItem(trade: clientTrades[index]);
                        },
                        separatorBuilder: (context, index) =>
                            Divider(color: AppColors.appColorGrey700.withOpacity(0.5), thickness: 1, height: 0),
                      ),
                    ),
        ],
      ),
    );
  }
}

class TradeItem extends StatefulWidget {
  const TradeItem({super.key, required this.trade});

  final ClientTradeStruct trade;

  @override
  State<TradeItem> createState() => _TradeItemState();
}

class _TradeItemState extends State<TradeItem> {
  ClientTradeStruct get trade => widget.trade;

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
                  trade.client?.name ?? "Tanlanmagan",
                  style: TextStyle(color: AppColors.appColorWhite, fontSize: 16),
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
                  formatNumber(
                    trade.trades.fold(
                      0.0,
                      (previousValue, element) =>
                          previousValue +
                          element.productsInTrade
                              .fold(0.0, (previousValue, element) => previousValue + element.amount * element.price),
                    ),
                  ),
                  style: TextStyle(color: AppColors.appColorWhite, fontSize: 16),
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
                  formatNumber(trade.trades.fold(
                      0.0,
                      (previousValue, element) =>
                          previousValue +
                          element.invoices.fold(0.0, (previousValue, element) => previousValue + element.amount))),
                  style: TextStyle(color: AppColors.appColorWhite, fontSize: 16),
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
                  formatNumber(trade.trades.length),
                  style: TextStyle(color: AppColors.appColorWhite, fontSize: 16),
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
                  formatNumber(
                    trade.trades.fold(
                          0.0,
                          (previousValue, element) =>
                              previousValue +
                              element.productsInTrade
                                  .fold(0.0, (previousValue, element) => previousValue + element.amount * element.price),
                        ) /
                        trade.trades.length,
                  ),
                  style: TextStyle(color: AppColors.appColorWhite, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ClientTradeStruct {
  ClientDto? client;
  List<TradeStruct> trades = [];

  ClientTradeStruct({this.client, required this.trades});
}
