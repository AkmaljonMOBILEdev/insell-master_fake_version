import 'dart:convert';
import 'dart:ui';

import 'package:easy_sell/database/model/supplier_dto.dart';
import 'package:easy_sell/services/money_calculator_service.dart';
import 'package:easy_sell/widgets/app_input_underline.dart';
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
import '../../../widgets/app_dialog.dart';
import '../../category_screen/widget/category_side.dart';

class SupplierInfoDialog extends StatefulWidget {
  const SupplierInfoDialog({Key? key, required this.supplier, required this.callback}) : super(key: key);
  final SupplierDto supplier;
  final VoidCallback callback;

  @override
  State<SupplierInfoDialog> createState() => _SupplierInfoDialogState();
}

class _SupplierInfoDialogState extends State<SupplierInfoDialog> {
  MyDatabase database = Get.find<MyDatabase>();
  final _formValidation = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _phoneNumberSecondController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _organizationNameController = TextEditingController();
  final TextEditingController _regionNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<ProductIncomeData> fromSupplierAllIncomes = [];
  late MoneyCalculatorService moneyCalculatorService;
  List<SupplierOrganizationDto> organizations = [];
  List<RegionData> regions = [];
  List<SegmentDto> _segments = [];

  List<String> supplierTypes = SupplierType.values.map((e) => e.name).toList();

  int? _regionId;
  int? _organizationId;
  int? _segmentId;

  List<CategoryData> productCategories = [];
  CategoryData? selectedCategory;

  @override
  void initState() {
    _nameController.text = widget.supplier.name;
    _phoneNumberController.text = widget.supplier.phoneNumber ?? '';
    _phoneNumberSecondController.text = widget.supplier.phoneNumber ?? '';
    _dateController.text =
        widget.supplier.dateOfBirth != null ? DateFormat('dd-MM-yyyy').format(widget.supplier.dateOfBirth!) : '';
    _organizationNameController.text = widget.supplier.supplierOrganization?.name ?? '';
    _regionNameController.text = widget.supplier.region?.name ?? '';
    _regionId = widget.supplier.region?.id;
    _segmentId = widget.supplier.segment?.id;
    _organizationId = widget.supplier.supplierOrganization?.id;
    _descriptionController.text = widget.supplier.description ?? '';
    productCategories = widget.supplier.categories;
    super.initState();
    initOrganizations();
    initRegions();
    initSegments();
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

  void initRegions() async {
    regions = await database.regionDao.getAllRegions();
    setState(() {});
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

  void updateSupplier() async {
    if (!_formValidation.currentState!.validate()) return;
    if (_regionId == null) return showAppSnackBar(context, "Regionni tanlang", "OK", isError: true);
    if (_organizationId == null) return showAppSnackBar(context, "Organizatsiya tanlang", "OK", isError: true);
    try {
      var request = {
        "name": _nameController.text,
        "address": _descriptionController.text,
        "phoneNumber": _phoneNumberController.text,
        "regionId": _regionId,
        "segmentId": _segmentId,
        "supplierOrganizationId": _organizationId,
        "dateOfBirth": DateFormat('dd-MM-yyyy').parse(_dateController.text).millisecondsSinceEpoch,
        "categoryIds": productCategories.map((e) => e.serverId).toList(),
      };
      var res = await HttpServices.put("/supplier/${widget.supplier.id}", request);
      if (res.statusCode == 200 || res.statusCode == 201) {
        showAppSnackBar(context, "Ta'minotchi muvaffaqiyatli qo'shildi", "OK");
      } else {
        throw res.body;
      }
      widget.callback();
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
      backgroundColor: Colors.black.withOpacity(0.9),
      title: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Ta\'minotchi malumotlari', style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
            IconButton(
              onPressed: () => Get.back(),
              icon: Icon(Icons.highlight_off_rounded, color: AppColors.appColorRed400, size: 25),
            ),
          ],
        ),
      ]),
      content: SizedBox(
        height: 550,
        width: 350,
        child: Form(
          key: _formValidation,
          child: SingleChildScrollView(
            child: Column(
              children: [
                AppInputUnderline(
                  controller: _nameController,
                  hintText: 'F.I.O',
                  prefixIcon: Icons.person_4_rounded,
                  validator: AppValidator().nameValidate,
                ),
                AppInputUnderline(
                  controller: _phoneNumberController,
                  hintText: 'Telefon raqami',
                  prefixIcon: UniconsLine.phone,
                  validator: AppValidator().numberValidate,
                  inputFormatters: [
                    MaskTextInputFormatter(
                      mask: '+### (##) ###-##-##',
                      filter: {"#": RegExp(r'[0-9]')},
                      type: MaskAutoCompletionType.lazy,
                    )
                  ],
                ),
                AppInputUnderline(
                  controller: _phoneNumberSecondController,
                  hintText: '2-Telefon raqami',
                  prefixIcon: UniconsLine.phone,
                  validator: AppValidator().numberValidate,
                  inputFormatters: [
                    MaskTextInputFormatter(
                      mask: '+### (##) ###-##-##',
                      filter: {"#": RegExp(r'[0-9]')},
                      type: MaskAutoCompletionType.lazy,
                    )
                  ],
                ),
                AppInputUnderline(
                  hintText: "Ta'minotchi tug'ilgan sana",
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
                                      child: Text(productCategories[index].name, style: TextStyle(color: AppColors.appColorWhite))),
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
                AppAutoComplete(
                  getValue: (AutocompleteDataStruct value) {
                    setState(() {
                      _segmentId =
                          _segments.firstWhereOrNull((element) => element.name == value.value && element.id == value.uniqueId)?.id;
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
                  initialValue: widget.supplier.segment?.name ?? '',
                  prefixIcon: UniconsLine.map,
                ),
                AppAutoComplete(
                  initialValue: _regionNameController.text,
                  getValue: (AutocompleteDataStruct value) {
                    setState(() {
                      _regionId = regions
                          .firstWhereOrNull((element) => element.name == value.value && element.id == value.uniqueId)
                          ?.serverId;
                    });
                  },
                  options: regions
                      .map(
                        (e) => AutocompleteDataStruct(
                          value: e.name,
                          uniqueId: e.id,
                        ),
                      )
                      .toList(),
                  hintText: 'Region Tanlang',
                  prefixIcon: UniconsLine.location_point,
                ),
                AppAutoComplete(
                  initialValue: _organizationNameController.text,
                  getValue: (AutocompleteDataStruct value) {
                    setState(() {
                      _organizationId = organizations
                          .firstWhereOrNull((element) => element.name == value.value && element.id == value.uniqueId)
                          ?.id;
                    });
                  },
                  options: organizations
                      .map(
                        (e) => AutocompleteDataStruct(
                          value: e.name,
                          uniqueId: e.id,
                        ),
                      )
                      .toList(),
                  hintText: 'Organizatsiya Tanlang',
                  prefixIcon: UniconsLine.building,
                ),
                const SizedBox(height: 10),
                AppInputUnderline(
                  controller: _descriptionController,
                  maxLines: 3,
                  hintText: 'Izoh',
                  textInputAction: TextInputAction.newline,
                  prefixIcon: UniconsLine.comment_alt,
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
              tooltip: '',
              onTap: updateSupplier,
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
