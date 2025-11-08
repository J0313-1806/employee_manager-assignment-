import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
part 'employee_model.freezed.dart';
part 'employee_model.g.dart';

@freezed
@HiveType(typeId: 0)
class EmployeeModel extends HiveObject with _$EmployeeModel {
  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String name;
  @override
  @HiveField(2)
  final String role;
  @override
  @HiveField(3)
  final String startDate;
  @override
  @HiveField(4)
  final String endDate;
  @override
  @HiveField(5)
  final bool active;

  EmployeeModel({
    required this.id,
    required this.name,
    required this.role,
    required this.startDate,
    required this.endDate,
    required this.active,
  });
}
