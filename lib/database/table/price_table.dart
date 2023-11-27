import 'package:drift/drift.dart';
import 'package:easy_sell/database/table/product_table.dart';

import 'currency_table.dart';

class Price extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get currencyId => integer().references(CurrencyTable, #id)();


  DateTimeColumn get discountExpired => dateTime().nullable()();

  RealColumn get discount => real().withDefault(const Constant(0.0))();

  RealColumn get value => real().withDefault(const Constant(0.0))();

  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  IntColumn get productId => integer().references(Product, #id)();

  DateTimeColumn get syncedAt => dateTime().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  IntColumn get serverId => integer().nullable()();
}
