import 'package:easy_sell/database/table/invoice_table.dart';
import 'package:easy_sell/widgets/app_autocomplete.dart';
import 'package:easy_sell/widgets/app_button.dart';
import 'package:easy_sell/widgets/app_input_underline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';
import '../../../../../constants/colors.dart';
import '../../../../../database/my_database.dart';
import '../../../../../utils/utils.dart';
import '../../../../../widgets/app_dialog.dart';
import '../../../database/model/trade_struct.dart';
import '../../../services/https_services.dart';
import '../../client_screen/widget/client_info_dialog.dart';

class UpdateTradeDialog extends StatefulWidget {
  const UpdateTradeDialog({super.key, required this.trade});
  final TradeStruct trade;

  @override
  State<UpdateTradeDialog> createState() => _UpdateTradeDialogState();
}

class _UpdateTradeDialogState extends State<UpdateTradeDialog> {
  MyDatabase database = Get.find<MyDatabase>();
  bool _showMoreFields = false;

  TradeStruct tradeForEdit = TradeStruct(
      description: '',
      posSession: null,
      client: null,
      invoices: [],
      productsInTrade: [],
      discount: null,
      refund: null,
      returned: false,
      returnedMoney: null,
      returnedProductsIncome: null,
      createdTime: null,
      success: false,
      deleted: false,
      id: 0);

  ClientData? _client;
  List<ClientData> _clients = [];
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _cashPayController = TextEditingController();
  final TextEditingController _cardPayController = TextEditingController();
  final TextEditingController _cashbackPayController = TextEditingController();
  final TextEditingController _bankPayController = TextEditingController();

  List<TextEditingController> priceControllers = [];

  @override
  void initState() {
    super.initState();
    tradeForEdit = widget.trade;
    _getClient();
    _getClientsList();
    _discountController.text = tradeForEdit.discount.toString();
    _descriptionController.text = tradeForEdit.description ?? '';
    _cashPayController.text = tradeForEdit.invoices.firstWhereOrNull((element) => element.payType.name == InvoiceType.CASH.name)?.amount.toString() ?? '';
    _cardPayController.text = tradeForEdit.invoices.firstWhereOrNull((element) => element.payType.name == InvoiceType.CARD.name)?.amount.toString() ?? '';
    _cashbackPayController.text =
        tradeForEdit.invoices.firstWhereOrNull((element) => element.payType.name == InvoiceType.CASHBACK.name)?.amount.toString() ?? '';
    _bankPayController.text =
        tradeForEdit.invoices.firstWhereOrNull((element) => element.payType.name == InvoiceType.TRANSFER.name)?.amount.toString() ?? ''; // _getClient();
    totalSum();
    print("CLIENT --> $_client");
    print("PAYTYPE --> ${tradeForEdit.invoices[0].payType.toString()}");
  }

  void _getClient() async {
    if (tradeForEdit.client?.id != null) {
      ClientData client = await database.clientDao.getById(tradeForEdit.client?.id ?? 0);
      setState(() {
        _client = client;
      });
    }
  }

  double totalSum() {
    double total = 0;
    for (var element in tradeForEdit.productsInTrade) {
      total += element.price * element.amount;
    }
    return total;
  }

