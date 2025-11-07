import 'package:employee_manager/src/bloc/sheet_select/sheet_select.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<dynamic> bottomSelect(BuildContext context) {
    return showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16.0),
                      ),
                    ),
                    builder: (sheetContext) {
                      return BlocProvider.value(
                        value: context.read<SelectionCubit>(),
                        child: ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          itemCount: 4,
                          separatorBuilder: (context, index) =>
                              Divider(height: 1),
                          itemBuilder: (context, index) {
                            final positions = [
                              'Product Designer',
                              'Flutter Developer',
                              'QA Tester',
                              'Product Owner',
                            ];
                            final position = positions[index];
                            return ListTile(
                              title: Text(position),
                              onTap: () {
                                context.read<SelectionCubit>().selectOption(
                                  position,
                                );

                                Navigator.pop(sheetContext);
                              },
                            );
                          },
                        ),
                      );
                    },
                  );
  }