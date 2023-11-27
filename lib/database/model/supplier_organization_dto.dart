import 'package:easy_sell/database/model/base_dto.dart';

class SupplierOrganizationDto extends Base {
  String name;
  String? address;
  String? phoneNumber;

  SupplierOrganizationDto({
    required this.name,
    this.address,
    this.phoneNumber,
    required int id,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(id: id, createdAt: createdAt, updatedAt: updatedAt);

  static fromJson(e) {
    return SupplierOrganizationDto(
      id: e['id'],
      name: e['name'],
      address: e['address'],
      phoneNumber: e['phoneNumber'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(e['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(e['updatedAt']),
    );
  }
}

class SegmentDto extends Base {
  final String name;
  final String? description;

  SegmentDto({
    required int id,
    required this.name,
    this.description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(id: id, createdAt: createdAt, updatedAt: updatedAt);

  static SegmentDto fromJson(item) {
    return SegmentDto(
      id: item['id'],
      name: item['name'],
      description: item['description'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(item['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(item['updatedAt']),
    );
  }
}
