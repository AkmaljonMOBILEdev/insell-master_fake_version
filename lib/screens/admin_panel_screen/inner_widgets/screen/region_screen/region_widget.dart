import 'package:easy_sell/database/table/region_table.dart';
import 'package:easy_sell/screens/admin_panel_screen/inner_widgets/screen/region_screen/widgets/add_region_dialog.dart';
import 'package:easy_sell/screens/admin_panel_screen/inner_widgets/screen/region_screen/widgets/region_list_item.dart';
import 'package:easy_sell/services/auto_sync.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_treeview/flutter_treeview.dart' as tree;
import 'package:unicons/unicons.dart';

import '../../../../../../constants/colors.dart';
import '../../../../../../database/my_database.dart';
import '../../../../../../utils/utils.dart';
import '../../../../../../widgets/app_button.dart';
import '../../../../sync_screen/syn_enums.dart';

class RegionSide extends StatefulWidget {
  const RegionSide({
    super.key,
    this.hideToolBar,
    required this.setSelectedRegion,
  });

  final Null Function(RegionData? region) setSelectedRegion;
  final bool? hideToolBar;

  @override
  State<RegionSide> createState() => _RegionSideState();
}

class _RegionSideState extends State<RegionSide> {
  MyDatabase database = Get.find<MyDatabase>();
  tree.TreeViewController _treeViewController = tree.TreeViewController();
  List<tree.Node> _region = [];

  Future<List<tree.Node>> _getRegions({int? parentId}) async {
    List<RegionData> regionData = await database.regionDao.getAllRegionsByParentId(parentId: parentId);
    List<tree.Node> region = [];
    for (RegionData item in regionData) {
      List<tree.Node> children = await _getRegions(parentId: item.id);
      region.add(
        tree.Node(
          parent: children.isNotEmpty,
          key: item.id.toString(),
          label: item.name,
          data: item,
          children: children,
        ),
      );
    }
    return region;
  }

  void initRegions() async {
    List<tree.Node> region = await _getRegions();
    setState(() {
      _region = region;
      _treeViewController = tree.TreeViewController(children: _region);
    });
  }

  void createNewRegion() async {
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
                code: toValue(groupCode),
                type: toValue(type),
              );
              await database.regionDao.createRegionWithCompanion(newRegion);
              await syncCategory();
              initRegions();
              Get.back();
            } catch (e) {
              if (context.mounted) {
                showAppSnackBar(context, 'Xatolik yuz berdi', 'OK', isError: true);
              }
            }
          }),
    );
  }

  RegionData? selectedCategory;
  bool isOpen = true;
  bool isExpandAll = false;

  void toggleTreeView() {
    setState(() {
      selectedCategory = null;
      if (isExpandAll) {
        _treeViewController = _treeViewController.copyWith(children: _region, selectedKey: null);
      } else {
        _treeViewController = _treeViewController.copyWith(children: _region.map((e) => e.copyWith(expanded: true)).toList());
      }
      isExpandAll = !isExpandAll;
    });
  }

  @override
  void initState() {
    super.initState();
    initRegions();
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
                          onTap: createNewRegion,
                          width: 150,
                          height: 40,
                          color: AppColors.appColorGreen400,
                          borderRadius: BorderRadius.circular(10),
                          margin: const EdgeInsets.only(top: 5),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(UniconsLine.plus, color: Colors.white, size: 20),
                              SizedBox(width: 10),
                              Text('Qo\'shish', style: TextStyle(color: Colors.white, fontSize: 16)),
                            ],
                          ),
                        ),
                        AppButton(
                          onTap: toggleTreeView,
                          hoverRadius: BorderRadius.circular(10),
                          child: Icon(!isExpandAll ? Icons.open_in_full : Icons.close_fullscreen, color: AppColors.appColorWhite, size: 20),
                        ),
                      ],
                    ),
                  ),
                ),
          Expanded(
            flex: 16,
            child: Container(
              decoration: BoxDecoration(color: AppColors.appColorBlackBgHover),
              child: _region.isEmpty
                  ? Center(child: Text('Region mavjud emas', style: TextStyle(color: AppColors.appColorWhite)))
                  : tree.TreeView(
                      physics: const BouncingScrollPhysics(),
                      controller: _treeViewController,
                      nodeBuilder: (context, node) {
                        return Draggable<RegionData>(
                          data: node.data as RegionData,
                          dragAnchorStrategy: childDragAnchorStrategy,
                          feedback: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.4), borderRadius: BorderRadius.circular(10)),
                            child: const Icon(Icons.location_on_outlined, color: Colors.orangeAccent, size: 40),
                          ),
                          child: DragTarget<RegionData>(
                            builder: (context, candidateData, rejectedData) {
                              return RegionListItem(
                                hideToolBar: widget.hideToolBar,
                                treeViewController: _treeViewController,
                                syncCategory: () async {
                                  await syncCategory();
                                  initRegions();
                                },
                                setTreeViewControllerState: (List<tree.Node> updated) {
                                  setState(() {
                                    _treeViewController = _treeViewController.copyWith(children: updated, selectedKey: node.key);
                                  });
                                },
                                node: node,
                                callback: (RegionData region) {
                                  widget.setSelectedRegion(region);
                                  setState(() {
                                    _treeViewController = _treeViewController.copyWith(
                                      children: _region,
                                      selectedKey: node.key,
                                    );
                                  });
                                },
                              );
                            },
                            onWillAccept: (RegionData? data) {
                              return true;
                            },
                            onAccept: (RegionData? data) async {
                              try {
                                if (data == null) return;
                                if (data.id == (node.data as RegionData).id) return;
                                RegionData draggedCategory = data;
                                RegionData droppedCategory = node.data as RegionData;
                                int? parentId = droppedCategory.id;
                                if (droppedCategory.id == -1) {
                                  parentId = null;
                                }
                                RegionData updatedCategory = draggedCategory.copyWith(
                                  parentId: toValue(parentId),
                                  updatedAt: DateTime.now(),
                                );
                                await database.regionDao.updateRegion(updatedCategory);
                                await syncCategory();
                                initRegions();
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

  Future<void> syncCategory() async {
    await uploadFunctions.autoUpload(UploadTypes.REGIONS);
  }
}
