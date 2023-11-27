import 'dart:convert';
import 'package:easy_sell/database/model/trade_product_full_report.dart';
import 'package:easy_sell/services/https_services.dart';
import 'package:easy_sell/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
import '../../../constants/colors.dart';
import '../../../services/excel_service.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_calendar_dialog.dart';
import '../../../widgets/app_input_underline.dart';
import '../../../widgets/app_list_performed.dart';

class ReportTradeFullInfo extends StatefulWidget {
  const ReportTradeFullInfo({super.key});

  @override
  State<ReportTradeFullInfo> createState() => _ReportTradeFullInfoState();
}

class _ReportTradeFullInfoState extends State<ReportTradeFullInfo> {
  final TextEditingController _dateController = TextEditingController();
  DateTime? _startDate = DateTime.now().copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
  DateTime? _endDate = DateTime.now();
  int organizationId = -1;
  bool loading = false;
  int size = 1000000000;
  List<TradeProductFullStruct> trades = [];
  String? errorMessage;
  int activeIndex = 0;
  bool descending = false;
  int total = 0;

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
      var response = await HttpServices.post("/report/trade-product-full-report", {
        'from': _startDate!.millisecondsSinceEpoch,
        'to': _endDate!.millisecondsSinceEpoch,
      });
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      // print(response.statusCode);
      // print(json);
      trades = [];
      total = json.length;
      for (var item in json) {
        trades.add(TradeProductFullStruct.fromJson(item));
      }
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

  final List<String> header = const [
    'Mahsulot',
    'Taminotchi kodi',
    'Artikul',
    'Savdo soni',
    'Savdo summasi',
    'Sotuv narxi',
    'Boshlang\'ich qoldiq',
    'So\'nggi qoldiq',
    'Jami kirim',
    'Yetkazib berilgan',
    'Mijozdan qaytgan',
    'Taminotchidan qaytgan',
    'Savdo',
    'Sarflar',
    'Kirim narxi',
  ];

  int rowPerPage = 20;
  double cellWidth = 200;
  int cellHeight = 50;
  int cellCount = 15;

  ScrollController horizontalScrollController = ScrollController();
  ScrollController verticalScrollController = ScrollController();

  List<List<String>> listBuilder(List<TradeProductFullStruct> trades) {
    return trades
        .map((e) => [
              e.product.name,
              e.product.vendorCode ?? '',
              e.product.code ?? '',
              formatNumber(e.tradeAmount),
              formatNumber(e.tradeSum),
              formatNumber(e.price),
              formatNumber(e.startAmount),
              formatNumber(e.endAmount),
              formatNumber(e.totalIncome),
              formatNumber(e.totalTransfer),
              formatNumber(e.totalReturnFromCustomer),
              formatNumber(e.totalReturnToSupplier),
              formatNumber(e.totalProductTrade),
              formatNumber(e.totalWriteOff),
              formatNumber(e.costPrice),
            ])
        .toList();
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
                            style: TextStyle(color: AppColors.appColorWhite, fontSize: 14),
                          ),
                          trades.isNotEmpty
                              ? Row(
                                children: [
                                  AppButton(
                                    onTap: () async {
                                      await ExcelService.createTxtFile([header, ...listBuilder(trades)], 'Maxsulot savdo xisoboti', context);
                                    },
                                    tooltip: 'Text ga yuklash',
                                    width: 35,
                                    height: 35,
                                    margin: const EdgeInsets.all(7),
                                    hoverColor: AppColors.appColorGreen300,
                                    colorOnClick: AppColors.appColorGreen700,
                                    splashColor: AppColors.appColorGreen700,
                                    borderRadius: BorderRadius.circular(10),
                                    hoverRadius: BorderRadius.circular(10),
                                    child: Icon(Icons.text_snippet_outlined, color: AppColors.appColorWhite, size: 21),
                                  ),
                                  AppButton(
                                      onTap: () async {
                                        await ExcelService.createExcelFile(
                                            [header, ...listBuilder(trades)], 'Savdo xisoboti', context);
                                      },
                                      tooltip: 'Excelga yuklash',
                                      width: 35,
                                      height: 35,
                                      margin: const EdgeInsets.all(7),
                                      hoverColor: AppColors.appColorGreen300,
                                      colorOnClick: AppColors.appColorGreen700,
                                      splashColor: AppColors.appColorGreen700,
                                      borderRadius: BorderRadius.circular(10),
                                      hoverRadius: BorderRadius.circular(10),
                                      child: Icon(Icons.downloading, color: AppColors.appColorWhite, size: 21),
                                    ),

                                ],
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
            flex: 10,
            child: loading
                ? Center(child: CircularProgressIndicator(color: AppColors.appColorGreen400))
                : errorMessage != null
                ? SizedBox(
                        height: 100,
                        child: Center(
                          child: Text(errorMessage ?? '', style: TextStyle(color: AppColors.appColorWhite, fontSize: 14)),
                        ),
                      )
                    : trades.isEmpty
                        ? SizedBox(
                            height: 100,
                            child: Center(
                              child: Text('Ma\'lumotlar bo\'sh', style: TextStyle(color: AppColors.appColorWhite, fontSize: 14)),
                            ),
                          )
                        : Scrollbar(
                            controller: horizontalScrollController,
                            thumbVisibility: true,
                            child: SingleChildScrollView(
                              controller: horizontalScrollController,
                              scrollDirection: Axis.horizontal,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 40,
                                    width: cellCount * cellWidth,
                                    child: AppListPerformedWidget(
                                      backgroundColor: AppColors.appColorGrey700.withOpacity(0.5),
                                      cellWidth: cellWidth,
                                      data: [
                                        header,
                                      ]
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height - 190,
                                    width: cellCount * cellWidth,
                                    child: AppListPerformedWidget(
                                      cellWidth: cellWidth,
                                      data: [
                                        // header,
                                        ...listBuilder(trades),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}

class TradeItem extends StatefulWidget {
  const TradeItem({super.key, required this.trade});

  final TradeProductFullStruct trade;

  @override
  State<TradeItem> createState() => _TradeItemState();
}

class _TradeItemState extends State<TradeItem> {
  TradeProductFullStruct get trade => widget.trade;

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
                  trade.product.name,
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
                  trade.product.vendorCode ?? '',
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
                  trade.product.code ?? '',
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
                  formatNumber(trade.tradeAmount),
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
                  formatNumber(trade.tradeSum),
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
                  formatNumber(trade.price),
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
                  formatNumber(trade.startAmount),
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
                  formatNumber(trade.endAmount),
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
                  formatNumber(trade.totalIncome),
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
                  formatNumber(trade.totalTransfer),
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
                  formatNumber(trade.totalReturnFromCustomer),
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
                  formatNumber(trade.totalReturnToSupplier),
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
                  formatNumber(trade.totalProductTrade),
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
                  formatNumber(trade.totalWriteOff),
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
                  formatNumber(trade.costPrice),
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
