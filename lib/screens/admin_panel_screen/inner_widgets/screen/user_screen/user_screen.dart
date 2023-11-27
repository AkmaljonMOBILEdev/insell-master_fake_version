import 'dart:convert';

import 'package:easy_sell/constants/colors.dart';
import 'package:easy_sell/database/model/user_dto.dart';
import 'package:easy_sell/screens/admin_panel_screen/inner_widgets/screen/user_screen/widgets/user_edit.dart';
import 'package:easy_sell/screens/admin_panel_screen/inner_widgets/screen/user_screen/widgets/user_item.dart';
import 'package:easy_sell/services/https_services.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

import '../../../../../widgets/app_button.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
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
              showDialog(context: context, builder: (context) => UserEditButton(reload: setState));
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
            future: HttpServices.get("/user/all"),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var response = snapshot.data;
                var json = jsonDecode(response?.body ?? '')['data'];
                List<UserDto> users = [];
                for (var item in json) {
                  users.add(UserDto.fromJson(item));
                }
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    UserDto user = users[index];
                    return UserItem(
                      user: user,
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
