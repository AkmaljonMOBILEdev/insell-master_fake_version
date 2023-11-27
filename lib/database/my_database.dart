import 'dart:io';
import 'package:easy_sell/database/dao/client_dao.dart';
import 'package:easy_sell/database/dao/employee_dao.dart';
import 'package:easy_sell/database/dao/posSession_dao.dart';
import 'package:easy_sell/database/dao/pos_dao.dart';
import 'package:easy_sell/database/dao/price_dao.dart';
import 'package:easy_sell/database/dao/product_dao.dart';
import 'package:easy_sell/database/dao/product_kit_dao.dart';
import 'package:easy_sell/database/dao/region_dao.dart';
import 'package:easy_sell/database/dao/season_dao.dart';
import 'package:easy_sell/database/table/barcode_table.dart';
import 'package:easy_sell/database/table/category_table.dart';
import 'package:easy_sell/database/table/client_table.dart';
import 'package:easy_sell/database/table/currency_table.dart';
import 'package:easy_sell/database/table/employee_table.dart';
import 'package:easy_sell/database/table/invoice_table.dart';
import 'package:easy_sell/database/table/pos_session_table.dart';
import 'package:easy_sell/database/table/pos_table.dart';
import 'package:easy_sell/database/table/price_table.dart';
import 'package:easy_sell/database/table/product_income_table.dart';
import 'package:easy_sell/database/table/product_kit_table.dart';
import 'package:easy_sell/database/table/product_season_table.dart';
import 'package:easy_sell/database/table/product_table.dart';
import 'package:easy_sell/database/table/region_table.dart';
import 'package:easy_sell/database/table/season_table.dart';
import 'package:easy_sell/database/table/trade_product_table.dart';
import 'package:easy_sell/database/table/trade_table.dart';
import 'package:path/path.dart' as p;
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

import 'dao/barcode_dao.dart';
import 'dao/category_dao.dart';
import 'dao/currency_dao.dart';
import 'dao/invoice_dao.dart';
import 'dao/product_with_season_dao.dart';
import 'dao/trade_dao.dart';
import 'dao/trade_product_dao.dart';


part 'my_database.g.dart';
@DriftDatabase(
  tables: [
    Client,
    Product,
    ProductIncome,
    Price,
    Employee,
    PosSession,
    POS,
    Category,
    Region,
    Transactions,
    TradeProduct,
    Trade,
    Barcode,
    ProductKit,
    Season,
    ProductWithSeason,
    CurrencyTable,
  ],
  daos: [
    ClientDao,
    ProductDao,
    PriceDao,
    EmployeeDao,
    PosSessionDao,
    PosDao,
    CategoryDao,
    TransactionsDao,
    TradeProductDao,
    TradeDao,
    BarcodeDao,
    ProductKitDao,
    RegionDao,
    SeasonDao,
    ProductWithSeasonDao,
    CurrencyDao,
  ],
)
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        await m.createAll();
      },
    );
  }

  Future<void> dropDatabase() {
    return transaction(() async {
      for (final table in allTables) {
        await delete(table).go();
      }
    });
  }
}

LazyDatabase _openConnection() {
  print('DATABASE CONNECTED!');

  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // final dbFolder = await getApplicationDocumentsDirectory();
    // final file = File(p.join(dbFolder.path, 'easy_sell_test_6.sqlite'));
    final folder1 = await getApplicationSupportDirectory();
    final file = File(p.join(folder1.path, 'easy_sell_db_1.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
