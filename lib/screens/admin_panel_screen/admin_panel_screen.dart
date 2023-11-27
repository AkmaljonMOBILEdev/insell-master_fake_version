import 'package:easy_sell/screens/admin_panel_screen/inner_widgets/screen/employee_screen/employee_screen.dart';
import 'package:easy_sell/screens/admin_panel_screen/inner_widgets/screen/organization_screen/organization_screen.dart';
import 'package:easy_sell/screens/admin_panel_screen/inner_widgets/screen/pos_screen/pos_screen.dart';
import 'package:easy_sell/screens/admin_panel_screen/inner_widgets/screen/region_screen/region_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';
import '../../constants/colors.dart';
import '../../database/my_database.dart';
import '../../widgets/app_button.dart';
import 'inner_widgets/screen/shop_screen/shop_screen.dart';
import 'inner_widgets/screen/user_screen/user_screen.dart';
import 'inner_widgets/upload_product.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  Widget innerWidget = Expanded(
    child: Center(
      child: Text('Yon Paneldan Tanlang', style: TextStyle(color: AppColors.appColorWhite, fontSize: 20)),
    ),
  );
  int? activeIndex;

  @override
  Widget build(BuildContext context) {
    List<SettingListItem> getSettingsItems = [
      SettingListItem(
        icon: Icons.drive_folder_upload,
        title: 'Yuklash',
        onTap: () {
          setState(() {
            activeIndex = 0;
            innerWidget = const UploadProductWidget();
          });
        },
      ),
      SettingListItem(
        icon: Icons.work_rounded,
        title: 'Organizatsiyalar',
        onTap: () {
          setState(() {
            activeIndex = 1;
            innerWidget = const OrganizationScreen();
          });
        },
      ),
      SettingListItem(
        icon: Icons.add_location_alt_outlined,
        title: 'Regionlar',
        onTap: () {
          setState(() {
            activeIndex = 2;
            innerWidget = RegionSide(
              setSelectedRegion: (RegionData? data) {},
            );
          });
        },
      ),
      SettingListItem(
        icon: Icons.shopping_bag_outlined,
        title: 'Do\'konlar',
        onTap: () {
          setState(() {
            activeIndex = 3;
            innerWidget = const ShopScreen();
          });
        },
      ),
      SettingListItem(
        icon: Icons.point_of_sale,
        title: 'Kassalar',
        onTap: () {
          setState(() {
            activeIndex = 4;
            innerWidget = const PosScreen();
          });
        },
      ),
      SettingListItem(
        icon: Icons.supervised_user_circle_rounded,
        title: 'Xodimlar',
        onTap: () {
          setState(() {
            activeIndex = 5;
            innerWidget = const EmployeeScreen();
          });
        },
      ),
      SettingListItem(
        icon: Icons.verified_user,
        title: 'Foydalanuvchilar',
        onTap: () {
          setState(() {
            activeIndex = 6;
            innerWidget = const UserScreen();
          });
        },
      ),
    ];
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black12,
        leading: AppButton(
          onTap: () => Get.back(),
          width: 50,
          height: 50,
          margin: const EdgeInsets.all(7),
          color: AppColors.appColorGrey700.withOpacity(0.5),
          hoverColor: AppColors.appColorGreen300,
          colorOnClick: AppColors.appColorGreen700,
          splashColor: AppColors.appColorGreen700,
          borderRadius: BorderRadius.circular(13),
          hoverRadius: BorderRadius.circular(13),
          child: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.appColorWhite),
        ),
        title: Text('Sozlamalar', style: TextStyle(color: AppColors.appColorWhite)),
        centerTitle: false,
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        padding: const EdgeInsets.only(right: 10, left: 10, bottom: 10, top: 65),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xFF26525f), Color(0xFF0f2228)],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.appColorBlackBg,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(0),
                              itemCount: getSettingsItems.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  color: activeIndex == index ? AppColors.appColorGrey700 : AppColors.appColorGrey700.withOpacity(0.3),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                  margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                                  child: getSettingsItems[index],
                                );
                              },
                            ),
                          ),
                          VerticalDivider(color: AppColors.appColorGrey700, thickness: 1, width: 0),
                          Flexible(
                            flex: 4,
                            child: Column(
                              children: [
                                innerWidget,
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function onTap;
  final bool? isLink;
  final bool? canSee;

  const SettingListItem({super.key, required this.icon, required this.title, required this.onTap, this.isLink = false, this.canSee = false});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      hoverColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      leading: Icon(icon, color: Colors.white, size: 20),
      title: Text(title, style: TextStyle(color: AppColors.appColorWhite, fontSize: 14)),
      trailing: Icon(isLink == true ? UniconsLine.external_link_alt : Icons.keyboard_arrow_right, color: AppColors.appColorWhite, size: 16),
      onTap: () => onTap(),
    );
  }
}
