import 'package:easy_sell/screens/category_screen/widget/category_add_dialog.dart';
import 'package:easy_sell/widgets/app_showmenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_treeview/flutter_treeview.dart' as tree;
import 'package:get/get.dart';

import '../../../database/my_database.dart';
import '../../../utils/utils.dart';
import 'change_parent_category.dart';

class CategoryListItem extends StatefulWidget {
  const CategoryListItem(
      {super.key,
      required this.node,
      required this.callback,
      required this.treeViewController,
      required this.syncCategory,
      required this.setTreeViewControllerState,
      this.hideToolBar});

  final tree.Node node;
  final Function callback;
  final tree.TreeViewController treeViewController;
  final void Function() syncCategory;
  final void Function(List<tree.Node> updated) setTreeViewControllerState;
  final bool? hideToolBar;

  @override
  State<CategoryListItem> createState() => _CategoryListItemState();
}

class _CategoryListItemState extends State<CategoryListItem> {
  MyDatabase database = Get.find<MyDatabase>();

  @override
  Widget build(BuildContext context) {
    tree.Node node = widget.node;
    return GestureDetector(
      onSecondaryTapDown: widget.hideToolBar == true
          ? null
          : (TapDownDetails details) {
              List<MenuItemStruct> menuItems = [
                MenuItemStruct(
                    enabled: false,
                    widget: Text(
                      'Kategoriya: ${(node.data as CategoryData).name}',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onTap: null),
                MenuItemStruct(
                  widget: const ListTile(
                    contentPadding: EdgeInsets.zero,
                    minVerticalPadding: 0,
                    leading: Icon(Icons.add, color: Colors.green, size: 16),
                    title: Text("Qo'shish", style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => CategoryAddDialog(
                        category: null,
                        callback: (String name, String description, String groupCode) async {
                          try {
                            CategoryCompanion newCategory = CategoryCompanion(
                              name: toValue(name),
                              description: toValue(description),
                              createdAt: toValue(DateTime.now()),
                              updatedAt: toValue(DateTime.now()),
                              parentId: toValue((node.data as CategoryData).id),
                              code: toValue(groupCode),
                            );
                            await database.categoryDao.createCategoryWithCompanion(newCategory);
                            widget.syncCategory();
                            Get.back();
                          } catch (e) {
                            showAppSnackBar(context, 'Xatolik yuz berdi', 'OK', isError: true);
                          }
                        },
                      ),
                    );
                  },
                ),
                MenuItemStruct(
                  widget: const ListTile(
                    contentPadding: EdgeInsets.zero,
                    minVerticalPadding: 0,
                    leading: Icon(Icons.edit, color: Colors.orangeAccent, size: 16),
                    title: Text("Tahrirlash", style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => CategoryAddDialog(
                        category: node.data as CategoryData,
                        callback: (String name, String description, String code) async {
                          try {
                            CategoryData currentCategory = node.data as CategoryData;
                            CategoryData updatedCategory = currentCategory.copyWith(
                              name: name,
                              description: toValue(description),
                              updatedAt: DateTime.now(),
                              code: toValue(code),
                            );
                            await database.categoryDao.updateCategory(updatedCategory);
                            widget.syncCategory();
                            Get.back();
                          } catch (e) {
                            showAppSnackBar(context, 'Xatolik yuz berdi', 'OK', isError: true);
                          }
                        },
                      ),
                    );
                  },
                ),
                MenuItemStruct(
                  widget: const ListTile(
                    contentPadding: EdgeInsets.zero,
                    minVerticalPadding: 0,
                    leading: Icon(Icons.drive_file_move_outline, color: Colors.cyan, size: 16),
                    title: Text("Ko'chirish", style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => CategoryParentDialog(
                        callback: (CategoryData? selectedCategory) async {
                          try {
                            CategoryData currentCategory = node.data as CategoryData;
                            CategoryData updatedCategory = currentCategory.copyWith(
                              updatedAt: DateTime.now(),
                              parentId: toValue(selectedCategory?.id),
                            );
                            await database.categoryDao.updateCategory(updatedCategory);
                            widget.syncCategory();
                            Get.back();
                          } catch (e) {
                            showAppSnackBar(context, 'Xatolik yuz berdi', 'OK', isError: true);
                          }
                        },
                      ),
                    );
                  },
                ),
              ];
              showAppMenu(context, menuItems, top: details.globalPosition.dy, left: details.globalPosition.dx);
            },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.white.withOpacity(0.2)),
          ),
        ),
        child: ListTile(
          leading: Icon(node.parent ? Icons.folder_special_rounded : Icons.folder_rounded, color: Colors.orangeAccent),
          title: Text(node.label, style: const TextStyle(color: Colors.white)),
          subtitle: Text((node.data as CategoryData).code ?? "", style: const TextStyle(color: Colors.white)),
          onTap: () async {
            widget.callback(node.data as CategoryData);
            tree.Node? currentNode = widget.treeViewController.getNode(node.key);
            if (currentNode != null) {
              List<tree.Node> updated =
                  widget.treeViewController.updateNode(node.key, currentNode.copyWith(expanded: !currentNode.expanded));
              widget.setTreeViewControllerState(updated);
            }
          },
        ),
      ),
    );
  }
}
