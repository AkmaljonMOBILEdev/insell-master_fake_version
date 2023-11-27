import 'package:easy_sell/database/my_database.dart';
import 'package:easy_sell/database/table/region_table.dart';
import 'package:easy_sell/widgets/app_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';

import '../../../../../../constants/colors.dart';
import '../../../../../../utils/validator.dart';
import '../../../../../../widgets/app_button.dart';
import '../../../../../../widgets/app_dialog.dart';
import '../../../../../../widgets/app_input_underline.dart';

class AddRegionDialog extends StatefulWidget {
  const AddRegionDialog({super.key, required this.callback, this.region});

  final RegionData? region;
  final Future Function(String name, String code, RegionType type) callback;

  @override
  State<AddRegionDialog> createState() => _AddRegionDialogState();
}

class _AddRegionDialogState extends State<AddRegionDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  RegionType? _selectedRegionType;

  @override
  void initState() {
    super.initState();
    initCategory();
  }

  void initCategory() {
    if (widget.region != null) {
      _nameController.text = widget.region?.name ?? '';
      _codeController.text = widget.region?.code ?? '';
      _selectedRegionType = widget.region?.type;
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      backgroundColor: Colors.black.withOpacity(0.9),
      title: Column(children: [
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.highlight_off_rounded, color: AppColors.appColorRed400, size: 25),
          ),
        ),
        const SizedBox(height: 10),
        Text('Region qo\'shish', style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
      ]),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 350,
          height: 250,
          child: Column(children: [
            AppInputUnderline(
              controller: _nameController,
              hintText: 'Region nomi',
              prefixIcon: UniconsLine.wrap_text,
              validator: AppValidator().namedValidate,
            ),
            const SizedBox(height: 5),
            AppInputUnderline(
              controller: _codeController,
              hintText: 'Region kodi',
              prefixIcon: UniconsLine.code_branch,
              validator: AppValidator().validate,
            ),
            const SizedBox(height: 5),
            AppDropDown(
              selectedValue: _selectedRegionType?.name,
              dropDownItems: RegionType.values.map((e) => e.name).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedRegionType = RegionType.fromString(value);
                });
              },
              icon: Icon(UniconsLine.location_point, color: AppColors.appColorWhite),
            ),
          ]),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AppButton(
              tooltip: '',
              onTap: () async {
                if (_formKey.currentState!.validate()) {
                  await widget.callback(_nameController.text, _codeController.text, _selectedRegionType ?? RegionType.CITY);
                }
              },
              width: 250,
              height: 40,
              color: AppColors.appColorGreen400,
              hoverColor: AppColors.appColorGreen300,
              colorOnClick: AppColors.appColorGreen700,
              splashColor: AppColors.appColorGreen700,
              borderRadius: BorderRadius.circular(12),
              hoverRadius: BorderRadius.circular(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Saqlash',
                    style: TextStyle(color: AppColors.appColorWhite, fontWeight: FontWeight.w500, fontSize: 16, letterSpacing: 1),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
