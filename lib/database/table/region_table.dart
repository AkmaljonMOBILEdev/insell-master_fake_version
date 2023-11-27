import 'package:drift/drift.dart';

class Region extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get parentId => integer().nullable()();

  TextColumn get type => textEnum<RegionType>().nullable()();

  TextColumn get name => text()();

  TextColumn get code => text()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  BoolColumn get isSynced => boolean().withDefault(const Constant(false)).nullable()();

  DateTimeColumn get syncedAt => dateTime().nullable()();

  IntColumn get serverId => integer().nullable()();
}

enum RegionType {
  COUNTRY,
  STATE,
  REGION,
  CITY,
  TOWN,
  DISTRICT;

  static RegionType fromString(String value) {
    switch (value) {
      case 'COUNTRY':
        return RegionType.COUNTRY;
      case 'STATE':
        return RegionType.STATE;
      case 'REGION':
        return RegionType.REGION;
      case 'CITY':
        return RegionType.CITY;
      case 'TOWN':
        return RegionType.TOWN;
      case 'DISTRICT':
        return RegionType.DISTRICT;
      default:
        return RegionType.COUNTRY;
    }
  }
}
