import 'package:bloc/bloc.dart';
import 'package:employee_manager/src/model/employee_model.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

part 'crud_event.dart';
part 'crud_state.dart';

class CrudBloc extends Bloc<CrudEvent, CrudState> {
  CrudBloc() : super(CrudInitial()) {
    on<CrudEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<LoadEmployees>((event, emit) {
      // Handle loading employees logic here
    });

    on<AddEmployee>((event, emit) {
      // Handle adding employee logic here
    });

    on<UpdateEmployee>((event, emit) {
      // Handle updating employee logic here
    });

    on<DeleteEmployee>((event, emit) {
      // Handle deleting employee logic here
    });

  }

}
