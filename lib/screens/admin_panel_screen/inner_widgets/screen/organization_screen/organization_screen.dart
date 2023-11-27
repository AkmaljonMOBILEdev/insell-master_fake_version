import 'dart:convert';

import 'package:easy_sell/constants/colors.dart';
import 'package:easy_sell/database/model/organization_dto.dart';
import 'package:easy_sell/screens/admin_panel_screen/inner_widgets/screen/organization_screen/widget/organization_edit.dart';
import 'package:easy_sell/screens/admin_panel_screen/inner_widgets/screen/organization_screen/widget/organization_item.dart';
import 'package:easy_sell/services/https_services.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

import '../../../../../widgets/app_button.dart';

class OrganizationScreen extends StatefulWidget {
  const OrganizationScreen({super.key});

  @override
  State<OrganizationScreen> createState() => _OrganizationScreenState();
}

class _OrganizationScreenState extends State<OrganizationScreen> {
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
                showDialog(context: context, builder: (context) => OrganizationEditButton(reload: setState));
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
                future: HttpServices.get("/organization/all"),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var response = snapshot.data;
                    var json = jsonDecode(response?.body ?? '')['data'];
                    List<OrganizationDto> organizations = [];
                    for (var item in json) {
                      organizations.add(OrganizationDto.fromJson(item));
                    }
                    return ListView.builder(
                      itemCount: organizations.length,
                      itemBuilder: (context, index) {
                        OrganizationDto organization = organizations[index];
                        return OrganizationItem(
                          organization: organization,
                          reload: setState,
                        );
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
