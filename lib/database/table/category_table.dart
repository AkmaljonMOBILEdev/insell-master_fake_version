import 'package:drift/drift.dart';

class Category extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get code => text().nullable()();

  TextColumn get groupCode => text().nullable()();

  TextColumn get description => text().nullable()();

  IntColumn get parentId => integer().references(Category, #id).nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  DateTimeColumn get isSyncedAt => dateTime().nullable()();

  IntColumn get serverId => integer().nullable()();
}
