import 'package:easy_sell/database/model/trade_dto.dart';
import 'package:easy_sell/screens/sell_screen/screens/trade_history_screen/widgets/trade_history_dialog.dart';
import 'package:easy_sell/utils/receipt.dart';
import 'package:easy_sell/utils/utils.dart';
import 'package:easy_sell/widgets/app_button.dart';
import 'package:easy_sell/widgets/app_table_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../constants/colors.dart';
import '../../../../../database/my_database.dart';

class TradeHistoryItem extends StatefulWidget {
  const TradeHistoryItem({super.key, required this.trade});

  final TradeDTO trade;

  @override
  State<TradeHistoryItem> createState() => _TradeHistoryItemState();
}

class _TradeHistoryItemState extends State<TradeHistoryItem> {
  MyDatabase database = Get.find<MyDatabase>();
  List<AppTableItemStruct> items = [];
  ClientData? _client;
  EmployeeData? _employee;
  double _totalSum = 0;
  List<Transaction>? _invoice;

  @override
  void didUpdateWidget(covariant TradeHistoryItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    itemBuilder();
  }

  void itemBuilder() async {
    items = [
      AppTableItemStruct(
        flex: 1,
        innerWidget: Center(
          child: Row(
            children: [
              Tooltip(
                message: widget.trade.trade.isReturned ? 'Qaytgan savdo' : 'Savdo',
                child: Icon(
                  widget.trade.trade.isReturned ? Icons.keyboard_double_arrow_down_rounded : Icons.keyboard_double_arrow_up_rounded,
                  color: widget.trade.trade.isReturned ? AppColors.appColorRed300 : AppColors.appColorGreen400,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(5)),
                child: Text('${widget.trade.trade.id}', style: const TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
      AppTableItemStruct(
        flex: 1,
        innerWidget: Center(
          child: Text(formatDateTime(widget.trade.trade.finishedAt), style: const TextStyle(color: Colors.white)),
        ),
      ),
      AppTableItemStruct(
        flex: 1,
        innerWidget: Center(
          child: Text(
            (widget.trade.trade.clientId != null) ? await getClientName(widget.trade.trade.clientId) : "-",
            style: TextStyle(color: widget.trade.trade.clientId != null ? AppColors.appColorGreen400 : Colors.white),
          ),
        ),
      ),
      AppTableItemStruct(
        flex: 1,
        innerWidget: Center(
          child: Text(totalSum(), style: const TextStyle(color: Colors.white)),
        ),
      ),
      AppTableItemStruct(
        flex: 1,
        innerWidget: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              widget.trade.trade.isReturned
                  ? const SizedBox(width: 35)
                  : AppButton(
                      onTap: () async {
                        double totalPay = 0.0;
                        for (var invoice in _invoice ?? []) {
                          totalPay += invoice.amount;
                        }
                        await GetAppReceipt().buildTradeReceipt(
                          trade: widget.trade,
                          client: _client,
                          totalSum: _totalSum,
                          employee: _employee,
                          payment: totalPay,
                        );
                      },
                      width: 32,
                      height: 32,
                      color: AppColors.appColorGrey700,
                      colorOnClick: AppColors.appColorGrey700,
                      borderRadius: BorderRadius.circular(12),
                      hoverRadius: BorderRadius.circular(12),
                      child: const Icon(Icons.print, color: Colors.white, size: 22),
                    ),
              const SizedBox(width: 10),
              AppButton(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return TradeHistoryDialog(trade: widget.trade);
                    },
                  );
                },
                width: 32,
                height: 32,
                color: AppColors.appColorGreen400,
                colorOnClick: AppColors.appColorGreen400,
                borderRadius: BorderRadius.circular(12),
                hoverRadius: BorderRadius.circular(12),
                child: const Icon(Icons.remove_red_eye_outlined, color: Colors.white, size: 23),
              ),
              const SizedBox(width: 25),
            ],
          ),
        ),
      ),
    ];
    setState(() {
      items = items;
    });
  }

  Future<String> getClientName(int? clientId) async {
    ClientData client = await database.clientDao.getById(clientId ?? -1);
    setState(() {
      _client = client;
    });
    return client.name;
  }

  Future<List<Transaction>> getPayments(int tradeId) async {
    List<Transaction> invoice = await database.transactionsDao.getByTradeId(tradeId);
    setState(() {
      _invoice = invoice;
    });
    return invoice;
  }

  String totalSum() {
    double sum = 0;
    // double discount = widget.trade.trade.discount == null ? 0 : widget.trade.trade.discount ?? 0;
    // sum -= discount;
    for (var element in widget.trade.tradeProducts) {
      sum += element.tradeProduct.amount * element.tradeProduct.price;
    }
    setState(() {
      _totalSum = sum;
    });
    return formatNumber(sum);
  }

  @override
  void initState() {
    super.initState();
    itemBuilder();
    getEmployee();
    getPayments(widget.trade.trade.id);
  }

  Future<void> getEmployee() async {
    PosSessionData? data = await database.posSessionDao.getLastSession();
    EmployeeData? employee = await database.employeeDao.getById(data?.cashier ?? 0);
    setState(() {
      _employee = employee;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppTableItems(
      height: 50,
      items: items,
      hideBorder: true,
    );
  }
}
