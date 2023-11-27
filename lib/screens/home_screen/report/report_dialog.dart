import 'dart:convert';
import 'package:easy_sell/constants/colors.dart';
import 'package:easy_sell/database/model/trade_dto.dart';
import 'package:easy_sell/database/my_database.dart';
import 'package:easy_sell/screens/home_screen/report/widgets/report_item_card.dart';
import 'package:easy_sell/screens/home_screen/report/widgets/report_type.dart';
import 'package:easy_sell/screens/home_screen/report/widgets/trade_item.dart';
import 'package:easy_sell/widgets/app_dropdown.dart';
import 'package:easy_sell/widgets/app_table_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';
import '../../../database/model/trade_product_dto.dart';
import '../../../database/table/invoice_table.dart';
import '../../../services/money_calculator_service.dart';
import '../../../utils/routes.dart';
import '../../../utils/translator.dart';
import '../../../utils/utils.dart';

class ReportWidget extends StatefulWidget {
  const ReportWidget({super.key});

  @override
  State<ReportWidget> createState() => _ReportWidgetState();
}

class _ReportWidgetState extends State<ReportWidget> {
  MyDatabase myDatabase = Get.find<MyDatabase>();
  late MoneyCalculatorService moneyCalculatorService;
  List<TradeDTO> trades = [];
  String _totalIncome = '0';
  String _totalOutcome = '0';
  String _totalSale = '0';
  double _totalReal = 0;
  double returnedMoney = 0;
  List<MoneyStructure> _moneyStructureList = [];
  List<double> tradeMoneysByType = [0, 0, 0, 0];
  List<double> incomeMoneysByType = [0, 0, 0, 0];
  List<double> outcomeMoneysByType = [0, 0, 0, 0];
  List<double> consumptionMoneysByType = [0, 0, 0, 0];
  List<double> startTime = [0, 0, 0, 0];
  List<double> endTime = [0, 0, 0, 0];
  POSData? myPos;

  bool showTypeCards = true;
  MoneyFromType filterType = MoneyFromType.SALE;

  List<Transaction> allInvoices = [];

  @override
  void initState() {
    super.initState();
    moneyCalculatorService = MoneyCalculatorService(database: myDatabase);
    getMyPos();
    getAllData();
  }

  void getMyPos() async {
    var userString = await storage.read('user');
    Map<String, dynamic> user = userString != null ? await jsonDecode(userString) : {};
    if (user['pos'] == null) {
      return;
    }
    int myPosServerId = user['pos']['id'];
    POSData? myPos_ = await myDatabase.posDao.getPosByServerId(myPosServerId);
    if (myPos_ != null) {
      setState(() {
        myPos = myPos_;
      });
    }
  }

  void getAllData() async {
    PosSessionData? posSessionData = await myDatabase.posSessionDao.getLastSession();
    trades = await myDatabase.tradeDao.getAllWithJoin(sessionId: posSessionData?.id ?? -1);
    calculateTradeInfo(trades);
    startTime[0] = await moneyCalculatorService.calculatePos(invoiceType: InvoiceType.CASH, at: posSessionData?.startTime ?? DateTime.now());
    endTime[0] = await moneyCalculatorService.calculatePos(invoiceType: InvoiceType.CASH, at: posSessionData?.endTime ?? DateTime.now());
    startTime[1] = await moneyCalculatorService.calculatePos(invoiceType: InvoiceType.CARD, at: posSessionData?.startTime ?? DateTime.now());
    endTime[1] = await moneyCalculatorService.calculatePos(invoiceType: InvoiceType.CARD, at: posSessionData?.endTime ?? DateTime.now());
    startTime[2] = await moneyCalculatorService.calculatePos(invoiceType: InvoiceType.TRANSFER, at: posSessionData?.startTime ?? DateTime.now());
    endTime[2] = await moneyCalculatorService.calculatePos(invoiceType: InvoiceType.TRANSFER, at: posSessionData?.endTime ?? DateTime.now());
    startTime[3] = await moneyCalculatorService.calculatePos(invoiceType: InvoiceType.CASHBACK, at: posSessionData?.startTime ?? DateTime.now());
    endTime[3] = await moneyCalculatorService.calculatePos(invoiceType: InvoiceType.CASHBACK, at: posSessionData?.endTime ?? DateTime.now());

    totalMoney();
    setState(() {});
  }

