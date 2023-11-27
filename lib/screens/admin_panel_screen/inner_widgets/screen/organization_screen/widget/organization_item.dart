import 'package:easy_sell/screens/admin_panel_screen/inner_widgets/screen/organization_screen/widget/organization_edit.dart';
import 'package:easy_sell/widgets/app_table_item.dart';
import 'package:flutter/material.dart';

import '../../../../../../database/model/organization_dto.dart';

class OrganizationItem extends StatefulWidget {
  const OrganizationItem({super.key, required this.organization, required this.reload});

  final OrganizationDto organization;
  final void Function(VoidCallback fn) reload;

  @override
  State<OrganizationItem> createState() => _OrganizationItemState();
}

class _OrganizationItemState extends State<OrganizationItem> {
  @override
  Widget build(BuildContext context) {
    return AppTableItems(
      hideBorder: false,
      height: 50,
      items: [
        AppTableItemStruct(
          innerWidget: Center(child: Text(widget.organization.name ?? '', style: const TextStyle(color: Colors.white, fontSize: 16))),
        ),
        AppTableItemStruct(
          innerWidget: Center(child: Text(widget.organization.address ?? '', style: const TextStyle(color: Colors.white, fontSize: 16))),
        ),
        AppTableItemStruct(
          innerWidget: Center(child: Text(widget.organization.type.toString(), style: const TextStyle(color: Colors.white, fontSize: 16))),
        ),
        AppTableItemStruct(
          // edit
          innerWidget: IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => OrganizationEditButton(
                  organization: widget.organization,
                  reload: widget.reload,
                ),
              );
            },
            icon: const Icon(Icons.edit, color: Colors.white),
            iconSize: 18,
          ),
        ),
      ],
    );
  }
}
