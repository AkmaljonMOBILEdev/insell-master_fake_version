import 'dart:convert';
import 'package:easy_sell/screens/settings_screen/screens/discount_settings_screen/discount_settings_screen.dart';
import 'package:easy_sell/services/https_services.dart';
import 'package:easy_sell/utils/validator.dart';
import 'package:easy_sell/widgets/app_autocomplete.dart';
import 'package:easy_sell/widgets/app_input_underline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';
import '../../../../../constants/colors.dart';
import '../../../../../utils/utils.dart';
import '../../../../../widgets/app_button.dart';
import '../../../../../widgets/app_dialog.dart';
import 'package:http/http.dart' as http;

class DiscountRoles {
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  TextEditingController stepController = TextEditingController();
  int? clientTypeId;
  Color cardColor = Colors.grey.shade800;

  DiscountRoles({
    this.clientTypeId,
  });

  void updateCardColor(Color newColor) {
    cardColor = newColor;
  }

  DiscountRoles.fromMap(DiscountRole map) {
    fromController.text = map.from.toString();
    toController.text = map.to.toString();
    stepController.text = map.percent.toString();
    clientTypeId = map.clientTypeId;
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'from': fromController.text,
      'to': toController.text,
      'percent': stepController.text,
      'clientTypeId': clientTypeId,
    };
  }
}

class AddDiscountDialog extends StatefulWidget {
  const AddDiscountDialog({Key? key, required this.callback, this.discountDto}) : super(key: key);
  final DiscountDto? discountDto;
  final VoidCallback callback;

  @override
  State<AddDiscountDialog> createState() => _AddDiscountDialogState();
}

class _AddDiscountDialogState extends State<AddDiscountDialog> {
  final _formValidation = GlobalKey<FormState>();
  final List<DiscountRoles> _roundingRoles = [DiscountRoles()];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _inputController = TextEditingController();
  double _result = 0.0;
  int selectedIndex = -1;
  bool _isFind = false;

