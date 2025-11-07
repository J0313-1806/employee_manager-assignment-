import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectionState extends Equatable {
  final String name;
  final String position;
  final String startDate;
  final String endDate;
  const SelectionState({
    this.name = 'Name',
    this.position = 'Position',
    this.startDate = 'Start Date',
    this.endDate = 'End Date',
  });

  SelectionState copyWith({
    String? name,
    String? position,
    String? startDate,
    String? endDate,
  }) {
    return SelectionState(
      name: name ?? this.name,
      position: position ?? this.position,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  @override
  List<Object?> get props => [name, position, startDate, endDate];
}

class SelectionCubit extends Cubit<SelectionState> {
  SelectionCubit() : super(SelectionState());

  void nameField(String value) {
    emit(state.copyWith(name: value));
  }

  void selectOption(String value) {
    emit(state.copyWith(position: value));
  }

  void startDate(String value) {
    print(value);
    emit(state.copyWith(startDate: value));
  }

  void endDate(String value) {
    emit(state.copyWith(endDate: value));
  }
}
