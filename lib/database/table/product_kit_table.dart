import 'package:drift/drift.dart';
import 'package:easy_sell/database/table/product_table.dart';

class ProductKit extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get productId => integer().references(Product, #id)();

  RealColumn get amount => real()();

  RealColumn get price => real()();

  DateTimeColumn get createdAt => dateTime().nullable()();

  DateTimeColumn get updatedAt => dateTime().nullable()();

  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  DateTimeColumn get syncedAt => dateTime().nullable()();

  IntColumn get serverId => integer().nullable()();
}
