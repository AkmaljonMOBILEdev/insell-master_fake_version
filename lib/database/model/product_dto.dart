import 'package:easy_sell/database/model/product_kit_dao.dart';
import 'package:easy_sell/database/my_database.dart';

class ProductDTO {
  ProductData productData;
  List<BarcodeData> barcodes = [];
  List<ProductKitDTO>? productsKit = [];
  List<PriceData> prices = [];
  List<SeasonData> seasons = [];
  double amount;

  ProductDTO({
    required this.productData,
    required this.barcodes,
    required this.prices,
    required this.amount,
    required this.seasons,
    this.productsKit,
  });

  toJson() => {
        'barcodes': barcodes,
        'productsKit': productsKit,
        "prices": prices,
        'productData': productData,
      };

  static fromJson(e) {
    return ProductDTO(
      barcodes: e['barcodes'] ?? [],
      prices: e['prices'] ?? [],
      productsKit: e['productsKit'],
      productData: e['productData'],
      amount: e['amount'],
      seasons: e['seasons'] ?? [],
    );
  }
}
