import 'package:drift/drift.dart';
import 'package:easy_sell/database/model/product_dto.dart';
import 'package:easy_sell/database/table/barcode_table.dart';
import '../my_database.dart';

part 'barcode_dao.g.dart';

@DriftAccessor(tables: [Barcode])
class BarcodeDao extends DatabaseAccessor<MyDatabase> with _$BarcodeDaoMixin {
  BarcodeDao(MyDatabase db) : super(db);

  // get by id
  Future<BarcodeData?> getById(int id) {
    return (select(barcode)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  // get by id non nullable
  Future<BarcodeData> getByIdNonNullable(int id) {
    return (select(barcode)..where((tbl) => tbl.id.equals(id))).getSingle();
  }

  // get all
  Future<List<BarcodeData>> getAll() async {
    return (select(barcode)).get();
  }

  // get all by product id
  Future<List<BarcodeData>> getAllByProductId(int productId) async {
    return (select(barcode)..where((tbl) => tbl.productId.equals(productId))).get();
  } // get all by barcode

  Future<ProductDTO?> getByBarcode(String search) async {
    final query = select(barcode)..where((tbl) => tbl.barcode.equals(search));
    final result = await query.getSingleOrNull();
    ProductDTO? productDTO = await db.productDao.getProductDTOByServerId(result?.productId ?? -1);
    return productDTO;
  }

  // create barcode
  Future<BarcodeData> createBarcode(BarcodeCompanion barcodeCompanion) async {
    int id = await into(barcode).insert(barcodeCompanion);
    BarcodeData? result = await getByIdNonNullable(id);
    return result;
  }

  // batch create barcodes
  Future<void> batchCreateBarcodes(List<BarcodeCompanion> barcodes) async {
    await batch((batch) {
      batch.insertAll(barcode, barcodes);
    });
  }

  // update barcode
  Future<void> updateBarcode(BarcodeData entry) async {
    await update(barcode).replace(entry);
  }

  Future<bool> checkIfClientExistsByServerId(BarcodeCompanion newBarcode) async {
    return (await (select(barcode)
              ..where(
                  (tbl) => tbl.barcode.equals(newBarcode.barcode.value) | tbl.serverId.equals(newBarcode.serverId.value ?? -1)))
            .getSingleOrNull()) !=
        null;
  }

  Future<bool> checkIsExist(String barcodeValue) async {
    return (await (select(barcode)..where((tbl) => tbl.barcode.equals(barcodeValue))).get()).isNotEmpty;
  }

  Future<int> updateByServerId(BarcodeCompanion newBarcode) async {
    return (update(barcode)..where((tbl) => tbl.serverId.equals(newBarcode.serverId.value ?? -1))).write(newBarcode);
  }

  Future<String> getLastBarcodeFromVendorCode(String text) async {
    try {
      final query = select(product)..where((tbl) => tbl.code.equals(text));
      final result = await query.getSingleOrNull();
      if (result == null) throw Exception('Product not found');
      final query2 = select(barcode)..where((tbl) => tbl.productId.equals(result.id));
      final result2 = await query2.get();
      if (result2.isEmpty) throw Exception('Barcode not found');
      return result2.last.barcode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> deleteByBarcode(String barcodeValue) async {
    try {
      return await (delete(barcode)..where((tbl) => tbl.barcode.equals(barcodeValue))).go();
    } catch (e) {
      rethrow;
    }
  }
}
