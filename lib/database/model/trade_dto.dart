import 'package:easy_sell/database/model/trade_product_data_dto.dart';
import 'package:easy_sell/database/model/trade_product_dto.dart';
import 'package:easy_sell/database/my_database.dart';

class TradeDTO {
  final TradeData trade;
  final List<TradeProductDto> tradeProducts;
  final List<Transaction> invoices;
  final List<TradeProductDataDto> data;

  TradeDTO({required this.trade, required this.tradeProducts, required this.invoices, required this.data});

  toJson() {
    return {
      'trade': trade.toJson(),
      'tradeProducts': tradeProducts.map((e) => e.toJson()).toList(),
      "transactions": invoices.map((e) => e.toJson()).toList(),
      'data': data.map((e) => e.toJson()).toList(),
    };
  }

  List<dynamic> toArray() {
    return [
      tradeProducts.map((e) => e.toJson()).toList(),
      invoices.map((e) => e.toJson()).toList(),
      data.map((e) => e.toJson()).toList(),
    ];
  }

  List<dynamic> toList() {
    return [
      trade.toJson(),
      tradeProducts.map((e) => e.toJson()).toList(),
      invoices.map((e) => e.toJson()).toList(),
      data.map((e) => e.toJson()).toList(),
    ];
  }

  // get only this fields: [];
  List<dynamic> getFields(dynamic dto, List<String> fields) {
    List<dynamic> result = [];
    fields.map((e) => result.add(dto[e]));
    return result;
  }
}
