import 'package:drift/drift.dart';
import 'package:easy_sell/database/table/product_season_table.dart';
import '../my_database.dart';

part 'product_with_season_dao.g.dart';

@DriftAccessor(tables: [ProductWithSeason])
class ProductWithSeasonDao extends DatabaseAccessor<MyDatabase> with _$ProductWithSeasonDaoMixin {
  ProductWithSeasonDao(MyDatabase db) : super(db);

  Future<List<ProductWithSeasonData>> getAllProductWithSeasons() async {
    return await (select(productWithSeason)).get();
  }

  Future<List<SeasonData>> getSeasonByProductId(int productId) async {
    return await (select(productWithSeason)..where((tbl) => tbl.productId.equals(productId)))
        .join([innerJoin(season, season.id.equalsExp(productWithSeason.seasonId))])
        .map((row) => row.readTable(season))
        .get();
  }

  Future<int> createProductWithSeason(ProductWithSeasonCompanion productWithSeasonCompanion) async {
    return await into(productWithSeason).insert(productWithSeasonCompanion);
  }

  Future<void> deleteById(int id) async {
    await (delete(productWithSeason)..where((tbl) => tbl.seasonId.equals(id))).go();
  }

  Future<void> deleteByProductId(int id) async {
    await (delete(productWithSeason)..where((tbl) => tbl.productId.equals(id))).go();
  }

  Future<void> updateWithProductId(ProductWithSeasonCompanion productWithSeasonCompanion) async {
    // first find it by productId
    ProductWithSeasonData? productWithSeasonData = await (select(productWithSeason)
          ..where((tbl) =>
              tbl.seasonId.equals(productWithSeasonCompanion.seasonId.value ?? -1) &
              tbl.productId.equals(productWithSeasonCompanion.productId.value ?? -1)))
        .getSingleOrNull();
    // if found, update it
    if (productWithSeasonData != null) {
      await (update(productWithSeason)
            ..where((tbl) {
              return tbl.seasonId.equals(productWithSeasonData.seasonId ?? -1) &
                  tbl.productId.equals(productWithSeasonData.productId ?? -1);
            }))
          .write(productWithSeasonCompanion);
    } else {
      await into(productWithSeason).insert(productWithSeasonCompanion);
    }
  }
}
