import 'package:employee_manager/src/bloc/crud/crud_bloc.dart';
import 'package:employee_manager/src/bloc/form_cubit/form_cubit_state_file.dart';
import 'package:employee_manager/src/model/employee_model.dart';
import 'package:employee_manager/src/widget/bottom_select.dart';
import 'package:employee_manager/src/widget/calender_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key, this.employeeModel});

  final EmployeeModel? employeeModel;

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {

  late final TextEditingController _nameController;

   @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employeeModel?.name ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<CrudBloc>(),
      child: BlocProvider<FormCubit>(
        create: (_) => FormCubit()
          ..nameField(widget.employeeModel?.name ?? '')
          ..startDate(widget.employeeModel?.startDate ?? 'Start Date')
          ..endDate(widget.employeeModel?.endDate ?? 'End Date')
          ..selectOption(widget.employeeModel?.role ?? 'Select Position'),
        child: BlocConsumer<CrudBloc, CrudState>(
          listener: (context, state) {},
          buildWhen: (previous, current) => current is DataLoaded,
          builder: (context, state) {
            return BlocConsumer<FormCubit, FormScreenState>(
              listener: (context, state) {},
              builder: (context, state) {
                return Scaffold(
                  resizeToAvoidBottomInset: true,
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
                        focusNode: FocusNode(),
                        controller: _nameController,
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
                            context.read<FormCubit>().nameField(value),
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

                  bottomNavigationBar: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0.0, 10.0, 16.0, 12.0),
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
                              style: TextStyle(
                                color: Colors.deepPurple.shade400,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          ElevatedButton(
                            onPressed: () {
                              final formState = context.read<FormCubit>().state;
                              if (formState.name.isEmpty ||
                                  formState.position == 'Select Position' ||
                                  formState.startDate.contains('Start')) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please fill all required fields',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              final isActive = !formState.endDate.contains('2')
                                  ? true
                                  : !DateFormat('dd MMM yyyy')
                                        .parseStrict(formState.endDate)
                                        .isBefore(DateTime.now());

                              final employee = EmployeeModel(
                                id:
                                    widget.employeeModel?.id ??
                                    DateTime.now().millisecondsSinceEpoch
                                        .toString(),
                                name: formState.name.isEmpty
                                    ? widget.employeeModel!.name
                                    : formState.name,
                                role: formState.position == 'Select Position'
                                    ? widget.employeeModel?.role ?? ''
                                    : formState.position,
                                startDate: formState.startDate.contains('Start')
                                    ? widget.employeeModel!.startDate
                                    : formState.startDate,
                                endDate: formState.endDate.contains('End')
                                    ? widget.employeeModel?.endDate ?? ''
                                    : formState.endDate,
                                active: isActive,
                              );

                              if (widget.employeeModel == null) {
                                // Add new employee
                                context.read<CrudBloc>().add(
                                  AddEmployee(employee),
                                );
                              } else {
                                // Update existing employee
                                context.read<CrudBloc>().add(
                                  UpdateEmployee(employee),
                                );
                              }
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
    FormScreenState state,
    bool isStart,
  ) {

    final displayDate = isStart
      ? (state.startDate != 'Start Date' 
          ? state.startDate 
          : widget.employeeModel?.startDate ?? 'Start Date')
      : (state.endDate != 'End Date'
          ? state.endDate
          : widget.employeeModel?.endDate ?? 'End Date');

    return InkWell(
      onTap: () {
        if (state.startDate.contains('S') && !isStart) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text('Select Start Date first!'),
                backgroundColor: Colors.black,
                duration: const Duration(seconds: 2),
              ),
            );
        } else {
          showCustomDatePicker(
            context: context,
            isStart: isStart,
            initialDate: DateTime.now(),
            startDate: !isStart && !state.startDate.contains('S')
                ? DateFormat('dd MMM yyyy').parseStrict(state.startDate)
                : null,
            onSave: (newDate) {
              if (isStart) {
                context.read<FormCubit>().startDate(
                  DateFormat('dd MMM yyyy').format(newDate),
                );
              } else {
                newDate != null
                    ? context.read<FormCubit>().endDate(
                        DateFormat('dd MMM yyyy').format(newDate),
                      )
                    : context.read<FormCubit>().endDate('End Date');
              }
            },
          );
        }
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
              displayDate,
              style: const TextStyle(color: Colors.black),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget postionSelector(BuildContext context, FormScreenState state) {
    return InkWell(
      onTap: () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
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
