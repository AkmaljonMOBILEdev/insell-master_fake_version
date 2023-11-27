import 'dart:convert';

import 'package:easy_sell/database/model/client_dto.dart';
import 'package:easy_sell/database/table/invoice_table.dart';
import 'package:easy_sell/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';
import '../../../../../constants/colors.dart';
import '../../../../../database/model/trade_dto.dart';
import '../../../../../database/my_database.dart';
import '../../../../../utils/utils.dart';
import '../../../../../widgets/app_dialog.dart';
import '../../../../client_screen/widget/client_info_dialog.dart';

class TradeHistoryDialog extends StatefulWidget {
  const TradeHistoryDialog({super.key, required this.trade});

  final TradeDTO trade;


  @override
  State<TradeHistoryDialog> createState() => _TradeHistoryDialogState();
}

class _TradeHistoryDialogState extends State<TradeHistoryDialog> {
  MyDatabase database = Get.find<MyDatabase>();
  Map _employee = {};
  ClientData? _client;
  bool _showMoreFields = false;

  @override
  void initState() {
    super.initState();
    _getClient();
    _getEmployee();
    totalSum();
  }

  void _getEmployee() async {
    var _user = await storage.read('user');
    if (_user != null) {
      setState(() {
        _employee = jsonDecode(_user);
      });
    }
  }

  void _getClient() async {
    if (widget.trade.trade.clientId != null) {
      ClientData client = await database.clientDao.getById(widget.trade.trade.clientId ?? 0);
      setState(() {
        _client = client;
      });
    }
  }

