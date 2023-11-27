import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:easy_sell/database/model/page_dto.dart';
import 'package:easy_sell/database/model/product_kit_dao.dart';
import 'package:easy_sell/database/table/product_table.dart';
import 'package:easy_sell/services/https_services.dart';
import 'package:easy_sell/utils/utils.dart';
import '../../widgets/app_input_table.dart';
import '../model/product_dto.dart';
import '../my_database.dart';
import 'package:http/http.dart' as http;

part 'product_dao.g.dart';

@DriftAccessor(tables: [Product])
class ProductDao extends DatabaseAccessor<MyDatabase> with _$ProductDaoMixin {
  ProductDao(MyDatabase db) : super(db);

  // get product by id
  Future<ProductData> getById(int id) {
    return (select(product)..where((tbl) => tbl.id.equals(id))).getSingle();
  }

  // get by server id
  Future<ProductData?> getByServerId(int? serverId) {
    return (select(product)
          ..where((tbl) => tbl.serverId.equals(serverId ?? -1)))
        .getSingleOrNull();
  }

  // get by server id
  Future<ProductDTO?> getProductDTOByServerId(int id) async {
    final query = (select(product)..where((tbl) => tbl.serverId.equals(id)));
    final result = await query.getSingleOrNull();
    if (result == null) return null;
    final List<PriceData> allLastPrices =
        await db.priceDao.getLastPricesByProductId(result.id);
    List<BarcodeData> barcodes =
        await db.barcodeDao.getAllByProductId(result.id);
    List<SeasonData> seasons =
        await db.productWithSeasonDao.getSeasonByProductId(result.id);
    double amount = 0;
    return ProductDTO(
      amount: amount,
      barcodes: barcodes,
      productData: result,
      prices: allLastPrices,
      seasons: seasons,
    );
  }

  // check if product exists by server id
  Future<bool> checkIfProductExistsByServerId(
      ProductCompanion companion) async {
    final result = await (select(product)
          ..where((tbl) => tbl.serverId.equals(companion.serverId.value ?? -1)))
        .getSingleOrNull();
    return result != null;
  }

  // batch insert
  Future<void> batchInsert(List<ProductCompanion> products) async {
    await batch((batch) {
      batch.insertAll(product, products);
    });
  }

