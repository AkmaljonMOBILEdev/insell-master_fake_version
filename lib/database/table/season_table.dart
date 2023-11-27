import 'package:drift/drift.dart';

class Season extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  DateTimeColumn get startDate => dateTime()();

  DateTimeColumn get endDate => dateTime()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  DateTimeColumn get syncedAt => dateTime().nullable()();

  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  IntColumn get serverId => integer().nullable()();
}