  double totalSum() {
    double total = 0;
    for (var element in widget.trade.data) {
      total += element.price * element.amount;
    }
    return total;
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
        width: Get.width * 0.9,
        height: Get.height * 0.9,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Container(
                      height: Get.height * 0.4,
                      width: Get.width * 0.39,
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
                                    message: widget.trade.trade.isReturned
                                        ? 'Qaytgan savdo ID:${widget.trade.trade.id}'
                                        : 'Savdo ID:${widget.trade.trade.id}',
                                    child: Icon(
                                      widget.trade.trade.isReturned
                                          ? Icons.keyboard_double_arrow_down_rounded
                                          : Icons.keyboard_double_arrow_up_rounded,
                                      color:
                                          widget.trade.trade.isReturned ? AppColors.appColorRed300 : AppColors.appColorGreen400,
                                    ),
                                  ),
                                  Text(
                                    widget.trade.trade.isReturned ? 'Qaytish' : 'Savdo',
                                    style: TextStyle(color: AppColors.appColorWhite, fontSize: 18),
                                  ),
                                ],
                              ),
                              Tooltip(
                                message: widget.trade.trade.isSynced ? formatDateTime(widget.trade.trade.finishedAt) : '-',
                                child: Icon(
                                  widget.trade.trade.isSynced ? Icons.cloud_done_outlined : Icons.cloud_off_outlined,
                                  color: widget.trade.trade.isSynced ? AppColors.appColorGreen400 : AppColors.appColorRed300,
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
                                  Icon(UniconsLine.user_nurse, color: AppColors.appColorWhite),
                                  Text('Sotuvchi:', style: TextStyle(color: AppColors.appColorWhite, fontSize: 18)),
                                ],
                              ),
                              Text('${_employee['name'] ?? ''}', style: TextStyle(color: AppColors.appColorWhite, fontSize: 18)),
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
                              Row(
                                children: [
                                  AppButton(
                                    onTap: () {
                                      if (_client != null) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ClientInfoDialog(
                                              callback: () {},
                                              client: ClientDto.fromClientData(_client),
                                            );
                                          },
                                        );
                                      }
                                    },
                                    height: 28,
                                    width: 30,
                                    hoverRadius: BorderRadius.circular(10),
                                    child: Center(
                                      child: Icon(Icons.info_outline_rounded, color: AppColors.appColorGreen400, size: 21),
                                    ),
                                  ),
                                  Text(_client?.name ?? '-', style: TextStyle(color: AppColors.appColorWhite, fontSize: 18)),
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
                              Text(formatDateTime(widget.trade.trade.finishedAt),
                                  style: TextStyle(color: AppColors.appColorWhite, fontSize: 18)),
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
                              Row(
                                children: [
                                  const Icon(UniconsLine.percentage, color: Colors.orange),
                                  Text('Chegirma:', style: TextStyle(color: AppColors.appColorWhite, fontSize: 18)),
                                ],
                              ),
                              Text(formatNumber(widget.trade.trade.discount),
                                  style: TextStyle(color: AppColors.appColorWhite, fontSize: 18)),
                            ],
                          ),
                          Divider(color: AppColors.appColorGrey700, height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(UniconsLine.comment_alt, color: AppColors.appColorWhite),
                                  Text('Izoh:', style: TextStyle(color: AppColors.appColorWhite, fontSize: 18)),
                                ],
                              ),
                              Text(
                                widget.trade.trade.description ?? '-',
                                style: TextStyle(color: AppColors.appColorWhite, fontSize: 18),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      height: Get.height * 0.30,
                      width: Get.width * 0.39,
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
                              Text(formatNumber((totalSum()) - (widget.trade.trade.discount ?? 0)),
                                  style: TextStyle(color: AppColors.appColorWhite, fontSize: 18)),
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
                                formatNumber(widget.trade.trade.refund),
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
                                      formatNumber(widget.trade.invoices
                                          .fold(0, (previousValue, element) => previousValue + element.amount.toInt())),
                                      style: TextStyle(color: AppColors.appColorWhite, fontSize: 18),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                              height: _showMoreFields ? Get.height * 0.13 : 0,
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              decoration: BoxDecoration(color: Colors.grey.shade900, borderRadius: BorderRadius.circular(15)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: widget.trade.invoices.map(
                                  (e) {
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const SizedBox(width: 10),
                                            Icon(
                                              e.payType == InvoiceType.CASH
                                                  ? UniconsLine.money_bill
                                                  : e.payType == InvoiceType.CARD
                                                      ? UniconsLine.credit_card
                                                      : e.payType == InvoiceType.CASHBACK
                                                          ? UniconsLine.percentage
                                                          : Icons.other_houses_rounded,
                                              color: AppColors.appColorWhite,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              e.payType == InvoiceType.CASH
                                                  ? 'Naqd:'
                                                  : e.payType == InvoiceType.CARD
                                                      ? 'Karta:'
                                                      : e.payType == InvoiceType.CASHBACK
                                                          ? 'Cashback:'
                                                          : 'Bank:',
                                              style: TextStyle(color: AppColors.appColorWhite, fontSize: 15),
                                            ),
                                          ],
                                        ),
                                        Text(formatNumber(e.amount),
                                            style: TextStyle(color: AppColors.appColorWhite, fontSize: 15)),
                                      ],
                                    );
                                  },
                                ).toList(),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      height: 40,
                      width: Get.width * 0.45,
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
                      height: Get.height * 0.65,
                      width: Get.width * 0.45,
                      decoration: BoxDecoration(color: AppColors.appColorBlackBg, borderRadius: BorderRadius.circular(15)),
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 10),
                        itemCount: widget.trade.tradeProducts.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            height: 55,
                            width: 100,
                            decoration: BoxDecoration(color: AppColors.appColorGrey700, borderRadius: BorderRadius.circular(15)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 7),
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                          color: AppColors.appColorBlackBg, borderRadius: BorderRadius.circular(15)),
                                      child: Text('${index + 1}', style: TextStyle(color: AppColors.appColorWhite, fontSize: 15)),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(widget.trade.tradeProducts[index].product.productData.name,
                                            style: TextStyle(color: AppColors.appColorWhite, fontSize: 17)),
                                        Text(
                                          '${formatNumber(widget.trade.tradeProducts[index].tradeProduct.amount)} * ${formatNumber(widget.trade.tradeProducts[index].tradeProduct.price)}',
                                          style: TextStyle(color: AppColors.appColorWhite, fontSize: 15),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                Text(
                                  formatNumber(widget.trade.tradeProducts[index].tradeProduct.amount *
                                      widget.trade.tradeProducts[index].tradeProduct.price),
                                  style: TextStyle(color: AppColors.appColorWhite, fontSize: 16),
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
