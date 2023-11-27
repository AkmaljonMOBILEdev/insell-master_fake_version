import 'package:easy_sell/screens/admin_panel_screen/inner_widgets/screen/region_screen/widgets/add_region_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_treeview/flutter_treeview.dart' as tree;
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';

import '../../../../../../constants/colors.dart';
import '../../../../../../database/my_database.dart';
import '../../../../../../database/table/region_table.dart';
import '../../../../../../utils/utils.dart';
import '../../../../../../widgets/app_button.dart';

class RegionListItem extends StatefulWidget {
  const RegionListItem(
      {super.key,
      required this.node,
      required this.callback,
      required this.treeViewController,
      required this.syncCategory,
      required this.setTreeViewControllerState,
      this.hideToolBar,
      this.onAddButton});

  final tree.Node node;
  final Function callback;
  final tree.TreeViewController treeViewController;
  final void Function() syncCategory;
  final void Function(List<tree.Node> updated) setTreeViewControllerState;
  final bool? hideToolBar;
  final void Function(RegionData regionData)? onAddButton;

  @override
  State<RegionListItem> createState() => _RegionListItemState();
}

class _RegionListItemState extends State<RegionListItem> {
  MyDatabase database = Get.find<MyDatabase>();

  @override
  Widget build(BuildContext context) {
    tree.Node node = widget.node;
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.4)))),
      margin: const EdgeInsets.all(10),
      child: ListTile(
        leading: const Icon(Icons.location_on_outlined, color: Colors.orangeAccent),
        title: Text(node.label, style: const TextStyle(color: Colors.white)),
        subtitle: Text((node.data as RegionData).code, style: const TextStyle(color: Colors.white)),
        onTap: () async {
          widget.callback(node.data as RegionData);
          tree.Node? currentNode = widget.treeViewController.getNode(node.key);
          if (currentNode != null) {
            List<tree.Node> updated = widget.treeViewController.updateNode(node.key, currentNode.copyWith(expanded: !currentNode.expanded));
            widget.setTreeViewControllerState(updated);
          }
        },
        trailing: widget.hideToolBar == true
            ? AppButton(
                onTap: () {
                  if (widget.onAddButton != null) widget.onAddButton!(node.data as RegionData);
                },
                width: 28,
                height: 28,
                hoverRadius: BorderRadius.circular(10),
                child: Icon(UniconsLine.user_plus, color: AppColors.appColorWhite, size: 26),
              )
            : IntrinsicWidth(
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AddRegionDialog(
                              region: null,
                              callback: (String name, String groupCode, RegionType type) async {
                                try {
                                  RegionCompanion newRegion = RegionCompanion(
                                    name: toValue(name),
                                    createdAt: toValue(DateTime.now()),
                                    updatedAt: toValue(DateTime.now()),
                                    parentId: toValue((node.data as RegionData).id),
                                    code: toValue(groupCode),
                                    type: toValue(type),
                                  );
                                  await database.regionDao.createRegionWithCompanion(newRegion);
                                  widget.syncCategory();
                                  Get.back();
                                } catch (e) {
                                  showAppSnackBar(context, 'Xatolik yuz berdi', 'OK', isError: true);
                                }
                              },
                            ),
                          );
                        },
                        icon: const Icon(Icons.add_circle_rounded, color: Colors.white)),
                    IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AddRegionDialog(
                              region: node.data as RegionData,
                              callback: (String name, String code, RegionType type) async {
                                try {
                                  RegionData currentCategory = node.data as RegionData;
                                  RegionData updatedCategory = currentCategory.copyWith(
                                    name: name,
                                    updatedAt: DateTime.now(),
                                    code: (code),
                                    type: toValue(type),
                                  );
                                  await database.regionDao.updateRegion(updatedCategory);
                                  widget.syncCategory();
                                  Get.back();
                                } catch (e) {
                                  showAppSnackBar(context, 'Xatolik yuz berdi', 'OK', isError: true);
                                }
                              },
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit_rounded, color: Colors.orangeAccent)),
                  ],
                ),
              ),
      ),
    );
  }
}
