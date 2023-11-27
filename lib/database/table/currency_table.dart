import 'package:drift/drift.dart';

class CurrencyTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get abbreviation => text()();

  TextColumn get symbol => text()();

  BoolColumn get defaultCurrency => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  IntColumn get serverId => integer().nullable()();
}
