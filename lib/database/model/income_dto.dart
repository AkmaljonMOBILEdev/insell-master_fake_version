import 'package:easy_sell/database/model/base_dto.dart';
import 'package:easy_sell/database/model/client_dto.dart';
import 'package:easy_sell/database/model/counter_party_dto.dart';
import 'package:easy_sell/database/model/employee_dto.dart';
import 'package:easy_sell/database/model/exchange_rate_dto.dart';
import 'package:easy_sell/database/model/transactions_dto.dart';
import 'package:easy_sell/database/model/pos_dto.dart';
import 'package:easy_sell/database/model/supplier_dto.dart';

class IncomeDto extends Base {
  TransactionDataStruct? invoice;
  PosDto? pos;
  String? description;
  DateTime createdTime;
  ExchangeRateDataStruct exchangeRate;
  IncomeType type;
  SupplierDto? supplier;
  PosDto? fromPos;
  ClientDto? client;
  CounterPartyDto? counterParty;
  EmployeeDto? employee;

  IncomeDto({
    this.invoice,
    this.pos,
    this.description,
    required this.createdTime,
    required this.exchangeRate,
    required this.type,
    this.supplier,
    this.fromPos,
    this.client,
    this.counterParty,
    this.employee,
    required super.id,
  });

  static IncomeDto fromJson(Map<String, dynamic> map) {
    return IncomeDto(
      invoice: map['invoice'] != null ? TransactionDataStruct.fromJson(map['invoice']) : null,
      pos: map['pos'] != null ? PosDto.fromJson(map['pos']) : null,
      description: map['description'],
      createdTime: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      exchangeRate: ExchangeRateDataStruct.fromJson(map['exchangeRate']),
      type: IncomeType.fromString(map['type']),
      supplier: map['supplier'] != null ? SupplierDto.fromJson(map['supplier']) : null,
      fromPos: map['fromPos'] != null ? PosDto.fromJson(map['fromPos']) : null,
      client: map['client'] != null ? ClientDto.fromJson(map['client']) : null,
      counterParty: map['counterparty'] != null ? CounterPartyDto.fromJson(map['counterparty']) : null,
      employee: map['employee'] != null ? EmployeeDto.fromJson(map['employee']) : null,
      id: map['id'],
    );
  }
}

enum IncomeType {
  CLIENT_RECEIPT,
  ORGANIZATION_RECEIPT,
  POS_RECEIPT,
  BANK_RECEIPT,
  CREDIT_LOAN_RECEIPT,
  COUNTERPARTY_LOAN_RECEIPT,
  EMPLOYEE_LOAN_RECEIPT,
  OTHER_RECEIPT,
  SUPPLIER_RETURN;

  static IncomeType fromString(String type) {
    switch (type) {
      case 'CLIENT_RECEIPT':
        return IncomeType.CLIENT_RECEIPT;
      case 'ORGANIZATION_RECEIPT':
        return IncomeType.ORGANIZATION_RECEIPT;
      case 'POS_RECEIPT':
        return IncomeType.POS_RECEIPT;
      case 'BANK_RECEIPT':
        return IncomeType.BANK_RECEIPT;
      case 'CREDIT_LOAN_RECEIPT':
        return IncomeType.CREDIT_LOAN_RECEIPT;
      case 'COUNTERPARTY_LOAN_RECEIPT':
        return IncomeType.COUNTERPARTY_LOAN_RECEIPT;
      case 'EMPLOYEE_LOAN_RECEIPT':
        return IncomeType.EMPLOYEE_LOAN_RECEIPT;
      case 'OTHER_RECEIPT':
        return IncomeType.OTHER_RECEIPT;
      default:
        return IncomeType.SUPPLIER_RETURN;
    }
  }
}
