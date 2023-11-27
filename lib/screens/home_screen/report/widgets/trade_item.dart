import 'package:easy_sell/database/model/trade_dto.dart';
import 'package:flutter/material.dart';

import '../../../sell_screen/screens/trade_history_screen/widgets/trade_history_dialog.dart';

class TradeItem extends StatefulWidget {
  const TradeItem({super.key, required this.tradeDTO});

  final TradeDTO tradeDTO;

  @override
  State<TradeItem> createState() => _TradeItemState();
}

class _TradeItemState extends State<TradeItem> {
  @override
  Widget build(BuildContext context) {
    return TradeHistoryDialog(trade: widget.tradeDTO);
  }
}
