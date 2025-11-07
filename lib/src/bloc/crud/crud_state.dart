part of 'crud_bloc.dart';

@immutable
class CrudState extends Equatable{
  @override
  List<Object?> get props => [];
}

final class CrudInitial extends CrudState {}

class DataLoading extends CrudState {}

class SuccessState extends CrudState {}

class DataLoaded extends CrudState {
  final List<EmployeeModel> employees;
  DataLoaded(this.employees);

  @override
  List<Object> get props => [employees];
}

class LoadError extends CrudState {
  final String message;
  LoadError(this.message);
}