  @override
  void initState() {
    super.initState();
    if (widget.discountDto != null) {
      _nameController.text = widget.discountDto?.name ?? '';
      _descriptionController.text = widget.discountDto?.description ?? '';
      addDiscountRoles(widget.discountDto?.discountRoles ?? []);
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
          Text('Cashback qo\'shish', style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
        ],
      ),
      content: SizedBox(
        height: 500,
        width: 950,
        child: Form(
          key: _formValidation,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 320,
                    child: AppInputUnderline(
                      controller: _nameController,
                      hintText: 'Nomi',
                      validator: AppValidator().namedValidate,
                      prefixIcon: Icons.view_headline,
                      numberFormat: false,
                    ),
                  ),
                  SizedBox(
                    width: 320,
                    child: AppInputUnderline(
                      controller: _descriptionController,
                      hintText: 'Izoh',
                      textInputAction: TextInputAction.newline,
                      prefixIcon: UniconsLine.comment_alt,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: _roundingRoles.length,
                  itemBuilder: (BuildContext context, index) {
                    final randomColor = randomColors[index % randomColors.length];
                    final roundingRole = _roundingRoles[index];
                    final isSelected = index == selectedIndex;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                      child: Card(
                        color: isSelected ? Colors.blue.shade600.withOpacity(0.3) : Colors.grey.shade800,
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 25,
                                        height: 25,
                                        decoration: BoxDecoration(color: randomColor, borderRadius: BorderRadius.circular(10)),
                                        child: Center(
                                          child: Text(
                                            '${index + 1}',
                                            style: TextStyle(
                                                color: AppColors.appColorWhite, fontSize: 16, fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        '',
                                        style:
                                            TextStyle(color: AppColors.appColorWhite, fontSize: 16, fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      AppButton(
                                        onTap: () {
                                          setState(() {
                                            _roundingRoles.removeAt(index);
                                          });
                                        },
                                        width: 30,
                                        height: 30,
                                        hoverRadius: BorderRadius.circular(10),
                                        child: Icon(Icons.close_rounded, color: AppColors.appColorWhite, size: 25),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 290,
                                    child: AppInputUnderline(
                                      hintText: 'Dan',
                                      onChanged: (value) {},
                                      controller: roundingRole.fromController,
                                      keyboardType: TextInputType.number,
                                      prefixIcon: UniconsLine.arrow_from_right,
                                      inputFormatters: [AppTextInputFormatter()],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    width: 290,
                                    child: AppInputUnderline(
                                      hintText: 'Gacha',
                                      controller: roundingRole.toController,
                                      keyboardType: TextInputType.number,
                                      prefixIcon: UniconsLine.arrow_to_right,
                                      inputFormatters: [AppTextInputFormatter()],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 290,
                                    child: AppInputUnderline(
                                      hintText: 'Chegirma %',
                                      controller: roundingRole.stepController,
                                      keyboardType: TextInputType.number,
                                      prefixIcon: Icons.percent_outlined,
                                      validator: AppValidator().sumValidate,
                                      inputFormatters: [AppTextInputFormatter()],
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  FutureBuilder(
                                      future: HttpServices.get("/settings/client-type/all"),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          var json = jsonDecode(snapshot.data?.body ?? '');
                                          List<AutocompleteDataStruct> clientTypes = [];
                                          for (var e in json['data']) {
                                            clientTypes.add(AutocompleteDataStruct(
                                              uniqueId: e['id'],
                                              value: e['name'],
                                            ));
                                          }
                                          return SizedBox(
                                              width: 290,
                                              child: AppAutoComplete(
                                                  getValue: (AutocompleteDataStruct value) {
                                                    setState(() {
                                                      _roundingRoles[index].clientTypeId = value.uniqueId;
                                                    });
                                                  },
                                                  options: clientTypes,
                                                  hintText: "Mijoz turi",
                                                  prefixIcon: Icons.person));
                                        } else {
                                          return const SizedBox();
                                        }
                                      }),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AppButton(
              onTap: () {
                setState(() {
                  _roundingRoles.add(DiscountRoles());
                });
              },
              height: 40,
              width: 40,
              color: Colors.blue.shade800,
              borderRadius: BorderRadius.circular(12),
              hoverRadius: BorderRadius.circular(12),
              child: Center(
                child: Icon(Icons.add, color: AppColors.appColorWhite),
              ),
            ),
            const SizedBox(width: 10),
            AppButton(
              tooltip: '',
              onTap: () {
                if (_formValidation.currentState!.validate()) {
                  createOrUpdatePriceRounding();
                  widget.callback();
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
                    widget.discountDto != null ? 'Yangilash' : 'Saqlash',
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

  double rounding(double value, double step, double decrease) {
    double calc = ((value + decrease) / step).round() * step - decrease;
    setState(() {
      _result = calc;
    });
    return _result;
  }

  double ceiling(double value, double step, double decrease) {
    double calc = ((value + decrease) / step).ceil() * step - decrease;
    setState(() {
      _result = calc;
    });
    return _result;
  }

  double flooring(double value, double step, double decrease) {
    double calc = ((value + decrease) / step).floor() * step - decrease;
    setState(() {
      _result = calc;
    });
    return _result;
  }

  void calculate() {
    double inputValue = double.tryParse(_inputController.text.replaceAll(' ', '')) ?? 0;

    DiscountRoles? currentRole;

    for (var roundingRole in _roundingRoles) {
      double from = double.tryParse(roundingRole.fromController.text.replaceAll(' ', '')) ?? 0;
      double? to = double.tryParse(roundingRole.toController.text.replaceAll(' ', ''));
      if (to == null) {
        if (inputValue >= from) {
          currentRole = roundingRole;
        }
      } else {
        if (inputValue >= from && inputValue <= to) {
          currentRole = roundingRole;
        }
      }
    }

    // Получение индекса для изменения цвета
    if (currentRole != null) {
      int index = _roundingRoles.indexOf(currentRole);
      setState(() {
        selectedIndex = index;
        _isFind = true;
      });
    } else {
      setState(() {
        selectedIndex = -1;
        _isFind = false;
      });
    }
  }

  void createOrUpdatePriceRounding() async {
    try {
      var req = {
        "name": _nameController.text,
        "description": _descriptionController.text,
        'discountRoles': _roundingRoles.map((e) {
          double? from = double.tryParse(e.fromController.text.replaceAll(' ', '')) ?? 0.0;
          double? to = double.tryParse(e.toController.text.replaceAll(' ', '')) ?? 0.0;
          double? step = double.tryParse(e.stepController.text.replaceAll(' ', '')) ?? 0.0;
          DiscountRoles newRole = DiscountRoles(clientTypeId: e.clientTypeId)
            ..fromController.text = from.toString()
            ..toController.text = to.toString()
            ..stepController.text = step.toString();
          return newRole.toJson();
        }).toList(),
      };
      http.Response response;
      print(req);
      if (widget.discountDto != null) {
        response = await HttpServices.put("/settings/discount/${widget.discountDto?.id}", req);
      } else {
        response = await HttpServices.post("/settings/discount/create", req);
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        showAppSnackBar(context, "Muvofaqiyatli yangilandi", "OK");
        Get.back();
        widget.callback();
      } else {
        throw Exception("Xatolik yuz berdi: ${response.body}");
      }
    } catch (e) {
      if (context.mounted) {
        showAppSnackBar(context, "Xatolik yuz berdi:$e", "OK", isError: true);
      }
    }
  }

  void addDiscountRoles(List<DiscountRole> discountRole) {
    _roundingRoles.clear();
    for (var rounding in discountRole) {
      DiscountRoles roundingRole = DiscountRoles(clientTypeId: rounding.clientTypeId);
      roundingRole.toController.text = rounding.to.toString();
      roundingRole.fromController.text = rounding.from.toString();
      if (rounding.to!.isFinite) {
        roundingRole.toController.text = '';
      }
      roundingRole.stepController.text = rounding.percent.toString();
      _roundingRoles.add(roundingRole);
    }
  }
}
