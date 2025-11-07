part of 'crud_bloc.dart';

@immutable
sealed class CrudState {}

final class CrudInitial extends CrudState {}

class DataLoading extends CrudState {}

class DataLoaded extends CrudState {
  final List<EmployeeModel> employees;
  DataLoaded(this.employees);
}

class LoadError extends CrudState {
  final String message;
  LoadError(this.message);
}