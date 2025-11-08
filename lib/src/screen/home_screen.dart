// ignore_for_file: avoid_print

import 'package:employee_manager/src/bloc/crud/crud_bloc.dart';
import 'package:employee_manager/src/model/employee_model.dart';
import 'package:employee_manager/src/screen/form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Employee Manager')),
      body: BlocConsumer<CrudBloc, CrudState>(
        listener: (context, state) {
          if (state is DataLoaded) {
            print('Data loaded: ${state.employees.length} employees');
          }
          if (state is DataLoading) {
            print('Loading data...');
          }
        },
        buildWhen: (previous, current) => current is DataLoaded,

        builder: (context, state) {
          if (state is DataLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DataLoaded) {
            if (state.employees.isEmpty) {
              return Center(child: Text('No Employees yet. Add one!'));
            }

            var employees = state.employees;
            var previousEmp = employees.where((e) => !e.active).toList();
            var currentEmp = employees.where((e) => e.active).toList();

            return Container(
              // color: Colors.deepPurple.shade50,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (currentEmp.isNotEmpty) ...[
                    displayTitle('Current Employees'),
                    employeeListWidget(
                      currentEmp,
                      title: 'Current Employees',
                      context: context,
                    ),
                  ],

                  if (previousEmp.isNotEmpty) ...[
                    displayTitle('Previous Employees'),
                    employeeListWidget(
                      previousEmp,
                      title: 'Previous Employees',
                      context: context,
                    ),
                  ],
                  Container(
                    padding: const EdgeInsets.all(15),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Swipe to delete',
                      style: TextStyle(color: Colors.deepPurple.shade400),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is LoadError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('No Employees yet. Add one!'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) =>
                  const FormScreen(titleText: 'Add Employee Details'),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget employeeListWidget(
    List<EmployeeModel> employees, {
    required String title,
    required BuildContext context,
  }) {
    final double height = MediaQuery.of(context).size.height;
    return Container(
      color: Colors.white,
      height: height / 2.8,
      width: double.infinity,
      child: ListView.separated(
        key: Key('$title list'),
        physics: const BouncingScrollPhysics(),
        itemCount: employees.length,
        itemBuilder: (context, index) {
          final employee = employees[index];
          return Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text('Employee data has been deleted'),
                    backgroundColor: Colors.black,
                    duration: const Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'Undo',
                      textColor: Colors.white,
                      onPressed: () {
                        setState(() {
                          employees.insert(index, employee);
                        });
                      },
                    ),
                  ),
                ).closed.then((reason) {
                  // Only delete if snackbar timed out (not undone)
                  if (reason == SnackBarClosedReason.timeout) {
                    context.read<CrudBloc>().add(DeleteEmployee(employee.id));
                  }
                });
            },
            background: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              color: Colors.red,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.delete_outline, color: Colors.white),
                  Icon(Icons.delete_outline, color: Colors.white),
                ],
              ),
            ),
            child: ListTile(
              key: Key('$title $index'),
              title: Text(employee.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(employee.role),
                  const SizedBox(height: 4),
                  Text('${employee.startDate} - ${employee.endDate}'),
                ],
              ),
              
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => FormScreen(
                      titleText: 'Edit Employee Details',
                      employeeModel: employee,
                    ),
                  ),
                );
              },
            ),
          );
        }, separatorBuilder: (BuildContext context, int index) { 
          return Divider(color: Colors.purple.shade50,);
         },
      ),
    );
  }

  Container displayTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14.0),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.deepPurple.shade400,
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
        ),
      ),
    );
  }
}
