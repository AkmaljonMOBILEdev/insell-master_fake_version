import 'package:drift/drift.dart';

class POS extends Table {
  TextColumn get name => text()();

  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  DateTimeColumn get syncedAt => dateTime().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  IntColumn get id => integer().autoIncrement()();

  BoolColumn get active => boolean()();

  IntColumn get serverId => integer().nullable()();

  TextColumn get type => textEnum<PosType>().nullable()();
}

enum PosType {
  SHOP,
  SHOP_MAIN,
  MAIN;

  static PosType fromString(String value) {
    switch (value) {
      case 'SHOP':
        return PosType.SHOP;
      case 'SHOP_MAIN':
        return PosType.SHOP_MAIN;
      case 'MAIN':
        return PosType.MAIN;
      default:
        return PosType.MAIN;
    }
  }
}
