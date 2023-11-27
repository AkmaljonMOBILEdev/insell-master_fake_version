import 'package:drift/drift.dart';
import 'package:easy_sell/database/table/employee_table.dart';
import '../my_database.dart';

part 'employee_dao.g.dart';

@DriftAccessor(tables: [Employee])
class EmployeeDao extends DatabaseAccessor<MyDatabase> with _$EmployeeDaoMixin {
  EmployeeDao(MyDatabase db) : super(db);

  // get all employees
  Future<List<EmployeeData>> getAllEmployees() async {
    return await (select(employee)).get();
  }

  // get by id
  Future<EmployeeData?> getById(int id) async {
    return await (select(employee)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  // get by cardNumber
  Future<EmployeeData?> getByCardNumber(String cardNumber) async {
    return await (select(employee)..where((tbl) => tbl.cardNumber.equals(cardNumber))).getSingleOrNull();
  }

  // create new employee
  Future<EmployeeData?> createEmployee(EmployeeData employeeData) async {
    bool isExist = await getById(employeeData.serverId ?? -1) != null;
    if (isExist) {
      return await updateEmployee(employeeData);
    }
    int id = await into(employee).insert(employeeData);
    return await getById(id);
  }

  // update employee
  Future<EmployeeData?> updateEmployee(EmployeeData employeeData) async {
    await update(employee).replace(employeeData);
    return await getById(employeeData.id);
  }

  Future<EmployeeData?>getByServerId(int cashierServerId) {
    return (select(employee)..where((tbl) => tbl.serverId.equals(cashierServerId))).getSingleOrNull();
  }
}
