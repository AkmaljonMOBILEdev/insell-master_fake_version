import 'package:easy_sell/database/model/shop_dto.dart';

import 'base_dto.dart';

class PosDto extends Base {
  String name;
  ShopDto shop;
  PosType type;

  PosDto({
    required this.name,
    required this.shop,
    required this.type,
    required super.id,
  });

  static PosDto fromJson(Map<String, dynamic> map) {
    return PosDto(
      name: map['name'],
      shop: ShopDto.fromJson(map['shop']),
      id: map['id'],
      type: PosType.fromString(map['type']),
    );
  }
}

enum PosType {
  SHOP,
  SHOP_MAIN,
  MAIN;

  // from string
  static PosType fromString(String type) {
    switch (type) {
      case 'SHOP':
        return PosType.SHOP;
      case 'SHOP_MAIN':
        return PosType.SHOP_MAIN;
      case 'MAIN':
        return PosType.MAIN;
      default:
        return PosType.MAIN;
    }
  }
}
