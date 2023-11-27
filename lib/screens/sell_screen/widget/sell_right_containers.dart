import 'dart:convert';

import 'package:easy_sell/database/model/trade_dto.dart';
import 'package:easy_sell/database/model/trade_product_data_dto.dart';
import 'package:easy_sell/database/my_database.dart';
import 'package:easy_sell/database/table/invoice_table.dart';
import 'package:easy_sell/screens/sell_screen/widget/sell_return_dialog.dart';
import 'package:easy_sell/screens/sell_screen/widget/sell_complete_dialog.dart';
import 'package:easy_sell/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';
import '../../../constants/colors.dart';
import '../../../database/model/product_dto.dart';
import '../../../database/model/trade_product_dto.dart';
import '../../../services/money_calculator_service.dart';
import '../../../services/storage_services.dart';
import '../../../widgets/app_button.dart';

class SellRightContainers extends StatefulWidget {
  const SellRightContainers(
      {super.key,
      required this.onPay,
      required this.setClient,
      required this.tradeData,
      required this.trades,
      required this.initialTradeIndex,
      required this.onReturn,
      required this.onSelectProduct});

  final List<TradeProductDataDto> tradeData;
  final List<TradeDTO> trades;
  final int initialTradeIndex;
  final Function(ClientData? client, {double? discount, double? refund}) onPay;
  final Function(int tradeId, Map additional) onReturn;
  final Function(ProductDTO product) onSelectProduct;
  final Function(ClientData? client) setClient;

  @override
  State<SellRightContainers> createState() => _SellRightContainersState();
}

class _SellRightContainersState extends State<SellRightContainers> {
  MyDatabase database = Get.find<MyDatabase>();
  List<ClientData> clients = [];
  ClientData? selectedClient;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<ProductDTO> topProducts = [];
  Storage storage = Storage();
  late MoneyCalculatorService moneyCalculatorService;
  double checkClientDebt = 0;
  bool canReturn = false;

  @override
  void initState() {
    super.initState();

    moneyCalculatorService = MoneyCalculatorService(
      database: database,
    );
    getClients();
    getTopProducts();
    setIfClientExist(widget.trades[widget.initialTradeIndex].trade.clientId);
  }

  void getTopProducts() async {
    String? topProductsList = await storage.read('topProducts');
    if (topProductsList != null) {
      List<int> topProductsIds = jsonDecode(topProductsList).cast<int>();
      topProducts = await database.productDao.getTopProducts(topProductsIds);
      setState(() {
        topProducts = topProducts;
      });
    }
  }

  void getClients() async {
    clients = await database.clientDao.getAllClients();
    setState(() {
      clients = clients;
    });
  }

  void clearSearchClient() {
    selectedClient = null;
  }

  double totalSum() {
    double total = 0;
    for (var element in widget.tradeData) {
      total += element.price * element.amount;
    }
    return total;
  }

  void calculateDebt(ClientData? clientData) async {
    if (clientData == null) return;
    setState(() {
      checkClientDebt = 0;
    });
  }

  //
  // void _handleCreatedClient(ClientData client) {
  //   widget.setClient(client);
  //   setState(() {
  //     selectedClient = client;
  //   });
  // }

