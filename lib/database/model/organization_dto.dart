
import 'package:easy_sell/database/model/base_dto.dart';

class OrganizationDto extends Base {
  int id;
  String? name;
  String? address;
  String? phoneNumber;
  OrganizationType? type;
  DateTime? createdAt;
  DateTime? updatedAt;

  OrganizationDto({
    required this.id,
    this.name,
    this.address,
    this.phoneNumber,
    this.type,
    this.createdAt,
    this.updatedAt,
  }) : super(
          id: id,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  static OrganizationDto fromJson(item) {
    return OrganizationDto(
      id: item['id'],
      name: item['name'],
      address: item['address'],
      phoneNumber: item['phoneNumber'],
      type: OrganizationType.fromStr(item['type']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(item['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(item['updatedAt']),
    );
  }
}

enum OrganizationType {
  MAIN,
  SO;

  static OrganizationType fromStr(String str) {
    switch (str) {
      case 'MAIN':
        return OrganizationType.MAIN;
      case 'SO':
        return OrganizationType.SO;
      default:
        return OrganizationType.MAIN;
    }
  }
}