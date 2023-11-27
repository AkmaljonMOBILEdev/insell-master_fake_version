import 'package:easy_sell/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:unicons/unicons.dart';
import '../../../../../../constants/colors.dart';
import '../../../../../../widgets/app_button.dart';
import '../../../../../../widgets/app_dialog.dart';
import 'package:http/http.dart' as http;
import '../../../../services/https_services.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/app_autocomplete.dart';
import '../../../../widgets/app_input_underline.dart';
import '../../../database/model/counter_party_dto.dart';
import '../../../database/my_database.dart';

class PartnerAddDialog extends StatefulWidget {
  const PartnerAddDialog({Key? key, required this.type, required this.callback, this.counterParty}) : super(key: key);
  final String type;
  final CounterPartyDto? counterParty;
  final VoidCallback callback;

  @override
  State<PartnerAddDialog> createState() => _PartnerAddDialogState();
}

class _PartnerAddDialogState extends State<PartnerAddDialog> {
  MyDatabase database = Get.find<MyDatabase>();
  final _formValidation = GlobalKey<FormState>();
  List<RegionData> _regions = [];
  RegionData? _regionData;
  DateTime? date;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getRegions();
    if (widget.counterParty != null) {
      _getValues();
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
          Text(
            widget.type == 'ORGANIZATION'
                ? 'Organizatsiya qo\'shish'
                : widget.type == 'PARTNER'
                    ? 'Kontragent qo\'shish'
                    : 'Bank qo\'shish',
            style: TextStyle(color: AppColors.appColorWhite, fontSize: 20),
          ),
        ],
      ),
      content: SizedBox(
        height: 350,
        width: 400,
        child: Form(
          key: _formValidation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AppInputUnderline(
                controller: _nameController,
                hintText: 'Nomi',
                textInputAction: TextInputAction.newline,
                validator: AppValidator().namedValidate,
                prefixIcon: UniconsLine.user_nurse,
              ),
              const SizedBox(height: 10),
              AppInputUnderline(
                controller: _addressController,
                hintText: 'Adress',
                textInputAction: TextInputAction.newline,
                prefixIcon: UniconsLine.location_point,
              ),
              const SizedBox(height: 10),
              AppInputUnderline(
                controller: _numberController,
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
              const SizedBox(height: 10),
              AppAutoComplete(
                getValue: (AutocompleteDataStruct value) {
                  setState(() {
                    _regionData = _regions.firstWhereOrNull((el) => el.name == value.value && value.uniqueId == el.id);
                  });
                },
                initialValue: _regionData?.name ?? _regions.firstWhereOrNull((el) => el.id == _regionData?.id)?.name,
                // widget.regionData?.name ?? _regions.firstWhereOrNull((el) => el.id == widget.client?.region?.id)?.name,
                options: _regions.map((e) => AutocompleteDataStruct(value: e.name, uniqueId: e.id)).toList(),
                hintText: 'Regionni Tanlang',
                prefixIcon: UniconsLine.map,
              ),
              const SizedBox(height: 10),
              widget.type == 'PARTNER'
                  ? AppInputUnderline(
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
                    )
                  // AppInputUnderline(
                  //         onTap: () async {
                  //           DateTime? selectedDate = await showAppDatePicker(context);
                  //           if (selectedDate != null) {
                  //             _dateController.text = DateFormat('dd-MM-yyyy').format(selectedDate);
                  //             date = DateFormat(_dateController.text).parse(_dateController.text);
                  //           }
                  //         },
                  //         controller: _dateController,
                  //         hintText: "Tug'ilgan sana",
                  //         prefixIcon: UniconsLine.calendar_alt,
                  //         inputFormatters: [
                  //           MaskTextInputFormatter(
                  //             mask: '##-##-####',
                  //             filter: {"#": RegExp(r'[0-9]')},
                  //             type: MaskAutoCompletionType.lazy,
                  //           )
                  //         ],
                  //       )
                  : const SizedBox(),
              // const SizedBox(height: 10),
              // AppInputUnderline(
              //   controller: _descriptionController,
              //   hintText: 'Izoh',
              //   maxLines: 3,
              //   textInputAction: TextInputAction.newline,
              //   prefixIcon: UniconsLine.comment_alt,
              // ),
            ],
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
              onTap: () async {
                try {
                  if (_formValidation.currentState!.validate()) {
                    if (_regionData == null) {
                      throw Exception('Regionni tanlang');
                    }
                    await createOrUpdatePartner();
                    widget.callback();
                  }
                } catch (e) {
                  print(e);
                  showAppSnackBar(context, 'Xatolik yuz berdi:$e', "OK", isError: true);
                }
              },
              width: 300,
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
                    widget.counterParty != null ? 'Saqlash' : 'Yaratish',
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

  void _clearFields() {
    _nameController.clear();
    _numberController.clear();
    _addressController.clear();
    _dateController.clear();
    _descriptionController.clear();
  }

  void _getValues() {
    _nameController.text = widget.counterParty?.name ?? '';
    _numberController.text = widget.counterParty?.phoneNumber ?? '';
    _addressController.text = widget.counterParty?.address ?? '';
    _dateController.text = DateFormat('dd-MM-yyyy').format(widget.counterParty?.dateOfBirth ?? DateTime.now());
    _regionData = widget.counterParty?.region;
    // _descriptionController.text = widget.counterParty?.description ?? '';
  }

  void _getRegions() async {
    List<RegionData> list = await database.regionDao.getAllRegions();
    // _regionData = list.firstWhereOrNull((el) => el.id == widget.client?.region?.id);
    setState(() {
      _regions = list;
    });
  }

  Future<void> createOrUpdatePartner() async {
    try {
      var req = {
        "name": _nameController.text,
        "address": _addressController.text,
        "phoneNumber": _numberController.text,
        "regionId": _regionData?.id,
        "type": widget.type,
        "dateOfBirth": date?.millisecondsSinceEpoch
      };
      http.Response response;
      if (widget.counterParty == null) {
        response = await HttpServices.post("/counterparty/create", req);
        showAppSnackBar(context, "Xamkor muvofaqiyatli qo'shildi", "OK");
      } else {
        response = await HttpServices.put("/counterparty/${widget.counterParty?.id}", req);
        showAppSnackBar(context, "Xamkor muvofaqiyatli yangilandi", "OK");
      }
      Get.back();
    } catch (e) {
      if (context.mounted) {
        showAppSnackBar(context, "Xatolik yuz berdi:$e", "OK", isError: true);
        print('$e');
      }
    }
  }
}
