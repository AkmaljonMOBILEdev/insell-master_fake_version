import 'base_dto.dart';

class Season extends Base {
  String name;
  String description;
  DateTime startDate;
  DateTime endDate;

  Season({
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required super.id,
  });

  Season copyWith({
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    int? id,
  }) {
    return Season(
      name: name ?? this.name,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      id: id ?? this.id,
    );
  }

  factory Season.fromJson(Map<String, dynamic> json) => Season(
        name: json["name"],
        description: json["description"],
        startDate: DateTime.fromMillisecondsSinceEpoch(json["startDate"]),
        endDate: DateTime.fromMillisecondsSinceEpoch(json["endDate"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "startDate": startDate,
        "endDate": endDate,
        "id": id,
      };
}