  void setIfClientExist(int? clientId) async {
    if (clientId == null) return;
    ClientData client = await database.clientDao.getById(clientId);
    setState(() {
      selectedClient = client;
    });
    calculateDebt(client);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // _showClientSearch == false ?
          Row(
            children: [
              // Container(
              //   height: 48,
              //   width: 173,
              //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(17), color: AppColors.appColorBlackBg),
              //   child: IconButton(
              //     onPressed: () {
              //       setState(() {
              //         _showClientSearch = true;
              //       });
              //     },
              //     icon: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Text('Mijozni tanlash', style: TextStyle(color: AppColors.appColorWhite, fontSize: 19)),
              //         const SizedBox(width: 5),
              //         Icon(UniconsLine.user_check, color: AppColors.appColorGreen400, size: 26),
              //       ],
              //     ),
              //   ),
              // ),
              // const SizedBox(width: 5),
              // AppButton(
              //   onTap: () {
              //     showDialog(
              //       context: context,
              //       builder: (BuildContext context) {
              //         return ClientInfoDialog(
              //           callback: () {},
              //           onClientCreated: _handleCreatedClient,
              //         );
              //       },
              //     );
              //     setState(() {
              //       if (selectedClient != null) {
              //         _showClientSearch = true;
              //       }
              //     });
              //   },
              //   tooltip: 'Yangi mijoz yaratish',
              //   height: 48,
              //   width: 48,
              //   color: AppColors.appColorBlackBg,
              //   borderRadius: BorderRadius.circular(15),
              //   hoverRadius: BorderRadius.circular(15),
              //   child: Icon(UniconsLine.user_plus, color: AppColors.appColorGreen400, size: 26),
              // ),
              // const SizedBox(width: 5),
              AppButton(
                onTap: () {
                  showAppScannerDialog(context, onConfirm: (barcode) async {
                    ClientData? client = await database.clientDao.getClientByDiscountCard(barcode);
                    widget.setClient(client);
                    if (client != null) {
                      calculateDebt(client);
                      setState(() {
                        selectedClient = client;
                      });
                    }
                  }, title: 'Diskont karta orqali mijoz qoshish', message: 'Skannerlang...');
                },
                tooltip: 'Diskont karta orqali qidirish',
                height: 48,
                width: 280,
                color: AppColors.appColorBlackBg,
                borderRadius: BorderRadius.circular(15),
                hoverRadius: BorderRadius.circular(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 35),
                        Icon(UniconsLine.credit_card_search, color: AppColors.appColorGreen400, size: 26),
                        const SizedBox(width: 25),
                        Text('Diskont karta', style: TextStyle(color: AppColors.appColorWhite, fontSize: 19)),
                      ],
                    ),
                    if (selectedClient != null)
                      Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  selectedClient = null;
                                });
                              },
                              icon: Icon(Icons.close, color: AppColors.appColorRed300, size: 26))),
                  ],
                ),
              ),
            ],
          ),
          // : Row(
          //     children: [
          //       SizedBox(
          //         width: 230,
          //         child: AppAutoComplete(
          //           getValue: (AutocompleteDataStruct value) {
          //             ClientData? currentClient =
          //                 clients.firstWhereOrNull((element) => element.name == value.value && element.id == value.uniqueId);
          //             widget.setClient(currentClient);
          //             calculateDebt(currentClient);
          //             setState(() {
          //               selectedClient = currentClient;
          //             });
          //           },
          //           initialValue: selectedClient?.name,
          //           options: clients
          //               .map((e) => AutocompleteDataStruct(
          //                     uniqueId: e.id,
          //                     value: e.name,
          //                   ))
          //               .toList(),
          //           hintText: 'Qidirish',
          //           prefixIcon: Icons.person_search_outlined,
          //         ),
          //       ),
          //       AppButton(
          //         onTap: () async {
          //           await database.tradeDao
          //               .updateTrade(widget.trades[widget.initialTradeIndex].trade.copyWith(clientId: toValue(null)));
          //           setState(() {
          //             _showClientSearch = false;
          //             clearSearchClient();
          //             selectedClient = null;
          //           });
          //         },
          //         width: 45,
          //         height: 45,
          //         color: AppColors.appColorRed300,
          //         borderRadius: BorderRadius.circular(15),
          //         hoverRadius: BorderRadius.circular(15),
          //         child: Icon(Icons.close, color: AppColors.appColorWhite),
          //       ),
          //     ],
          //   ),
          const SizedBox(height: 5),
          Container(
            width: 280,
            padding: const EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 11),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(17), color: AppColors.appColorBlackBg),
            child: Column(
              children: [
                Text('Savdo malumotlari:', style: TextStyle(color: AppColors.appColorWhite, fontSize: 18)),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(UniconsLine.user, color: AppColors.appColorWhite),
                        Text(' Mijoz:', style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
                      ],
                    ),
                    Text(
                      selectedClient == null ? 'Tanlanmagan' : selectedClient!.name,
                      style: TextStyle(
                        color: AppColors.appColorWhite,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                selectedClient == null
                    ? const SizedBox()
                    : Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Row(
                          children: [
                            Icon(UniconsLine.money_bill, color: AppColors.appColorRed300),
                            Text(' Mijoz qarzi:', style: TextStyle(color: AppColors.appColorWhite, fontSize: 14)),
                          ],
                        ),
                        Text(
                          selectedClient == null ? 'Tanlanmagan' : formatNumber(checkClientDebt),
                          style: TextStyle(color: checkClientDebt > 0 ? AppColors.appColorRed300 : AppColors.appColorGreen400, fontSize: 14),
                        )
                      ]),
                Divider(color: AppColors.appColorGrey700),
                if (selectedClient != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.percent_outlined, color: Colors.orange),
                          Text(' Cashback:', style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
                        ],
                      ),
                      Text(formatNumber(selectedClient?.cashback ?? 0), style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
                    ],
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(UniconsLine.money_bill, color: Colors.blue),
                        Text(' Summa:', style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
                      ],
                    ),
                    Text(formatNumber(totalSum()), style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: Container(
                width: 280,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                  color: AppColors.appColorBlackBg,
                ),
                child: topProducts.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.warning_amber_rounded, color: AppColors.appColorWhite, size: 40),
                            const SizedBox(height: 20),
                            Text('Top mahsulotlar ro\'yxati bo\'sh', style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.only(top: 10),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemCount: topProducts.length,
                        itemBuilder: (BuildContext context, index) {
                          return InkWell(
                            onTap: () {
                              widget.onSelectProduct(topProducts[index]);
                            },
                            child: Container(
                              margin: const EdgeInsets.all(3),
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                color: AppColors.appColorGrey700,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                                Text(topProducts[index].productData.name, style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
                              ]),
                            ),
                          );
                        },
                      )),
          ),
          const SizedBox(height: 5),
          Container(
            width: 280,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(17), color: AppColors.appColorBlackBg),
            child: Column(
              children: [
                AppButton(
                  onTap: () async {
                    try {
                      if (widget.trades[widget.initialTradeIndex].tradeProducts.isEmpty) {
                        throw 'Mahsulotlar ro\'yxati bo\'sh!';
                      }
                      await checkIfClientGetThisProducts(widget.trades[widget.initialTradeIndex]);
                      if (context.mounted) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return SellReturnProductDialog(
                              client: selectedClient,
                              onReturn: (Map<dynamic, dynamic> value) {
                                if (value['returnedMoney'] && !canReturn) {
                                  showAppAlertDialog(
                                    context,
                                    title: 'Diqqat!',
                                    message: "Kassada yetarli naqd pul mavjud emas!",
                                    buttonLabel: 'Ok',
                                    cancelLabel: 'Bekor qilish',
                                  );
                                } else {
                                  widget.onReturn(widget.trades[widget.initialTradeIndex].trade.id, value);
                                }
                              },
                            );
                          },
                        );
                      }
                    } catch (e) {
                      showAppAlertDialog(
                        context,
                        title: 'Diqqat!',
                        message: e.toString(),
                        buttonLabel: 'Ok',
                        cancelLabel: 'Bekor qilish',
                      );
                    }
                  },
                  width: 290,
                  height: 45,
                  margin: const EdgeInsets.symmetric(vertical: 3),
                  color: AppColors.appColorGrey700,
                  hoverColor: AppColors.appColorGrey400,
                  colorOnClick: AppColors.appColorGrey700,
                  splashColor: AppColors.appColorGrey700,
                  borderRadius: BorderRadius.circular(13),
                  hoverRadius: BorderRadius.circular(13),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(UniconsLine.arrow_up_left, color: AppColors.appColorWhite, size: 25),
                      const SizedBox(width: 3),
                      Text(
                        "Qaytarish",
                        style: TextStyle(color: AppColors.appColorWhite, fontWeight: FontWeight.w500, fontSize: 18, letterSpacing: 1),
                      ),
                    ],
                  ),
                ),
                AppButton(
                  onTap: () {
                    try {
                      validation();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return SellCompleteDialog(
                            client: selectedClient,
                            totalSum: totalSum(),
                            onPay: widget.onPay,
                            currentTrade: widget.trades[widget.initialTradeIndex],
                            checkClientDebt: checkClientDebt,
                          );
                        },
                      );
                    } catch (e) {
                      showAppAlertDialog(
                        context,
                        title: 'Diqqat!',
                        message: e.toString(),
                        buttonLabel: 'Ok',
                        cancelLabel: 'Bekor qilish',
                      );
                    }
                  },
                  width: 290,
                  height: 45,
                  margin: const EdgeInsets.symmetric(vertical: 3),
                  color: AppColors.appColorGreen400,
                  hoverColor: AppColors.appColorGreen300,
                  colorOnClick: AppColors.appColorGreen700,
                  splashColor: AppColors.appColorGreen700,
                  borderRadius: BorderRadius.circular(13),
                  hoverRadius: BorderRadius.circular(13),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(UniconsLine.wallet, color: AppColors.appColorWhite, size: 25),
                      const SizedBox(width: 3),
                      Text(
                        "To'lov",
                        style: TextStyle(color: AppColors.appColorWhite, fontWeight: FontWeight.w500, fontSize: 18, letterSpacing: 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void validation() {
    if (widget.tradeData.isEmpty) {
      throw "Savdoda hech qanday mahsulot yo'q!";
    }
    // List<String> reason = [];
    // TradeDTO currentTrade = widget.trades[widget.initialTradeIndex];
    // for (TradeProductDataDto productData in currentTrade.data) {
    //   int index = currentTrade.data.indexOf(productData);
    //   double minimalPrice = currentTrade.tradeProducts[index].product.prices
    //           .firstWhereOrNull((element) => element.priceType == PriceType.WHOLESALE)
    //           ?.value ??
    //       0;
    //   if (productData.amount == 0) {
    //     reason.add("Savdoda mahsulotlar soni 0 bo'lmasligi kerak!");
    //   } else if (productData.amount > currentTrade.tradeProducts[index].product.amount.toDouble()) {
    //     reason.add(
    //         "Savdoda mahsulotlar soni omborda mavjud sonidan ko'p bo'lmasligi kerak! \nSiz kiritgan mahsulotlar soni: ${formatNumber(productData.amount)} \nOmborda mavjud mahsulotlar soni: ${formatNumber(currentTrade.tradeProducts[index].product.amount)}");
    //   } else if (productData.price < minimalPrice) {
    //     reason.add(
    //         "Savdoda mahsulot narxi Minimal narxidan past bo'lmasligi kerak! \nSiz kiritgan mahsulot: ${currentTrade.tradeProducts[index].product.productData.name} \nNarxi: ${formatNumber(productData.price)} \nMinimal narxi: ${formatNumber(minimalPrice)}");
    //   }
    // }
    // if (reason.isNotEmpty) {
    //   throw reason.join("\n\n");
    // }
  }

  Future<bool> canReturnMoney(List<TradeProductDataDto> products) async {
    double hasTotalMoneyInPos = await moneyCalculatorService.calculatePos(invoiceType: InvoiceType.CASH);
    double totalReturnMoney = 0;
    for (TradeProductDataDto product in products) {
      totalReturnMoney += product.price * product.amount;
    }
    bool canReturn = totalReturnMoney <= hasTotalMoneyInPos;
    return canReturn;
  }

  Future<void> checkIfClientGetThisProducts(TradeDTO trade) async {
    int? clientId = selectedClient?.id;
    List<TradeProductDataDto> currentProducts = trade.data;
    canReturn = await canReturnMoney(currentProducts);
    setState(() {});
    if (clientId == null && !canReturn) {
      throw "Kassada ushbu naqd pul mavjud emas";
    }

    if (clientId != null) {
      List<TradeDTO> tradesHistory = await database.tradeDao.getTradeByClientId(clientId);
      List<TradeProductDto> clientProductsHistory = tradesHistory.map((e) => e.tradeProducts).expand((element) => element).toList();
      bool isClientGetThisProducts = true;
      for (TradeProductDataDto currentProduct in currentProducts) {
        bool isProductExist = clientProductsHistory
            .any((element) => element.product.productData.id == currentProduct.productId && element.tradeProduct.amount >= currentProduct.amount);
        if (!isProductExist) {
          isClientGetThisProducts = false;
          break;
        }
      }
      if (!isClientGetThisProducts) {
        throw "Mijoz savdo tarixida ushbu mahsulotlar mavjud emas";
      }
    }
  }
}
