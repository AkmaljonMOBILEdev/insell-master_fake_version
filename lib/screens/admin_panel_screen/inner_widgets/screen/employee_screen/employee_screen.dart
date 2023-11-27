import 'dart:convert';

import 'package:easy_sell/constants/colors.dart';
import 'package:easy_sell/database/model/employee_dto.dart';
import 'package:easy_sell/screens/admin_panel_screen/inner_widgets/screen/employee_screen/widgets/employee_edit.dart';
import 'package:easy_sell/screens/admin_panel_screen/inner_widgets/screen/employee_screen/widgets/employee_item.dart';
import 'package:easy_sell/services/https_services.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

import '../../../../../widgets/app_button.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppButton(
            onTap: () async {
              showDialog(context: context, builder: (context) => EmployeeEditButton(reload: setState));
            },
            width: 150,
            height: 40,
            color: AppColors.appColorGreen400,
            borderRadius: BorderRadius.circular(10),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(UniconsLine.plus, color: Colors.white, size: 20),
                SizedBox(width: 10),
                Text('Qo\'shish', style: TextStyle(color: Colors.white, fontSize: 16)),
              ],
            ),
          ),
          Expanded(
              child: FutureBuilder(
            future: HttpServices.get("/employee/all"),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var response = snapshot.data;
                var json = jsonDecode(response?.body ?? '')['data'];
                List<EmployeeDto> employees = [];
                for (var item in json) {
                  employees.add(EmployeeDto.fromJson(item));
                }
                return ListView.builder(
                  itemCount: employees.length,
                  itemBuilder: (context, index) {
                    EmployeeDto employee = employees[index];
                    return EmployeeItem(
                      employee: employee,
                      reload: setState,
                    );
                  },
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          )),
        ],
      ),
    ));
  }
}