  void totalMoney() {
    double totalIncome = 0;
    double totalOutcome = 0;
    double totalSale = 0;
    double totalInvoiceFromSale = 0;
    List<MoneyStructure> moneyStructureList = [];
    for (TradeDTO trade in trades) {
      double total = 0;
      double discount = trade.trade.discount != null ? trade.trade.discount ?? 0 : 0;
      total -= discount;
      for (Transaction invoice in trade.invoices) {
        totalInvoiceFromSale += invoice.amount;
        splitByType(invoice, tradeMoneysByType, MoneyFromType.SALE);
        if (trade.trade.isReturned == true) {
          splitByType(invoice, outcomeMoneysByType, MoneyFromType.OUTGOING);
        } else {
          splitByType(invoice, incomeMoneysByType, MoneyFromType.INCOME);
        }
      }
      for (TradeProductDto tradeProductData in trade.tradeProducts) {
        total += tradeProductData.tradeProduct.amount * tradeProductData.tradeProduct.price;
      }
      if (!trade.trade.isReturned) {
        totalSale += total;
      } else {
        totalOutcome += total;
      }
      moneyStructureList.add(MoneyStructure(
        amount: total,
        type: trade.trade.isReturned ? MoneyFromType.RETURN : MoneyFromType.SALE,
        date: trade.trade.createdAt,
        index: trades.indexOf(trade),
      ));
      if (!trade.trade.isReturned) {
        double totalInvoice = trade.invoices.fold(0.0, (previousValue, element) => previousValue + element.amount);
        moneyStructureList.add(MoneyStructure(
          amount: totalInvoice,
          type: MoneyFromType.INCOME,
          date: trade.trade.createdAt,
          index: trades.indexOf(trade),
        ));
      } else {
        moneyStructureList.add(MoneyStructure(
          amount: total,
          type: MoneyFromType.OUTGOING,
          date: trade.trade.createdAt,
          index: trades.indexOf(trade),
        ));
      }
    }
    // for (IncomeMoneyDataStruct income in incomeMoney) {
    //   totalIncome += income.invoiceData.amount;
    //   splitByType(income.invoiceData, incomeMoneysByType, MoneyFromType.INCOME);
    //   moneyStructureList.add(MoneyStructure(
    //     amount: income.invoiceData.amount,
    //     type: MoneyFromType.INCOME,
    //     date: income.incomeData.createdAt,
    //     index: incomeMoney.indexOf(income),
    //   ));
    // }
    //
    // for (PosTransferDto posTransferDto in posTransfer) {
    //   bool isIncome = myPos?.id != posTransferDto.posTransferData.fromPosId;
    //   double amount = posTransferDto.posTransferData.amount;
    //   InvoiceType payType = InvoiceType.fromString(posTransferDto.posTransferData.payType?.name);
    //   Transaction invoiceData = Transaction(
    //     id: posTransferDto.posTransferData.id,
    //     amount: amount,
    //     income: isIncome,
    //     payType: payType,
    //     createdAt: posTransferDto.posTransferData.createdAt,
    //     updatedAt: posTransferDto.posTransferData.updatedAt,
    //     isSynced: posTransferDto.posTransferData.isSynced,
    //   );
    //   MoneyStructure posTransferStruct = MoneyStructure(
    //     amount: amount,
    //     type: MoneyFromType.POS_TRANSFER,
    //     date: posTransferDto.posTransferData.createdAt,
    //     index: posTransfer.indexOf(posTransferDto),
    //   );
    //   if (isIncome) {
    //     totalIncome += amount;
    //     splitByType(invoiceData, incomeMoneysByType, MoneyFromType.INCOME);
    //   } else {
    //     totalOutcome += amount;
    //     splitByType(invoiceData, outcomeMoneysByType, MoneyFromType.OUTGOING);
    //   }
    //   moneyStructureList.add(posTransferStruct);
    // }
    // for (OutcomeMoneyDataStruct outcome in outcomeMoney) {
    //   totalOutcome += outcome.invoice.amount;
    //   splitByType(outcome.invoice, outcomeMoneysByType, MoneyFromType.OUTGOING);
    //   moneyStructureList.add(MoneyStructure(
    //     amount: outcome.invoice.amount,
    //     type: MoneyFromType.OUTGOING,
    //     date: outcome.outcome.createdAt,
    //     index: outcomeMoney.indexOf(outcome),
    //   ));
    // }
    // for (ConsumptionMoneyDataStruct consumption in consumptionMoney) {
    //   totalOutcome += consumption.invoiceData.amount;
    //   splitByType(consumption.invoiceData, outcomeMoneysByType, MoneyFromType.CONSUMPTION);
    //   moneyStructureList.add(MoneyStructure(
    //     amount: consumption.invoiceData.amount,
    //     type: MoneyFromType.CONSUMPTION,
    //     date: consumption.data.createdAt,
    //     index: consumptionMoney.indexOf(consumption),
    //   ));
    // }
    moneyStructureList.sort((a, b) => b.date.compareTo(a.date));
    setState(() {
      _totalIncome = formatNumber(totalIncome + totalInvoiceFromSale);
      _totalOutcome = formatNumber(totalOutcome);
      _totalSale = formatNumber(totalSale);
      _totalReal = (totalInvoiceFromSale - totalOutcome);
      returnedMoney = totalOutcome;
      _moneyStructureList = moneyStructureList;
    });
  }

