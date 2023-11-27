import 'dart:convert';
import 'package:easy_sell/database/my_database.dart';
import 'package:easy_sell/screens/report_screen/widget/report_header.dart';
import 'package:easy_sell/services/https_services.dart';
import 'package:easy_sell/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
import '../../../constants/colors.dart';
import '../../../database/model/transactions_dto.dart';
import '../../../database/model/trade_struct.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_calendar_dialog.dart';
import '../../../widgets/app_input_underline.dart';

class ReportPosSide extends StatefulWidget {
  const ReportPosSide({super.key});

  @override
  State<ReportPosSide> createState() => _ReportPosSideState();
}

class _ReportPosSideState extends State<ReportPosSide> {
  final TextEditingController _dateController = TextEditingController();
  DateTime? _startDate = DateTime.now();
  DateTime? _endDate = DateTime.now();
  int organizationId = -1;
  bool loading = false;
  int size = 1000000000;
  int total = 0;
  List<TradeStruct> trades = [];
  List<PosTradeStruct> clientTrades = [];
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
        if (item['deleted'] == false) {
          trades.add(TradeStruct.fromJson(item));
        }
      }
      List<PosTradeStruct> tempClientTrades = [];
      for (var trade in trades) {
        bool isExist = false;

        for (var clientTrade in tempClientTrades) {
          if (clientTrade.pos?.id == trade.posSession?.pos.id) {
            clientTrade.trades.add(trade);
            isExist = true;
            break;
          }
        }
        if (!isExist) {
          tempClientTrades.add(PosTradeStruct(pos: trade.posSession?.pos, trades: [trade]));
        }
      }
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
    setState(() {
      organizationId = json['organization']['id'];
    });
  }

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
                          // clientTrades.isNotEmpty
                          //     ? AppButton(
                          //         onTap: () async {
                          //           List header = ['Mijoz nomi', 'Savdo', 'To\'lov', 'Umumiy savdo soni', 'Ortacha chek'];
                          //           List data = clientTrades
                          //               .map((e) => [
                          //                     e.client?.name ?? "Tanlanmagan",
                          //                     e.trades.fold(
                          //                       0.0,
                          //                       (previousValue, element) =>
                          //                           previousValue +
                          //                           element.productsInTrade.fold(
                          //                               0.0,
                          //                               (previousValue, element) =>
                          //                                   previousValue + element.amount * element.price),
                          //                     ),
                          //                     e.trades.fold(
                          //                         0.0,
                          //                         (previousValue, element) =>
                          //                             previousValue +
                          //                             element.invoices
                          //                                 .fold(0.0, (previousValue, element) => previousValue + element.amount)),
                          //                     formatNumber(e.trades.length),
                          //                     formatNumber(
                          //                       e.trades.fold(
                          //                             0.0,
                          //                             (previousValue, element) =>
                          //                                 previousValue +
                          //                                 element.productsInTrade.fold(
                          //                                     0.0,
                          //                                     (previousValue, element) =>
                          //                                         previousValue + element.amount * element.price),
                          //                           ) /
                          //                           e.trades.length,
                          //                     ),
                          //                   ])
                          //               .toList();
                          //           await ExcelService.createExcelFile([header, ...data], 'Mijoz savdo xisoboti', context);
                          //         },
                          //         tooltip: 'Excelga yuklash',
                          //         width: 35,
                          //         height: 35,
                          //         margin: const EdgeInsets.all(7),
                          //         hoverColor: AppColors.appColorGreen300,
                          //         colorOnClick: AppColors.appColorGreen700,
                          //         splashColor: AppColors.appColorGreen700,
                          //         borderRadius: BorderRadius.circular(30),
                          //         hoverRadius: BorderRadius.circular(30),
                          //         child: Icon(Icons.downloading, color: AppColors.appColorWhite, size: 21),
                          //       )
                          //     : const SizedBox(),
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
                HeaderStruct(title: 'Kassa nomi', index: 0, activeIndex: activeIndex, desc: descending, sort: () {}),
                HeaderStruct(title: 'Savdo', index: 1, activeIndex: activeIndex, desc: descending, sort: () {}),
                HeaderStruct(title: 'Skidka', index: 1, activeIndex: activeIndex, desc: descending, sort: () {}),
                HeaderStruct(title: 'Vazvrat', index: 1, activeIndex: activeIndex, desc: descending, sort: () {}),
                HeaderStruct(title: 'Balans', index: 2, activeIndex: activeIndex, desc: descending, sort: () {}),
                HeaderStruct(title: 'Naqd', index: 4, activeIndex: activeIndex, desc: descending, sort: () {}),
                HeaderStruct(title: 'Karta', index: 5, activeIndex: activeIndex, desc: descending, sort: () {}),
                HeaderStruct(title: 'Bank', index: 6, activeIndex: activeIndex, desc: descending, sort: () {}),
                HeaderStruct(title: 'Cashback', index: 7, activeIndex: activeIndex, desc: descending, sort: () {}),
                HeaderStruct(title: 'Savdo soni', index: 8, activeIndex: activeIndex, desc: descending, sort: () {}),
                HeaderStruct(title: 'Ortacha chek', index: 9, activeIndex: activeIndex, desc: descending, sort: () {}),
              ],
            ),
          ),
          Expanded(
            child: loading
                ? Center(child: CircularProgressIndicator(color: AppColors.appColorGreen400))
                : errorMessage != null
                    ? Center(child: Text(errorMessage ?? "", style: TextStyle(color: AppColors.appColorRed400)))
                    : ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(left: 5, top: 5),
                        itemCount: clientTrades.length,
                        itemBuilder: (context, index) {
                          return TradeItem(trade: clientTrades[index]);
                        },
                        separatorBuilder: (context, index) => Divider(color: AppColors.appColorGrey700.withOpacity(0.5), thickness: 1, height: 0),
                      ),
          ),
          Column(
            children: [
              Expanded(
                flex: 0,
                child: TradeItem(
                  trade: PosTradeStruct(
                    trades: trades,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TradeItem extends StatefulWidget {
  const TradeItem({super.key, required this.trade});

  final PosTradeStruct trade;

  @override
  State<TradeItem> createState() => _TradeItemState();
}

class _TradeItemState extends State<TradeItem> {
  PosTradeStruct get trade => widget.trade;

  double get total => trade.trades.where((element) => element.returned == false).fold(
        0.0,
        (previousValue, element) =>
            previousValue +
            element.productsInTrade.fold(0.0, (previousValue, element) => previousValue + element.amount * element.price),
      );

  double get totalReturn => trade.trades.where((element) => element.returned == true).fold(
        0.0,
        (previousValue, element) =>
            previousValue +
            element.productsInTrade.fold(0.0, (previousValue, element) => previousValue + element.amount * element.price),
      );

  double get discount => trade.trades.where((element) => element.returned == false).fold(
        0.0,
        (previousValue, element) => previousValue + (element.discount ?? 0),
      );

  double get totalInvoice => trade.trades.where((element) => element.returned == false).fold(
        0.0,
        (previousValue, element) =>
            previousValue + element.invoices.fold(0.0, (previousValue, element) => previousValue + element.amount),
      );

  double get cash => trade.trades.where((element) => element.returned == false).fold(
        0.0,
        (previousValue, element) =>
            previousValue +
            element.invoices
                .where((element) => element.payType == PayType.CASH)
                .fold(0.0, (previousValue, element) => previousValue + element.amount),
      );

  double get card => trade.trades.where((element) => element.returned == false).fold(
        0.0,
        (previousValue, element) =>
            previousValue +
            element.invoices
                .where((element) => element.payType == PayType.CARD)
                .fold(0.0, (previousValue, element) => previousValue + element.amount),
      );

  double get bank => trade.trades.where((element) => element.returned == false).fold(
        0.0,
        (previousValue, element) =>
            previousValue +
            element.invoices
                .where((element) => element.payType == PayType.TRANSFER)
                .fold(0.0, (previousValue, element) => previousValue + element.amount),
      );

  double get cashback => trade.trades.where((element) => element.returned == false).fold(
        0.0,
        (previousValue, element) =>
            previousValue +
            element.invoices
                .where((element) => element.payType == PayType.CASHBACK)
                .fold(0.0, (previousValue, element) => previousValue + element.amount),
      );

  int get tradeCount => trade.trades.where((element) => element.returned == false).length;

  double get averageCheck => total / tradeCount;

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
                  trade.pos?.name ?? "Umumiy",
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
                  formatNumber(totalReturn),
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
                  formatNumber(totalInvoice - totalReturn),
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
                  formatNumber(cash - totalReturn),
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
                Text(
                  formatNumber(tradeCount),
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
                  formatNumber(averageCheck),
                  style: TextStyle(color: AppColors.appColorWhite, fontSize: 14),
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
