import 'package:drift/drift.dart';

import '../my_database.dart';
import '../table/invoice_table.dart';

part 'invoice_dao.g.dart';

@DriftAccessor(tables: [Transactions])
class TransactionsDao extends DatabaseAccessor<MyDatabase> with _$TransactionsDaoMixin {
  TransactionsDao(MyDatabase db) : super(db);

  // get all
  Future<List<Transaction>> getAll({DateTime? at}) {
    if (at != null) {
      return (select(transactions)..where((t) => t.createdAt.isSmallerOrEqualValue(at))).get();
    }
    return select(transactions).get();
  }

  // get by id
  Future<Transaction> getById(int id) => (select(transactions)..where((t) => t.id.equals(id))).getSingle();

  // get by trade id
  Future<List<Transaction>> getByTradeId(int tradeId) => (select(transactions)..where((t) => t.tradeId.equals(tradeId))).get();

  // get by trade id list
  Future<List<Transaction>> getByTradeIds(int tradeId) => (select(transactions)..where((t) => t.tradeId.equals(tradeId))).get();

  // create new
  Future<int> createNewInvoice(TransactionsCompanion entry) => into(transactions).insert(entry);

  Future<void> replaceByData(Transaction entry) async {
    await update(transactions).replace(entry);
  }

  Future<Transaction?> getByServerId(int serverId) {
    return (select(transactions)..where((t) => t.serverId.equals(serverId))).getSingleOrNull();
  }

  Future<void> deleteByTradeId(int id) async {
    await (delete(transactions)..where((t) => t.tradeId.equals(id))).go();
  }
}