  Future<void> _getClientsList() async {
    List<ClientData> clients = await database.clientDao.getAllClients();
    setState(() {
      _clients = clients;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      backgroundColor: Colors.black.withOpacity(0.9),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 0),
          Text('Savdo ma\'lumotlari', style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
          IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.highlight_off_rounded, color: AppColors.appColorRed400, size: 25),
          ),
        ],
      ),
      content: SizedBox(
        width: 1100,
        height: 630,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Container(
                      height: 350,
                      width: 485,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(color: AppColors.appColorBlackBg, borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Tooltip(
                                    message: tradeForEdit.isReturned ? 'Qaytgan savdo ID:${tradeForEdit.id}' : 'Savdo ID:${tradeForEdit.id}',
                                    child: Icon(
                                      tradeForEdit.isReturned ? Icons.keyboard_double_arrow_down_rounded : Icons.keyboard_double_arrow_up_rounded,
                                      color: tradeForEdit.isReturned ? AppColors.appColorRed300 : AppColors.appColorGreen400,
                                    ),
                                  ),
                                  Text(
                                    tradeForEdit.isReturned ? 'Qaytish' : 'Savdo',
                                    style: TextStyle(color: AppColors.appColorWhite, fontSize: 18),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Divider(color: AppColors.appColorGrey700, height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(UniconsLine.calendar_alt, color: AppColors.appColorWhite),
                                  Text('Vaqt:', style: TextStyle(color: AppColors.appColorWhite, fontSize: 18)),
                                ],
                              ),
                              Text(formatDateTime(tradeForEdit.updatedAt), style: TextStyle(color: AppColors.appColorWhite, fontSize: 18)),
                            ],
                          ),
                          Divider(color: AppColors.appColorGrey700, height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(UniconsLine.user_nurse, color: AppColors.appColorWhite),
                                  Text('Sotuvchi:', style: TextStyle(color: AppColors.appColorWhite, fontSize: 18)),
                                ],
                              ),
                              Text('${tradeForEdit.posSession?.cashier.firstName} ${tradeForEdit.posSession?.cashier.lastName}',
                                  style: TextStyle(color: AppColors.appColorWhite, fontSize: 18)),
                            ],
                          ),
                          Divider(color: AppColors.appColorGrey700, height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(UniconsLine.user, color: AppColors.appColorWhite),
                                  Text('Xaridor:', style: TextStyle(color: AppColors.appColorWhite, fontSize: 18)),
                                ],
                              ),
                              SizedBox(
                                width: 300,
                                child: AppAutoComplete(
                                  getValue: (AutocompleteDataStruct selected) {
                                    setState(() {
                                      _client = _clients.firstWhere((element) => element.id == selected.uniqueId);
                                    });
                                  },
                                  initialValue: _client != null ? _clients.firstWhere((element) => element.id == _client!.id).name : null,
                                  options: _clients.map((e) => AutocompleteDataStruct(value: e.name, uniqueId: e.id)).toList(),
                                  hintText: _client != null ? _client!.name : 'Tanlanmagan',
                                  borderBottom: false,
                                ),
                              ),
                            ],
                          ),
                          Divider(color: AppColors.appColorGrey700, height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(UniconsLine.money_bill, color: Colors.blue),
                                  Text('Umumiy summa:', style: TextStyle(color: AppColors.appColorWhite, fontSize: 18)),
                                ],
                              ),
                              Text(formatNumber(totalSum()), style: TextStyle(color: AppColors.appColorWhite, fontSize: 18)),
                            ],
                          ),
                          Divider(color: AppColors.appColorGrey700, height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                const Icon(UniconsLine.percentage, color: Colors.orange),
                                Text('Chegirma:', style: TextStyle(color: AppColors.appColorWhite, fontSize: 18)),
                              ]),
                              SizedBox(
                                width: 300,
                                child: AppInputUnderline(
                                  controller: _discountController,
                                  hideIcon: true,
                                  textAlign: TextAlign.end,
                                  hintText: '',
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  inputFormatters: [AppTextInputFormatter()],
                                ),
                              ),
                            ],
                          ),
                          Divider(color: AppColors.appColorGrey700, height: 1),
                          const SizedBox(height: 10),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(UniconsLine.comment_alt, color: AppColors.appColorWhite),
                                  Text('Izoh:', style: TextStyle(color: AppColors.appColorWhite, fontSize: 18)),
                                ],
                              ),
                              SizedBox(
                                width: 580,
                                child: AppInputUnderline(
                                  controller: _descriptionController,
                                  outlineBorder: true,
                                  hideIcon: true,
                                  hintText: 'Izoh kiriting...',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      height: 270,
                      width: 485,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(color: AppColors.appColorBlackBg, borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(UniconsLine.money_withdraw, color: AppColors.appColorGreen400),
                                  Text('To\'lov uchun:', style: TextStyle(color: AppColors.appColorWhite, fontSize: 18)),
                                ],
                              ),
                              Text(formatNumber((totalSum()) - (tradeForEdit.discount ?? 0)), style: TextStyle(color: AppColors.appColorWhite, fontSize: 18)),
                            ],
                          ),
                          Divider(color: AppColors.appColorGrey700, height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(UniconsLine.money_insert, color: Colors.amberAccent),
                                  Text('Qaytim summasi:', style: TextStyle(color: AppColors.appColorWhite, fontSize: 18)),
                                ],
                              ),
                              Text(
                                formatNumber(tradeForEdit.refund),
                                style: TextStyle(color: AppColors.appColorWhite, fontSize: 18),
                              ),
                            ],
                          ),
                          Divider(color: AppColors.appColorGrey700, height: 10),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _showMoreFields = !_showMoreFields;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(UniconsLine.money_withdrawal, color: AppColors.appColorGreen700),
                                    Text('To\'langan summa:', style: TextStyle(color: AppColors.appColorWhite, fontSize: 18)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      _showMoreFields ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                                      color: AppColors.appColorGreen400,
                                    ),
                                    Text(
                                      formatNumber(tradeForEdit.invoices.fold(0, (previousValue, element) => previousValue + element.amount.toInt())),
                                      style: TextStyle(color: AppColors.appColorWhite, fontSize: 18),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: _showMoreFields ? Get.height * 0.16 : 0,
                            padding: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                            decoration: BoxDecoration(color: Colors.grey.shade900, borderRadius: BorderRadius.circular(15)),
                            child: SingleChildScrollView(
                              child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 220,
                                      child: AppInputUnderline(
                                        controller: _cashPayController,
                                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                        inputFormatters: [AppTextInputFormatter()],
                                        height: 50,
                                        hintText: 'Naqd',
                                        outlineBorder: true,
                                        prefixIcon: UniconsLine.money_bill,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 230,
                                      child: AppInputUnderline(
                                        controller: _cardPayController,
                                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                        inputFormatters: [AppTextInputFormatter()],
                                        height: 50,
                                        hintText: 'Karta',
                                        outlineBorder: true,
                                        prefixIcon: UniconsLine.credit_card,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                AppInputUnderline(
                                  controller: _cashbackPayController,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  inputFormatters: [AppTextInputFormatter()],
                                  height: 50,
                                  hintText: 'Cashback',
                                  outlineBorder: true,
                                  prefixIcon: UniconsLine.percentage,
                                ),
                                const SizedBox(height: 5),
                                AppInputUnderline(
                                  controller: _bankPayController,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  inputFormatters: [AppTextInputFormatter()],
                                  height: 50,
                                  hintText: 'Bank',
                                  outlineBorder: true,
                                  prefixIcon: Icons.other_houses_rounded,
                                ),
                              ]

                                  // widget.trade.invoices.map(
                                  //       (e) {
                                  //     return Row(
                                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //       children: [
                                  //         Row(
                                  //           children: [
                                  //             const SizedBox(width: 10),
                                  //             Icon(
                                  //               e.payType.name == InvoiceType.CASH.name
                                  //                   ? UniconsLine.money_bill
                                  //                   : e.payType.name == InvoiceType.CARD.name
                                  //                   ? UniconsLine.credit_card
                                  //                   : e.payType.name == InvoiceType.CASHBACK.name
                                  //                   ? UniconsLine.percentage
                                  //                   : Icons.other_houses_rounded,
                                  //               color: AppColors.appColorWhite,
                                  //               size: 20,
                                  //             ),
                                  //             const SizedBox(width: 10),
                                  //             Text(
                                  //               e.payType.name == InvoiceType.CASH.name
                                  //                   ? 'Naqd:'
                                  //                   : e.payType.name == InvoiceType.CARD.name
                                  //                   ? 'Karta:'
                                  //                   : e.payType.name == InvoiceType.CASHBACK.name
                                  //                   ? 'Cashback:'
                                  //                   : 'Bank:',
                                  //               style: TextStyle(color: AppColors.appColorWhite, fontSize: 15),
                                  //             ),
                                  //           ],
                                  //         ),
                                  //         Text(formatNumber(e.amount),
                                  //             style: TextStyle(color: AppColors.appColorWhite, fontSize: 15)),
                                  //       ],
                                  //     );
                                  //   },
                                  // ).toList(),
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      height: 40,
                      width: 600,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(color: AppColors.appColorBlackBg, borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(UniconsLine.shopping_bag, color: AppColors.appColorWhite, size: 25),
                          Text('Savdo maxsulot', style: TextStyle(color: AppColors.appColorWhite, fontSize: 18)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      height: 580,
                      width: 600,
                      decoration: BoxDecoration(color: AppColors.appColorBlackBg, borderRadius: BorderRadius.circular(15)),
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 10),
                        itemCount: tradeForEdit.productsInTrade.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (priceControllers.length <= index) {
                            priceControllers.add(TextEditingController(
                              text: formatNumber(tradeForEdit.productsInTrade[index].price),
                            ));
                          }
                          // TextEditingController priceController = TextEditingController(
                          //   text: tradeForEdit.productsInTrade[index].price.toString(),
                          // );
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            height: 55,
                            width: 100,
                            decoration: BoxDecoration(color: AppColors.appColorGrey700.withOpacity(0.6), borderRadius: BorderRadius.circular(15)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 7),
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(color: AppColors.appColorBlackBg, borderRadius: BorderRadius.circular(15)),
                                      child: Text('${index + 1}', style: TextStyle(color: AppColors.appColorWhite, fontSize: 15)),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              tradeForEdit.productsInTrade[index].product.name,
                                              style: TextStyle(color: AppColors.appColorWhite, fontSize: 17),
                                            ),
                                            Text(
                                              ' (${tradeForEdit.productsInTrade[index].product.vendorCode.toString()})',
                                              style: TextStyle(color: AppColors.appColorWhite.withOpacity(0.6), fontSize: 17),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            AppButton(
                                              onTap: () {
                                                if (tradeForEdit.productsInTrade[index].amount > 1) {
                                                  setState(() {
                                                    tradeForEdit.productsInTrade[index].amount--;
                                                  });
                                                }
                                              },
                                              width: 20,
                                              height: 20,
                                              color: AppColors.appColorRed400.withOpacity(0.7),
                                              borderRadius: BorderRadius.circular(10),
                                              hoverRadius: BorderRadius.circular(10),
                                              child: Center(child: Icon(Icons.remove_rounded, color: AppColors.appColorWhite, size: 18)),
                                            ),
                                            const SizedBox(width: 5),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8),
                                              decoration: BoxDecoration(
                                                color: AppColors.appColorGrey700.withOpacity(0.7),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                formatNumber(tradeForEdit.productsInTrade[index].amount),
                                                style: TextStyle(color: AppColors.appColorWhite, fontSize: 16),
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            AppButton(
                                              onTap: () {
                                                setState(() {
                                                  tradeForEdit.productsInTrade[index].amount++ ;
                                                });
                                              },
                                              width: 20,
                                              height: 20,
                                              color: AppColors.appColorGreen400.withOpacity(0.7),
                                              borderRadius: BorderRadius.circular(10),
                                              hoverRadius: BorderRadius.circular(10),
                                              child: Center(child: Icon(Icons.add_rounded, color: AppColors.appColorWhite, size: 18)),
                                            ),
                                            const SizedBox(width: 50),
                                            SizedBox(
                                              width: 100,
                                              height: 25,
                                              child: AppInputUnderline(
                                                // key: UniqueKey(),
                                                controller: priceControllers[index],
                                                onChanged: (value) {
                                                  setState(() {
                                                    print(value);
                                                    tradeForEdit.productsInTrade[index].price = double.tryParse(value.replaceAll(" ", "")) ?? 0;
                                                    // tradeForEdit.productsInTrade[index].price =
                                                    //     double.tryParse(value.replaceAll(',', '')) ?? 0;
                                                    // priceController.selection  = TextSelection.fromPosition(TextPosition(offset: priceController.text.length));
                                                  });
                                                },
                                                // keyboardType: TextInputType.number,
                                                hintText: 'Narx',
                                                hideIcon: true,
                                                inputFormatters: [AppTextInputFormatter()],
                                              ),
                                            ),
                                            // Text(
                                            //   formatNumber(tradeForEdit.productsInTrade[index].price),
                                            //   style: TextStyle(color: AppColors.appColorWhite, fontSize: 15),
                                            // ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      formatNumber(tradeForEdit.productsInTrade[index].amount * tradeForEdit.productsInTrade[index].price),
                                      style: TextStyle(color: AppColors.appColorWhite, fontSize: 16),
                                    ),
                                    const SizedBox(width: 5),
                                    AppButton(
                                      onTap: () {
                                        setState(() {
                                          tradeForEdit.productsInTrade.removeAt(index);
                                        });
                                      },
                                      width: 27,
                                      height: 27,
                                      color: AppColors.appColorRed400,
                                      borderRadius: BorderRadius.circular(10),
                                      hoverRadius: BorderRadius.circular(10),
                                      child: Center(child: Icon(UniconsLine.trash_alt, color: AppColors.appColorWhite, size: 20)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
