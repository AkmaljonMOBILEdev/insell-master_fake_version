import 'package:easy_sell/database/model/base_dto.dart';

class DiscountDataStruct extends Base {
  final String name;
  final String? description;
  final List<DiscountRolesDataStruct> discountRoles;

  DiscountDataStruct({
    required int id,
    required this.name,
    this.description,
    this.discountRoles = const [],
    super.createdAt,
    super.updatedAt,
  }) : super(id: id);

  static DiscountDataStruct fromJson(Map<String, dynamic> json) {
    List<DiscountRolesDataStruct> discountRoles = [];
    for (var i = 0; i < json['discountRoles'].length; i++) {
      discountRoles.add(DiscountRolesDataStruct.fromJson(json['discountRoles'][i]));
    }
    return DiscountDataStruct(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      discountRoles: discountRoles,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'discountRoles': discountRoles.map((e) => e.toJson()).toList(),
    };
  }
}

class DiscountRolesDataStruct {
  double? from;
  double? to;
  double? percent;
  int? clientTypeId;

  DiscountRolesDataStruct({
    this.from,
    this.to,
    this.percent,
    this.clientTypeId,
  });

  static DiscountRolesDataStruct fromJson(Map<String, dynamic> json) {
    return DiscountRolesDataStruct(
      from: json['from'],
      to: json['to'],
      percent: json['percent'],
      clientTypeId: json['clientTypeId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'from': from,
      'to': to,
      'percent': percent,
      'clientTypeId': clientTypeId,
    };
  }
}
