import 'package:drift/drift.dart';
import 'package:easy_sell/database/table/employee_table.dart';
import 'package:easy_sell/database/table/pos_table.dart';

class PosSession extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get pos => integer().references(POS, #id).nullable()();

  IntColumn get cashier => integer().references(Employee, #id).nullable()();

  DateTimeColumn get startTime => dateTime().nullable()();

  DateTimeColumn get endTime => dateTime().nullable()();

  TextColumn get sessionStartNote => text().nullable()();

  TextColumn get sessionEndNote => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  BoolColumn get isSynced => boolean().withDefault(const Constant(false)).nullable()();

  DateTimeColumn get syncedAt => dateTime().nullable()();

  IntColumn get serverId => integer().nullable()();
}
