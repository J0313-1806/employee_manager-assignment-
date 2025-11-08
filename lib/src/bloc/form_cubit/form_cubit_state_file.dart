import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FormScreenState extends Equatable {
  final String name;
  final String position;
  final String startDate;
  final String endDate;
  const FormScreenState({
    this.name = 'Name',
    this.position = 'Position',
    this.startDate = 'Start Date',
    this.endDate = 'End Date',
  });

  FormScreenState copyWith({
    String? name,
    String? position,
    String? startDate,
    String? endDate,
  }) {
    return FormScreenState(
      name: name ?? this.name,
      position: position ?? this.position,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  @override
  List<Object?> get props => [name, position, startDate, endDate];
}

class FormCubit extends Cubit<FormScreenState> {
  FormCubit() : super(FormScreenState());

  void nameField(String value) {
    emit(state.copyWith(name: value));
  }

  void selectOption(String value) {
    emit(state.copyWith(position: value));
  }

  void startDate(String value) {
    emit(state.copyWith(startDate: value));
  }

  void endDate(String value) {
    emit(state.copyWith(endDate: value));
  }
}
