import 'package:drift/drift.dart';
import 'package:easy_sell/database/table/client_table.dart';
import 'package:easy_sell/database/table/pos_session_table.dart';

class Trade extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get posSessionId => integer().references(PosSession, #id).nullable()();

  IntColumn get clientId => integer().references(Client, #id).nullable()();

  TextColumn get description => text().nullable()();

  RealColumn get discount => real().nullable()();

  RealColumn get refund => real().nullable()();

  BoolColumn get isFinished => boolean().withDefault(const Constant(false))();

  BoolColumn get isCanceled => boolean().withDefault(const Constant(false))();

  BoolColumn get isReturned => boolean().withDefault(const Constant(false))();

  BoolColumn get returnedMoney => boolean().withDefault(const Constant(false))();

  BoolColumn get returnedProductsIncome => boolean().withDefault(const Constant(false))();

  DateTimeColumn get finishedAt => dateTime().nullable()();

  DateTimeColumn get updatedAt => dateTime()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get syncedAt => dateTime().nullable()();

  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  IntColumn get serverId => integer().nullable()();
}
