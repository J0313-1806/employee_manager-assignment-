import 'package:bloc/bloc.dart';
import 'package:employee_manager/src/data/hive_repo.dart';
import 'package:employee_manager/src/model/employee_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

part 'crud_event.dart';
part 'crud_state.dart';

class CrudBloc extends Bloc<CrudEvent, CrudState> {

  Box<EmployeeModel> employeeBox = Hive.box<EmployeeModel>('employees');
  final HiveRepository _hiveRepository = HiveRepository();

  CrudBloc() : super(CrudInitial()) {
    on<CrudEvent>((event, emit) {     
    });

    on<LoadEmployees>((event, emit) {
      try {
        emit(DataLoading());
        var empList = _hiveRepository.getAllEmployee();
        add(DataUpdated(empList));
      } catch (e) {
        
        emit(LoadError(e.toString()));
      }
    });

    on<AddEmployee>((event, emit) async {
      try {
        await _hiveRepository.addEmployee(event.employee);

        add(LoadEmployees());
      } catch (e) {
        print(e.toString());
        emit(LoadError('Failed to add task: $e'));
      }
    });

    on<UpdateEmployee>((event, emit) async {
      try {
        await _hiveRepository.updateEmployee(event.employee);
        emit(SuccessState());
      } catch (e) {
        emit(LoadError('Failed to update task: $e'));
      }
    });

    on<DeleteEmployee>((event, emit) async {
      try {
        await _hiveRepository.deleteEmployee(event.id);
        add(LoadEmployees());
      } catch (e) {
        emit(LoadError('Failed to delete task: $e'));
      }
    });

  on<DataUpdated>((event, emit) async {
    if (listEquals(
      (state is DataLoaded) ? (state as DataLoaded).employees : [],
      event.employees,
    )) {
      return;
    }
    emit(DataLoaded(event.employees));
  });

    _hiveRepository.employeeBoxListenable.addListener(() {
      add(DataUpdated(_hiveRepository.getAllEmployee()));
    });
  }
}
