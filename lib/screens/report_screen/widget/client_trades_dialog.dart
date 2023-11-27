import 'package:easy_sell/screens/report_screen/widget/report_trade_info.dart';
import 'package:easy_sell/utils/utils.dart';
import 'package:easy_sell/widgets/app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../database/model/trade_struct.dart';

class ClientTradesDialog extends StatefulWidget {
  const ClientTradesDialog({super.key, required this.trades});

  final List<TradeStruct> trades;

  @override
  State<ClientTradesDialog> createState() => _ClientTradesDialogState();
}

class _ClientTradesDialogState extends State<ClientTradesDialog> {
  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: const Text('Mijoz savdolari', style: TextStyle(color: Colors.white)),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        height: MediaQuery.of(context).size.height * 0.8,
        child: ListView.separated(
          separatorBuilder: (context, index) => const Divider(color: Colors.white),
          itemCount: widget.trades.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                widget.trades[index].client?.name ?? 'Tanlanmagan',
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Row(
                children: [
                  Text(
                    formatNumber(
                      widget.trades[index].productsInTrade.fold(0.0, (previousValue, element) => previousValue + element.price),
                    ),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
              trailing: IconButton(
                onPressed: () => Get.to(
                  () => TradeInfoScreen(
                    trade: widget.trades[index],
                  ),
                ),
                icon: const Icon(Icons.info_outline, color: Colors.white),
              ),
            );
          },
        ),
      ),
    );
  }
}
