import 'package:easy_sell/database/model/product_dto.dart';
import 'package:easy_sell/database/my_database.dart';

class TradeProductDto {
  TradeProductData tradeProduct;
  final ProductDTO product;

  TradeProductDto({required this.tradeProduct, required this.product});

  @override
  String toString() {
    return 'TradeProductDto(tradeProduct: $tradeProduct, product: $product)';
  }

  toJson() {
    return {
      'tradeProduct': tradeProduct.toJson(),
      'product': product.toJson(),
    };
  }
}
