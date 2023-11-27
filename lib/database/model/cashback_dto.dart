import 'package:easy_sell/database/model/base_dto.dart';

class CashbackDataStruct extends Base {
  final String name;
  final String? description;
  final List<CashbackRolesDataStruct> cashbackRoles;

  CashbackDataStruct({
    required int id,
    required this.name,
    this.description,
    this.cashbackRoles = const [],
  }) : super(id: id);

  static CashbackDataStruct fromJson(Map<String, dynamic> json) {
    List<CashbackRolesDataStruct> cashbackRoles = [];
    for (var i = 0; i < json['cashbackRoles'].length; i++) {
      cashbackRoles.add(CashbackRolesDataStruct.fromJson(json['cashbackRoles'][i]));
    }
    return CashbackDataStruct(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      cashbackRoles: cashbackRoles,
    );
  }
}

class CashbackRolesDataStruct {
  double? from;
  double? to;
  double? percent;

  CashbackRolesDataStruct({
    this.from,
    this.to,
    this.percent,
  });

  static CashbackRolesDataStruct fromJson(Map<String, dynamic> json) {
    return CashbackRolesDataStruct(
      from: json['from'],
      to: json['to'],
      percent: json['percent'],
    );
  }
}
