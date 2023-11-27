import 'package:easy_sell/database/model/base_dto.dart';
import 'package:easy_sell/database/model/currency_dto.dart';
import 'package:easy_sell/database/my_database.dart';

class ProductIncomePrice extends Base {
  ProductData product;
  double price;
  double amount;
  double suggestedPrice;
  CurrencyDataStruct currency;

  ProductIncomePrice({
    required this.product,
    required this.price,
    required this.amount,
    required this.suggestedPrice,
    required this.currency,
    required int id,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(id: id, createdAt: createdAt, updatedAt: updatedAt);

  static ProductIncomePrice fromJson(productIncome) {
    productIncome['product']['isSynced'] = true;
    productIncome['product']['productsInBox'] = productIncome['product']['productsInBox'].toString();
    productIncome['product']['isKit'] = productIncome['product']['kit'];
    productIncome['product']['serverId'] = productIncome['product']['id'];
    ProductData productData = ProductData.fromJson(productIncome['product']);
    return ProductIncomePrice(
      product: productData,
      price: productIncome['price'],
      amount: productIncome['amount'],
      suggestedPrice: productIncome['suggestedPrice'],
      currency: CurrencyDataStruct.fromJson(productIncome['currency']),
      id: productIncome['id'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(productIncome['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(productIncome['updatedAt']),
    );
  }
}
