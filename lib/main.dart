import 'package:employee_manager/src/bloc/crud_bloc.dart';
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
      title: 'Todo CRUD BLoC',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BlocProvider(
        create: (context) => CrudBloc(),//..add(LoadTodos()
        child: const HomeScreen(),
      ),
    );
  }
}
