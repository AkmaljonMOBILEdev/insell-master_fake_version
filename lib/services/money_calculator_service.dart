import 'package:easy_sell/database/model/trade_dto.dart';
import 'package:easy_sell/database/table/invoice_table.dart';
import '../database/my_database.dart';

class MoneyCalculatorService {
  final MyDatabase database;

  MoneyCalculatorService({required this.database});

  Future<List<TradeDTO>> getClientAllTrades(int clientId, {DateTime? at}) async {
    return await database.tradeDao.getTradeByClientId(clientId, at: at);
  }

  Future<double> calculatePos({
    InvoiceType? invoiceType,
    DateTime? at,
  }) async {
    double totalCheck = 0;
    List<Transaction> invoices = await database.transactionsDao.getAll(at: at);
    for (Transaction invoice in invoices) {
      if (invoiceType != null) {
        if (invoice.payType == invoiceType) {
          if (invoice.income == true) {
            totalCheck += invoice.amount;
          } else {
            totalCheck -= invoice.amount;
          }
        }
      } else {
        totalCheck += invoice.amount;
      }
    }
    return totalCheck;
  }
}
