import 'package:employee_manager/src/bloc/crud/crud_bloc.dart';
import 'package:employee_manager/src/bloc/form_cubit/form_cubit_state_file.dart';
import 'package:employee_manager/src/data/hive_repo.dart';
import 'package:employee_manager/src/model/employee_model.dart';
import 'package:employee_manager/src/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

// final HiveRepository hiveRepository = HiveRepository();
void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(EmployeeModelAdapter());

  final employeeBox = await Hive.openBox<EmployeeModel>('employees');

  final hiveRepo = HiveRepository(box: employeeBox);

  runApp(
    RepositoryProvider.value(
      value: hiveRepo,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<CrudBloc>(
            create: (context) =>
                CrudBloc(hiveRepository: context.read<HiveRepository>())
                  ..add(LoadEmployees()),
          ),
          BlocProvider<FormCubit>(create: (context) => FormCubit()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Employee Manager',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}
