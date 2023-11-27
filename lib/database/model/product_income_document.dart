import 'package:easy_sell/database/model/currency_dto.dart';
import 'package:easy_sell/database/model/invoice_dto.dart';
import 'package:easy_sell/database/model/shop_dto.dart';
import 'package:easy_sell/database/model/supplier_dto.dart';
import 'package:easy_sell/database/my_database.dart';
import 'package:easy_sell/screens/warehouse_screen/widget/update_dialog/warehouse_info_update.dart';
import 'base_dto.dart';

class ProductIncomeDocumentDto extends Base {
  ShopDto? fromShop;
  ShopDto? shop;
  String? description;
  SupplierDto? supplier;
  DateTime createdTime;
  DateTime? expiredDebtDate;
  double total;
  List<ProductIncomeDto> productIncomes;
  ProductIncomeType? type;
  CurrencyDataStruct? currency;
  SuggestPriceSetting? setPrice;
  InvoiceDataStruct? invoice;
  double discount = 0;

  ProductIncomeDocumentDto({
    this.supplier,
    this.description,
    this.fromShop,
    required this.createdTime,
    required this.expiredDebtDate,
    required this.total,
    required this.productIncomes,
    required this.discount,
    this.currency,
    this.setPrice,
    this.type,
    this.shop,
    this.invoice,
    required int id,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(id: id, createdAt: createdAt, updatedAt: updatedAt);

  static ProductIncomeDocumentDto fromJson(item) {
    List<ProductIncomeDto> productIncomes = [];
    for (var productIncome in item['productIncomes']) {
      productIncomes.add(ProductIncomeDto.fromJson(productIncome));
    }
    return ProductIncomeDocumentDto(
      supplier: item['supplier'] != null ? SupplierDto.fromJson(item['supplier']) : null,
      description: item['description'],
      createdTime: DateTime.fromMillisecondsSinceEpoch(item['createdTime']),
      expiredDebtDate: item['expiredDebtDate'] != null ? DateTime.fromMillisecondsSinceEpoch(item['expiredDebtDate']) : null,
      total: 0,
      fromShop: item['fromShop'] != null ? ShopDto.fromJson(item['fromShop']) : null,
      shop: item['shop'] != null ? ShopDto.fromJson(item['shop']) : null,
      productIncomes: productIncomes,
      type: ProductIncomeType.fromString(item['type']),
      id: item['id'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(item['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(item['updatedAt']),
      discount: item['discount'],
      currency: CurrencyDataStruct.fromJson(item['currency']),
      setPrice: item['setPrice'] != null ? SuggestPriceSetting.fromJson(item['setPrice']) : null,
      invoice: item['invoice'] != null ? InvoiceDataStruct.fromJson(item['invoice']) : null,
    );
  }

  // to json
  @override
  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> productIncomes = [];
    for (var productIncome in this.productIncomes) {
      productIncomes.add(productIncome.toJson());
    }
    return {
      'supplier': supplier?.toJson(),
      'description': description,
      'createdTime': createdTime.millisecondsSinceEpoch,
      'expiredDebtDate': expiredDebtDate?.millisecondsSinceEpoch,
      'total': total,
      'fromShop': fromShop?.toJson(),
      'shop': shop?.toJson(),
      'productIncomes': productIncomes,
      'type': type.toString().split('.').last,
      'discount': discount,
      'currency': currency?.toJson(),
      'setPriceId': setPrice?.toJson(),
      'invoice': invoice?.toJson(),
    };
  }

  // to request json
  Map<String, dynamic> toRequestJson() {
    return {
      "fromShopId": fromShop?.id,
      "shopId": shop?.id,
      "description": description,
      "createdTime": createdTime.millisecondsSinceEpoch,
      "expiredDebtDate": expiredDebtDate == null ? null : expiredDebtDate!.millisecondsSinceEpoch,
      "supplierId": supplier?.id,
      "productIncomes": productIncomes.map((productIncome) {
        return {
          "productId": productIncome.product.serverId,
          "price": productIncome.price,
          "amount": productIncome.amount,
          "expireDate": productIncome.expiredDate?.millisecondsSinceEpoch,
          "currencyId": productIncome.currency?.id,
          "suggestedPrice": productIncome.suggestedPrice,
        };
      }).toList(),
      "type": "INCOME",
      "discount": discount,
      'currencyId': currency?.id,
      'setPriceId': setPrice?.id,
    };
  }

  // to price option
  List<Map<String, dynamic>> toPriceOption() {
    return productIncomes
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
    return ProductIncomeDocumentDto(
      supplier: null,
      description: null,
      createdTime: DateTime.now(),
      expiredDebtDate: null,
      total: 0,
      fromShop: null,
      shop: null,
      productIncomes: [],
      type: null,
      id: 0,
      createdAt: null,
      updatedAt: null,
      discount: 0,
      currency: null,
      invoice: null,
      setPrice: null,
    );
  }

  List<Map<String, dynamic>> toSuggestPrice() {
    return productIncomes
        .map((e) => {
              "productId": e.product.serverId,
              "price": e.suggestedPrice,
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

class ProductIncomeDto extends Base {
  ProductData product;
  double price;
  double amount;
  DateTime? expiredDate;
  CurrencyDataStruct? currency;
  double? suggestedPrice;

  ProductIncomeDto({
    required this.product,
    required this.price,
    required this.amount,
    this.expiredDate,
    this.currency,
    this.suggestedPrice = 0,
    required int id,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(id: id, createdAt: createdAt, updatedAt: updatedAt);

  static ProductIncomeDto fromJson(productIncome) {
    productIncome['product']['isSynced'] = true;
    productIncome['product']['productsInBox'] = productIncome['product']['productsInBox'].toString();
    productIncome['product']['isKit'] = productIncome['product']['kit'];
    productIncome['product']['serverId'] = productIncome['product']['id'];
    ProductData productData = ProductData.fromJson(productIncome['product']);
    return ProductIncomeDto(
      product: productData,
      price: productIncome['price'],
      amount: productIncome['amount'],
      expiredDate: productIncome['expireDate'] != null ? DateTime.fromMillisecondsSinceEpoch(productIncome['expireDate']) : null,
      currency: CurrencyDataStruct.fromJson(productIncome['currency']),
      id: productIncome['id'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(productIncome['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(productIncome['updatedAt']),
      suggestedPrice: productIncome['suggestedPrice'],
    );
  }
}
