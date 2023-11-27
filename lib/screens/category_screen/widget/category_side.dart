import 'package:easy_sell/widgets/app_input_underline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../database/my_database.dart';
import '../../../utils/utils.dart';
import '../../../widgets/app_button.dart';
import 'category_add_dialog.dart';
import 'category_list_item.dart';
import 'package:flutter_treeview/flutter_treeview.dart' as tree;

class CategorySide extends StatefulWidget {
  const CategorySide({
    super.key,
    required this.syncCategory,
    required this.loadingCategory,
    required this.getProducts,
    this.hideToolBar,
    required this.setSelectCategory,
  });

  final bool loadingCategory;
  final Future Function() syncCategory;
  final void Function(int categoryId) getProducts;
  final bool? hideToolBar;
  final Null Function(CategoryData? category) setSelectCategory;

  @override
  State<CategorySide> createState() => _CategorySideState();
}

class _CategorySideState extends State<CategorySide> {
  MyDatabase database = Get.find<MyDatabase>();
  tree.TreeViewController _treeViewController = tree.TreeViewController();
  List<tree.Node> _category = [];

  Future<List<tree.Node>> _getCategory({int? parentId, String search = ''}) async {
    List<CategoryData> categoryData = await database.categoryDao.getAllCategoriesById(parentId: parentId);
    List<tree.Node> category = [];
    for (CategoryData item in categoryData) {
      List<tree.Node> children = await _getCategory(parentId: item.id);
      category.add(
        tree.Node(
          parent: children.isNotEmpty,
          key: item.id.toString(),
          label: item.name,
          data: item,
          children: children,
        ),
      );
    }
    return category;
  }

  void initCategory({String search = ''}) async {
    List<tree.Node> category = await _getCategory(search: search);
    setState(() {
      _category = category;
      _treeViewController = tree.TreeViewController(children: _category);
    });
  }

  void createNewCategory() async {
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
                  code: toValue(groupCode));
              await database.categoryDao.createCategoryWithCompanion(newCategory);
              await widget.syncCategory();
              initCategory();
              Get.back();
            } catch (e) {
              if (context.mounted) {
                showAppSnackBar(context, 'Xatolik yuz berdi', 'OK', isError: true);
              }
            }
          }),
    );
  }

  CategoryData? selectedCategory;
  bool isOpen = true;
  bool isExpandAll = false;

  void toggleTreeView() {
    setState(() {
      selectedCategory = null;
      if (isExpandAll) {
        _treeViewController = _treeViewController.copyWith(children: _category, selectedKey: null);
      } else {
        _treeViewController = _treeViewController.copyWith(children: _category.map((e) => e.copyWith(expanded: true)).toList());
      }
      isExpandAll = !isExpandAll;
    });
  }

  @override
  void initState() {
    super.initState();
    initCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Column(
        children: [
          widget.hideToolBar ?? false
              ? const SizedBox()
              : Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    color: Colors.black.withOpacity(0.8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppButton(
                          onTap: createNewCategory,
                          width: 150,
                          height: 60,
                          color: AppColors.appColorGreen400,
                          borderRadius: BorderRadius.circular(10),
                          hoverRadius: BorderRadius.circular(10),
                          child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Text('Kategoriya Qo\'shish', style: TextStyle(color: Colors.white)),
                          ]),
                        ),
                        SizedBox(
                          width: 300,
                          child: AppInputUnderline(
                            hintText: 'Qidirish',
                            prefixIcon: Icons.search,
                            onChanged: (String search) async {
                              List<CategoryData> categoryData = await database.categoryDao.searchByName(search: search);
                              List<tree.Node> category = [];
                              for (CategoryData item in categoryData) {
                                List<tree.Node> children = await _getCategory(parentId: item.id);
                                category.add(
                                  tree.Node(
                                    parent: children.isNotEmpty,
                                    key: item.id.toString(),
                                    label: item.name,
                                    data: item,
                                    children: children,
                                    expanded: true,
                                  ),
                                );
                              }
                              setState(() {
                                _category = category;
                                _treeViewController = _treeViewController.copyWith(children: _category);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          Expanded(
            flex: 16,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.appColorBlackBgHover,
              ),
              child: widget.loadingCategory
                  ? Center(child: CircularProgressIndicator(color: AppColors.appColorWhite))
                  : _category.isEmpty
                      ? Center(child: Text('Kategoriya mavjud emas', style: TextStyle(color: AppColors.appColorWhite)))
                      : tree.TreeView(
                          physics: const BouncingScrollPhysics(),
                          controller: _treeViewController,
                          nodeBuilder: (context, node) {
                            return Draggable<CategoryData>(
                              data: node.data as CategoryData,
                              dragAnchorStrategy: childDragAnchorStrategy,
                              feedback: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.folder_rounded, color: Colors.orangeAccent, size: 40),
                              ),
                              child: DragTarget<CategoryData>(
                                builder: (context, candidateData, rejectedData) {
                                  return CategoryListItem(
                                    hideToolBar: widget.hideToolBar,
                                    treeViewController: _treeViewController,
                                    syncCategory: () async {
                                      await widget.syncCategory();
                                      initCategory();
                                    },
                                    setTreeViewControllerState: (List<tree.Node> updated) {
                                      setState(() {
                                        _treeViewController =
                                            _treeViewController.copyWith(children: updated, selectedKey: node.key);
                                      });
                                    },
                                    node: node,
                                    callback: (CategoryData category) {
                                      widget.getProducts(category.id);
                                      widget.setSelectCategory(category);
                                      setState(() {
                                        _treeViewController = _treeViewController.copyWith(
                                          children: _category,
                                          selectedKey: node.key,
                                        );
                                      });
                                    },
                                  );
                                },
                                onWillAccept: (CategoryData? data) {
                                  return true;
                                },
                                onAccept: (CategoryData? data) async {
                                  try {
                                    if (data == null) return;
                                    if (data.id == (node.data as CategoryData).id) return;
                                    CategoryData draggedCategory = data;
                                    CategoryData droppedCategory = node.data as CategoryData;
                                    int? parentId = droppedCategory.id;
                                    if (droppedCategory.id == -1) {
                                      parentId = null;
                                    }
                                    CategoryData updatedCategory = draggedCategory.copyWith(
                                      parentId: toValue(parentId),
                                      updatedAt: DateTime.now(),
                                    );
                                    await database.categoryDao.updateCategory(updatedCategory);
                                    await widget.syncCategory();
                                    initCategory();
                                    _treeViewController.expandToNode(selectedCategory?.id.toString() ?? "");
                                  } catch (e) {
                                    if (context.mounted) {
                                      showAppSnackBar(context, 'Xatolik yuz berdi', 'OK', isError: true);
                                    }
                                  }
                                },
                              ),
                            );
                          },
                          theme: const tree.TreeViewTheme(
                            expanderTheme: tree.ExpanderThemeData(
                              type: tree.ExpanderType.none,
                              modifier: tree.ExpanderModifier.squareOutlined,
                              position: tree.ExpanderPosition.start,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
            ),
          ),
        ],
      ),
    );
  }
}
