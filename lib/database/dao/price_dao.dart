import 'package:drift/drift.dart';
import '../my_database.dart';
import '../table/price_table.dart';

part 'price_dao.g.dart';

@DriftAccessor(tables: [Price])
class PriceDao extends DatabaseAccessor<MyDatabase> with _$PriceDaoMixin {
  PriceDao(MyDatabase db) : super(db);

  Future<List<PriceData>> getAll() async {
    final query = select(price)..orderBy([(tbl) => OrderingTerm.desc(tbl.id)]);
    final result = await query.get();
    return result;
  }

  // get by id
  Future<PriceData?> getById(int id) {
    return (select(price)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<List<PriceData>> getLastPricesByProductId(int productId) async {
    final query = select(price)
      ..where((tbl) => tbl.productId.equals(productId))
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.id)])
      ..limit(50);
    final result = await query.get();
    List<PriceData> prices = [];
    for (PriceData price in result) {
      if (prices.isEmpty) {
        prices.add(price);
      }
    }
    return prices;
  }

  // batch create prices
  Future<void> batchCreatePrices(List<PriceCompanion> prices) async {
    await batch((batch) {
      batch.insertAll(price, prices);
    });
  }

  Future<bool> checkIfPriceExistsByServerId(PriceCompanion newPriceCompanion) async {
    final result =
        await (select(price)..where((tbl) => tbl.serverId.equals(newPriceCompanion.serverId.value ?? -1))).getSingleOrNull();
    bool exists = result != null;
    if (exists) {
      return await updateByServerId(newPriceCompanion);
    }
    return false;
  }

  // update by server id
  Future<bool> updateByServerId(PriceCompanion newPriceCompanion) async {
    final result =
        await (select(price)..where((tbl) => tbl.serverId.equals(newPriceCompanion.serverId.value ?? -1))).getSingleOrNull();
    bool exists = result != null;
    if (exists) {
      await (update(price)..where((tbl) => tbl.serverId.equals(newPriceCompanion.serverId.value ?? -1))).write(newPriceCompanion);
      return true;
    }
    return false;
  }

  // get prices by product id
  Future<List<PriceData>> getPricesByProductId(int productId) async {
    return (select(price)
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)])
          ..where((tbl) => tbl.productId.equals(productId)))
        .get();
  }

  Future<double?> getLastPriceFromVendorCode(String trim) async {
    try {
      ProductData productResult = await (select(product)
            ..where((tbl) {
              return tbl.code.equals(trim);
            }))
          .getSingle();
      double priceValue = await getLastPricesByProductId(productResult.id).then((value) {
        if (value.isEmpty) {
          return 0;
        }
        return value.first.value;
      });
      return priceValue;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PriceData>> getByProductServerId(int serverId) async {
    ProductData? productData = await (select(product)..where((tbl) => tbl.serverId.equals(serverId))).getSingleOrNull();
    if (productData == null) {
      return [];
    }
    return getLastPricesByProductId(productData.id);
  }
}
