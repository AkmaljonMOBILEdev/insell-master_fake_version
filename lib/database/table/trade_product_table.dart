import 'package:drift/drift.dart';
import 'package:easy_sell/database/table/product_table.dart';
import 'package:easy_sell/database/table/trade_table.dart';

class TradeProduct extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get productId => integer().references(Product, #id)();

  RealColumn get amount => real()();

  RealColumn get price => real()();

  TextColumn get priceName => text().nullable()();

  RealColumn get discount => real().nullable()();

  TextColumn get unit => text()();

  IntColumn get tradeId => integer().references(Trade, #id).nullable()();

  IntColumn get serverId => integer().nullable()();

  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  DateTimeColumn get syncedAt => dateTime().nullable()();

  DateTimeColumn get updatedAt => dateTime()();

  DateTimeColumn get createdAt => dateTime()();
}
