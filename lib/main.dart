import 'package:employee_manager/src/bloc/crud/crud_bloc.dart';
import 'package:employee_manager/src/bloc/sheet_select/sheet_select.dart';
import 'package:employee_manager/src/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Employee Manager',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<CrudBloc>(
            create: (context) => CrudBloc()..add(LoadEmployees()),
          ),
          BlocProvider<SelectionCubit>(
            create: (context) => SelectionCubit(),
          ),
        ],
        child: const HomeScreen(),
      ),
    );
  }
}
