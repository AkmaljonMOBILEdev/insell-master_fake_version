import 'package:drift/drift.dart';
import 'package:easy_sell/database/table/currency_table.dart';
import '../my_database.dart';

part 'currency_dao.g.dart';

@DriftAccessor(tables: [CurrencyTable])
class CurrencyDao extends DatabaseAccessor<MyDatabase> with _$CurrencyDaoMixin {
  CurrencyDao(MyDatabase db) : super(db);

  Future<CurrencyTableData?> getByServerId(item) async {
    return await (select(currencyTable)..where((tbl) => tbl.serverId.equals(item))).getSingleOrNull();
  }
}
