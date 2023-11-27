import 'package:easy_sell/database/dao/posSession_dao.dart';
import 'package:easy_sell/database/model/trade_dto.dart';
import 'package:easy_sell/database/my_database.dart';
import 'package:easy_sell/database/table/invoice_table.dart';
import 'package:easy_sell/screens/sell_screen/screens/trade_history_screen/widgets/trade_history_item_info.dart';
import 'package:easy_sell/screens/sell_screen/screens/trade_history_screen/widgets/trade_history_item.dart';
import 'package:easy_sell/screens/sell_screen/screens/trade_history_screen/widgets/trade_session_total_info.dart';
import 'package:easy_sell/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';
import '../../../../constants/colors.dart';
import '../../../../services/excel_service.dart';
import '../../../../utils/translator.dart';
import '../../../../widgets/app_button.dart';

class TradeHistoryScreen extends StatefulWidget {
  const TradeHistoryScreen({Key? key}) : super(key: key);

  @override
  State<TradeHistoryScreen> createState() => _TradeHistoryScreenState();
}

class _TradeHistoryScreenState extends State<TradeHistoryScreen> {
  List<PosSessionDTO> _posSessions = [];
  MyDatabase database = Get.find<MyDatabase>();
  int _initialPosSessionIndex = -1;
  bool loading = false;
  List<TradeDTO> filteredTrades = [];
  int _tradesCount = 0;
  int _returnedTradesCount = 0;
  double _paymentsTotalSum = 0;
  double _tradesTotalSum = 0;
  double _returnedTradesTotalSum = 0;
  double _paymentCashTotal = 0;
  double _paymentCardTotal = 0;

  @override
  void initState() {
    super.initState();
    getPossession();
  }

  void getPossession() async {
    List<PosSessionDTO> posSessions = await database.posSessionDao.getAllPosSessionsWithJoin();
    setState(() {
      _posSessions = posSessions.reversed.toList();
    });
  }

  Future<void> getTradesByPosSessionId(int possessionId) async {
    List<TradeDTO> trades = await database.tradeDao.getTradesByPosSessionId(possessionId, desc: true);
    setState(() {
      filteredTrades = trades;
    });
  }

  void getTotals() {
    _tradesCount = tradesCount();
    _returnedTradesCount = returnedTradesCount();
    _tradesTotalSum = tradesTotalSum();
    _returnedTradesTotalSum = returnedTradesTotalSum();
    _paymentsTotalSum = paymentsTotalSum();
    _paymentCashTotal = paymentsCashTotal();
    _paymentCardTotal = paymentCardTotal();
  }

