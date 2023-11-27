import 'package:easy_sell/database/model/base_dto.dart';

class EmployeeDto extends Base {
  String name;
  String firstName;
  EmployeeGender gender;
  EmployeeType employeeType;
  String? lastName;
  String? address;
  String? phoneNumber;
  String? phoneNumber2;
  DateTime? dateOfBirth;
  String? position;
  String? cardNumber;

  EmployeeDto({
    required this.name,
    required this.firstName,
    required this.gender,
    required this.employeeType,
    required super.id,
    this.lastName,
    this.address,
    this.phoneNumber,
    this.phoneNumber2,
    this.dateOfBirth,
    this.position,
    this.cardNumber,
  });

  static EmployeeDto fromJson(Map<String, dynamic> json) {
    return EmployeeDto(
      name: json['name'],
      firstName: json['firstName'],
      gender: EmployeeGender.fromString(json['gender']),
      employeeType: EmployeeType.fromString(json['type']),
      id: json['id'],
      dateOfBirth: json['dateOfBirth'] != null ? DateTime.fromMillisecondsSinceEpoch(json['dateOfBirth']) : null,
      address: json['address'],
      cardNumber: json['cardNumber'],
      lastName: json['lastName'],
      phoneNumber2: json['phoneNumber2'],
      phoneNumber: json['phoneNumber'],
      position: json['position'],
    );
  }
}

enum EmployeeGender {
  MALE,
  FEMALE;

  static EmployeeGender fromString(String gender) {
    switch (gender) {
      case "MALE":
        return EmployeeGender.MALE;
      case "FEMALE":
        return EmployeeGender.FEMALE;
      default:
        return EmployeeGender.MALE;
    }
  }
}

enum EmployeeType {
  CASHIER,
  STOREKEEPER,
  MANAGER,
  ADMINISTRATOR;

  static EmployeeType fromString(String type) {
    switch (type) {
      case "CASHIER":
        return EmployeeType.CASHIER;
      case "STOREKEEPER":
        return EmployeeType.STOREKEEPER;
      case "MANAGER":
        return EmployeeType.MANAGER;
      default:
        return EmployeeType.CASHIER;
    }
  }
}
