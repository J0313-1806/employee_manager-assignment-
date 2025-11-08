// ignore_for_file: avoid_print

import 'package:employee_manager/src/bloc/crud/crud_bloc.dart';
import 'package:employee_manager/src/model/employee_model.dart';
import 'package:employee_manager/src/screen/form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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

            return Column(
              children: [
                currentEmp.isNotEmpty
                    ? employeeListWidget(
                        currentEmp,
                        title: 'Current Employees',
                        context: context,
                      )
                    : SizedBox.shrink(),

                previousEmp.isNotEmpty
                    ? employeeListWidget(
                        previousEmp,
                        title: 'Previous Employees',
                        context: context,
                      )
                    : SizedBox.shrink(),
              ],
            );
          } else if (state is LoadError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('No Employees yet. Add one!'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const FormScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Column employeeListWidget(
    List<EmployeeModel> employees, {
    required String title,
    required BuildContext context,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14.0),
          decoration: BoxDecoration(color: Colors.grey.shade300),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.deepPurple.shade400,
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
        ),
        ListView.builder(
          key: Key('$title list'),
          shrinkWrap: true,
          itemCount: employees.length,
          itemBuilder: (context, index) {
            final employee = employees[index];
            return Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) {
                context.read<CrudBloc>().add(DeleteEmployee(employee.id));
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
                shape: Border(
                  top: BorderSide(color: Colors.grey.shade300),
                  bottom: BorderSide(color: Colors.grey.shade300),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => FormScreen(employeeModel: employee),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
