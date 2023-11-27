import 'package:easy_sell/services/https_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:unicons/unicons.dart';
import '../../../../constants/colors.dart';
import '../../../../database/my_database.dart';
import '../../../../utils/utils.dart';
import '../../../../utils/validator.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_input_underline.dart';

class SupplierOrganizationRightContainers extends StatefulWidget {
  const SupplierOrganizationRightContainers({Key? key, required this.callback, required this.allSuppliersLength})
      : super(key: key);
  final VoidCallback callback;
  final int allSuppliersLength;

  @override
  State<SupplierOrganizationRightContainers> createState() => _SupplierOrganizationRightContainersState();
}

class _SupplierOrganizationRightContainersState extends State<SupplierOrganizationRightContainers> {
  MyDatabase database = Get.find<MyDatabase>();
  final _formValidation = GlobalKey<FormState>();
  bool _showAddSupplier = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumber1Controller = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  void createNewSupplierOrganization() async {
    try {
      var request = {
        "name": _nameController.text,
        "address": _addressController.text,
        "phoneNumber": _phoneNumber1Controller.text,
      };
      var res = await HttpServices.post("/supplier-organization/create", request);
      if (res.statusCode == 200 || res.statusCode == 201) {
        showAppSnackBar(context, "Muvaffaqiyatli qo'shildi", "OK");
      } else {
        throw res.body;
      }
      widget.callback();
      _clearFields();
      setState(() {
        _showAddSupplier = false;
      });
    } catch (e) {
      if (context.mounted) {
        showAppSnackBar(context, "Xatolik yuz berdi:$e", "OK", isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _showAddSupplier
              ? AnimatedContainer(
                  height: _showAddSupplier == true ? screenHeight / 1.12 : screenHeight / 1.573,
                  width: screenWidth / 3.99,
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: AppColors.appColorBlackBg),
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.fastOutSlowIn,
                  child: Form(
                    key: _formValidation,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                _showAddSupplier = false;
                              });
                            },
                            icon: Icon(Icons.highlight_off_rounded, color: AppColors.appColorRed400, size: 30),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Text(
                            "Organizatsiya malumotlarini kiriting",
                            style: TextStyle(color: AppColors.appColorWhite, fontSize: 20),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 9,
                              child: AppInputUnderline(
                                hintText: 'Organizatsiya nomi',
                                controller: _nameController,
                                validator: AppValidator().nameValidate,
                                hintTextColor: AppColors.appColorGrey400,
                                prefixIcon: Icons.drive_file_rename_outline,
                                iconSize: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        AppInputUnderline(
                          hintText: 'Telefon raqami',
                          controller: _phoneNumber1Controller,
                          validator: AppValidator().numberValidate,
                          inputFormatters: [
                            MaskTextInputFormatter(
                              mask: '+### (##) ###-##-##',
                              filter: {"#": RegExp(r'[0-9]')},
                              type: MaskAutoCompletionType.lazy,
                            )
                          ],
                          hintTextColor: AppColors.appColorGrey400,
                          prefixIcon: UniconsLine.phone,
                          iconSize: 20,
                        ),
                        const SizedBox(height: 5),
                        AppInputUnderline(
                          hintText: "Manzil",
                          controller: _addressController,
                          maxLines: 2,
                          hintTextColor: AppColors.appColorGrey400,
                          prefixIcon: UniconsLine.building,
                          iconSize: 20,
                          iconColor: AppColors.appColorWhite,
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            AppButton(
                              onTap: () => _clearFields(),
                              height: 40,
                              width: 40,
                              borderRadius: BorderRadius.circular(15),
                              hoverRadius: BorderRadius.circular(15),
                              child: Center(
                                child: Icon(Icons.cleaning_services_rounded, color: AppColors.appColorWhite),
                              ),
                            ),
                            AppButton(
                              tooltip: '',
                              onTap: createNewSupplierOrganization,
                              width: 180,
                              height: 40,
                              color: AppColors.appColorGreen400,
                              hoverColor: AppColors.appColorGreen300,
                              colorOnClick: AppColors.appColorGreen700,
                              splashColor: AppColors.appColorGreen700,
                              borderRadius: BorderRadius.circular(15),
                              hoverRadius: BorderRadius.circular(15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Saqlash',
                                    style: TextStyle(
                                        color: AppColors.appColorWhite,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        letterSpacing: 1),
                                  ),
                                  Icon(UniconsLine.save, color: AppColors.appColorWhite, size: 18)
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                )
              : AppButton(
                  onTap: () {
                    setState(() {
                      _showAddSupplier = true;
                    });
                  },
                  width: screenWidth / 3.99,
                  height: screenHeight / 1.573,
                  borderRadius: BorderRadius.circular(20),
                  hoverRadius: BorderRadius.circular(20),
                  color: AppColors.appColorBlackBg,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_rounded, color: AppColors.appColorGreen400, size: 30),
                        ],
                      ),
                      Text("Organizatsiya qo'shish", style: TextStyle(color: AppColors.appColorWhite, fontSize: 22))
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  void _clearFields() {
    _nameController.clear();
    _phoneNumber1Controller.clear();
    _addressController.clear();
  }
}
