import 'package:employee_manager/src/model/employee_model.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class HiveRepository {

  // Use a constant for the box name
  static const String _employeeBoxName = 'employees';
  final Box<EmployeeModel> _employeeBox = Hive.box<EmployeeModel>(_employeeBoxName);

  // C - Create/Add EmployeeModel
  Future<void> addEmployee(EmployeeModel employee) async {
    await _employeeBox.put(employee.id, employee);
  }

  // R - Read All EmployeeModels
  List<EmployeeModel> getAllEmployee() {
    return _employeeBox.values.toList();
  }

  // U - Update EmployeeModel
  Future<void> updateEmployee(EmployeeModel employee) async {
    await _employeeBox.put(employee.id, employee);
  }

  // D - Delete EmployeeModel
  Future<void> deleteEmployee(String id) async {
    await _employeeBox.delete(id);
  }

  // Get a listenable stream of changes for the entire box
  ValueListenable<Box<EmployeeModel>> get employeeBoxListenable =>
      _employeeBox.listenable();
}