  @override
  Widget build(BuildContext context) {
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
        centerTitle: false,
        title: Text('Kassa tarixi', style: TextStyle(color: AppColors.appColorWhite)),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              constraints: const BoxConstraints.expand(),
              padding: const EdgeInsets.only(right: 10, left: 10, bottom: 10, top: 65),
              decoration: const BoxDecoration(color: Color(0xFF0f2228)),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    decoration: BoxDecoration(color: AppColors.appColorBlackBg, borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(UniconsLine.shopping_cart, color: AppColors.appColorWhite, size: 20),
                        Text(' Sessiyalar', style: TextStyle(color: AppColors.appColorWhite, fontWeight: FontWeight.w500, fontSize: 20)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: _posSessions.isEmpty
                        ? Center(
                            child: Text('Sessiya mavjud emas', style: TextStyle(color: AppColors.appColorWhite.withOpacity(0.5), fontSize: 20)),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.all(0),
                            itemCount: _posSessions.length,
                            separatorBuilder: (context, index) => const Divider(color: Colors.white24, height: 1),
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                decoration: BoxDecoration(
                                  color: _initialPosSessionIndex == index ? AppColors.appColorWhite.withOpacity(0.2) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  hoverColor: AppColors.appColorGreen300,
                                  contentPadding: const EdgeInsets.all(0),
                                  splashColor: AppColors.appColorGreen300,
                                  minVerticalPadding: 0,
                                  title: Text(
                                    'Sessiya: [${_posSessions[index].employeeData?.firstName} ${_posSessions[index].employeeData?.lastName}]',
                                    style: TextStyle(color: AppColors.appColorWhite, fontWeight: FontWeight.w500, fontSize: 16),
                                  ),
                                  subtitle: Text(
                                    '${formatDateTime(_posSessions[index].posSessionData.startTime)} • ${_posSessions[index].posSessionData.endTime != null ? formatDateTime(_posSessions[index].posSessionData.endTime) : "Yopilmagan"}',
                                    style: TextStyle(color: AppColors.appColorWhite.withOpacity(0.5), fontSize: 12),
                                  ),
                                  onTap: () async {
                                    await getTradesByPosSessionId(_posSessions[index].posSessionData.id);
                                    setState(() {
                                      _initialPosSessionIndex = index;
                                      getTotals();
                                    });
                                  },
                                  trailing: Tooltip(
                                    message: 'Excelga yuklash',
                                    child: AppButton(
                                      onTap: () async {
                                        List<TradeDTO> all = await database.tradeDao.getAllWithJoin(sessionId: _posSessions[index].posSessionData.id);
                                        List header = ['ID', "Savdo turi", 'Mijoz', 'Sana', 'Mahsulotlar', "To'lov", "To'lov turi", "Chegirma"];
                                        List data = [];
                                        for (var e in all) {
                                          String clientName = '';
                                          if (e.trade.clientId != null) {
                                            ClientData? client = await database.clientDao.getById(e.trade.clientId ?? -1);
                                            clientName = client.name;
                                          }
                                          data.add([
                                            e.trade.id,
                                            e.trade.isReturned ? 'Vozvrat' : 'Savdo',
                                            clientName,
                                            e.trade.createdAt.toString().split(' ')[0],
                                            e.tradeProducts
                                                .map((e) => " ${e.product.productData.name} dan ${e.tradeProduct.amount} ta ${e.tradeProduct.price} so'mdan")
                                                .join('\n'),
                                            e.invoices.map((e) => e.amount).join('\n'),
                                            e.invoices.map((e) => translate(e.payType.name)).join('\n / '),
                                            e.trade.discount
                                          ]);
                                        }
                                        await ExcelService.createExcelFile([header, ...data], 'Savdolar sessiya boyicha', context);
                                      },
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
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
          const VerticalDivider(width: 0.4, color: Colors.white),
          Expanded(
            flex: 3,
            child: Container(
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
                  const TradeHistoryItemInfo(),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(17), bottomRight: Radius.circular(17)),
                        color: AppColors.appColorBlackBg,
                      ),
                      child: loading
                          ? Center(child: CircularProgressIndicator(color: AppColors.appColorGreen700))
                          : (filteredTrades.isEmpty)
                              ? Center(
                                  child: Text(
                                    _initialPosSessionIndex == -1 ? 'Sessiya tanlanmagan' : 'Savdo mavjud emas',
                                    style: TextStyle(color: AppColors.appColorWhite, fontSize: 20),
                                  ),
                                )
                              : SingleChildScrollView(
                                  child: ListView.separated(
                                    padding: const EdgeInsets.only(top: 5),
                                    itemCount: filteredTrades.length,
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (BuildContext context, int index) {
                                      return TradeHistoryItem(
                                        trade: filteredTrades[index],
                                      );
                                    },
                                    separatorBuilder: (BuildContext context, int index) {
                                      return const Divider(height: 1, color: Colors.white24);
                                    },
                                  ),
                                ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _initialPosSessionIndex == -1
                      ? const SizedBox()
                      : TradeSessionTotalInfo(
                          filteredTrades: filteredTrades,
                          tradesCount: _tradesCount,
                          returnedTradesCount: _returnedTradesCount,
                          tradesTotalSum: _tradesTotalSum,
                          returnedTradesTotalSum: _returnedTradesTotalSum,
                          paymentsTotalSum: _paymentsTotalSum,
                          paymentCashTotal: _paymentCashTotal,
                          paymentCardTotal: _paymentCardTotal,
                        )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  int tradesCount() {
    if (filteredTrades.isNotEmpty) {
      int totalTrades = filteredTrades.where((element) => element.trade.isReturned == false).length;
      return totalTrades;
    } else {
      return 0;
    }
  }

  int returnedTradesCount() {
    if (filteredTrades.isNotEmpty) {
      int totalReturnedTrades = filteredTrades.where((element) => element.trade.isReturned == true).length;
      return totalReturnedTrades;
    } else {
      return 0;
    }
  }

  double paymentsTotalSum() {
    double paymentTotalAmount = 0;
    for (var payment in filteredTrades) {
      if (payment.invoices.isNotEmpty) {
        double paymentTotal = payment.invoices.map((invoice) => invoice.amount).reduce((value, element) => value + element);
        paymentTotalAmount += paymentTotal;
      }
    }
    return paymentTotalAmount;
  }

  double tradesTotalSum() {
    double sum = 0;
    double discount = 0;
    for (var trade in filteredTrades) {
      if (trade.trade.isReturned == false) {
        discount += trade.trade.discount ?? 0;
        sum += trade.tradeProducts.map((e) => e.tradeProduct.price * e.tradeProduct.amount).reduce((value, element) => value + element);
      }
    }
    return sum - discount;
  }

  double returnedTradesTotalSum() {
    double sum = 0;
    for (var trade in filteredTrades) {
      if (trade.trade.isReturned == true) {
        sum += trade.tradeProducts.map((e) => e.tradeProduct.price * e.tradeProduct.amount).reduce((value, element) => value + element);
      }
    }
    return sum;
  }

  double paymentsCashTotal() {
    double sum = 0;
    for (var trade in filteredTrades) {
      if (trade.invoices.isNotEmpty) {
        sum += trade.invoices.fold(0, (previousValue, element) {
          if (element.payType == InvoiceType.CASH) {
            return previousValue + element.amount;
          } else {
            return previousValue;
          }
        });
      }
    }
    return sum;
  }

  double paymentCardTotal() {
    double sum = 0;
    for (var trade in filteredTrades) {
      if (trade.invoices.isNotEmpty) {
        sum += trade.invoices.fold(0, (previousValue, element) {
          if (element.payType == InvoiceType.CARD) {
            return previousValue + element.amount;
          } else {
            return previousValue;
          }
        });
      }
    }
    return sum;
  }
}
