import 'package:easy_sell/database/model/currency_dto.dart';
import 'package:easy_sell/database/model/invoice_dto.dart';
import 'package:easy_sell/database/model/shop_dto.dart';
import 'package:easy_sell/database/model/supplier_dto.dart';
import 'package:easy_sell/database/my_database.dart';
import 'package:easy_sell/screens/warehouse_screen/widget/update_dialog/warehouse_info_update.dart';
import 'base_dto.dart';

class ProductOutcomeDocumentDto extends Base {
  ShopDto? shop;
  String? description;
  SupplierDto? supplier;
  DateTime createdTime;
  List<ProductExpense> productExpenses;
  ProductIncomeType? type;
  CurrencyDataStruct? currency;
  SuggestPriceSetting? setPrice;
  InvoiceDataStruct? invoice;

  ProductOutcomeDocumentDto({
    this.supplier,
    this.description,
    required this.createdTime,
    required this.productExpenses,
    this.currency,
    this.setPrice,
    this.type,
    this.shop,
    this.invoice,
    required int id,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(id: id, createdAt: createdAt, updatedAt: updatedAt);

  static ProductOutcomeDocumentDto fromJson(item) {
    List<ProductExpense> productExpenses = [];
    for (var productExpense in item['productExpenses']) {
      productExpenses.add(ProductExpense.fromJson(productExpense));
    }
    return ProductOutcomeDocumentDto(
      supplier: item['supplier'] != null ? SupplierDto.fromJson(item['supplier']) : null,
      description: item['description'],
      createdTime: DateTime.fromMillisecondsSinceEpoch(item['createdTime']),
      shop: item['shop'] != null ? ShopDto.fromJson(item['shop']) : null,
      productExpenses: productExpenses,
      type: ProductIncomeType.fromString(item['type']),
      id: item['id'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(item['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(item['updatedAt']),
      currency: CurrencyDataStruct.fromJson(item['currency']),
      setPrice: item['setPrice'] != null ? SuggestPriceSetting.fromJson(item['setPrice']) : null,
      invoice: item['invoice'] != null ? InvoiceDataStruct.fromJson(item['invoice']) : null,
    );
  }

  // to json
  @override
  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> productExpensesAll = [];
    for (var productExpense in productExpenses) {
      productExpensesAll.add(productExpense.toJson());
    }
    return {
      'supplier': supplier?.toJson(),
      'description': description,
      'createdTime': createdTime.millisecondsSinceEpoch,
      'shop': shop?.toJson(),
      'productExpenses': productExpenses,
      'type': type.toString().split('.').last,
      'currency': currency?.toJson(),
      'setPriceId': setPrice?.toJson(),
      'invoice': invoice?.toJson(),
    };
  }

  // to request json
  Map<String, dynamic> toRequestJson() {
    return {
      "shopId": shop?.id,
      "description": description,
      "supplierId": supplier?.id,
      "createdTime": createdTime.millisecondsSinceEpoch,
      'currencyId': currency?.id,
      "productExpenses": productExpenses.map((productExpense) {
        return {
          "currencyId": productExpense.currency?.id,
          "amount": productExpense.amount,
          "price": productExpense.price,
          "productId": productExpense.product.serverId,
          "description": "",
        };
      }).toList(),
    };
  }

  // to price option
  List<Map<String, dynamic>> toPriceOption() {
    return productExpenses
        .map((e) => {
              "productId": e.product.serverId,
              "price": e.price,
              "currencyId": e.currency?.id,
              "priceSettingId": setPrice?.id,
              "priceTypeId": setPrice?.id,
            })
        .toList();
  }

  static empty() {
    return ProductOutcomeDocumentDto(
      supplier: null,
      description: null,
      createdTime: DateTime.now(),
      shop: null,
      productExpenses: [],
      type: null,
      id: 0,
      createdAt: null,
      updatedAt: null,
      currency: null,
      invoice: null,
      setPrice: null,
    );
  }

  List<Map<String, dynamic>> toSuggestPrice() {
    return productExpenses
        .map((e) => {
              "productId": e.product.serverId,
              "currencyId": e.currency?.id,
              "priceTypeId": setPrice?.id,
            })
        .toList();
  }
}

enum ProductIncomeType {
  INCOME,
  RETURN,
  KIT,
  TRANSFER;

  static ProductIncomeType fromString(String type) {
    switch (type) {
      case 'INCOME':
        return ProductIncomeType.INCOME;
      case 'RETURN':
        return ProductIncomeType.RETURN;
      case 'KIT':
        return ProductIncomeType.KIT;
      case 'TRANSFER':
        return ProductIncomeType.TRANSFER;
      default:
        return ProductIncomeType.INCOME;
    }
  }
}

class ProductExpense extends Base {
  ProductData product;
  double price;
  double amount;
  CurrencyDataStruct? currency;

  ProductExpense({
    required this.product,
    required this.price,
    required this.amount,
    this.currency,
    required int id,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(id: id, createdAt: createdAt, updatedAt: updatedAt);

  static ProductExpense fromJson(productExpense) {
    productExpense['product']['isSynced'] = true;
    productExpense['product']['productsInBox'] = productExpense['product']['productsInBox'].toString();
    productExpense['product']['isKit'] = productExpense['product']['kit'];
    productExpense['product']['serverId'] = productExpense['product']['id'];
    ProductData productData = ProductData.fromJson(productExpense['product']);
    return ProductExpense(
      product: productData,
      price: productExpense['price'],
      amount: productExpense['amount'],
      currency: CurrencyDataStruct.fromJson(productExpense['currency']),
      id: productExpense['id'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(productExpense['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(productExpense['updatedAt']),
    );
  }
}