  void splitByType(Transaction invoice, List<double> moneysByType, MoneyFromType type) {
    if (invoice.payType == InvoiceType.CASH) {
      moneysByType[0] += invoice.amount;
    } else if (invoice.payType == InvoiceType.CARD) {
      moneysByType[1] += invoice.amount;
    } else if (invoice.payType == InvoiceType.TRANSFER) {
      moneysByType[2] += invoice.amount;
    } else if (invoice.payType == InvoiceType.CASHBACK) {
      moneysByType[3] += invoice.amount;
    }

    setState(() {
      if (type == MoneyFromType.SALE) {
        tradeMoneysByType = moneysByType;
      } else if (type == MoneyFromType.INCOME) {
        incomeMoneysByType = moneysByType;
      } else if (type == MoneyFromType.OUTGOING) {
        outcomeMoneysByType = moneysByType;
      } else if (type == MoneyFromType.CONSUMPTION) {
        consumptionMoneysByType = moneysByType;
      }
    });
  }

  String dropdownSelectedValue = '111';
  bool showCards = true;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: AppColors.appColorBlackBg, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          showCards
              ? Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 10),
                            Icon(Icons.point_of_sale_rounded, color: AppColors.appColorWhite, size: 30),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Smena xisoboti', style: TextStyle(color: AppColors.appColorWhite, fontSize: 30)),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => Get.toNamed(Routes.TRADE_HISTORY),
                              icon: Icon(Icons.history_rounded, color: AppColors.appColorWhite, size: 28),
                            ),
                            IconButton(
                              onPressed: () => Get.back(),
                              icon: Icon(Icons.cancel_outlined, color: AppColors.appColorRed300, size: 28),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ],
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 30),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Text('Smenani tanlang:', style: TextStyle(color: AppColors.appColorGrey400, fontSize: 20)),
                    //       SizedBox(
                    //         width: 300,
                    //         child: AppDropDown(
                    //           dropDownItems: const ['111', '222', '333', '444'],
                    //           selectedValue: dropdownSelectedValue,
                    //           onChanged: (value) {},
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        alignment: WrapAlignment.center,
                        children: [
                          ReportItemCard(
                            title: 'Smena Boshida',
                            amount: formatNumber(startTime.fold(0.0, (previousValue, element) => previousValue + element)),
                            icon: Icons.play_arrow_rounded,
                            color: Colors.deepOrange,
                            moneysByType: startTime,
                          ),
                          ReportItemCard(
                            title: 'Umumiy Savdo',
                            amount: _totalSale,
                            icon: UniconsLine.shopping_cart,
                            color: Colors.blueGrey,
                            moneysByType: tradeMoneysByType,
                          ),
                          ReportItemCard(
                            title: 'Umumiy Kirim',
                            amount: _totalIncome,
                            icon: Icons.arrow_downward_rounded,
                            color: Colors.green,
                            moneysByType: incomeMoneysByType,
                          ),
                          ReportItemCard(
                            title: 'Umumiy Chiqim',
                            amount: '0',
                            icon: Icons.arrow_upward_rounded,
                            color: Colors.redAccent,
                            moneysByType: outcomeMoneysByType,
                          ),
                          ReportItemCard(
                            title: 'Smena Oxirida',
                            amount: formatNumber(endTime.fold(0.0, (previousValue, element) => previousValue + element)),
                            icon: Icons.stop_rounded,
                            color: Colors.redAccent,
                            moneysByType: endTime,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: width * 0.775,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ReportItemCard(
                            title: 'Hozirgi Balans',
                            amount: formatNumber(_totalReal),
                            icon: Icons.real_estate_agent_outlined,
                            color: Colors.pinkAccent,
                            moneysByType: [incomeMoneysByType[0] - returnedMoney, incomeMoneysByType[1], returnedMoney, 0],
                            types: [
                              Row(
                                children: [
                                  const Icon(UniconsLine.money_bill, color: Colors.blue, size: 18),
                                  const SizedBox(width: 5),
                                  Text('Naqd:', style: TextStyle(color: AppColors.appColorGrey400, fontSize: 14)),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.credit_card, color: Colors.green, size: 18),
                                  const SizedBox(width: 5),
                                  Text(
                                    "Karta:",
                                    style: TextStyle(color: AppColors.appColorGrey400, fontSize: 14),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.remove_circle_outline, color: Colors.red, size: 18),
                                  const SizedBox(width: 5),
                                  Text("Vazvrat", style: TextStyle(color: AppColors.appColorGrey400, fontSize: 14)),
                                ],
                              ),
                              Container(),
                            ],
                          ),
                          const SizedBox(width: 10),
                          ReportItemCard(
                            title: 'Check haqida',
                            amount: formatNumber(tradeInfo[1]),
                            icon: Icons.receipt_long_rounded,
                            color: Colors.brown,
                            moneysByType: tradeInfo,
                            types: [
                              Row(
                                children: [
                                  const Icon(Icons.numbers, color: Colors.green, size: 18),
                                  const SizedBox(width: 5),
                                  Text("Jami Cheklar", style: TextStyle(color: AppColors.appColorGrey400, fontSize: 14)),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(UniconsLine.money_bill, color: Colors.blue, size: 18),
                                  const SizedBox(width: 5),
                                  Text('Jami:', style: TextStyle(color: AppColors.appColorGrey400, fontSize: 14)),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.align_vertical_bottom, color: Colors.green, size: 18),
                                  const SizedBox(width: 5),
                                  Text(
                                    "O'rtacha:",
                                    style: TextStyle(color: AppColors.appColorGrey400, fontSize: 14),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              Container(),
                            ],
                          ),
                          const SizedBox(width: 10),
                          ReportItemCard(
                            title: 'Klientlar haqida',
                            amount: formatNumber(clientsInfo[3]),
                            icon: Icons.people_alt_outlined,
                            color: Colors.deepOrangeAccent,
                            moneysByType: clientsInfo,
                            types: [
                              Row(
                                children: [
                                  const Icon(Icons.person_2, color: Colors.grey, size: 18),
                                  const SizedBox(width: 5),
                                  Text("Eski Klientlar", style: TextStyle(color: AppColors.appColorGrey400, fontSize: 14)),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.person_add_alt, color: Colors.green, size: 18),
                                  const SizedBox(width: 5),
                                  Text('Yangi Klientlar', style: TextStyle(color: AppColors.appColorGrey400, fontSize: 14)),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.person_off, color: Colors.redAccent, size: 18),
                                  const SizedBox(width: 5),
                                  Text("Tanlanmagan Klientlar", style: TextStyle(color: AppColors.appColorGrey400, fontSize: 14)),
                                ],
                              ),
                              Container(),
                            ],
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              setState(() {
                                showCards = false;
                              });
                            },
                            child: Container(
                              width: width * 0.20,
                              decoration: BoxDecoration(color: Colors.grey.shade900, borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 49),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(20)),
                                        padding: const EdgeInsets.all(5),
                                        child: Icon(Icons.arrow_forward, color: AppColors.appColorWhite, size: 22),
                                      ),
                                      const SizedBox(width: 10),
                                      Text("Batafsil", style: TextStyle(color: AppColors.appColorGrey400, fontSize: 20)),
                                    ],
                                  ),
                                  const SizedBox(height: 49),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          (!showTypeCards)
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      showTypeCards = !showTypeCards;
                                    });
                                  },
                                  icon: Icon(Icons.arrow_back, color: AppColors.appColorWhite, size: 30),
                                )
                              : Container(),
                          Text('Xisobotlar ( ${translate(filterType.name)} )', style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                showCards = true;
                              });
                            },
                            icon: Icon(Icons.cancel_outlined, color: AppColors.appColorRed300, size: 28),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    !showTypeCards
                        ? SizedBox(
                            height: height * 0.8,
                            child: ExpandedList(
                              returnWidget: returnWidget,
                              type: filterType,
                              list: _moneyStructureList,
                            ),
                          )
                        : Column(
                            children: [
                              ReportTypeCard(
                                type: MoneyFromType.SALE,
                                total: _totalSale,
                                title: "Savdolar",
                                icon: UniconsLine.shopping_cart,
                                onTap: () {
                                  setState(() {
                                    showTypeCards = false;
                                    filterType = MoneyFromType.SALE;
                                  });
                                },
                              ),
                              Divider(color: AppColors.appColorGrey400.withOpacity(0.5), thickness: 0.5, height: 0),
                              ReportTypeCard(
                                type: MoneyFromType.INCOME,
                                total: _totalIncome,
                                title: "Kirimlar",
                                icon: Icons.arrow_downward_rounded,
                                onTap: () {
                                  setState(() {
                                    showTypeCards = false;
                                    filterType = MoneyFromType.INCOME;
                                  });
                                },
                              ),
                              Divider(color: AppColors.appColorGrey400.withOpacity(0.5), thickness: 0.5, height: 0),
                              ReportTypeCard(
                                type: MoneyFromType.OUTGOING,
                                total: _totalOutcome,
                                title: "Chiqimlar",
                                icon: Icons.arrow_upward_rounded,
                                onTap: () {
                                  setState(() {
                                    showTypeCards = false;
                                    filterType = MoneyFromType.OUTGOING;
                                  });
                                },
                              ),
                              Divider(color: AppColors.appColorGrey400.withOpacity(0.5), thickness: 0.5, height: 0),
                              ReportTypeCard(
                                type: MoneyFromType.RETURN,
                                total: "",
                                title: "Qaytgan savdolar",
                                icon: Icons.assignment_return_outlined,
                                onTap: () {
                                  setState(() {
                                    showTypeCards = false;
                                    filterType = MoneyFromType.RETURN;
                                  });
                                },
                              ),
                              Divider(color: AppColors.appColorGrey400.withOpacity(0.5), thickness: 0.5, height: 0),
                              // ReportTypeCard(
                              //   type: MoneyFromType.CONSUMPTION,
                              //   total: '${_moneyStructureList.where((element) => element.type == MoneyFromType.CONSUMPTION).length} ta',
                              //   title: "Pul o'tkazmalar",
                              //   icon: Icons.local_police_sharp,
                              //   onTap: () {
                              //     setState(() {
                              //       showTypeCards = false;
                              //       filterType = MoneyFromType.CONSUMPTION;
                              //     });
                              //   },
                              // ),
                              // Divider(color: AppColors.appColorGrey400.withOpacity(0.5), thickness: 0.5, height: 0),
                            ],
                          ),
                  ],
                )
        ],
      ),
    );
  }

  returnWidget(MoneyFromType type, int moneyStructId) {
    switch (type) {
      case MoneyFromType.SALE:
        {
          TradeDTO tradeDTO = trades[moneyStructId];
          return TradeItem(
            tradeDTO: tradeDTO,
          );
        }
      case MoneyFromType.INCOME:
        {
          TradeDTO tradeDTO = trades[moneyStructId];
          return TradeItem(
            tradeDTO: tradeDTO,
          );
        }
      case MoneyFromType.OUTGOING:
        {
          TradeDTO tradeDTO = trades[moneyStructId];
          return TradeItem(
            tradeDTO: tradeDTO,
          );
        }
      case MoneyFromType.RETURN:
        {
          TradeDTO tradeDTO = trades[moneyStructId];
          return TradeItem(
            tradeDTO: tradeDTO,
          );
        }
      // case MoneyFromType.CONSUMPTION:
      //   {
      //     ConsumptionMoneyDataStruct returnMoney = consumptionMoney[moneyStructId];
      //     return ConsumptionItem(
      //       consumption: returnMoney,
      //     );
      //   }
      // case MoneyFromType.POS_TRANSFER:
      //   {
      //     PosTransferDto posTransferDto = posTransfer[moneyStructId];
      //     return PosTransferItem(
      //       posTransferDto: posTransferDto,
      //     );
      //   }
      default:
        return const Text('Mavjud emas');
    }
  }

  List<double> tradeInfo = [0, 0, 0, 0]; // total check count, total check sum, average check sum
  List<double> clientsInfo = [0, 0, 0, 0, 0]; // old clients, new clients, old clients, total clients
  void calculateTradeInfo(List<TradeDTO> trades) async {
    PosSessionData? posSessionData = await myDatabase.posSessionDao.getLastSession();
    List<TradeDTO> unReturnedTrades = trades.where((element) => !element.trade.isReturned).toList();
    tradeInfo[0] = unReturnedTrades.length.toDouble();
    clientsInfo[3] = unReturnedTrades.length.toDouble();
    double totalSumProduct = 0;
    for (TradeDTO trade in unReturnedTrades) {
      double total = 0;
      for (TradeProductDto tradeProductData in trade.tradeProducts) {
        total += tradeProductData.tradeProduct.amount * tradeProductData.tradeProduct.price;
      }
      totalSumProduct += total;
      int? clientId = trade.trade.clientId;
      if (clientId == null) {
        clientsInfo[2]++;
      } else {
        ClientData? clientData = await myDatabase.clientDao.getById(clientId);
        DateTime? createdAtThisClient = clientData.createdAt;
        DateTime? startTime = posSessionData?.startTime ?? DateTime.now();
        DateTime? endTime = posSessionData?.endTime ?? DateTime.now();
        bool isNewClient = createdAtThisClient.isAfter(startTime) && createdAtThisClient.isBefore(endTime);
        if (isNewClient) {
          clientsInfo[1]++;
        } else {
          clientsInfo[0]++;
        }
      }
    }
    tradeInfo[1] = totalSumProduct;
    tradeInfo[2] = totalSumProduct / tradeInfo[0];
  }
}

