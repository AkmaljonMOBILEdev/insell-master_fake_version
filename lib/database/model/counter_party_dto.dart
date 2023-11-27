import 'package:easy_sell/database/model/base_dto.dart';
import 'package:easy_sell/database/my_database.dart';

class CounterPartyDto extends Base {
  String name;
  String? address;
  String? phoneNumber;
  CounterPartyType type;
  RegionData? region;
  DateTime? dateOfBirth;
  String? counterpartyCode;

  CounterPartyDto({
    required this.name,
    required this.type,
    this.region,
    this.address,
    this.phoneNumber,
    this.dateOfBirth,
    this.counterpartyCode,
    required super.id,
  });

  static CounterPartyDto fromJson(Map<String, dynamic> map) {
    return CounterPartyDto(
      name: map['name'],
      type: CounterPartyType.fromString(map['type']),
      region: map['region'] == null ? null : RegionData.fromJson(map['region']),
      address: map['address'],
      phoneNumber: map['phoneNumber'],
      dateOfBirth: map['dateOfBirth'] == null ? null : DateTime.fromMillisecondsSinceEpoch(map['dateOfBirth']),
      counterpartyCode: map['counterpartyCode'],
      id: map['id'],
    );
  }
}

enum CounterPartyType {
  PARTNER,
  ORGANIZATION,
  BANK;

  static CounterPartyType fromString(String type) {
    switch (type) {
      case 'PARTNER':
        return CounterPartyType.PARTNER;
      case 'ORGANIZATION':
        return CounterPartyType.ORGANIZATION;
      case 'BANK':
        return CounterPartyType.BANK;
      default:
        return CounterPartyType.PARTNER;
    }
  }
}
