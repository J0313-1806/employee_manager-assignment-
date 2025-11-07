import 'package:employee_manager/src/bloc/crud/crud_bloc.dart';
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
        bloc: CrudBloc(),
        listener: (context, state) => {},
        builder: (context, state) {
          if (state is DataLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is DataLoaded) {
            if (state.employees.isEmpty) {
              return Center(child: Text('No Employees yet. Add one!'));
            }
            final employees = state.employees;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14.0),
                  decoration: BoxDecoration(color: Colors.grey.shade300),
                  child: Text(
                    'Current Employees',
                    style: TextStyle(
                      color: Colors.deepPurple.shade400,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                ListView.builder(
                  key: const Key('c_e_list'),
                  shrinkWrap: true,
                  itemCount: employees.length,
                  itemBuilder: (context, index) {
                    final employee = employees[index];
                    return Dismissible(
                      key: const Key('current_employees_list'),
                      background: Container(
                        color: Colors.red,
                        child: Icon(Icons.delete_outline, color: Colors.white),
                      ),
                      child: ListTile(
                        key: Key('ce$index'),
                        title: Text('employee.name'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('employee.position'),
                            const SizedBox(height: 4),
                            Text('date'),
                          ],
                        ),
                        shape: Border(
                          top: BorderSide(color: Colors.grey.shade300),
                          bottom: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          }
          return Center(child: Text('Press + to add an Employee'));
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
}
