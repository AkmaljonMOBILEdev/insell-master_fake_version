import 'dart:convert';

import 'package:easy_sell/constants/colors.dart';
import 'package:easy_sell/database/model/pos_dto.dart';
import 'package:easy_sell/screens/admin_panel_screen/inner_widgets/screen/pos_screen/widgets/pos_edit.dart';
import 'package:easy_sell/screens/admin_panel_screen/inner_widgets/screen/pos_screen/widgets/pos_item.dart';
import 'package:easy_sell/services/https_services.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

import '../../../../../widgets/app_button.dart';

class PosScreen extends StatefulWidget {
  const PosScreen({super.key});

  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
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
              showDialog(context: context, builder: (context) => PosEditButton(reload: setState));
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
            future: HttpServices.get("/pos/all"),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var response = snapshot.data;
                var json = jsonDecode(response?.body ?? '')['data'];
                List<PosDto> pos_s = [];
                for (var item in json) {
                  pos_s.add(PosDto.fromJson(item));
                }
                return ListView.builder(
                  itemCount: pos_s.length,
                  itemBuilder: (context, index) {
                    PosDto pos = pos_s[index];
                    return PosItem(
                      pos: pos,
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
