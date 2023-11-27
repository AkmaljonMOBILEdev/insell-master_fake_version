import 'package:drift/drift.dart';
import 'package:easy_sell/database/table/region_table.dart';

class Client extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get code => integer().nullable()();

  TextColumn get name => text()();

  DateTimeColumn get dobDay => dateTime().nullable()();

  TextColumn get gender => text()();

  TextColumn get phoneNumber1 => text().nullable()();

  TextColumn get phoneNumber2 => text().nullable()();

  TextColumn get address => text().nullable()();

  IntColumn get regionId => integer().references(Region, #id).nullable()();

  TextColumn get category => text().nullable()();

  TextColumn get discountCard => text().nullable()();

  TextColumn get description => text().nullable()();

  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  TextColumn get organizationName => text().nullable()();

  DateTimeColumn get syncedAt => dateTime().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  IntColumn get serverId => integer().nullable()();

  TextColumn get clientCurrency => textEnum<ClientCurrency>().nullable()();

  IntColumn get typeId => integer().nullable()();

  IntColumn get cashbackId => integer().nullable()();

  RealColumn get cashback => real().nullable()();
}

enum ClientCurrency {
  UZS,
  USD;

  static ClientCurrency fromString(String currency) {
    switch (currency) {
      case 'UZS':
        return ClientCurrency.UZS;
      case 'USD':
        return ClientCurrency.USD;
      default:
        return ClientCurrency.USD;
    }
  }
}
