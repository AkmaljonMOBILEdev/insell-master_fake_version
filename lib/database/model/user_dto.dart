import 'package:easy_sell/database/model/base_dto.dart';
import 'package:easy_sell/database/model/pos_dto.dart';
import 'package:easy_sell/database/model/shop_dto.dart';

import '../../constants/user_role.dart';
import 'organization_dto.dart';

class UserDto extends Base {
  String name;
  String? phoneNumber;
  String? phoneNumber2;
  String? data;
  String? username;

  ShopDto? shop;
  PosDto? pos;
  bool enabled;
  List<UserRole> roles;
  OrganizationDto? organization;

  UserDto({
    required this.name,
    this.phoneNumber,
    this.phoneNumber2,
    this.data,
    this.username,
    this.shop,
    this.pos,
    this.enabled = true,
    this.roles = const [],
    this.organization,
    required super.id,
    super.createdAt,
    super.updatedAt,
  });

  static UserDto fromJson(Map<String, dynamic> json) {
    return UserDto(
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      phoneNumber2: json['phoneNumber2'],
      data: json['data'],
      username: json['username'],
      shop: json['shop'] != null ? ShopDto.fromJson(json['shop']) : null,
      pos: json['pos'] != null ? PosDto.fromJson(json['pos']) : null,
      enabled: json['enabled'],
      roles: json['roles'] != null ? json['roles'].map<UserRole>((e) => UserRole.fromString(e)).toList() : [],
      id: json['id'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt']),
      organization: json['organization'] != null ? OrganizationDto.fromJson(json['organization']) : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'phoneNumber2': phoneNumber2,
      'data': data,
      'username': username,
      'shop': shop?.toJson(),
      'pos': pos?.toJson(),
      'enabled': enabled,
      'roles': roles.map((e) => e.toString()).toList(),
      'id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'organization': organization?.toJson(),
    };
  }
}
