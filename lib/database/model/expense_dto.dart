import 'base_dto.dart';

class ExpenseDto extends Base {
  String? name;
  bool affectToProfit;

  ExpenseDto({
    this.name,
    required this.affectToProfit,
    required super.id,
  });

  static ExpenseDto fromJson(Map<String, dynamic> map) {
    return ExpenseDto(
      name: map['name'],
      affectToProfit: map['affectToProfit'],
      id: map['id'],
    );
  }
}
