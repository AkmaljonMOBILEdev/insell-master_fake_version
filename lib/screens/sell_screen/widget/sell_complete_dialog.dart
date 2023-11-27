import 'dart:async';
import 'dart:convert';
import 'package:easy_sell/database/model/cashback_dto.dart';
import 'package:easy_sell/database/model/discount_dto.dart';
import 'package:easy_sell/database/model/trade_dto.dart';
import 'package:easy_sell/database/table/invoice_table.dart';
import 'package:easy_sell/services/storage_services.dart';
import 'package:easy_sell/utils/receipt.dart';
import 'package:easy_sell/widgets/app_input_underline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';
import '../../../constants/colors.dart';
import '../../../database/my_database.dart';
import '../../../utils/utils.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_dialog.dart';

class SellCompleteDialog extends StatefulWidget {
  const SellCompleteDialog({
    super.key,
    this.client,
    required this.totalSum,
    required this.onPay,
    required this.currentTrade,
    required this.checkClientDebt,
  });

  final ClientData? client;
  final double totalSum;
  final Function(ClientData? client, {double? discount, double? refund}) onPay;
  final TradeDTO currentTrade;
  final double checkClientDebt;

  @override
  State<SellCompleteDialog> createState() => _SellCompleteDialogState();
}

class _SellCompleteDialogState extends State<SellCompleteDialog> {
  MyDatabase database = Get.find<MyDatabase>();
  Storage storage = Storage();
  final TextEditingController _paymentForCashController =
      TextEditingController();
  final TextEditingController _paymentForCardController =
      TextEditingController();
  final TextEditingController _paymentForBankController =
      TextEditingController();
  final TextEditingController _paymentForCashbackController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool printReceipt = true;
  bool isCredit = false;
  bool _showMoreFields = false;
  bool _moreFieldsVisible = false;
  bool checkoutSet = true;
  EmployeeData? _employee;
  List<Transaction>? _invoice;
  double discountPercent = 0.0;
  double? cashbackPercent;
  AppTextInputFormatter formatterForDiscount = AppTextInputFormatter();
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    findDiscountPercent();
    findCashbackPercent();
    getEmployee();
  }

  void findDiscountPercent() async {
    double totalSum = widget.totalSum;
    var discountSettings = (await storage.read("discount_settings")) ?? "{}";

    List<DiscountDataStruct> discountDataStructs = [];
    for (var item in jsonDecode(discountSettings)['data']) {
      discountDataStructs.add(DiscountDataStruct.fromJson(item));
    }

    for (var discount in discountDataStructs) {
      for (var discountRole in discount.discountRoles) {
        if (totalSum >= (discountRole.from ?? 0) &&
            totalSum <= (discountRole.to ?? double.maxFinite)) {
          if (discountRole.clientTypeId == widget.client?.typeId) {
            setState(() {
              discountPercent = discountRole.percent ?? 0;
            });
          }
        }
      }
    }

    _paymentForCashController.text =
        formatNumber(widget.totalSum - calculateAutoDiscount());
    setState(() {});
  }

  void findCashbackPercent() async {
    double totalSum = widget.totalSum;
    var cashbackSettings = (await storage.read("cashback_settings")) ?? "{}";

    List<CashbackDataStruct> cashbackDataStructs = [];
    for (var item in jsonDecode(cashbackSettings)['data']) {
      cashbackDataStructs.add(CashbackDataStruct.fromJson(item));
    }
    CashbackDataStruct? currentCashback = cashbackDataStructs
        .firstWhereOrNull((element) => element.id == widget.client?.cashbackId);

    for (var cashbackRole in currentCashback?.cashbackRoles ?? []) {
      if (totalSum >= (cashbackRole.from ?? 0) &&
          totalSum <= (cashbackRole.to ?? double.maxFinite)) {
        setState(() {
          cashbackPercent = cashbackRole.percent ?? 0;
        });
      }
    }
    setState(() {});
  }

  RegExp spaceRemover = RegExp(r"\s+");
  bool buttonDisabled = false;

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      backgroundColor: Colors.black.withOpacity(0.9),
      title: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(Icons.highlight_off_rounded,
                  color: AppColors.appColorRed400, size: 25),
            ),
          ),
          const SizedBox(height: 10),
          Text('To\'lovni amalga oshirish',
              style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
        ],
      ),
      content: Form(
        child: SizedBox(
          width: 900,
          height: 350,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 400,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: AppColors.appColorBlackBg,
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(UniconsLine.user,
                                color: AppColors.appColorWhite),
                            const SizedBox(width: 3),
                            Text('Mijoz',
                                style: TextStyle(
                                    color: AppColors.appColorWhite,
                                    fontSize: 18)),
                          ],
                        ),
                        widget.client != null
                            ? Column(
                                children: [
                                  Text(widget.client?.name ?? "",
                                      style: TextStyle(
                                          color: AppColors.appColorWhite,
                                          fontSize: 16)),
                                ],
                              )
                            : Text('Tanlanmagan',
                                style: TextStyle(
                                    color: AppColors.appColorWhite,
                                    fontSize: 18)),
                      ],
                    ),
                    Divider(color: AppColors.appColorGrey700),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(UniconsLine.money_bill,
                                color: Colors.blue),
                            const SizedBox(width: 3),
                            Text('Umumiy summa:',
                                style: TextStyle(
                                    color: AppColors.appColorWhite,
                                    fontSize: 18)),
                          ],
                        ),
                        Text(formatNumber(widget.totalSum),
                            style: TextStyle(
                                color: AppColors.appColorWhite, fontSize: 18)),
                      ],
                    ),
                    Divider(color: AppColors.appColorGrey700),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(UniconsLine.percentage,
                                color: Colors.orange),
                            const SizedBox(width: 3),
                            Text('Chegirma:',
                                style: TextStyle(
                                    color: AppColors.appColorWhite,
                                    fontSize: 18)),
                          ],
                        ),
                        Text(formatNumber(calculateAutoDiscount()),
                            style: TextStyle(
                                color: AppColors.appColorWhite, fontSize: 18)),
                      ],
                    ),
                    Divider(color: AppColors.appColorGrey700),
                    if (cashbackPercent != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.expand_circle_down_outlined,
                                  color: Colors.teal),
                              const SizedBox(width: 3),
                              Text('Cashback:',
                                  style: TextStyle(
                                      color: AppColors.appColorWhite,
                                      fontSize: 18)),
                            ],
                          ),
                          Text(
                              formatNumber(
                                  ((cashbackPercent ?? 0) * widget.totalSum) /
                                      100),
                              style: TextStyle(
                                  color: AppColors.appColorWhite,
                                  fontSize: 18)),
                        ],
                      ),
                    if (cashbackPercent != null)
                      Divider(color: AppColors.appColorGrey700),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(UniconsLine.money_withdraw,
                                color: AppColors.appColorGreen400),
                            const SizedBox(width: 3),
                            Text('To\'lov summasi:',
                                style: TextStyle(
                                    color: AppColors.appColorWhite,
                                    fontSize: 18)),
                          ],
                        ),
                        Text(
                            formatNumber(
                                widget.totalSum - calculateAutoDiscount()),
                            style: TextStyle(
                                color: AppColors.appColorWhite, fontSize: 18)),
                      ],
                    ),
                    Divider(color: AppColors.appColorGrey700),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade800.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(UniconsLine.money_withdrawal,
                                      color: AppColors.appColorWhite),
                                  const SizedBox(width: 3),
                                  Text('Kiritilgan summa:',
                                      style: TextStyle(
                                          color: AppColors.appColorWhite,
                                          fontSize: 18)),
                                ],
                              ),
                              Text(sumTotalPays(),
                                  style: TextStyle(
                                      color: AppColors.appColorWhite,
                                      fontSize: 18)),
                            ],
                          ),
                          checkoutSet
                              ? Column(
                                  children: [
                                    Divider(color: AppColors.appColorBlackBg),
                                    needToPaySumma() > 0
                                        ? SizedBox(
                                            height: 28,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(
                                                        UniconsLine.money_stack,
                                                        color: Colors.white),
                                                    const SizedBox(width: 3),
                                                    Text("To'lash kerak summa:",
                                                        style: TextStyle(
                                                            color: AppColors
                                                                .appColorWhite,
                                                            fontSize: 18)),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      formatNumber(
                                                          needToPaySumma()),
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .appColorRed300,
                                                          fontSize: 18),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        : SizedBox(
                                            height: 28,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(
                                                        UniconsLine.money_stack,
                                                        color:
                                                            Colors.tealAccent),
                                                    const SizedBox(width: 3),
                                                    Text('Qaytim summa:',
                                                        style: TextStyle(
                                                            color: AppColors
                                                                .appColorWhite,
                                                            fontSize: 18)),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      formatNumber(
                                                          calculateReturnSumma()),
                                                      style: TextStyle(
                                                          color: isCredit
                                                              ? AppColors
                                                                  .appColorRed300
                                                              : AppColors
                                                                  .appColorGreen300,
                                                          fontSize: 18),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                  ],
                                )
                              : const SizedBox()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 400,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: AppColors.appColorBlackBg,
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 340,
                              child: AppInputUnderline(
                                hintText: 'Naqd summa kiriting',
                                focusNode: _focusNode,
                                controller: _paymentForCashController,
                                onChanged: (value) => setState(() {}),
                                prefixIcon: UniconsLine.money_bill,
                                iconColor: AppColors.appColorWhite,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                inputFormatters: [AppTextInputFormatter()],
                              ),
                            ),
                            AppButton(
                              onTap: () {
                                setState(() {
                                  _paymentForCashController.clear();
                                  _focusNode.requestFocus();
                                });
                              },
                              height: 35,
                              width: 40,
                              hoverRadius: BorderRadius.circular(10),
                              child: Icon(Icons.clear_rounded,
                                  color: AppColors.appColorRed300),
                            )
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AppButton(
                              onTap: () {
                                setState(() {
                                  _showMoreFields = !_showMoreFields;
                                  fieldVisiblyIndicator();
                                });
                              },
                              height: 25,
                              width: 200,
                              hoverRadius: BorderRadius.circular(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Qo'shimcha to'lov turlari",
                                      style: TextStyle(
                                          color: AppColors.appColorWhite)),
                                  Icon(
                                    _showMoreFields
                                        ? Icons.keyboard_arrow_up_rounded
                                        : Icons.keyboard_arrow_down_rounded,
                                    color: AppColors.appColorGreen400,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        AnimatedContainer(
                          width: 400,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.fastOutSlowIn,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade900,
                              borderRadius: BorderRadius.circular(15)),
                          child: _moreFieldsVisible
                              ? Column(
                                  children: [
                                    const SizedBox(height: 5),
                                    AppInputUnderline(
                                      hintText: 'Bank summa kiriting',
                                      controller: _paymentForBankController,
                                      onChanged: (value) => setState(() {}),
                                      prefixIcon: Icons.other_houses_rounded,
                                      iconColor: AppColors.appColorWhite,
                                      inputFormatters: [
                                        AppTextInputFormatter()
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    AppInputUnderline(
                                      hintText: 'Karta summa kiriting',
                                      controller: _paymentForCardController,
                                      onChanged: (value) => setState(() {}),
                                      prefixIcon: UniconsLine.credit_card,
                                      iconColor: AppColors.appColorWhite,
                                      inputFormatters: [
                                        AppTextInputFormatter()
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    AppInputUnderline(
                                      hintText: 'Cashback summa kiriting',
                                      controller: _paymentForCashbackController,
                                      onChanged: (value) => setState(() {}),
                                      prefixIcon: UniconsLine.money_insert,
                                      iconColor: AppColors.appColorWhite,
                                      inputFormatters: [
                                        AppTextInputFormatter()
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                )
                              : const SizedBox(),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const SizedBox(height: 5),
                    Container(
                      height: 45,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade800.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(UniconsLine.print,
                                  color: AppColors.appColorWhite),
                              const SizedBox(width: 3),
                              Text('Chek chiqarish:',
                                  style: TextStyle(
                                      color: AppColors.appColorWhite,
                                      fontSize: 18)),
                            ],
                          ),
                          Transform.scale(
                            scale: 0.8,
                            child: Switch(
                              value: printReceipt,
                              activeColor: AppColors.appColorGreen400,
                              onChanged: (bool value) {
                                setState(() {
                                  printReceipt = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 40,
              width: 360,
              child: AppInputUnderline(
                  hintText: 'Izoh',
                  controller: _descriptionController,
                  prefixIcon: UniconsLine.comment_alt,
                  onChanged: (value) {
                    setState(() {});
                  }),
            ),
            const SizedBox(width: 15),
            AppButton(
              onTap: () {
                _clearFields();
              },
              height: 40,
              width: 40,
              borderRadius: BorderRadius.circular(15),
              hoverRadius: BorderRadius.circular(15),
              child: Center(
                child: Icon(Icons.cleaning_services_rounded,
                    color: AppColors.appColorWhite),
              ),
            ),
            const SizedBox(width: 15),
            AppButton(
              tooltip: '',
              onTap: buttonDisabled
                  ? null
                  : () async {
                      try {
                        setState(() {
                          buttonDisabled = true;
                        });
                        // if (widget.client == null) {
                        double returnSum = calculateReturnSumma();
                        if (returnSum < 0){
                          throw "Noto'g'ri summa kiritildi";
                        }
                        if (isCredit) {
                          throw "Mijoz tanlanmagan\n Tanlanmagan mijozga qarzga sotish mumkin emas";
                        } else if (!checkoutSet && returnSum > 0) {
                          throw "Ko'p pul kirgizilmoqda";
                        }
                        // }
                        double cashback = double.tryParse(
                                _paymentForCashbackController.text
                                    .replaceAll(spaceRemover, "")) ??
                            0;
                        double cashbackBalance = widget.client?.cashback ?? 0;
                        if (cashback > cashbackBalance) {
                          throw "Cashback miqdori yetarli emas";
                        }

                        if (_paymentForCashController.text.isNotEmpty) {
                          TransactionsCompanion newInvoiceForCash =
                              TransactionsCompanion(
                            updatedAt: toValue(DateTime.now()),
                            createdAt: toValue(DateTime.now()),
                            tradeId: toValue(widget.currentTrade.trade.id),
                            payType: toValue(InvoiceType.CASH),
                            income: toValue(true),
                            description: toValue(_descriptionController.text),
                            amount: toValue(((double.tryParse(
                                        _paymentForCashController.text
                                            .replaceAll(spaceRemover, "")) ??
                                    0) -
                                calculateReturnSumma()
                            )),
                          );
                          await database.transactionsDao
                              .createNewInvoice(newInvoiceForCash);
                        }
                        if (_paymentForCardController.text.isNotEmpty) {
                          TransactionsCompanion newInvoiceForCard =
                              TransactionsCompanion(
                            updatedAt: toValue(DateTime.now()),
                            createdAt: toValue(DateTime.now()),
                            tradeId: toValue(widget.currentTrade.trade.id),
                            payType: toValue(InvoiceType.CARD),
                            income: toValue(true),
                            description: toValue(_descriptionController.text),
                            amount: toValue(double.tryParse(
                                    _paymentForCardController.text
                                        .replaceAll(spaceRemover, "")) ??
                                0),
                          );
                          await database.transactionsDao
                              .createNewInvoice(newInvoiceForCard);
                        }
                        if (_paymentForBankController.text.isNotEmpty) {
                          TransactionsCompanion newInvoiceForBank =
                              TransactionsCompanion(
                            updatedAt: toValue(DateTime.now()),
                            createdAt: toValue(DateTime.now()),
                            tradeId: toValue(widget.currentTrade.trade.id),
                            payType: toValue(InvoiceType.TRANSFER),
                            income: toValue(true),
                            description: toValue(_descriptionController.text),
                            amount: toValue(double.tryParse(
                                    _paymentForBankController.text
                                        .replaceAll(spaceRemover, "")) ??
                                0),
                          );
                          await database.transactionsDao
                              .createNewInvoice(newInvoiceForBank);
                        }
                        if (_paymentForCashbackController.text.isNotEmpty) {
                          TransactionsCompanion newInvoiceForBank =
                              TransactionsCompanion(
                            updatedAt: toValue(DateTime.now()),
                            createdAt: toValue(DateTime.now()),
                            tradeId: toValue(widget.currentTrade.trade.id),
                            payType: toValue(InvoiceType.CASHBACK),
                            income: toValue(true),
                            description: toValue(_descriptionController.text),
                            amount: toValue(double.tryParse(
                                    _paymentForCashbackController.text
                                        .replaceAll(spaceRemover, "")) ??
                                0),
                          );
                          await database.transactionsDao
                              .createNewInvoice(newInvoiceForBank);
                        }
                        await widget.onPay(
                          widget.client,
                          refund: calculateReturnSumma(),
                          discount: calculateAutoDiscount(),
                        );
                        Future<List<Transaction>> getPayments(
                            int tradeId) async {
                          List<Transaction> invoice = await database
                              .transactionsDao
                              .getByTradeIds(tradeId);
                          setState(() {
                            _invoice = invoice;
                          });
                          return invoice;
                        }

                        await getPayments(widget.currentTrade.trade.id);

                        // double payCash = double.tryParse(_paymentForCashController.text.replaceAll(" ", "")) ?? 0;
                        // double payCard = double.tryParse(_paymentForCardController.text.replaceAll(" ", "")) ?? 0;
                        // double payBank = double.tryParse(_paymentForBankController.text.replaceAll(" ", "")) ?? 0;
                        // double payReceipt = payCash+payCard+payBank;
                        // print(payReceipt);

                        // print(_invoice);
                        double totalPay = 0.0;
                        for (var invoice in _invoice ?? []) {
                          totalPay += invoice.amount;
                        }

                        printReceipt
                            ? await GetAppReceipt().buildTradeReceipt(
                                trade: widget.currentTrade,
                                client: widget.client,
                                totalSum: widget.totalSum,
                                employee: _employee,
                                payment: totalPay,
                                refund: calculateReturnSumma(),
                                discount: calculateAutoDiscount(),
                              )
                            : null;
                        setState(() {
                          buttonDisabled = false;
                        });
                      } catch (e) {
                        setState(() {
                          buttonDisabled = false;
                        });
                        if (context.mounted) {
                          showAppAlertDialog(context,
                              title: 'DIQQAT!',
                              message: 'Xatolik:${e.toString()}',
                              buttonLabel: 'Ok',
                              cancelLabel: "Bekor qilish");
                        }
                      }
                    },
              width: 400,
              height: 40,
              color: AppColors.appColorGreen400,
              hoverColor: AppColors.appColorGreen300,
              colorOnClick: AppColors.appColorGreen700,
              splashColor: AppColors.appColorGreen700,
              borderRadius: BorderRadius.circular(12),
              hoverRadius: BorderRadius.circular(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Saqlash',
                    style: TextStyle(
                        color: AppColors.appColorWhite,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        letterSpacing: 1),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> getEmployee() async {
    PosSessionData? data = await database.posSessionDao.getLastSession();
    EmployeeData? employee =
        await database.employeeDao.getById(data?.cashier ?? 0);
    setState(() {
      _employee = employee;
    });
  }

  void fieldVisiblyIndicator() {
    if (_showMoreFields == true) {
      Timer(const Duration(milliseconds: 200), () {
        setState(() {
          _moreFieldsVisible = true;
        });
      });
    } else {
      Timer(const Duration(milliseconds: 100), () {
        setState(() {
          _moreFieldsVisible = false;
        });
      });
    }
  }

  void _clearFields() {
    _paymentForCashController.clear();
    _paymentForCardController.clear();
    _paymentForCashbackController.clear();
    _paymentForBankController.clear();
    _descriptionController.clear();
    setState(() {});
  }

  double calculateReturnSumma() {
    double returnSum = 0;
    bool isNotEmpty = _paymentForCashController.text.isNotEmpty ||
        _paymentForCardController.text.isNotEmpty ||
        _paymentForBankController.text.isNotEmpty ||
        _paymentForCashbackController.text.isNotEmpty;
    if (isNotEmpty) {
      double paymentSumCash = double.tryParse(_paymentForCashController.text.replaceAll(spaceRemover, "")) ?? 0;
      double paymentSumCard = double.tryParse(
              _paymentForCardController.text.replaceAll(spaceRemover, "")) ??
          0;
      double paymentSumBank = double.tryParse(
              _paymentForBankController.text.replaceAll(spaceRemover, "")) ??
          0;
      double paymentSumCashBack = double.tryParse(_paymentForCashbackController
              .text
              .replaceAll(spaceRemover, "")) ??
          0;
      double noCashSum = paymentSumCard + paymentSumBank + paymentSumCashBack;
      if (noCashSum > widget.totalSum - calculateAutoDiscount()) {
        return widget.totalSum - calculateAutoDiscount() - noCashSum;
      }
      returnSum = (paymentSumCash +
              paymentSumCard +
              paymentSumBank +
              paymentSumCashBack) -
          (widget.totalSum - calculateAutoDiscount());
    } else {
      returnSum = -widget.totalSum - calculateAutoDiscount();
    }
    setState(() {
      isCredit = returnSum < 0;
    });
    return returnSum < 0 ? 0 : returnSum;
  }

  String sumTotalPays() {
    bool isNotEmpty = _paymentForCashController.text.isNotEmpty ||
        _paymentForCardController.text.isNotEmpty ||
        _paymentForBankController.text.isNotEmpty ||
        _paymentForCashbackController.text.isNotEmpty;
    if (isNotEmpty) {
      double paymentSumCash = double.tryParse(_paymentForCashController.text.replaceAll(spaceRemover, '')) ?? 0;
      double paymentSumCard = double.tryParse(
              _paymentForCardController.text.replaceAll(spaceRemover, '')) ??
          0;
      double paymentSumBank = double.tryParse(
              _paymentForBankController.text.replaceAll(spaceRemover, '')) ??
          0;
      double paymentSumCashBack = double.tryParse(_paymentForCashbackController
              .text
              .replaceAll(spaceRemover, '')) ??
          0;
      return formatNumber(paymentSumCash +
          paymentSumCard +
          paymentSumBank +
          paymentSumCashBack);
    }
    return formatNumber(0);
  }

  double calculateAutoDiscount() {
    double totalSum = widget.totalSum;
    double discount = totalSum * (discountPercent / 100);
    totalSum = totalSum - discount;
    return totalSum % 1000 + discount;
  }

  double needToPaySumma() {
    double totalSum = widget.totalSum;
    totalSum = totalSum - calculateAutoDiscount();
    double paymentSumCash = double.tryParse(
            _paymentForCashController.text.replaceAll(spaceRemover, "")) ??
        0;
    double paymentSumCard = double.tryParse(
            _paymentForCardController.text.replaceAll(spaceRemover, "")) ??
        0;
    double paymentSumBank = double.tryParse(
            _paymentForBankController.text.replaceAll(spaceRemover, "")) ??
        0;
    double paymentSumCashBack = double.tryParse(
            _paymentForCashbackController.text.replaceAll(spaceRemover, "")) ??
        0;
    double needToPay = totalSum -
        (paymentSumCash + paymentSumCard + paymentSumBank + paymentSumCashBack);
    return needToPay;
  }
}
