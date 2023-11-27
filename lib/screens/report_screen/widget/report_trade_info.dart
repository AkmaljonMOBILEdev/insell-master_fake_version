import 'package:easy_sell/database/model/trade_struct.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../database/model/transactions_dto.dart';
import '../../../utils/utils.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_table_item.dart';

class TradeInfoScreen extends StatefulWidget {
  const TradeInfoScreen({super.key, required this.trade});

  final TradeStruct trade;

  @override
  State<TradeInfoScreen> createState() => _TradeInfoScreenState();
}

class _TradeInfoScreenState extends State<TradeInfoScreen> {
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
        title: Text("Savdo Ma'lumoti ( #${widget.trade.id} )", style: TextStyle(color: AppColors.appColorWhite)),
        centerTitle: false,
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        padding: const EdgeInsets.only(right: 10, left: 10, bottom: 10, top: 65),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xFF26525f), Color(0xFF0f2228)],
          ),
        ),
        child: TradeCheckCard(trade: widget.trade),
      ),
    );
  }
}

class TradeCheckCard extends StatefulWidget {
  const TradeCheckCard({super.key, required this.trade});

  final TradeStruct trade;

  @override
  State<TradeCheckCard> createState() => _TradeCheckCardState();
}

class _TradeCheckCardState extends State<TradeCheckCard> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            "Savdo Ma'lumoti",
            style: TextStyle(color: AppColors.appColorWhite, fontSize: 30),
          ),
          const SizedBox(height: 20),
          Container(
            width: width / 1.25,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(13),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5)),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.appColorGrey700), borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.shopping_bag_outlined, color: Colors.white),
                                const SizedBox(width: 10),
                                Text("Savdo Ma'lumoti", style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
                              ],
                            ),
                            Divider(color: AppColors.appColorWhite),
                            ListTile(
                              contentPadding: const EdgeInsets.all(0),
                              leading: const Icon(Icons.sell_outlined, color: Colors.white),
                              title: Text(
                                "Savdo ID:${widget.trade.id}",
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Text(
                                formatDateTime(widget.trade.createdTime),
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            ListTile(
                              isThreeLine: true,
                              contentPadding: const EdgeInsets.all(0),
                              leading: const Icon(Icons.comment_bank_outlined, color: Colors.white),
                              title: const Text(
                                "Izoh:",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Text(
                                widget.trade.description ?? '-',
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    // invoice info
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.appColorGrey700), borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.receipt_long_outlined, color: Colors.white),
                                const SizedBox(width: 10),
                                Text("Chek Ma'lumoti", style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
                              ],
                            ),
                            Divider(color: AppColors.appColorWhite),
                            for (TransactionDataStruct invoice in widget.trade.invoices)
                              ListTile(
                                contentPadding: const EdgeInsets.all(0),
                                leading: Icon(
                                    invoice.payType.name == "CASH"
                                        ? Icons.money
                                        : invoice.payType.name == "TRANSFER"
                                            ? Icons.account_balance_wallet_outlined
                                            : Icons.credit_card_outlined,
                                    color: Colors.green),
                                title: Text(
                                  "${invoice.payType.name}: ${formatNumber(invoice.amount + (invoice.payType.name == "CASH" ? (widget.trade.refund ?? 0) : 0))} so'm",
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                subtitle: Text(
                                  formatDateTime(invoice.createdAt),
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    // client info
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.appColorGrey700), borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Mijoz Ma'lumoti", style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
                            Divider(color: AppColors.appColorWhite),
                            ListTile(
                              contentPadding: const EdgeInsets.all(0),
                              leading: const Icon(Icons.person, color: Colors.white),
                              title: Text(
                                "Mijoz :${widget.trade.client?.name ?? '-'}",
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Text(
                                (widget.trade.client?.phoneNumber ?? "-"),
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            ListTile(
                              isThreeLine: true,
                              contentPadding: const EdgeInsets.all(0),
                              leading: const Icon(Icons.location_history_sharp, color: Colors.white),
                              title: Text(
                                "Region: ${widget.trade.client?.region?.name ?? '-'}",
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Text(
                                widget.trade.client?.address ?? '-',
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Divider(color: AppColors.appColorWhite),
                const SizedBox(height: 20),
                Text("Savdo Tovarlar", style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
                const SizedBox(height: 20),
                AppTableItems(
                  height: 50,
                  items: [
                    AppTableItemStruct(
                      flex: 3,
                      innerWidget: const Center(
                        child: Text(
                          "Tovar",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    AppTableItemStruct(
                      flex: 1,
                      innerWidget: const Center(
                        child: Text(
                          "Soni",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    AppTableItemStruct(
                      flex: 2,
                      innerWidget: const Center(
                        child: Text(
                          "Narxi",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    AppTableItemStruct(
                      flex: 4,
                      innerWidget: const Center(
                        child: Text(
                          "Jami",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                for (ProductInTrade product in widget.trade.productsInTrade)
                  AppTableItems(
                    height: 50,
                    items: [
                      AppTableItemStruct(
                        flex: 3,
                        innerWidget: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                product.product.name,
                                style: const TextStyle(color: Colors.white),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                product.product.code ?? '',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      AppTableItemStruct(
                        flex: 1,
                        innerWidget: Center(
                          child: Text(
                            formatNumber(product.amount),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      AppTableItemStruct(
                        flex: 2,
                        innerWidget: Center(
                          child: Text(
                            formatNumber(product.price),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      AppTableItemStruct(
                        flex: 4,
                        innerWidget: Center(
                          child: Text(
                            "${formatNumber(product.amount)} x ${formatNumber(product.price)} = ${formatNumber(product.amount * product.price)}",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.appColorGrey700.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: AppTableItems(
                    height: 50,
                    hideBorder: true,
                    items: [
                      AppTableItemStruct(
                        flex: 3,
                        innerWidget: Center(
                          child: Text(
                            "To'lov: ${formatNumber(widget.trade.invoices.fold(0.0, (previousValue, element) => previousValue + element.amount) + (widget.trade.refund ?? 0).toDouble())} so'm",
                            style: const TextStyle(color: Colors.green),
                          ),
                        ),
                      ),
                      AppTableItemStruct(
                        flex: 4,
                        innerWidget: Center(
                          child: Text(
                            "Skidka: ${formatNumber(widget.trade.discount)} so'm",
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                      AppTableItemStruct(
                        flex: 4,
                        innerWidget: Center(
                          child: Text(
                            "Qaytim: ${formatNumber(widget.trade.refund)} so'm",
                            style: const TextStyle(color: Colors.orange),
                          ),
                        ),
                      ),
                      AppTableItemStruct(
                        flex: 4,
                        innerWidget: Center(
                          child: Text(
                            "Jami:  ${formatNumber(widget.trade.productsInTrade.fold(0.0, (previousValue, element) => previousValue + element.amount * element.price))} so'm",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
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
}
