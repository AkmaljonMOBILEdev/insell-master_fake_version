import 'package:drift/drift.dart';
import 'package:easy_sell/database/table/product_table.dart';

class Barcode extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get productId => integer().references(Product, #id)();

  TextColumn get barcode => text()();

  DateTimeColumn get createdAt => dateTime().nullable()();

  DateTimeColumn get updatedAt => dateTime().nullable()();

  DateTimeColumn get syncedAt => dateTime().nullable()();

  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  IntColumn get serverId => integer().nullable()();
}
