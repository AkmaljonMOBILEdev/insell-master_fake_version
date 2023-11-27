import 'package:drift/drift.dart';
import 'package:easy_sell/database/table/category_table.dart';

class Product extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  RealColumn get valueAddedTax => real().withDefault(const Constant(0)).nullable()();

  TextColumn get barcode => text().nullable()();

  TextColumn get code => text().nullable()();

  TextColumn get vendorCode => text().nullable()();

  TextColumn get description => text().nullable()();

  BoolColumn get isKit => boolean().withDefault(const Constant(false))();

  TextColumn get productsInBox => text().nullable()();

  TextColumn get unit => text()();

  TextColumn get volume => text().nullable()();

  TextColumn get weight => text().nullable()();

  IntColumn get categoryId => integer().references(Category, #id).nullable()();

  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  DateTimeColumn get syncedAt => dateTime().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  IntColumn get serverId => integer().nullable()();
}
