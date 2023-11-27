import 'package:easy_sell/database/model/base_dto.dart';
import 'package:easy_sell/database/my_database.dart';

class ShopDto extends Base {
  String name;
  RegionData region;
  String address;
  ShopType type;

  ShopDto({
    required this.name,
    required this.region,
    required this.address,
    required this.type,
    required int id,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(
          id: id,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  static ShopDto fromJson(item) {
    return ShopDto(
      name: item['name'],
      region: RegionData.fromJson(item['region']),
      address: item['address'],
      type: ShopType.fromStr(item['type']),
      id: item['id'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(item['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(item['updatedAt']),
    );
  }
}

enum ShopType {
  WAREHOUSE_ADMINISTRATION,
  RETAIL,
  WHOLESALE,
  MIXED,
  WAREHOUSE,
  WAREHOUSE_SHOP;

  static ShopType fromStr(String str) {
    switch (str) {
      case 'WAREHOUSE_ADMINISTRATION':
        return ShopType.WAREHOUSE_ADMINISTRATION;
      case 'RETAIL':
        return ShopType.RETAIL;
      case 'WHOLESALE':
        return ShopType.WHOLESALE;
      case 'MIXED':
        return ShopType.MIXED;
      case 'WAREHOUSE':
        return ShopType.WAREHOUSE;
      case 'WAREHOUSE_SHOP':
        return ShopType.WAREHOUSE_SHOP;
      default:
        return ShopType.RETAIL;
    }
  }
}
