import 'package:easy_sell/database/model/base_dto.dart';

class PriceTypeDataStruct extends Base {
  String name;
  String? description;
  bool defaultPriceType;

  PriceTypeDataStruct({
    required int id,
    required this.name,
    required this.description,
    required this.defaultPriceType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(id: id, createdAt: createdAt, updatedAt: updatedAt);

  static PriceTypeDataStruct fromJson(Map<String, dynamic> json) {
    return PriceTypeDataStruct(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      defaultPriceType: json['default'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'default': defaultPriceType,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
    };
  }
}
