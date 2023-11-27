import 'dart:convert';

import 'package:easy_sell/services/https_services.dart';
import 'package:easy_sell/widgets/app_input_underline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:unicons/unicons.dart';
import '../../../constants/colors.dart';
import '../../../database/model/client_dto.dart';
import '../../../database/my_database.dart';
import '../../../utils/utils.dart';
import '../../../utils/validator.dart';
import '../../../widgets/app_autocomplete.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_dialog.dart';
import 'package:http/http.dart' as http;

class ClientInfoDialog extends StatefulWidget {
  const ClientInfoDialog({Key? key, this.client, required this.callback, this.onClientCreated, this.regionData})
      : super(key: key);
  final ClientDto? client;
  final VoidCallback callback;
  final RegionData? regionData;
  final Function(ClientData)? onClientCreated;

  @override
  State<ClientInfoDialog> createState() => _ClientInfoDialogState();
}

class _ClientInfoDialogState extends State<ClientInfoDialog> {
  MyDatabase database = Get.find<MyDatabase>();
  final _formValidation = GlobalKey<FormState>();
  bool _isGender = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _number1Controller = TextEditingController();
  final TextEditingController _number2Controller = TextEditingController();
  final TextEditingController _discountCardController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<RegionData> _regions = [];
  RegionData? _regionData;
  int? typeId;

  @override
  void initState() {
    _regionData = widget.regionData;
    typeId = widget.client?.typeId;
    if (widget.client != null) {
      _nameController.text = widget.client?.name ?? '';
      _dateController.text =
          widget.client?.dateOfBirth != null ? DateFormat('dd-MM-yyyy').format(widget.client?.dateOfBirth ?? DateTime.now()) : '';
      _number1Controller.text = widget.client?.phoneNumber ?? '';
      _number2Controller.text = widget.client?.phoneNumber2 ?? '';
      _discountCardController.text = widget.client?.discountCard ?? '';
      _descriptionController.text = widget.client?.description ?? '';

      if (widget.client?.gender == ClientGender.FEMALE) {
        _isGender = true;
      }
    }

    super.initState();
    _getRegions();
  }

  void createOrUpdateClient() async {
    if (!_formValidation.currentState!.validate()) return;
    if (typeId == null) return showAppSnackBar(context, "Mijoz turi tanlanmagan", "OK", isError: true);
    try {
      var req = {
        "name": _nameController.text,
        "address": "",
        "phoneNumber": _number1Controller.text,
        "phoneNumber2": _number2Controller.text,
        "dateOfBirth": DateFormat('dd-MM-yyyy').parse(_dateController.text).millisecondsSinceEpoch,
        "gender": _isGender ? "FEMALE" : "MALE",
        "organizationName": "",
        "discountCard": _discountCardController.text,
        "description": _descriptionController.text,
        "regionId": _regionData?.id,
        "typeId": typeId,
      };
      http.Response response;
      if (widget.client == null) {
        response = await HttpServices.post("/client/create", req);
      } else {
        response = await HttpServices.put("/client/${widget.client?.id}", req);
      }
      widget.callback();
      Get.back();
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw response.body;
      }
    } catch (e) {
      showAppSnackBar(context, "Xatolik: $e", "OK", isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      backgroundColor: Colors.black.withOpacity(0.9),
      title: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(Icons.highlight_off_rounded, color: AppColors.appColorRed400, size: 25),
            ),
          ),
          Text(widget.client != null ? 'Mijoz malumotlari' : 'Mijoz yaratish',
              style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
        ],
      ),
      content: SizedBox(
        height: 500,
        width: 350,
        child: Form(
          key: _formValidation,
          child: SingleChildScrollView(
            child: Column(
              children: [
                AppInputUnderline(
                  controller: _discountCardController,
                  hintText: 'Diskont karta',
                  prefixIcon: UniconsLine.credit_card,
                  numberFormat: false,
                  validator: AppValidator(message: "Discount kiritilsin").validate,
                ),
                AppInputUnderline(
                  controller: _nameController,
                  hintText: 'F.I.O',
                  prefixIcon: UniconsLine.user_circle,
                  validator: AppValidator().nameValidate,
                  suffixIcon: changeGenderOnClick(),
                ),
                AppInputUnderline(
                  controller: _dateController,
                  hintText: 'Tug\'ilgan sana(DD-MM-YYYY)',
                  prefixIcon: UniconsLine.calender,
                  inputFormatters: [
                    MaskTextInputFormatter(
                      mask: '##-##-####',
                      filter: {"#": RegExp(r'[0-9]')},
                    )
                  ],
                  textInputAction: TextInputAction.next,
                ),
                AppInputUnderline(
                  controller: _number1Controller,
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
                  controller: _number2Controller,
                  hintText: "Telefon raqami (qo'shimcha)",
                  prefixIcon: UniconsLine.phone,
                  inputFormatters: [
                    MaskTextInputFormatter(
                      mask: '+### (##) ###-##-##',
                      filter: {"#": RegExp(r'[0-9]')},
                      type: MaskAutoCompletionType.lazy,
                    )
                  ],
                ),
                if (_regions.isNotEmpty)
                  Row(
                    children: [
                      Expanded(
                        flex: 10,
                        child: AppAutoComplete(
                          getValue: (AutocompleteDataStruct value) {
                            setState(() {
                              _regionData = _regions.firstWhereOrNull((el) => el.name == value.value && value.uniqueId == el.id);
                            });
                          },
                          initialValue: widget.regionData?.name ??
                              _regions.firstWhereOrNull((el) => el.id == widget.client?.region?.id)?.name,
                          options: _regions.map((e) => AutocompleteDataStruct(value: e.name, uniqueId: e.id)).toList(),
                          hintText: 'Regionni Tanlang',
                          prefixIcon: UniconsLine.map,
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                FutureBuilder(
                  future: HttpServices.get("/settings/client-type/all"),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var json = jsonDecode(snapshot.data?.body ?? '')['data'];
                      List<AutocompleteDataStruct> data = [];
                      for (var item in json) {
                        data.add(AutocompleteDataStruct(value: item['name'], uniqueId: item['id']));
                      }
                      return AppAutoComplete(
                        getValue: (AutocompleteDataStruct value) {
                          setState(() {
                            typeId = value.uniqueId;
                          });
                        },
                        options: data,
                        hintText: 'Mijoz turi',
                        prefixIcon: Icons.verified,
                        initialValue: data.firstWhereOrNull((el) => el.uniqueId == widget.client?.typeId)?.value,
                      );
                    } else {
                      return Center(child: CircularProgressIndicator(color: AppColors.appColorGreen400));
                    }
                  },
                ),
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
            if (widget.client == null)
              AppButton(
                onTap: () {
                  _clearFields();
                },
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
              onTap: createOrUpdateClient,
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
                    widget.client != null ? 'Saqlash' : 'Yaratish',
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

  void _getRegions() async {
    List<RegionData> list = await database.regionDao.getAllRegions();
    setState(() {
      _regions = list;
    });
  }

  void _clearFields() {
    _nameController.clear();
    _dateController.clear();
    _number1Controller.clear();
    _number2Controller.clear();
    _discountCardController.clear();
    _descriptionController.clear();
  }

  Widget changeGenderOnClick() {
    return IconButton(
      onPressed: () {
        setState(() {
          _isGender = !_isGender;
        });
      },
      icon: _isGender
          ? Icon(
              Icons.face_3,
              color: Colors.pinkAccent.shade100,
            )
          : const Icon(
              Icons.face,
              color: Colors.blue,
            ),
    );
  }
}
