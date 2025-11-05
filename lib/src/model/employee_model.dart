import 'package:freezed_annotation/freezed_annotation.dart';
part 'employee_model.freezed.dart';
// part 'employee_model.g.dart';

@freezed
class EmployeeModel with _$EmployeeModel {
  @override
  final String id;
  @override
  final String name;
  @override
  final String role;
  @override
  final String duration;

  EmployeeModel({
    required this.id,
    required this.name,
    required this.role,
    required this.duration,
  });
}