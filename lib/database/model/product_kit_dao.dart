import 'package:easy_sell/database/model/product_dto.dart';
import 'package:easy_sell/database/my_database.dart';

class ProductKitDTO {
  final ProductDTO product;
  final ProductKitData productKit;

  ProductKitDTO({required this.product, required this.productKit});
}
