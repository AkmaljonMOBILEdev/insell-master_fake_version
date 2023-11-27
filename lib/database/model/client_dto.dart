import 'package:easy_sell/database/model/base_dto.dart';

import '../my_database.dart';

class ClientDto extends Base {
  String name;
  int? code;
  String? address;
  String? phoneNumber;
  String? phoneNumber2;
  String? discountCard;
  DateTime? dateOfBirth;
  String? organizationName;
  String? description;
  String? email;
  ClientGender? gender;
  String? clientCode;
  RegionData? region;
  int? typeId;
  ClientType? type;

  ClientDto(
      {required this.name,
      required this.typeId,
      this.type,
      this.code,
      this.address,
      this.phoneNumber,
      this.phoneNumber2,
      this.discountCard,
      this.dateOfBirth,
      this.organizationName,
      this.description,
      this.email,
      this.clientCode,
      this.gender,
      this.region,
      required super.id});

  static fromJson(e) {
    return ClientDto(
      id: e['id'],
      name: e['name'],
      description: e['description'],
      address: e['address'],
      phoneNumber: e['phoneNumber'],
      organizationName: e['organizationName'],
      code: e['code'],
      clientCode: e['clientCode'],
      dateOfBirth: DateTime.fromMillisecondsSinceEpoch(e['dateOfBirth']),
      discountCard: e['discountCard'],
      email: e['email'],
      gender: ClientGender.fromString(e['gender']),
      phoneNumber2: e['phoneNumber2'],
      region: RegionData.fromJson(e['region']),
      typeId: e['typeId'],
      type: e['type'] == null ? null : ClientType.fromJson(e['type']),
    );
  }

  static fromClientData(ClientData? client) {
    return ClientDto(
      name: client?.name ?? "NOMALUM",
      id: client!.id,
      discountCard: client.discountCard,
      typeId: -1,
    );
  }
}

enum ClientGender {
  MALE,
  FEMALE;

  static fromString(String gender) {
    switch (gender) {
      case "MALE":
        return ClientGender.MALE;
      case "FEMALE":
        return ClientGender.FEMALE;
    }
  }
}

// id	integer($int64)
// createdAt	string($date-time)
// updatedAt	string($date-time)
// name*	string
// description	string
// cashbackId	integer($int64)
// tradeDebt	boolean
// banned	boolean
class ClientType {
  int id;
  String name;
  String? description;
  int? cashbackId;
  bool tradeDebt;
  bool banned;

  ClientType({
    required this.id,
    required this.name,
    this.description,
    this.cashbackId,
    this.tradeDebt = false,
    this.banned = false,
  });

  static ClientType fromJson(Map<String, dynamic> json) {
    return ClientType(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      cashbackId: json['cashbackId'],
      tradeDebt: json['tradeDebt'],
      banned: json['banned'],
    );
  }
}
