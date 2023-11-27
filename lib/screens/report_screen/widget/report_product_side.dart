import 'dart:convert';
import 'package:easy_sell/services/https_services.dart';
import 'package:easy_sell/utils/utils.dart';
import 'package:easy_sell/widgets/app_table_item.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
import '../../../constants/colors.dart';
import '../../../database/model/trade_struct.dart';
import '../../../database/my_database.dart';
import '../../../services/excel_service.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_calendar_dialog.dart';
import '../../../widgets/app_input_underline.dart';

class ReportProductSide extends StatefulWidget {
  const ReportProductSide({super.key});

  @override
  State<ReportProductSide> createState() => _ReportProductSideState();
}

class _ReportProductSideState extends State<ReportProductSide> {
  final TextEditingController _dateController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  int organizationId = -1;
  bool loading = false;
  int total = 0;
  List<TradeStruct> trades = [];
  List<TradeProductStruct> tradeProducts = [];
  String? errorMessage;
  int activeIndex = 0;
  bool descending = false;
  double progressPercent = 0;

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
      var endDate = _endDate?.add(const Duration(minutes: 59, seconds: 59, hours: 23));
      var response = await HttpServices.post("/report/trade-product-report", {
        'from': (_startDate?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch),
        'to': (endDate?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch),
      });
      var json = jsonDecode(response.body);
      List<TradeProductStruct> _tradeProducts = [];
      for (var item in json) {
        _tradeProducts.add(TradeProductStruct.fromJson(item));
      }
      setState(() {
        tradeProducts = _tradeProducts;
        loading = false;
        errorMessage = null;
        total = json.length;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        loading = false;
      });
    }
  }

  Stream<List<TradeStruct>> getTradeStream() async* {
    yield trades;
  }

  void getOrganizationId() async {
    var json = jsonDecode((await HttpServices.get('/user/get-me')).body);
    setState(() {
      organizationId = json['organization']['id'];
    });
  }

  List<String> headers = [
    'Taminotchi artikuli',
    'Artikul',
    'Qoldiq(b)',
    'Sotuv miqdori',
    'Umumiy Kirim',
    'Qoldiq(o)',
    'Sotuv narxi',
    'Sotuv summasi',
    'Tan narxi',
    'Tan narx summasi',
    'Foyda',
    'Rentabellik',
    'Miqdoriy %',
  ];

  String searchTerm = '';

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
                  children: [
                    SizedBox(
                      width: 250,
                      height: 45,
                      child: AppInputUnderline(
                        hintText: 'Qidirish',
                        onChanged: (value) {
                          setState(() {
                            searchTerm = value;
                          });
                        },
                        prefixIcon: UniconsLine.search,
                        iconSize: 25,
                        keyboardType: TextInputType.number,
                        outlineBorder: true,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: _startDate != null || _endDate != null
                      ? [
                          Text(
                            'Jami Savdo: ${formatNumber(total)} ta',
                            style: TextStyle(fontSize: 16, color: AppColors.appColorWhite),
                          ),
                          const SizedBox(width: 10),
                          tradeProducts.isNotEmpty
                              ? AppButton(
                                  onTap: () async {
                                    List data = tradeProducts.map((TradeProductStruct e) {
                                      return [
                                        e.product.vendorCode,
                                        e.product.code,
                                        e.stock,
                                        e.totalAmount,
                                        e.totalIncome,
                                        e.endStock,
                                        e.latestPrice,
                                        e.totalPrice,
                                        e.incomePrice,
                                        e.incomePrice * e.totalAmount,
                                        e.totalPrice - (e.incomePrice * e.totalAmount),
                                        e.profitPercent,
                                        e.stockPercent,
                                      ];
                                    }).toList();
                                    await ExcelService.createExcelFile([headers, ...data], 'Maxsulot savdo xisoboti', context);
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
                          tradeProducts.isNotEmpty
                              ? AppButton(
                                  onTap: () async {
                                    List data = tradeProducts.map((e) {
                                      return [
                                        e.product.vendorCode,
                                        e.product.code,
                                        e.stock,
                                        e.totalAmount,
                                        e.totalIncome,
                                        e.endStock,
                                        e.latestPrice,
                                        e.totalPrice,
                                        e.incomePrice,
                                        e.incomePrice * e.totalAmount,
                                        e.totalPrice - (e.incomePrice * e.totalAmount),
                                        e.profitPercent,
                                        e.stockPercent
                                      ];
                                    }).toList();
                                    // txt file
                                    await ExcelService.createTxtFile([headers, ...data], 'Maxsulot savdo xisoboti', context);
                                  },
                                  tooltip: 'Text ga yuklash',
                                  width: 35,
                                  height: 35,
                                  margin: const EdgeInsets.all(7),
                                  hoverColor: AppColors.appColorGreen300,
                                  colorOnClick: AppColors.appColorGreen700,
                                  splashColor: AppColors.appColorGreen700,
                                  borderRadius: BorderRadius.circular(30),
                                  hoverRadius: BorderRadius.circular(30),
                                  child: Icon(Icons.text_snippet_outlined, color: AppColors.appColorWhite, size: 21),
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
          const SizedBox(height: 10),
          AppTableItems(
            backgroundColor: AppColors.appColorGrey700.withOpacity(0.5),
            layouts: const [2, 2, 1, 1, 1, 1, 1, 2, 1, 2, 1, 1, 1],
            height: 50,
            items: headers.map((e) {
              int index = headers.indexOf(e);
              bool isLast = index == headers.length - 1;
              bool isFirst = index == 0;
              return AppTableItemStruct(
                innerWidget: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (activeIndex == index)
                      Icon(
                        descending ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                        color: AppColors.appColorWhite,
                        size: 16,
                      ),
                    Expanded(
                      child: Tooltip(
                        message: e,
                        child: TextButton(
                          onPressed: () => {
                            // sort
                            setState(() {
                              tradeProducts.sort((a, b) {
                                switch (index) {
                                  case 0:
                                    return descending
                                        ? (a.product.vendorCode ?? '').compareTo(b.product.vendorCode ?? '')
                                        : (b.product.vendorCode ?? '').compareTo(a.product.vendorCode ?? '');
                                  case 1:
                                    return descending
                                        ? (a.product.code ?? '').compareTo(b.product.code ?? '')
                                        : (b.product.code ?? '').compareTo(a.product.code ?? '');
                                  case 2:
                                    return descending ? a.stock.compareTo(b.stock) : b.stock.compareTo(a.stock);
                                  case 3:
                                    return descending
                                        ? a.totalAmount.compareTo(b.totalAmount)
                                        : b.totalAmount.compareTo(a.totalAmount);
                                  case 4:
                                    return descending
                                        ? a.totalIncome.compareTo(b.totalIncome)
                                        : b.totalIncome.compareTo(a.totalIncome);
                                  case 5:
                                    return descending ? a.endStock.compareTo(b.endStock) : b.endStock.compareTo(a.endStock);
                                  case 6:
                                    return descending
                                        ? a.latestPrice.compareTo(b.latestPrice)
                                        : b.latestPrice.compareTo(a.latestPrice);
                                  case 7:
                                    return descending
                                        ? a.totalPrice.compareTo(b.totalPrice)
                                        : b.totalPrice.compareTo(a.totalPrice);
                                  case 8:
                                    return descending
                                        ? a.incomePrice.compareTo(b.incomePrice)
                                        : b.incomePrice.compareTo(a.incomePrice);
                                  case 9:
                                    return descending
                                        ? (a.incomePrice * a.totalAmount).compareTo(b.incomePrice * b.totalAmount)
                                        : (b.incomePrice * b.totalAmount).compareTo(a.incomePrice * a.totalAmount);
                                  case 10:
                                    return descending ? a.profit.compareTo(b.profit) : b.profit.compareTo(a.profit);
                                  case 11:
                                    return descending
                                        ? a.profitPercent.compareTo(b.profitPercent)
                                        : b.profitPercent.compareTo(a.profitPercent);
                                  case 12:
                                    return descending
                                        ? a.stockPercent.compareTo(b.stockPercent)
                                        : b.stockPercent.compareTo(a.stockPercent);
                                  default:
                                    return descending
                                        ? a.product.name.compareTo(b.product.name)
                                        : b.product.name.compareTo(a.product.name);
                                }
                              });
                              descending = !descending;
                              activeIndex = index;
                            })
                          },
                          child: Text(
                            e,
                            style: TextStyle(color: AppColors.appColorWhite),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: isFirst
                                ? TextAlign.start
                                : isLast
                                    ? TextAlign.end
                                    : TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          Expanded(
            child: loading
                ? Center(child: CircularProgressIndicator(color: AppColors.appColorGreen400))
                : errorMessage != null
                    ? Center(child: Text(errorMessage ?? "", style: TextStyle(color: AppColors.appColorRed400)))
                    : ListView.builder(
                        itemExtent: 50,
                        cacheExtent: 3000,
                        padding: const EdgeInsets.all(0),
                        itemBuilder: (context, index) {
                          TradeProductStruct product = tradeProducts.where((element) {
                            return (element.product.code ?? '').toLowerCase().contains(searchTerm.toLowerCase());
                          }).toList()[index];
                          return TradeProductItem(product: product);
                        },
                        itemCount: tradeProducts.where((element) {
                          return (element.product.code ?? '').toLowerCase().contains(searchTerm.toLowerCase());
                        }).length),
          ),
        ],
      ),
    );
  }
}

class TradeProductItem extends StatefulWidget {
  const TradeProductItem({super.key, required this.product});

  final TradeProductStruct product;

  @override
  State<TradeProductItem> createState() => _TradeProductItemState();
}

class _TradeProductItemState extends State<TradeProductItem> with AutomaticKeepAliveClientMixin {
  TradeProductStruct get product => widget.product;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AppTableItems(
      height: 50,
      layouts: const [2, 2, 1, 1, 1, 1, 1, 2, 1, 2, 1, 1, 1],
      items: [
        AppTableItemStruct(
          innerWidget: Center(
            child: Text(
              '${product.product.vendorCode}',
              style: TextStyle(color: AppColors.appColorWhite),
              textAlign: TextAlign.start,
            ),
          ),
        ),
        AppTableItemStruct(
          innerWidget: Center(
            child: Text(
              '${product.product.code}',
              style: TextStyle(color: AppColors.appColorWhite),
              textAlign: TextAlign.start,
            ),
          ),
        ),
        AppTableItemStruct(
          innerWidget: Center(
            child: Text(
              formatNumber(product.stock),
              style: TextStyle(color: AppColors.appColorWhite),
              textAlign: TextAlign.start,
            ),
          ),
        ),
        AppTableItemStruct(
          innerWidget: Center(
            child: Text(
              formatNumber(product.totalAmount),
              style: TextStyle(color: AppColors.appColorWhite),
              textAlign: TextAlign.start,
            ),
          ),
        ),
        AppTableItemStruct(
          innerWidget: Center(
            child: Text(
              formatNumber(product.totalIncome),
              style: TextStyle(color: AppColors.appColorWhite),
              textAlign: TextAlign.start,
            ),
          ),
        ),
        AppTableItemStruct(
          innerWidget: Center(
            child: Text(
              formatNumber(product.endStock),
              style: TextStyle(color: AppColors.appColorWhite),
              textAlign: TextAlign.start,
            ),
          ),
        ),
        AppTableItemStruct(
          innerWidget: Center(
            child: Text(
              formatNumber(product.latestPrice),
              style: TextStyle(color: AppColors.appColorWhite),
              textAlign: TextAlign.start,
            ),
          ),
        ),
        AppTableItemStruct(
          innerWidget: Center(
            child: Text(
              formatNumber(product.totalPrice),
              style: TextStyle(color: AppColors.appColorWhite),
              textAlign: TextAlign.start,
            ),
          ),
        ),
        AppTableItemStruct(
          innerWidget: Center(
            child: Text(
              formatNumber(product.incomePrice),
              style: TextStyle(color: AppColors.appColorWhite),
              textAlign: TextAlign.start,
            ),
          ),
        ),
        AppTableItemStruct(
          innerWidget: Center(
            child: Text(
              formatNumber(product.incomePrice * product.totalAmount),
              style: TextStyle(color: AppColors.appColorWhite),
              textAlign: TextAlign.start,
            ),
          ),
        ),
        AppTableItemStruct(
          innerWidget: Center(
            child: Text(
              formatNumber(product.profit),
              style: TextStyle(color: AppColors.appColorWhite),
              textAlign: TextAlign.start,
            ),
          ),
        ),
        AppTableItemStruct(
          innerWidget: Center(
            child: Text(
              formatNumber(product.profitPercent),
              style: TextStyle(color: AppColors.appColorWhite),
              textAlign: TextAlign.start,
            ),
          ),
        ),
        AppTableItemStruct(
          innerWidget: Center(
            child: Text(
              formatNumber(product.stockPercent),
              style: TextStyle(color: AppColors.appColorWhite),
              textAlign: TextAlign.start,
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class TradeProductStruct {
  ProductData product;
  double totalAmount;
  double totalPrice;
  double stock;
  double endStock;
  double latestPrice;
  double incomePrice;

  TradeProductStruct({
    required this.product,
    required this.totalAmount,
    required this.totalPrice,
    this.stock = 0,
    this.endStock = 0,
    this.latestPrice = 0,
    this.incomePrice = 0,
  });

  double get totalIncome => totalAmount + endStock - stock;

  // calculate profit
  double get profit => totalPrice - incomePrice * totalAmount;

  // set profit
  set profit(double value) => totalPrice = value;

  // calculate profit percent
  double get profitPercent => (latestPrice - incomePrice) / latestPrice * 100;

  // set profit percent
  set profitPercent(double value) => totalPrice = value;

  // calculate stock percent
  double get stockPercent => (totalAmount / (endStock + totalAmount)) * 100;

  // set stock percent
  set stockPercent(double value) => totalPrice = value;

  @override
  String toString() {
    return 'TradeProductStruct(product: $product, totalAmount: $totalAmount, totalPrice: $totalPrice, stock: $stock, latestPrice: $latestPrice, incomePrice: $incomePrice)';
  }

  static TradeProductStruct fromJson(item) {
    item['product']['isKit'] = item['product']['kit'];
    item['product']['productsInBox'] = item['product']['productsInBox'].toString();
    item['product']['isSynced'] = true;
    item['product']['serverId'] = item['product']['id'];
    return TradeProductStruct(
      product: ProductData.fromJson(item['product']),
      totalAmount: item['tradeAmount'],
      totalPrice: item['tradeSum'],
      stock: item['startAmount'],
      endStock: item['endAmount'],
      latestPrice: item['price'],
      incomePrice: item['costPrice'],
    );
  }
}
