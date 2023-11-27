class PriceSetDto {
  int id;
  int createdAt;
  int updatedAt;
  String name;
  String description;
  int? roundingId;
  double exchangeRateAddition;
  List<SetPriceRoleDto> setPriceRoles;

  PriceSetDto({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    required this.description,
    this.exchangeRateAddition = 0,
    required this.roundingId,
    required this.setPriceRoles,
  });

  factory PriceSetDto.fromJson(Map<String, dynamic> json) {
    List setPriceRolesList = json['setPriceRoles'];
    List<SetPriceRoleDto> roundingRolesDtoList = setPriceRolesList.map((roleJson) => SetPriceRoleDto.fromJson(roleJson)).toList();

    return PriceSetDto(
      id: json['id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      name: json['name'],
      description: json['description'],
      roundingId: json['roundingId'],
      exchangeRateAddition: json['exchangeRateAddition'],
      setPriceRoles: roundingRolesDtoList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'name': name,
      'description': description,
      'exchangeRateAddition': exchangeRateAddition,
      'roundingRoles': setPriceRoles.map((role) => role.toJson()).toList(),
    };
  }
}

class SetPriceRoleDto {
  int? fromPriceTypeId;
  int? priceTypeId;
  double fromPrice;
  double toPrice;
  double percent;
  bool decrease;
  bool fromIncomePrice;

  SetPriceRoleDto({
    required this.fromPriceTypeId,
    required this.priceTypeId,
    required this.fromPrice,
    required this.toPrice,
    required this.percent,
    required this.decrease,
    required this.fromIncomePrice,
  });

  factory SetPriceRoleDto.fromJson(Map<String, dynamic> json) {
    return SetPriceRoleDto(
      fromPriceTypeId: json['fromPriceTypeId'],
      priceTypeId: json['priceTypeId'],
      fromPrice: json['fromPrice'],
      toPrice: json['toPrice'],
      percent: json['percent'],
      decrease: json['decrease'],
      fromIncomePrice: json['fromIncomePrice'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fromPriceTypeId': fromPriceTypeId,
      'priceTypeId': priceTypeId,
      'fromPrice': fromPrice,
      'toPrice': toPrice,
      'percent': percent,
      'decrease': decrease,
      'fromIncomePrice': fromIncomePrice,
    };
  }
}
