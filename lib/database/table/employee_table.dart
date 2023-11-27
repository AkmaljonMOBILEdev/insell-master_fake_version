import 'package:drift/drift.dart';

class Employee extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get firstName => text()();

  TextColumn get lastName => text().nullable()();

  TextColumn get address => text().nullable()();

  TextColumn get phoneNumber => text().nullable()();

  TextColumn get phoneNumber2 => text().nullable()();

  DateTimeColumn get dobDay => dateTime().nullable()();

  TextColumn get position => text().nullable()();

  TextColumn get gender => text().nullable()();

  TextColumn get cardNumber => text().nullable()();

  BoolColumn get isSynced => boolean().withDefault(const Constant(false)).nullable()();

  DateTimeColumn get syncedAt => dateTime().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  IntColumn get serverId => integer().nullable()();
}
