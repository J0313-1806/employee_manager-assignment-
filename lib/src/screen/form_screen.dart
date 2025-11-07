import 'package:employee_manager/src/bloc/crud/crud_bloc.dart';
import 'package:employee_manager/src/bloc/sheet_select/sheet_select.dart';
import 'package:employee_manager/src/model/employee_model.dart';
import 'package:employee_manager/src/widget/bottom_select.dart';
import 'package:employee_manager/src/widget/calender_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class FormScreen extends StatelessWidget {
  const FormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (crudContext) => CrudBloc(),
      child: BlocProvider<SelectionCubit>(
        create: (_) => SelectionCubit(),
        child: BlocConsumer<CrudBloc, CrudState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            return BlocConsumer<SelectionCubit, SelectionState>(
              listener: (context, state) {
                // _positionController.text = state.selectedValue;
                // state.startDate;
                // state.endDate;
              },
              builder: (context, state) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text('Add Employee Details'),
                    actions: [
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          Hive.box<EmployeeModel>('employees').clear();
                        },
                      ),
                    ],
                  ),
                  body: ListView(
                    padding: EdgeInsets.all(16.0),
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Name',
                          prefixIcon: Icon(Icons.person_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        onChanged: (value) =>
                            context.read<SelectionCubit>().nameField(value),
                      ),
                      SizedBox(height: 20),
                      postionSelector(context, state),
                      SizedBox(height: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            dateSelector(context, state, true),
                            Icon(Icons.arrow_forward_rounded),
                            dateSelector(context, state, false),
                          ],
                        ),
                      ),
                    ],
                  ),

                  bottomNavigationBar: Container(
                    padding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 26.0),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple.shade50,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.deepPurple.shade400),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        ElevatedButton(
                          onPressed: () {
                            context.read<CrudBloc>().add(
                              AddEmployee(
                                EmployeeModel(
                                  id: DateTime.now().millisecondsSinceEpoch
                                      .toString(),
                                  name: context
                                      .read<SelectionCubit>()
                                      .state
                                      .name,
                                  role: context
                                      .read<SelectionCubit>()
                                      .state
                                      .position,
                                  duration:
                                      !context
                                          .read<SelectionCubit>()
                                          .state
                                          .endDate
                                          .contains('2')
                                      ? context
                                            .read<SelectionCubit>()
                                            .state
                                            .startDate
                                      : '${context.read<SelectionCubit>().state.startDate} - ${context.read<SelectionCubit>().state.endDate}',
                                  active:
                                      context
                                          .read<SelectionCubit>()
                                          .state
                                          .endDate
                                          .contains('2')
                                      ? DateFormat('dd MMM yyyy')
                                                .parseStrict(
                                                  context
                                                      .read<SelectionCubit>()
                                                      .state
                                                      .endDate,
                                                )
                                                .isBefore(DateTime.now())
                                            ? false
                                            : true
                                      : true,
                                ),
                              ),
                            );
                            Navigator.pop(context);
                          },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple.shade400,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                          ),
                          child: Text(
                            'Save',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  InkWell dateSelector(
    BuildContext context,
    SelectionState state,
    bool isStart,
  ) {
    return InkWell(
      onTap: () {
        showCustomDatePicker(
          context: context,
          isStart: isStart,
          initialDate: DateTime.now(),
          startDate: !isStart && !state.startDate.contains('S')
              ? DateFormat('dd MMM yyyy').parseStrict(state.startDate)
              : null,
          onSave: (newDate) {
            if (isStart) {
              context.read<SelectionCubit>().startDate(
                DateFormat('dd MMM yyyy').format(newDate),
              );
            } else {
              newDate != null
                  ? context.read<SelectionCubit>().endDate(
                      DateFormat('dd MMM yyyy').format(newDate),
                    )
                  : context.read<SelectionCubit>().endDate('End Date');
            }
          },
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        height: 60,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_month_outlined),
            SizedBox(width: 16.0),
            Text(
              isStart ? state.startDate : state.endDate,
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget postionSelector(BuildContext context, SelectionState state) {
    return InkWell(
      onTap: () {
        bottomSelect(context);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 12.0),
          title: Text(
            state.position,
            style: TextStyle(
              color: state.position == 'Select Position'
                  ? Colors.grey
                  : Colors.black,
            ),
          ),
          leading: Icon(Icons.work_outline),
          trailing: Icon(Icons.arrow_drop_down),
        ),
      ),
    );
  }
}
