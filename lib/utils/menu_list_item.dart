import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

import '../../../constants/colors.dart';

class MenuListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function onTap;
  final bool? isLink;
  final bool? canSee;

  const MenuListItem({super.key, required this.icon, required this.title, required this.onTap, this.isLink = false, this.canSee = false});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      hoverColor: AppColors.appColorGrey700.withOpacity(0.5),
      leading: Icon(icon, color: Colors.white, size: 20),
      title: Text(title, style: TextStyle(color: AppColors.appColorWhite, fontSize: 14)),
      trailing: Icon(isLink == true ? UniconsLine.external_link_alt : Icons.keyboard_arrow_right, color: AppColors.appColorWhite, size: 16),
      onTap: () => onTap(),
    );
  }
}