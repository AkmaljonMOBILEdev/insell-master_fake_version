import 'package:easy_sell/database/my_database.dart';
import 'package:easy_sell/services/auto_sync.dart';
import 'package:easy_sell/widgets/app_autocomplete.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/colors.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_dialog.dart';

class CategoryParentDialog extends StatefulWidget {
  const CategoryParentDialog({super.key, required this.callback, this.category});

  final CategoryData? category;
  final Future Function(CategoryData?) callback;

  @override
  State<CategoryParentDialog> createState() => _CategoryParentDialogState();
}

class _CategoryParentDialogState extends State<CategoryParentDialog> {
  CategoryData? selectedCategory;

  @override
  void initState() {
    super.initState();
    getCategoryList();
  }

  List<CategoryData> categoryList = [];

  void getCategoryList() async {
    categoryList = await database.categoryDao.getAllCategories();
    setState(() {});
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
          width: 150,
          height: 100,
          child: Column(children: [
            AppAutoComplete(
              getValue: (value) {
                selectedCategory = categoryList.firstWhereOrNull((element) => element.id == value.uniqueId);
                setState(() {});
              },
              options: categoryList
                  .map((e) => AutocompleteDataStruct(
                        uniqueId: e.id,
                        value: e.name,
                      ))
                  .toList(),
              hintText: 'Ota Kategoriyani tanlang',
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
                  await widget.callback(selectedCategory);
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
