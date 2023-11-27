import 'package:drift/drift.dart';
import 'package:easy_sell/database/table/product_table.dart';
import 'package:easy_sell/database/table/season_table.dart';


class ProductWithSeason extends Table {
  IntColumn get productId => integer().references(Product, #id).nullable()();

  IntColumn get seasonId => integer().references(Season, #id).nullable()();
}
