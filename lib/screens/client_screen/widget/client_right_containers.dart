import 'package:easy_sell/screens/client_screen/widget/client_region_side.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';
import '../../../constants/colors.dart';
import '../../../database/my_database.dart';
import 'client_info_dialog.dart';

class ClientRightContainers extends StatefulWidget {
  const ClientRightContainers({Key? key, required this.callback, required this.allClientsLength, required this.getByRegion})
      : super(key: key);
  final VoidCallback callback;
  final void Function(int) getByRegion;
  final int allClientsLength;

  @override
  State<ClientRightContainers> createState() => _ClientRightContainersState();
}

class _ClientRightContainersState extends State<ClientRightContainers> {
  MyDatabase database = Get.find<MyDatabase>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 80,
          width: screenWidth / 3.99,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: AppColors.appColorBlackBg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                leading: Icon(UniconsLine.users_alt, color: AppColors.appColorWhite),
                title: Text('Jami Mijozlar:', style: TextStyle(color: AppColors.appColorWhite)),
                trailing: Text('${widget.allClientsLength}', style: TextStyle(color: AppColors.appColorWhite, fontSize: 18)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Expanded(
          child: Container(
            width: screenWidth / 3.99,
            height: screenHeight / 1.573,
            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                children: [
                  ClientRegionSide(
                    setSelectedRegion: (RegionData? region) {
                      widget.getByRegion(region?.id ?? 0);
                    },
                    hideToolBar: true,
                    onAddButton: (RegionData? regionData) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ClientInfoDialog(
                            callback: widget.callback,
                            regionData: regionData,
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
