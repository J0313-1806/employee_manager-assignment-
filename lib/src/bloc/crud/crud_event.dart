part of 'crud_bloc.dart';

@immutable
class CrudEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadEmployees extends CrudEvent {
  LoadEmployees();

  @override
  List<Object?> get props => [];
}

class AddEmployee extends CrudEvent {
  final EmployeeModel employee;
  AddEmployee(this.employee);

  @override
  List<Object?> get props => [employee];
}

class UpdateEmployee extends CrudEvent {
  final EmployeeModel employee;
  UpdateEmployee(this.employee);

  @override
  List<Object?> get props => [employee];
}

class DeleteEmployee extends CrudEvent {
  final String id;
  DeleteEmployee(this.id);

  @override
  List<Object?> get props => [id];
}

class DataUpdated extends CrudEvent {
  final List<EmployeeModel> employees;
  DataUpdated(this.employees);
  @override
  List<Object?> get props => [employees];
}
