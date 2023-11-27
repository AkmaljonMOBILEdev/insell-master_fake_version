import 'dart:convert';
import 'dart:ui';
import 'package:easy_sell/database/model/supplier_dto.dart';
import 'package:easy_sell/widgets/app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:unicons/unicons.dart';

import '../../../constants/colors.dart';
import '../../../database/model/supplier_organization_dto.dart';
import '../../../database/my_database.dart';
import '../../../services/https_services.dart';
import '../../../utils/utils.dart';
import '../../../utils/validator.dart';
import '../../../widgets/app_autocomplete.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_input_underline.dart';
import '../../admin_panel_screen/inner_widgets/screen/region_screen/region_widget.dart';
import '../../category_screen/widget/category_side.dart';
import '../../sync_screen/upload_functions.dart';

class AddSupplierDialog extends StatefulWidget {
  const AddSupplierDialog({super.key, required this.callback, this.regionData, this.supplier});

  final SupplierDto? supplier;
  final RegionData? regionData;
  final VoidCallback callback;

  @override
  State<AddSupplierDialog> createState() => _AddSupplierDialogState();
}

class _AddSupplierDialogState extends State<AddSupplierDialog> {
  MyDatabase database = Get.find<MyDatabase>();
  final _formValidation = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _productCategoryController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _phoneNumber1Controller = TextEditingController();
  final TextEditingController _phoneNumber2Controller = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _organizationNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isGender = false;
  RegionData? _regionData;
  int? _segmentId;
  int? _organizationId;
  List segments = [];
  late UploadFunctions uploadFunctions;
  List<CategoryData> productCategories = [];
  CategoryData? selectedCategory;
  List<SegmentDto> _segments = [];
  List<SupplierOrganizationDto> organizations = [];
  List<String> supplierTypes = SupplierType.values.map((e) => e.name).toList();
  String? selectedSupplierType;

  @override
  void initState() {
    super.initState();
    _regionData = widget.regionData;
    uploadFunctions = UploadFunctions(database: database, progress: {}, setter: setter);
    initSegments();
    initOrganizations();
  }

  void initOrganizations() async {
    var res = await HttpServices.get("/supplier-organization/all");
    var jsonData = jsonDecode(res.body);
    List<SupplierOrganizationDto> organizations_ = [];
    for (var item in jsonData['data']) {
      organizations_.add(SupplierOrganizationDto.fromJson(item));
    }
    setState(() {
      organizations = organizations_;
    });
  }

  void initSegments() async {
    var res = await HttpServices.get("/settings/supplier-segment/all");
    var jsonData = jsonDecode(res.body);
    List<SegmentDto> segments_ = [];
    for (var item in jsonData['data']) {
      segments_.add(SegmentDto.fromJson(item));
    }
    setState(() {
      _segments = segments_;
    });
  }

  void setter(void Function() fn) {}

