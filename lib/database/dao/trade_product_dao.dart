import 'package:drift/drift.dart';
import 'package:easy_sell/database/model/product_dto.dart';
import 'package:easy_sell/database/model/trade_product_dto.dart';
import 'package:easy_sell/database/table/trade_product_table.dart';
import '../my_database.dart';

part 'trade_product_dao.g.dart';

@DriftAccessor(tables: [TradeProduct])
class TradeProductDao extends DatabaseAccessor<MyDatabase> with _$TradeProductDaoMixin {
  TradeProductDao(MyDatabase db) : super(db);

  // get all
  Future<List<TradeProductData>> getAll() => select(tradeProduct).get();

  // get by id
  Future<TradeProductData> getById(int id) => (select(tradeProduct)..where((t) => t.id.equals(id))).getSingle();

  // get by trade id
  Future<List<TradeProductDto>> getByTradeId(int tradeId) async {
    final query = (select(tradeProduct)..where((t) => t.tradeId.equals(tradeId))).join([
      leftOuterJoin(product, tradeProduct.productId.equalsExp(product.id)),
    ]);
    final List results = await query.get();
    final List<TradeProductDto> tradeProducts = [];
    for (var result in results) {
      ProductDTO currentProduct = await db.productDao.getProductWithProductId(result.readTable(product).id);
      tradeProducts.add(TradeProductDto(
        product: currentProduct,
        tradeProduct: result.readTable(tradeProduct),
      ));
    }
    return tradeProducts;
  }

  // get by trade id
  Future<TradeProductDto> getByTradeIdSingle(int id) async {
    final query = (select(tradeProduct)..where((t) => t.id.equals(id))).join([
      leftOuterJoin(product, tradeProduct.productId.equalsExp(product.id)),
    ]);
    final result = await query.getSingle();
    ProductDTO currentProduct = await db.productDao.getProductWithProductId(result.readTable(product).id);
    return TradeProductDto(
      product: currentProduct,
      tradeProduct: result.readTable(tradeProduct),
    );
  }

  // create trade product
  Future<TradeProductDto> create(TradeProductCompanion newTradeProduct) async {
    int id = await into(tradeProduct).insert(newTradeProduct);
    return getByTradeIdSingle(id);
  }

  // update trade product
  Future<int> updateByProductId(int productServerId, TradeProductCompanion tradeProductCompanion) async {
    ProductData? currentProduct = await db.productDao.getByServerId(productServerId);
    return await (update(tradeProduct)..where((t) => t.productId.equals(currentProduct?.id ?? -1))).write(tradeProductCompanion);
  }

  Future<int> updateByProductIdByData(int id, TradeProductData tradeProductData) async {
    return await (update(tradeProduct)..where((t) => t.id.equals(id))).write(tradeProductData);
  }

  // replace by id
  Future<void> replaceById(int id, TradeProductData tradeProductCompanion) async {
    await (update(tradeProduct)..where((t) => t.id.equals(id))).write(tradeProductCompanion);
  }

  // replace by Data
  Future<void> replaceByData(TradeProductData tradeProductData) async {
    await (update(tradeProduct).replace(tradeProductData));
  }

  // delete trade product
  Future<int> deleteById(int id, {required int tradeId}) async {
    bool isFinished = await db.tradeDao.isFinished(tradeId);
    if (isFinished) {
      throw Exception('Trade is finished');
    }
    return await (delete(tradeProduct)..where((t) => t.id.equals(id))).go();
  }

  Future<void> deleteByTradeId(int id) async {
    await (delete(tradeProduct)..where((t) => t.tradeId.equals(id))).go();
  }
}
