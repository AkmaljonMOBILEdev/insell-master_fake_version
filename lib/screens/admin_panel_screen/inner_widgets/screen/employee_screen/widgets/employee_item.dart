import 'package:easy_sell/database/model/employee_dto.dart';
import 'package:easy_sell/widgets/app_table_item.dart';
import 'package:flutter/material.dart';

import 'employee_edit.dart';

class EmployeeItem extends StatefulWidget {
  const EmployeeItem({super.key, required this.reload, required this.employee});

  final EmployeeDto employee;
  final void Function(VoidCallback fn) reload;

  @override
  State<EmployeeItem> createState() => _EmployeeItemState();
}

class _EmployeeItemState extends State<EmployeeItem> {
  @override
  Widget build(BuildContext context) {
    return AppTableItems(
      hideBorder: false,
      height: 50,
      items: [
        AppTableItemStruct(
          innerWidget: Center(child: Text(widget.employee.name, style: const TextStyle(color: Colors.white, fontSize: 16))),
        ),
        AppTableItemStruct(
          innerWidget:
              Center(child: Text(widget.employee.cardNumber ?? '', style: const TextStyle(color: Colors.white, fontSize: 16))),
        ),
        AppTableItemStruct(
          innerWidget:
              Center(child: Text(widget.employee.phoneNumber ?? '', style: const TextStyle(color: Colors.white, fontSize: 16))),
        ),
        AppTableItemStruct(
          // edit
          innerWidget: IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => EmployeeEditButton(
                  employee: widget.employee,
                  reload: widget.reload,
                ),
              );
            },
            icon: const Icon(Icons.edit, color: Colors.white),
            iconSize: 18,
          ),
        ),
      ],
    );
  }
}
