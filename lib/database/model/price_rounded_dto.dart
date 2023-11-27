class PriceRoundedDto {
  int id;
  int createdAt;
  int updatedAt;
  String name;
  String description;
  List<RoundingRoleDto> roundingRoles;

  PriceRoundedDto({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    required this.description,
    required this.roundingRoles,
  });

  factory PriceRoundedDto.fromJson(Map<String, dynamic> json) {
    var roundingRolesList = json['roundingRoles'] as List;
    List<RoundingRoleDto> roundingRolesDtoList = roundingRolesList.map((roleJson) => RoundingRoleDto.fromJson(roleJson)).toList();

    return PriceRoundedDto(
      id: json['id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      name: json['name'],
      description: json['description'],
      roundingRoles: roundingRolesDtoList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'name': name,
      'description': description,
      'roundingRoles': roundingRoles.map((role) => role.toJson()).toList(),
    };
  }
}

class RoundingRoleDto {
  double from;
  double to;
  double step;
  double decrease;
  bool rounding;
  bool roundUp;

  RoundingRoleDto({
    required this.from,
    required this.to,
    required this.step,
    required this.decrease,
    required this.rounding,
    required this.roundUp,
  });

  factory RoundingRoleDto.fromJson(Map<String, dynamic> json) {
    return RoundingRoleDto(
      from: json['from'],
      to: json['to'],
      step: json['step'],
      decrease: json['decrease'],
      rounding: json['rounding'],
      roundUp: json['roundUp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'from': from,
      'to': to,
      'step': step,
      'decrease': decrease,
      'rounding': rounding,
      'roundUp': roundUp,
    };
  }
}
