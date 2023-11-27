import 'package:easy_sell/database/model/base_dto.dart';
import 'package:easy_sell/database/model/supplier_organization_dto.dart';

import '../my_database.dart';

class SupplierDto extends Base {
  String name;
  String? description;
  String? address;
  String? phoneNumber;
  SupplierOrganizationDto? supplierOrganization;
  RegionData? region;
  String? supplierCode;
  DateTime? dateOfBirth;
  List<CategoryData> categories = [];
  SupplierSegment? segment;

  SupplierDto({
    required this.name,
    this.description,
    this.address,
    this.phoneNumber,
    this.supplierOrganization,
    this.region,
    this.supplierCode,
    this.dateOfBirth,
    this.segment,
    required this.categories,
    required int id,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(id: id, createdAt: createdAt, updatedAt: updatedAt);

  static SupplierDto fromJson(e) {
    List<CategoryData> categories = [];
    if (e['categories'] != null) {
      for (var item in e['categories']) {
        item['isSynced'] = true;
        item['serverId'] = item['id'];
        categories.add(CategoryData.fromJson(item));
      }
    }
    return SupplierDto(
      id: e['id'],
      name: e['name'],
      description: e['description'],
      address: e['address'],
      phoneNumber: e['phoneNumber'],
      supplierOrganization:
          e['supplierOrganization'] != null ? SupplierOrganizationDto.fromJson(e['supplierOrganization']) : null,
      categories: categories,
      segment: e['segment'] != null ? SupplierSegment.fromJson(e['segment']) : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(e['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(e['updatedAt']),
      region: e['region'] != null ? RegionData.fromJson(e['region']) : null,
      supplierCode: e['supplierCode'],
      dateOfBirth: e['dateOfBirth'] != null ? DateTime.fromMillisecondsSinceEpoch(e['dateOfBirth']) : null,
    );
  }
}

enum SupplierCurrency {
  USD,
  UZS;
}

enum SupplierType {
  PARTNER,
  ORGANIZATION,
  BANK;

  static SupplierType fromString(String value) {
    switch (value) {
      case 'PARTNER':
        return SupplierType.PARTNER;
      case 'ORGANIZATION':
        return SupplierType.ORGANIZATION;
      case 'BANK':
        return SupplierType.BANK;
      default:
        return SupplierType.PARTNER;
    }
  }
}

class SupplierSegment {
  int id;
  String name;
  String? description;

  SupplierSegment({
    required this.id,
    required this.name,
    this.description,
  });

  static SupplierSegment fromJson(e) {
    return SupplierSegment(id: e['id'], name: e['name'], description: e['description']);
  }
}
