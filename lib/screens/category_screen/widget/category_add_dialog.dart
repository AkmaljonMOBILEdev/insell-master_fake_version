import 'package:easy_sell/database/my_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';

import '../../../constants/colors.dart';
import '../../../utils/validator.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_dialog.dart';
import '../../../widgets/app_input_underline.dart';

class CategoryAddDialog extends StatefulWidget {
  const CategoryAddDialog({super.key, required this.callback, this.category});

  final CategoryData? category;
  final Future Function(String name, String description, String code) callback;

  @override
  State<CategoryAddDialog> createState() => _CategoryAddDialogState();
}

class _CategoryAddDialogState extends State<CategoryAddDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initCategory();
  }

  void initCategory() {
    if (widget.category != null) {
      _nameController.text = widget.category?.name ?? '';
      _codeController.text = widget.category?.code ?? '';
      _descriptionController.text = widget.category?.description ?? '';
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
        Text('Kategoriya qo\'shish', style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
      ]),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 350,
          height: 250,
          child: Column(children: [
            AppInputUnderline(
              controller: _nameController,
              hintText: 'Kategoriya nomi',
              prefixIcon: UniconsLine.wrap_text,
              validator: AppValidator().namedValidate,
            ),
            const SizedBox(height: 5),
            AppInputUnderline(
              controller: _codeController,
              hintText: 'Kategoriya kodi',
              prefixIcon: UniconsLine.code_branch,
              validator: AppValidator().validate,
            ),
            const SizedBox(height: 5),
            AppInputUnderline(
              maxLines: 3,
              controller: _descriptionController,
              hintText: 'Izoh',
              prefixIcon: UniconsLine.comment_alt,
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
                  await widget.callback(_nameController.text, _descriptionController.text, _codeController.text);
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
