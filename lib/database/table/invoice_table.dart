import 'package:drift/drift.dart';
import 'package:easy_sell/database/table/trade_table.dart';

enum InvoiceType {
  CASH,
  CARD,
  TRANSFER,
  CASHBACK;

  static InvoiceType fromString(String? value) {
    switch (value) {
      case 'CASH':
        return InvoiceType.CASH;
      case 'CARD':
        return InvoiceType.CARD;
      case 'TRANSFER':
        return InvoiceType.TRANSFER;
      case 'CASHBACK':
        return InvoiceType.CASHBACK;
      default:
        return InvoiceType.CASH;
    }
  }
}

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get serverId => integer().nullable()();

  RealColumn get amount => real()();

  TextColumn get description => text().nullable()();

  BoolColumn get income => boolean()();

  TextColumn get payType => textEnum<InvoiceType>()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  DateTimeColumn get syncedAt => dateTime().nullable()();

  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  IntColumn get tradeId => integer().references(Trade, #id).nullable()();
}