  //  get all products by ProductDTO
  Future<List<ProductDTO>> getAllProductsDTO(
      {int limit = 10, int offset = 0}) async {
    final query = (select(product)
      ..orderBy([
        (tbl) =>
            OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.desc)
      ])
      ..limit(limit, offset: limit * offset));
    final results = await query.get();
    List<ProductDTO> products = [];
    for (ProductData result in results) {
      final List<BarcodeData> barcodes =
          await db.barcodeDao.getAllByProductId(result.id);
      List<SeasonData> seasons =
          await db.productWithSeasonDao.getSeasonByProductId(result.id);
      ProductDTO newProduct = ProductDTO(
        seasons: seasons,
        amount: 0,
        barcodes: barcodes,
        prices: await db.priceDao.getLastPricesByProductId(result.id),
        productData: result,
      );
      products.add(newProduct);
    }
    return products;
  }

  Future<ProductDTO> getSingleProductDTO(int id) async {
    final query = (select(product)..where((tbl) => tbl.serverId.equals(id)));
    final result = await query.getSingle();
    final List<PriceData> allLastPrices =
        await db.priceDao.getLastPricesByProductId(id);
    List<BarcodeData> barcodes =
        await db.barcodeDao.getAllByProductId(result.id);
    List<SeasonData> seasons =
        await db.productWithSeasonDao.getSeasonByProductId(result.id);
    return ProductDTO(
      seasons: seasons,
      amount: 0,
      barcodes: barcodes,
      prices: allLastPrices,
      productData: result,
    );
  }

  Future<ProductDTO> getProductWithProductId(int id) async {
    final query = (select(product)..where((tbl) => tbl.id.equals(id)));
    final result = await query.getSingle();
    final List<PriceData> allLastPrices =
        await db.priceDao.getLastPricesByProductId(id);
    List<BarcodeData> barcodes =
        await db.barcodeDao.getAllByProductId(result.id);
    List<SeasonData> seasons =
        await db.productWithSeasonDao.getSeasonByProductId(result.id);
    return ProductDTO(
      seasons: seasons,
      amount: 0,
      barcodes: barcodes,
      prices: allLastPrices,
      productData: result,
      productsKit: await db.productKitDao.getAllByProductId(id),
    );
  }

  // get by barcode
  Future<ProductDTO?> getSingleProductDTOWithBarcode(String barcode) async {
    final query =
        (select(product)..where((tbl) => tbl.barcode.equals(barcode)));
    final result = await query.getSingleOrNull();
    if (result == null) {
      return null;
    }
    final List<PriceData> allLastPrices =
        await db.priceDao.getLastPricesByProductId(result.id);
    List<BarcodeData> barcodes =
        await db.barcodeDao.getAllByProductId(result.id);
    List<SeasonData> seasons =
        await db.productWithSeasonDao.getSeasonByProductId(result.id);
    return ProductDTO(
      seasons: seasons,
      amount: 0,
      barcodes: barcodes,
      prices: allLastPrices,
      productData: result,
    );
  }

  // get all products
  Future<int> getAllProductsCount() async {
    final count = await (selectOnly(product)..addColumns([product.id.count()]))
        .getSingle();
    return count.read(product.id.count()) ?? 0;
  }

  // get all products by limit
  Future<PageDto<ProductDTO>> getAllProductsByLimitOrSearchPage(
      {int limit = 10, int offset = 0, String search = ''}) async {
    return PageDto<ProductDTO>(
      data: await getAllProductsByLimitOrSearch(
          limit: limit, offset: offset, search: search),
      total: await getAllProductsCountBySearch(search: search),
    );
  }

  Future<int> getAllProductsCountBySearch({String search = ''}) async {
    List<BarcodeData> barcodes = await (select(db.barcode)
          ..where((tbl) => tbl.barcode.like('%$search%'))
          ..limit(10))
        .get();
    return (await (select(product)
              ..where((tbl) =>
                  tbl.name.like('%$search%') |
                  tbl.vendorCode.like('%$search%') |
                  tbl.code.like('%$search%') |
                  tbl.barcode.like('%$search%') |
                  tbl.id.isIn(barcodes.map((e) => e.productId))))
            .get())
        .length;
  }

  Future<List<ProductDTO>> getAllProductsByLimitOrSearch(
      {int limit = 10, int offset = 0, String search = ''}) async {
    List<BarcodeData> barcodes = await (select(db.barcode)
          ..where((tbl) => tbl.barcode.like('%$search%'))
          ..limit(10))
        .get();
    final query = (select(product)
      ..orderBy([
        (tbl) =>
            OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.desc)
      ])
      ..where((tbl) =>
          tbl.name.like('%$search%') |
          tbl.vendorCode.like('%$search%') |
          tbl.code.like('%$search%') |
          tbl.barcode.like('%$search%') |
          tbl.id.isIn(barcodes.map((e) => e.productId)))
      ..limit(limit, offset: limit * offset));
    List<ProductData> products = await query.get();

    if (search.trim().isNotEmpty && products.length > 1) {
      int index =
          products.indexWhere((element) => element.vendorCode == search, 1);
      if (index != -1) {
        ProductData product = products.removeAt(index);
        products.insert(0, product);
      }
    }

    final List<ProductDTO> productDTOs = [];

    for (ProductData product in products) {
      int? productId = product.id;
      final List<PriceData> allLastPrices =
          await db.priceDao.getLastPricesByProductId(productId);
      final List<BarcodeData> barcodes =
          await db.barcodeDao.getAllByProductId(product.id);
      List<SeasonData> seasons =
          await db.productWithSeasonDao.getSeasonByProductId(product.id);
      productDTOs.add(ProductDTO(
        seasons: seasons,
        amount: 0,
        barcodes: barcodes,
        prices: allLastPrices,
        productData: product,
      ));
    }
    return productDTOs;
  }

  Future<List<ProductDTO>> getAllProducts({bool withPrice = false, bool withBarcode = false, bool withSeason = false}) async {
    final query = (select(product)
      ..orderBy([
        (tbl) =>
            OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.desc)
      ])
    );
    List<ProductData> products = await query.get();


    final List<ProductDTO> productDTOs = [];

    for (ProductData product in products) {
      int? productId = product.id;
      final List<PriceData> allLastPrice = [];
      if (withPrice) {
        allLastPrice.addAll(await db.priceDao.getLastPricesByProductId(productId));
      }
      final List<BarcodeData> barcodes = [];
      if (withBarcode) {
        barcodes.addAll(await db.barcodeDao.getAllByProductId(product.id));
      }
      final List<SeasonData> seasons = [];
      if (withSeason) {
        seasons.addAll(await db.productWithSeasonDao.getSeasonByProductId(product.id));
      }
      productDTOs.add(ProductDTO(
        seasons: seasons,
        amount: 0,
        barcodes: barcodes,
        prices: allLastPrice,
        productData: product,
      ));
    }
    return productDTOs;
  }

  Future<List<ProductDTO>> getAllProductsBoxByLimitOrSearch(
      {int limit = 10, int offset = 0, String search = ''}) async {
    final List<ProductData> products = await (select(product)
          ..limit(limit, offset: limit * offset)
          ..orderBy([
            (tbl) =>
                OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.desc)
          ])
          ..where((tbl) => tbl.isKit.equals(true))
          ..where((tbl) =>
              tbl.name.like('%$search%') |
              tbl.vendorCode.like('%$search%') |
              tbl.barcode.like('%$search%')))
        .get();
    final List<ProductDTO> productDTOs = [];

    for (ProductData product in products) {
      int productId = product.id;
      List<PriceData> allLastPrices =
          await db.priceDao.getLastPricesByProductId(productId);
      List<ProductKitDTO> productKits =
          await db.productKitDao.getAllByProductId(productId);
      final List<BarcodeData> barcodes =
          await db.barcodeDao.getAllByProductId(productId);
      List<SeasonData> seasons =
          await db.productWithSeasonDao.getSeasonByProductId(product.id);
      productDTOs.add(ProductDTO(
        seasons: seasons,
        amount: 0,
        barcodes: barcodes,
        productsKit: productKits,
        prices: allLastPrices,
        productData: product,
      ));
    }
    return productDTOs;
  }

  // create product transaction
  Future<ProductData> createProductTransaction(ProductData productData,
      {double retailPrice = 0,
      double wholesalePrice = 0,
      double discountPrice = 0,
      int? categoryId}) async {
    try {
      int id = await transaction(() async {
        int id = await into(product).insert(ProductCompanion.insert(
          name: (productData.name),
          vendorCode: Value(productData.vendorCode),
          barcode: Value(productData.barcode),
          unit: productData.unit,
          description: Value(productData.description),
          isKit: Value(productData.isKit),
          productsInBox: Value(productData.productsInBox),
          volume: Value(productData.volume),
          weight: Value(productData.weight),
          isSynced: const Value(false),
          createdAt: productData.createdAt,
          updatedAt: productData.updatedAt,
          syncedAt: const Value(null),
          categoryId: Value(productData.categoryId),
          serverId: const Value(null),
        ));
        return id;
      });
      return await getById(id);
    } catch (e) {
      bool isUniqueError =
          e.toString().contains('UNIQUE constraint failed: product.barcode');
      if (isUniqueError) {
        throw Exception(
            'Ushbu mahsulot allaqachon bazada mavjud, Barcode: ${productData.barcode}');
      } else if (e
          .toString()
          .contains('UNIQUE constraint failed: product.vendor_code')) {
        throw Exception(
            'Ushbu mahsulot allaqachon bazada mavjud, Vendor code: ${productData.vendorCode}');
      }
      rethrow;
    }
  }

  // create product transaction with companion
  Future<ProductData?> createProductTransactionWithCompanion(
      ProductCompanion productData) async {
    bool isExist = await getByServerId(productData.serverId.value) != null;
    if (isExist) {
      return null;
    }
    int id = await transaction(() async {
      int id = await into(product).insert(productData);
      return id;
    });
    return await getById(id);
  }

  Future<ProductDTO> createProductTransactionWithCompanionId(
    ProductCompanion productData, {
    double? retailPrice,
    double? wholesalePrice,
  }) async {
    return await transaction(() async {
      int id = await into(product).insert(productData);
      return getProductWithProductId(id);
    });
  }

  // update product transaction
  Future<void> updateProductTransaction(ProductData entry,
      {double retailPrice = 0,
      double wholesalePrice = 0,
      double discountPrice = 0,
      int? serverId,
      bool? isSynced}) async {
    await transaction(() async {
      await (update(product)..where((tbl) => tbl.id.equals(entry.id)))
          .write(ProductCompanion(
        id: Value(entry.id),
        code: Value(entry.code),
        name: Value(entry.name),
        vendorCode: Value(entry.vendorCode),
        barcode: Value(entry.barcode),
        description: Value(entry.description),
        isKit: Value(entry.isKit),
        productsInBox: Value(entry.productsInBox),
        unit: Value(entry.unit),
        volume: Value(entry.volume),
        weight: Value(entry.weight),
        isSynced: Value(isSynced ?? entry.isSynced),
        syncedAt: Value(entry.syncedAt),
        categoryId: Value(entry.categoryId),
        updatedAt: Value(DateTime.now()),
        serverId: Value(serverId ?? entry.serverId),
        createdAt: Value(entry.createdAt),
      ));
    });
  }

  // update by serverId
  Future<bool> updateByServerId(ProductCompanion productData) async {
    return await (update(product)
              ..where((tbl) =>
                  tbl.serverId.equals(productData.serverId.value ?? -1)))
            .write(productData) >
        -1;
  }

  // update with replace
  Future<void> updateWithReplace(ProductCompanion productData) async {
    await (update(product).replace(productData));
  }

  Future<void> updateWithReplaceByData(ProductData productData) async {
    await (update(product).replace(productData));
  }

  // sync product transaction
  Future<void> synchronizeProduct(ProductData newProductData,
      {required double retailPrice,
      required double wholesalePrice,
      required double discountPrice,
      int? categoryId}) async {
    if (categoryId != null) {
      categoryId = (await db.categoryDao.getById(categoryId)).serverId;
    }
    Map<String, dynamic> request = {
      "name": newProductData.name,
      "description": newProductData.description,
      "weight": newProductData.weight,
      "volume": newProductData.volume,
      "vendorCode": newProductData.vendorCode,
      "unit": newProductData.unit,
      "productsInPackage": newProductData.productsInBox,
      "barcode": newProductData.barcode,
      "productsInBox": newProductData.productsInBox,
      "categoryId": categoryId,
      "retailPrice": retailPrice,
      "wholesalePrice": wholesalePrice,
      "discount": discountPrice,
    };
    http.Response response;

    try {
      if (newProductData.serverId == null) {
        response = await HttpServices.post('/product/create', request);
      } else {
        response = await HttpServices.put(
            '/product/${newProductData.serverId}', request);
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        await updateProductTransaction(
          newProductData.copyWith(
            isSynced: true,
            syncedAt: toValue(DateTime.now()),
            serverId: toValue(data['id']),
            updatedAt: DateTime.now(),
            createdAt: newProductData.createdAt,
            vendorCode: toValue(data['vendorCode']),
          ),
          retailPrice: retailPrice,
          wholesalePrice: wholesalePrice,
          discountPrice: discountPrice,
          serverId: data['id'],
          isSynced: true,
        );
      }
    } catch (e) {
      await updateProductTransaction(
          newProductData.copyWith(
            updatedAt: DateTime.now(),
          ),
          retailPrice: retailPrice,
          wholesalePrice: wholesalePrice,
          discountPrice: discountPrice,
          serverId: newProductData.serverId);
    }
  }

  // delete product transaction
  Future<void> deleteProductTransaction(int id) async {
    await transaction(() async {
      await (delete(product)..where((tbl) => tbl.id.equals(id))).go();
    });
  }

  // search productDto
  searchProduct(String value) {
    var result = (select(product)
          ..where((tbl) =>
              tbl.name.like('%$value%') | tbl.vendorCode.like('%$value%')))
        .get();
    return result;
  }

  // check has unSynced product
  Future<bool> hasUnSyncedProduct() async {
    return (await (select(product)..where((tbl) => tbl.isSynced.equals(false)))
            .get())
        .isNotEmpty;
  }

  // get all unsynced products
  Future<List<ProductDTO>> getAllUnSyncedProducts() async {
    final query = (select(product)
      ..where((tbl) {
        return tbl.syncedAt.isNull() |
            tbl.syncedAt.isSmallerThan(tbl.updatedAt) |
            tbl.isSynced.equals(false);
      }));
    final results = await query.get();
    List<ProductDTO> products = [];
    for (ProductData result in results) {
      final List<BarcodeData> barcodes =
          await db.barcodeDao.getAllByProductId(result.id);
      int? productId = result.id;
      final List<PriceData> allLastPrices =
          await db.priceDao.getLastPricesByProductId(productId);
      List<ProductKitDTO> productsKit =
          await db.productKitDao.getAllByProductId(result.id);
      List<SeasonData> seasons =
          await db.productWithSeasonDao.getSeasonByProductId(result.id);
      ProductDTO newProduct = ProductDTO(
        barcodes: barcodes,
        productsKit: productsKit,
        prices: allLastPrices,
        productData: result,
        amount: 0,
        seasons: seasons,
      );
      products.add(newProduct);
    }
    return products;
  }

  Future<List<ProductDTO>> getTopProducts(List<int> productsList) async {
    List<ProductDTO> result = [];
    for (int i = 0; i < productsList.length; i++) {
      final product = await getProductWithProductId(productsList[i]);
      result.add(product);
    }
    return result;
  }

  Future<ProductDTO> getSingleProductDTOByServerId(int id) async {
    final query = (select(product)..where((tbl) => tbl.serverId.equals(id)));
    final result = await query.getSingle();
    final List<PriceData> allLastPrices =
        await db.priceDao.getLastPricesByProductId(result.id);
    List<BarcodeData> barcodes =
        await db.barcodeDao.getAllByProductId(result.id);
    List<SeasonData> seasons =
        await db.productWithSeasonDao.getSeasonByProductId(result.id);
    return ProductDTO(
      seasons: seasons,
      amount: 0,
      barcodes: barcodes,
      prices: allLastPrices,
      productData: result,
    );
  }

  Future<List<ProductDTO>> getProductsByCategoryId(int categoryId,
      {String search = ''}) async {
    final query = (select(product)
      ..where(
        (tbl) =>
            tbl.categoryId.equals(categoryId) &
            (search.isNotEmpty
                ? (tbl.name.like('%$search%') |
                    tbl.vendorCode.like('%$search%') |
                    tbl.code.like('%$search%') |
                    tbl.barcode.like('%$search%'))
                : const CustomExpression<bool>('1=1')),
      ));
    final results = await query.get();
    List<ProductDTO> products = [];
    for (ProductData result in results) {
      final List<BarcodeData> barcodes =
          await db.barcodeDao.getAllByProductId(result.id);
      int? productId = result.id;
      final List<PriceData> allLastPrices =
          await db.priceDao.getLastPricesByProductId(productId);
      List<ProductKitDTO> productsKit =
          await db.productKitDao.getAllByProductId(result.id);
      List<SeasonData> seasons =
          await db.productWithSeasonDao.getSeasonByProductId(result.id);
      ProductDTO newProduct = ProductDTO(
        barcodes: barcodes,
        productsKit: productsKit,
        prices: allLastPrices,
        productData: result,
        amount: 0,
        seasons: seasons,
      );
      products.add(newProduct);
    }
    return products;
  }

  Future<int> getTotal() async {
    final query = await select(product).get();
    return query.length;
  }

  Future<ProductData> createWithCompanion(ProductCompanion newProduct) async {
    final query = await into(product).insert(newProduct);
    return await getById(query);
  }

  Future<bool> checkByCode(String string) async {
    final query =
        await (select(product)..where((tbl) => tbl.code.equals(string))).get();
    return query.isNotEmpty;
  }

  Future<ProductData?> findByTableResults(
    TableResult result,
    List<String> selectedFields,
  ) async {
    try {
      List<String> values = result.values;
      String queryString = "";
      for (int i = 0; i < selectedFields.length; i++) {
        String field = selectedFields[i];
        String value = values[i].trim();
        if (value.isNotEmpty) {
          queryString += "$field = '$value' AND ";
        }
      }
      queryString = queryString.substring(0, queryString.length - 4);
      final expression = CustomExpression<bool>(queryString);
      final query = select(product)..where((tbl) => expression);
      final productResult = await query.getSingleOrNull();
      if (productResult == null) return null;
      return productResult;
    } catch (e) {
      rethrow;
    }
  }

  Future<ProductData> getProductFromVendorCode(String trim) async {
    final query = select(product)..where((tbl) => tbl.code.equals(trim));
    return await query.getSingle();
  }

  Future<ProductData?> getByCode(String string) async {
    final query = select(product)..where((tbl) => tbl.code.equals(string));
    return await query.getSingleOrNull();
  }

  Future<bool> checkProductExist(String code) async {
    final query = select(product)..where((tbl) => tbl.code.equals(code));
    return (await query.get()).isNotEmpty;
  }

  Future<List<ProductData>> getAll() async {
    return await select(product).get();
  }
}
