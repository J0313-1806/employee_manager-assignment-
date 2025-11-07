import 'package:employee_manager/src/bloc/crud/crud_bloc.dart';
import 'package:employee_manager/src/bloc/sheet_select/sheet_select.dart';
import 'package:employee_manager/src/data/hive_repo.dart';
import 'package:employee_manager/src/model/employee_model.dart';
import 'package:employee_manager/src/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

final HiveRepository hiveRepository = HiveRepository();
void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(EmployeeModelAdapter());

  await Hive.openBox<EmployeeModel>('employees');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => HiveRepository(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Employee Manager',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: MultiBlocProvider(
          providers: [
            BlocProvider<CrudBloc>(
              create: (context) =>
                  CrudBloc()..add(LoadEmployees()),
            ),
            BlocProvider<SelectionCubit>(create: (context) => SelectionCubit()),
          ],
          child: const HomeScreen(),
        ),
      ),
    );
  }
}