class MoneyStructure {
  final MoneyFromType type;
  final double amount;
  final DateTime date;
  final int index;

  MoneyStructure({required this.type, required this.amount, required this.date, required this.index});
}

enum MoneyFromType {
  SALE,
  RETURN,
  INCOME,
  POS_TRANSFER,
  OUTGOING,
  CONSUMPTION;
}

class ExpandedList extends StatefulWidget {
  const ExpandedList({super.key, required this.type, required this.list, required this.returnWidget});

  final MoneyFromType type;
  final List<MoneyStructure> list;
  final Function(MoneyFromType type, int moneyStructId) returnWidget;

  @override
  State<ExpandedList> createState() => _ExpandedListState();
}

class _ExpandedListState extends State<ExpandedList> {
  @override
  Widget build(BuildContext context) {
    List<MoneyStructure> moneyStructureList = widget.list;
    return moneyStructureList.where((element) => element.type == widget.type).isEmpty
        ? Center(
            child: Text(
              'Mavjud emas',
              style: TextStyle(color: AppColors.appColorGrey400, fontSize: 20),
            ),
          )
        : ListView.separated(
            itemCount: moneyStructureList.where((element) => element.type == widget.type).length,
            itemBuilder: (context, index) {
              MoneyStructure item = moneyStructureList.where((element) => element.type == widget.type).toList()[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: AppTableItems(
                  hideBorder: true,
                  height: 40,
                  items: [
                    AppTableItemStruct(
                      flex: 1,
                      innerWidget: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(
                              item.type == MoneyFromType.SALE
                                  ? UniconsLine.shopping_cart
                                  : item.type == MoneyFromType.INCOME
                                      ? Icons.arrow_downward_rounded
                                      : item.type == MoneyFromType.OUTGOING
                                          ? Icons.arrow_upward_rounded
                                          : item.type == MoneyFromType.RETURN
                                              ? Icons.assignment_return_outlined
                                              : item.type == MoneyFromType.POS_TRANSFER
                                                  ? Icons.local_police_sharp
                                                  : Icons.money_off_csred_rounded,
                              color: item.type == MoneyFromType.SALE
                                  ? AppColors.appColorGreen400
                                  : item.type == MoneyFromType.INCOME
                                      ? AppColors.appColorGreen400
                                      : item.type == MoneyFromType.OUTGOING
                                          ? AppColors.appColorRed400
                                          : item.type == MoneyFromType.RETURN
                                              ? Colors.orange
                                              : item.type == MoneyFromType.POS_TRANSFER
                                                  ? Colors.blueAccent
                                                  : AppColors.appColorGrey400,
                            ),
                            const SizedBox(width: 10),
                            Text(translate(item.type.name.toString()), style: const TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                    AppTableItemStruct(
                        flex: 1,
                        innerWidget: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Text(formatNumber(item.amount), style: const TextStyle(color: Colors.white))),
                        )),
                    AppTableItemStruct(
                        flex: 1,
                        innerWidget: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Text(formatDateTime(item.date), style: const TextStyle(color: Colors.white))),
                        )),
                    AppTableItemStruct(
                        flex: 0,
                        hideBorder: true,
                        innerWidget: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return widget.returnWidget(item.type, item.index);
                              },
                            );
                          },
                          icon: Icon(
                            UniconsLine.eye,
                            color: AppColors.appColorGrey400,
                            size: 25,
                          ),
                        )),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const Divider(
                color: Colors.white30,
                height: 0,
              );
            },
          );
  }
}
