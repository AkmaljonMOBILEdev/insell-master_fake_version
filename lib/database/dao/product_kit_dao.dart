import 'package:drift/drift.dart';
import 'package:easy_sell/database/model/product_dto.dart';
import 'package:easy_sell/database/model/product_kit_dao.dart';
import 'package:easy_sell/database/table/product_kit_table.dart';
import '../my_database.dart';

part 'product_kit_dao.g.dart';

@DriftAccessor(tables: [ProductKit])
class ProductKitDao extends DatabaseAccessor<MyDatabase> with _$ProductKitDaoMixin {
  ProductKitDao(MyDatabase db) : super(db);

  // get by id
  Future<ProductKitData?> getById(int id) {
    return (select(productKit)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  // get all
  Future<List<ProductKitData>> getAll() async {
    return (select(productKit)).get();
  }

  // create productKit
  Future<int> createProductKit(ProductKitCompanion productKitCompanion) async {
    return await into(productKit).insert(productKitCompanion);
  }

  // batch create productKits
  Future<void> batchCreateProductKits(List<ProductKitCompanion> productKits) async {
    await batch((batch) {
      batch.insertAll(productKit, productKits);
    });
  }

  // update productKit
  Future<void> updateProductKit(ProductKitData entry) async {
    await update(productKit).replace(entry);
  }

  Future<bool> checkIfClientExistsByServerId(ProductKitCompanion newProductKit) async {
    return (await (select(productKit)..where((tbl) => tbl.serverId.equals(newProductKit.serverId.value ?? -1)))
            .getSingleOrNull()) !=
        null;
  }

  Future<int> updateByServerId(ProductKitCompanion newProductKit) async {
    return (update(productKit)..where((tbl) => tbl.serverId.equals(newProductKit.serverId.value ?? -1))).write(newProductKit);
  }

  // get all by product id
  Future<List<ProductKitDTO>> getAllByProductId(int productId) async {
    final query = select(productKit)
      ..where((tbl) => tbl.productId.equals(productId))
      ..join([innerJoin(product, product.id.equalsExp(productKit.productId))]);
    final List<ProductKitData> results = await query.get();
    List<ProductKitDTO> productKits = [];
    for (ProductKitData result in results) {
      int? kitProductId = result.productId;
      ProductDTO productDto = await db.productDao.getProductWithProductId(kitProductId);
      productKits.add(ProductKitDTO(product: productDto, productKit: result));
    }
    return productKits;
  }
}
