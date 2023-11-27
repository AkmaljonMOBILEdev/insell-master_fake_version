import 'package:easy_sell/widgets/app_calendar_dialog.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
import '../../../constants/colors.dart';
import '../../../database/my_database.dart';
import '../../../services/https_services.dart';
import '../../../utils/utils.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_input_underline.dart';

class SeasonRightContainers extends StatefulWidget {
  const SeasonRightContainers({Key? key, required this.allSeasons, required this.callback}) : super(key: key);
  final int allSeasons;
  final Function callback;

  @override
  State<SeasonRightContainers> createState() => _SeasonRightContainersState();
}

class _SeasonRightContainersState extends State<SeasonRightContainers> {
  final _formValidation = GlobalKey<FormState>();
  bool _showAddSeason = false;
  List<POSData> allPos = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  void createNewSeason() async {
    try {
      var request = {
        "name": _nameController.text,
        "description": _descriptionController.text,
        "startDate": _startDate?.millisecondsSinceEpoch,
        "endDate": _endDate?.millisecondsSinceEpoch,
      };
      var res = await HttpServices.post("/season/create", request);
      print(request);
      print(res.body);
      _clearFields();
      setState(() {
        _showAddSeason = false;
      });
      widget.callback();
    } catch (e) {
      if (context.mounted) {
        showAppSnackBar(context, e.toString(), "OK", isError: true);
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
        AnimatedContainer(
          height: _showAddSeason == true ? 0 : 100,
          width: screenWidth / 3.99,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: AppColors.appColorBlackBg),
          duration: const Duration(milliseconds: 400),
          curve: Curves.fastOutSlowIn,
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(UniconsLine.umbrella, color: AppColors.appColorWhite, size: 38),
                          Text(" Mavsumlar:", style: TextStyle(color: AppColors.appColorWhite)),
                        ],
                      ),
                      Row(
                        children: [
                          Text('${widget.allSeasons}', style: TextStyle(color: AppColors.appColorWhite)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Expanded(
          child: _showAddSeason
              ? AnimatedContainer(
                  height: _showAddSeason == true ? screenHeight / 1.12 : screenHeight / 1.573,
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
                                _showAddSeason = false;
                              });
                            },
                            icon: Icon(Icons.highlight_off_rounded, color: AppColors.appColorRed400, size: 30),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: Text("Mavsum malumotlarini kiriting",
                              style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
                        ),
                        AppInputUnderline(
                          controller: _nameController,
                          hintText: "Mavsum nomi",
                          hintTextColor: AppColors.appColorGrey400,
                          prefixIcon: UniconsLine.umbrella,
                          iconSize: 25,
                        ),
                        const SizedBox(height: 5),
                        AppInputUnderline(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AppCalendarDialog(
                                  callback: (DateTime startDate, DateTime? endDate) {
                                    setState(() {
                                      _startDate = startDate;
                                      _endDate = endDate;
                                    });
                                  },
                                );
                              },
                            );
                          },
                          controller: _dateController,
                          hintText: "Mavsum davomiyligi",
                          hintTextColor: AppColors.appColorGrey400,
                          prefixIcon: UniconsLine.calendar_alt,
                          iconSize: 25,
                          keyboardType: TextInputType.number,
                          inputFormatters: [AppTextInputFormatter()],
                        ),
                        const SizedBox(height: 5),
                        _startDate != null || _endDate != null
                            ? Container(
                                height: 30,
                                width: 300,
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: AppColors.appColorGreen400.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${formatDate(_startDate)}  -  ${formatDate(_endDate)}',
                                      style: TextStyle(color: AppColors.appColorWhite, fontSize: 16),
                                    ),
                                    AppButton(
                                      onTap: () {
                                        setState(() {
                                          _startDate = null;
                                          _endDate = null;
                                        });
                                      },
                                      width: 30,
                                      child: Icon(Icons.close_rounded, color: AppColors.appColorWhite, size: 20),
                                    )
                                  ],
                                ),
                              )
                            : const SizedBox(),
                        const SizedBox(height: 5),
                        AppInputUnderline(
                          hintText: "Izoh",
                          controller: _descriptionController,
                          maxLines: 3,
                          hintTextColor: AppColors.appColorGrey400,
                          prefixIcon: UniconsLine.comment_alt,
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
                              onTap: createNewSeason,
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
                      _showAddSeason = true;
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
                          Icon(UniconsLine.umbrella, color: AppColors.appColorGreen400, size: 40),
                          Icon(Icons.add_rounded, color: AppColors.appColorGreen400, size: 25),
                        ],
                      ),
                      Text("Mavsum kiritish", style: TextStyle(color: AppColors.appColorWhite, fontSize: 22))
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  void _clearFields() {
    _nameController.clear();
    _startDate = null;
    _endDate = null;
    _descriptionController.clear();
  }
}
