// ignore_for_file: avoid_print

import 'package:bloc/bloc.dart';
import 'package:employee_manager/src/data/hive_repo.dart';
import 'package:employee_manager/src/model/employee_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
// ignore: depend_on_referenced_packages

part 'crud_event.dart';
part 'crud_state.dart';

class CrudBloc extends Bloc<CrudEvent, CrudState> {
  final HiveRepository _hiveRepository;

  CrudBloc({required HiveRepository hiveRepository})
    : _hiveRepository = hiveRepository,
      super(CrudInitial()) {
    on<CrudEvent>((event, emit) {});

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
        final empList = _hiveRepository.getAllEmployee();
        emit(DataLoaded(empList));
      } catch (e) {
        print(e.toString());
        emit(LoadError('Failed to add task: $e'));
      }
    });

    on<UpdateEmployee>((event, emit) async {
      try {
        await _hiveRepository.updateEmployee(event.employee);
        final empList = _hiveRepository.getAllEmployee();
        emit(DataLoaded(empList));
      } catch (e) {
        emit(LoadError('Failed to update task: $e'));
      }
    });

    on<DeleteEmployee>((event, emit) async {
      try {
        await _hiveRepository.deleteEmployee(event.id);
        final empList = _hiveRepository.getAllEmployee();
        emit(DataLoaded(empList));
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
  }
}
