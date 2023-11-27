import 'dart:convert';
import 'package:easy_sell/constants/colors.dart';
import 'package:easy_sell/database/model/shop_dto.dart';
import 'package:easy_sell/utils/utils.dart';
import 'package:easy_sell/widgets/app_autocomplete.dart';
import 'package:easy_sell/widgets/app_dropdown.dart';
import 'package:easy_sell/widgets/app_input_underline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../../../../../database/model/organization_dto.dart';
import '../../../../../../services/https_services.dart';
import '../../../../../../widgets/app_button.dart';
import 'package:http/http.dart' as http;

class OrganizationEditButton extends StatefulWidget {
  const OrganizationEditButton({super.key, this.organization, required this.reload});

  final OrganizationDto? organization;
  final void Function(VoidCallback fn) reload;

  @override
  State<OrganizationEditButton> createState() => _OrganizationEditButtonState();
}

class _OrganizationEditButtonState extends State<OrganizationEditButton> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  OrganizationType? _selectedShopType;

  @override
  void initState() {
    super.initState();
    if (widget.organization != null) {
      _nameController.text = widget.organization?.name ?? '';
      _addressController.text = widget.organization?.address ?? '';
      _phoneNumberController.text = widget.organization?.phoneNumber ?? '';
      _selectedShopType = widget.organization!.type;
    }
  }

  void createOrUpdateOrganization() async {
    try {
      var request = {
        'name': _nameController.text,
        'phoneNumber': _phoneNumberController.text,
        'address': _addressController.text,
        'type': _selectedShopType?.name,
      };
      http.Response response;
      if (widget.organization != null) {
        response = await HttpServices.put('/organization/${widget.organization!.id}', request);
      } else {
        response = await HttpServices.post('/organization/create', request);
      }
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(response.body);
      }
      Get.back();
      widget.reload(() {});
    } catch (e) {
      showAppAlertDialog(context, title: 'Xatolik', message: e.toString(), cancelLabel: 'Ok', buttonLabel: 'OK');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.appColorBlackBg,
      title: const Text('Organizatsiyani tahrirlash', style: TextStyle(color: Colors.white)),
      content: SizedBox(
        width: 300,
        height: 350,
        child: Column(
          children: [
            AppInputUnderline(
              hintText: 'Organizatsiya nomi',
              controller: _nameController,
              prefixIcon: (Icons.work_rounded),
            ),
            const SizedBox(height: 10),
            AppInputUnderline(
              hintText: 'Organizatsiya Addressi',
              controller: _addressController,
              prefixIcon: (Icons.edit_note_outlined),
            ),
            const SizedBox(height: 10),
            AppInputUnderline(
              hintText: 'Organizatsiya telefon raqami',
              controller: _phoneNumberController,
              prefixIcon: (Icons.phone),
              inputFormatters: [
                MaskTextInputFormatter(
                  mask: '+998 (##) ###-##-##',
                  filter: {"#": RegExp(r'[0-9]')},
                )
              ],
            ),
            const SizedBox(height: 10),
            AppDropDown(
              selectedValue: _selectedShopType?.name,
              dropDownItems: OrganizationType.values.map((e) => e.name).toList(),
              onChanged: (value) {
                _selectedShopType = OrganizationType.fromStr(value);
              },
            ),

            const Spacer(),
            AppButton(
              onTap: createOrUpdateOrganization,
              width: 300,
              height: 40,
              color: AppColors.appColorGreen400,
              borderRadius: BorderRadius.circular(10),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Saqlash', style: TextStyle(color: Colors.white, fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
