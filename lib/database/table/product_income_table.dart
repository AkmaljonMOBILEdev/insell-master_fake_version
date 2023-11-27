import 'package:drift/drift.dart';
import 'package:easy_sell/database/table/product_table.dart';

class ProductIncome extends Table {
  IntColumn get id => integer().autoIncrement()();

  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  DateTimeColumn get syncedAt => dateTime().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  IntColumn get productId => integer().references(Product, #id)();

  TextColumn get currency =>
      textEnum<ProductIncomeCurrency>().withDefault(Constant(ProductIncomeCurrency.UZS.name.toString())).nullable()();

  RealColumn get price => real().withDefault(const Constant(0.0))();

  RealColumn get amount => real().withDefault(const Constant(0.0))();

  TextColumn get description => text().nullable()();

  DateTimeColumn get expireDate => dateTime().nullable()();

  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  IntColumn get serverId => integer().nullable()();
}

enum ProductIncomeCurrency {
  UZS,
  USD;

  static ProductIncomeCurrency fromString(String value) {
    switch (value) {
      case 'UZS':
        return ProductIncomeCurrency.UZS;
      case 'USD':
        return ProductIncomeCurrency.USD;
      default:
        return ProductIncomeCurrency.UZS;
    }
  }
}
