import 'dart:convert';
import 'package:easy_sell/screens/supplier_screen/widget/supplier_region_side.dart';
import 'package:easy_sell/screens/sync_screen/upload_functions.dart';
import 'package:easy_sell/services/https_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/colors.dart';
import '../../../database/model/supplier_organization_dto.dart';
import '../../../database/my_database.dart';
import '../../../utils/utils.dart';
import 'add_supplier_dialog.dart';

class SupplierRightContainers extends StatefulWidget {
  const SupplierRightContainers({Key? key, required this.callback, required this.allSuppliersLength, required this.getByRegion})
      : super(key: key);
  final VoidCallback callback;
  final int allSuppliersLength;
  final Function(int) getByRegion;

  @override
  State<SupplierRightContainers> createState() => _SupplierRightContainersState();
}

class _SupplierRightContainersState extends State<SupplierRightContainers> {
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
  late UploadFunctions uploadFunctions;
  List<String> productCategories = [];
  List<SupplierOrganizationDto> organizations = [];
  List segments = [];
  int? _regionId;
  int? _organizationId;

  @override
  void initState() {
    super.initState();
    uploadFunctions = UploadFunctions(database: database, progress: {}, setter: setter);
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

  void setter(void Function() fn) {}

  void createNewSupplier() async {
    if (!_formValidation.currentState!.validate()) return;
    if (_regionId == null) return showAppSnackBar(context, "Regionni tanlang", "OK", isError: true);
    if (_organizationId == null) return showAppSnackBar(context, "Organizatsiya tanlang", "OK", isError: true);
    try {
      var request = {
        "name": _nameController.text,
        "address": _addressController.text,
        "phoneNumber": _phoneNumber1Controller.text,
        "regionId": _regionId,
        "supplierOrganizationId": _organizationId,
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
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Container(
          height: Get.height - 80,
          width: screenWidth / 3.99,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.black),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              children: [
                SupplierRegionSide(
                  setSelectedRegion: (RegionData? region) {
                    widget.getByRegion(region?.id ?? 0);
                  },
                  hideToolBar: true,
                  onAddButton: (RegionData? regionData) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AddSupplierDialog(
                          regionData: regionData,
                          callback: widget.callback,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
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