  void createNewSupplier() async {
    if (!_formValidation.currentState!.validate()) return;
    if (_regionData == null) return showAppSnackBar(context, "Regionni tanlang", "OK", isError: true);
    if (_organizationId == null) return showAppSnackBar(context, "Organizatsiya tanlang", "OK", isError: true);
    if (_segmentId == null) return showAppSnackBar(context, "Segmentni tanlang", "OK", isError: true);

    try {
      var request = {
        "name": _nameController.text,
        "address": _addressController.text,
        "phoneNumber": _phoneNumber1Controller.text,
        "regionId": _regionData?.serverId,
        "segmentId": _segmentId,
        "supplierOrganizationId": _organizationId,
        "dateOfBirth": DateFormat('dd-MM-yyyy').parse(_dateController.text).millisecondsSinceEpoch,
        "categoryIds": productCategories.map((e) => e.serverId).toList(),
      };
      var res = await HttpServices.post("/supplier/create", request);
      if (res.statusCode == 200 || res.statusCode == 201) {
        showAppSnackBar(context, "Ta'minotchi muvaffaqiyatli qo'shildi", "OK");
      } else {
        throw res.body;
      }
      widget.callback();
      _clearFields();
      Get.back();
    } catch (e) {
      if (context.mounted) {
        showAppSnackBar(context, "Xatolik yuz berdi:$e", "OK", isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(Icons.highlight_off_rounded, color: AppColors.appColorRed400, size: 25),
            ),
          ),
          Text("Ta'minotchi malumotlarini kiriting", style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
        ],
      ),
      content: SizedBox(
        width: 400,
        height: 800,
        child: Form(
          key: _formValidation,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 9,
                      child: AppInputUnderline(
                        hintText: 'F.I.O',
                        controller: _nameController,
                        validator: AppValidator().nameValidate,
                        hintTextColor: AppColors.appColorGrey400,
                        prefixIcon: Icons.person_4_rounded,
                        iconSize: 20,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: AppButton(
                        onTap: () {
                          setState(() {
                            _isGender = !_isGender;
                          });
                        },
                        hoverRadius: BorderRadius.circular(10),
                        child: Icon(
                          _isGender ? Icons.face_3 : Icons.face,
                          color: _isGender ? Colors.pinkAccent.shade100 : Colors.blue,
                        ),
                      ),
                    )
                  ],
                ),
                AppInputUnderline(
                  hintText: "Tug\'ilgan sana(DD-MM-YYYY)",
                  controller: _dateController,
                  hintTextColor: AppColors.appColorGrey400,
                  prefixIcon: UniconsLine.calendar_alt,
                  iconSize: 20,
                  inputFormatters: [
                    MaskTextInputFormatter(
                      mask: '##-##-####',
                      filter: {"#": RegExp(r'[0-9]')},
                      type: MaskAutoCompletionType.lazy,
                    )
                  ],
                ),
                AppInputUnderline(
                  hintText: 'Telefon raqami 1',
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
                AppInputUnderline(
                  hintText: 'Telefon raqami 2',
                  controller: _phoneNumber2Controller,
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
                Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      subtitle: Text('Kategoriyasi', style: TextStyle(color: AppColors.appColorGrey400)),
                      title: Text('Tanlash', style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
                      trailing: Icon(Icons.keyboard_arrow_right_outlined, color: AppColors.appColorWhite),
                      leading: Icon(UniconsLine.list_ui_alt, color: AppColors.appColorWhite),
                      onTap: () async {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: Colors.black.withOpacity(0.9),
                            title: Text('Kategoriyani tanlang', style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
                            content: SizedBox(
                              width: Get.width / 3,
                              height: Get.height / 1.5,
                              child: Column(
                                children: [
                                  CategorySide(
                                    hideToolBar: true,
                                    getProducts: (int id) {},
                                    loadingCategory: false,
                                    syncCategory: () async {},
                                    setSelectCategory: (CategoryData? category) {
                                      setState(() {
                                        selectedCategory = category;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              AppButton(
                                onTap: () {
                                  setState(() {
                                    selectedCategory = null;
                                  });
                                  Get.back();
                                },
                                width: 100,
                                height: 40,
                                color: AppColors.appColorRed400,
                                hoverColor: AppColors.appColorRed300,
                                colorOnClick: AppColors.appColorRed400,
                                splashColor: AppColors.appColorRed400,
                                borderRadius: BorderRadius.circular(12),
                                hoverRadius: BorderRadius.circular(12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Bekor qilish',
                                      style: TextStyle(color: AppColors.appColorWhite, fontWeight: FontWeight.w500, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                              AppButton(
                                onTap: () {
                                  if (selectedCategory == null) {
                                    Get.back();
                                    return;
                                  }
                                  bool isExist = productCategories.any((element) => element.id == selectedCategory?.id);
                                  if (isExist) {
                                    Get.back();
                                    return;
                                  }
                                  setState(() {
                                    productCategories.add(selectedCategory!);
                                    selectedCategory = null;
                                  });
                                  Get.back();
                                },
                                width: 100,
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
                                      'Tanlash',
                                      style: TextStyle(color: AppColors.appColorWhite, fontWeight: FontWeight.w500, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Divider(color: AppColors.appColorGrey400, height: 0, thickness: 0.5),
                    SizedBox(
                      height: productCategories.isNotEmpty ? 38 : 0,
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(
                          dragDevices: {
                            PointerDeviceKind.touch,
                            PointerDeviceKind.mouse,
                            PointerDeviceKind.trackpad,
                            PointerDeviceKind.stylus,
                            PointerDeviceKind.invertedStylus,
                            PointerDeviceKind.unknown,
                          },
                        ),
                        child: ListView.builder(
                          itemCount: productCategories.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: const EdgeInsets.only(right: 5, top: 5, bottom: 5),
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(color: Colors.green.shade800, borderRadius: BorderRadius.circular(15)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 10),
                                  Center(
                                      child:
                                          Text(productCategories[index].name, style: TextStyle(color: AppColors.appColorWhite))),
                                  const SizedBox(width: 10),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        productCategories.removeAt(index);
                                      });
                                    },
                                    child: Icon(Icons.clear_rounded, color: AppColors.appColorGrey300, size: 18),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      subtitle: Text('Regionni tanlang', style: TextStyle(color: AppColors.appColorGrey400)),
                      title: Text(_regionData?.name ?? "", style: TextStyle(color: AppColors.appColorWhite, fontSize: 16)),
                      trailing: Icon(Icons.keyboard_arrow_right_outlined, color: AppColors.appColorWhite),
                      leading: Icon(UniconsLine.list_ui_alt, color: AppColors.appColorWhite),
                      onTap: () async {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: Colors.black.withOpacity(0.9),
                            title: Text('Regionni tanlang', style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
                            content: SizedBox(
                              width: Get.width / 3,
                              height: Get.height / 1.5,
                              child: Column(
                                children: [
                                  RegionSide(
                                    hideToolBar: true,
                                    setSelectedRegion: (RegionData? region) {
                                      setState(() {
                                        _regionData = region;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              AppButton(
                                onTap: () {
                                  if (_regionData == null) {
                                    Get.back();
                                    return;
                                  }
                                  Get.back();
                                },
                                width: 100,
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
                                      'Tanlash',
                                      style: TextStyle(color: AppColors.appColorWhite, fontWeight: FontWeight.w500, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
                AppAutoComplete(
                  getValue: (AutocompleteDataStruct value) {
                    setState(() {
                      _segmentId = _segments
                          .firstWhereOrNull((element) => element.name == value.value && element.id == value.uniqueId)
                          ?.id;
                    });
                  },
                  options: _segments
                      .map(
                        (e) => AutocompleteDataStruct(
                          value: e.name,
                          uniqueId: e.id,
                        ),
                      )
                      .toList(),
                  hintText: 'Segmentni Tanlang',
                  prefixIcon: UniconsLine.map,
                ),
                AppAutoComplete(
                  getValue: (AutocompleteDataStruct value) {
                    setState(() {
                      _organizationId = organizations
                          .firstWhereOrNull((element) => element.name == value.value && element.id == value.uniqueId)
                          ?.id;
                    });
                  },
                  options: organizations
                      .map(
                        (e) => AutocompleteDataStruct(value: e.name, uniqueId: e.id),
                      )
                      .toList(),
                  hintText: 'Organizatsiya Tanlang',
                  prefixIcon: UniconsLine.building,
                ),
                const SizedBox(height: 5),
                AppInputUnderline(
                  hintText: "Izoh",
                  controller: _descriptionController,
                  maxLines: 2,
                  hintTextColor: AppColors.appColorGrey400,
                  prefixIcon: UniconsLine.comment_alt,
                  iconSize: 20,
                  iconColor: AppColors.appColorWhite,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
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
              onTap: createNewSupplier,
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
                    style: TextStyle(color: AppColors.appColorWhite, fontWeight: FontWeight.w500, fontSize: 16, letterSpacing: 1),
                  ),
                  Icon(UniconsLine.save, color: AppColors.appColorWhite, size: 18)
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _clearFields() {
    _productCategoryController.clear();
    _nameController.clear();
    _dateController.clear();
    _phoneNumber1Controller.clear();
    _phoneNumber2Controller.clear();
    _addressController.clear();
    _organizationNameController.clear();
    _descriptionController.clear();
  }
}
