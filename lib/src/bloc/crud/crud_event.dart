part of 'crud_bloc.dart';

@immutable
sealed class CrudEvent {}

class LoadEmployees extends CrudEvent {}

class AddEmployee extends CrudEvent {
  final EmployeeModel employee;
  AddEmployee(this.employee);
}

class UpdateEmployee extends CrudEvent {
  final EmployeeModel employee;
  UpdateEmployee(this.employee);
}

class DeleteEmployee extends CrudEvent {
  final int id;
  DeleteEmployee(this.id);
}

class PositionSelected extends CrudEvent {
  final String position;
  PositionSelected(this.position);
}