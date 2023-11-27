import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../constants/colors.dart';
import 'app_button.dart';

class AppInputTable extends StatefulWidget {
  const AppInputTable({super.key, required this.callback, required this.defaultFieldsForHeader, this.description});

  final Future<void> Function(List<TableResult>) callback;
  final List<TableField> defaultFieldsForHeader;
  final String? description;

  @override
  State<AppInputTable> createState() => _AppInputTableState();
}

class _AppInputTableState extends State<AppInputTable> {
  final FocusScopeNode dialogFocus = FocusScopeNode();
  int defaultRowCount = 15;

  LinkedList<TableData> dataHistory = LinkedList<TableData>();
  bool loading = false;
  List<TableField> defaultFieldsForHeader = [];
  bool buttonLoading = false;

  @override
  void initState() {
    super.initState();
    dialogFocus.requestFocus();
    defaultFieldsForHeader = widget.defaultFieldsForHeader;
    initEmptyData(defaultFieldsForHeader.length, defaultRowCount);
  }

  void initEmptyData(int colCount, int rowCount) {
    List<List<CellItemStruct>> data = [];
    for (var i = 0; i < rowCount; i++) {
      List<CellItemStruct> row = [];
      for (var j = 0; j < colCount; j++) {
        row.add(CellItemStruct(controller: TextEditingController(), isEditable: false, selected: false));
      }
      data.add(row);
    }
    dataHistory.add(TableData(data: data));
  }

  Future<List<List<TextEditingController>>> getDataFromClipboard() async {
    List<List<TextEditingController>> data = [];
    ClipboardData? clipboardData = await Clipboard.getData('text/plain');
    if (clipboardData != null) {
      String text = clipboardData.text ?? "";
      List<String> rows = text.split('\n');
      for (var row in rows) {
        List<String> cells = row.split('\t');
        if (cells.isNotEmpty) {
          data.add(cells.map((e) => TextEditingController(text: e)).toList());
        }
      }
    }
    return data;
  }

  Future<void> pasteData(int colIndex, int rowIndex) async {
    setState(() {
      loading = true;
    });
    List<List<TextEditingController>> pastedData = await getDataFromClipboard();
    if (pastedData.isEmpty) return;
    for (var i = 0; i < pastedData.length; i++) {
      for (var j = 0; j < pastedData[i].length; j++) {
        try {
          dataHistory.last.data[rowIndex + i][colIndex + j].controller.text = pastedData[i][j].text;
        } catch (e) {
          List<CellItemStruct> newRow = List.generate(defaultFieldsForHeader.length,
              (index) => CellItemStruct(controller: TextEditingController(), selected: false, isEditable: false));
          dataHistory.last.data.add(newRow);
          bool rangeIsValid = rowIndex + i < dataHistory.last.data.length && colIndex + j < newRow.length;
          if (rangeIsValid) {
            dataHistory.last.data[rowIndex + i][colIndex + j].controller.text = pastedData[i][j].text;
          }
          setState(() {
            defaultRowCount = dataHistory.last.data.length;
          });
        }
      }
    }
    setState(() {
      loading = false;
    });
  }

  final ScrollController _xController = ScrollController();
  final ScrollController _yController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      title: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Text(
                      'Ma\'lumot kiritish',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Text(
                      widget.description ?? "",
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.highlight_off_rounded, color: AppColors.appColorRed400, size: 25),
                ),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(color: Colors.white12),
            height: 50,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: defaultFieldsForHeader
                    .map((e) => InkWell(
                          onTap: () {
                            dialogFocus.requestFocus();
                          },
                          child: Container(
                            width: 200,
                            height: 50,
                            decoration: BoxDecoration(
                                border: Border.all(
                              color: Colors.white12,
                              width: 1,
                            )),
                            child: Center(
                              child: Text(
                                e.label ?? "",
                                style: const TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
      content: FocusScope(
        node: dialogFocus,
        autofocus: true,
        onFocusChange: (value) {
          dialogFocus.requestFocus();
        },
        child: Container(
          color: Colors.black,
          child: loading
              ? const Center(child: CircularProgressIndicator(color: Colors.lightBlue))
              : RawScrollbar(
                  thumbVisibility: true,
                  trackVisibility: true,
                  interactive: true,
                  scrollbarOrientation: ScrollbarOrientation.right,
                  thickness: 10,
                  controller: _yController,
                  child: SingleChildScrollView(
                    controller: _yController,
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      controller: _xController,
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        children: dataHistory.last.data.map((row) {
                          return Row(
                            children: row.map((cell) {
                              return CellItem(
                                cell: cell,
                                pasteEvent: () async {
                                  int rowIndex = dataHistory.last.data.indexOf(row);
                                  int columnIndex = row.indexOf(cell);
                                  await pasteData(columnIndex, rowIndex);
                                },
                                inputFormatter: widget.defaultFieldsForHeader[row.indexOf(cell)].inputFormatter,
                              );
                            }).toList(),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: AppButton(
            onTap: () async {
              try {
                setState(() {
                  buttonLoading = true;
                });
                List<TableResult> result = [];
                for (var row in dataHistory.last.data) {
                  if (row.every((element) => element.controller.text.isEmpty)) continue;
                  result.add(TableResult(
                      values: row.map((e) => e.controller.text).toList(),
                      fields: defaultFieldsForHeader.map((e) => e.value ?? "").toList()));
                }
                await widget.callback(result);
                setState(() {
                  buttonLoading = false;
                });
              } catch (e) {
                setState(() {
                  buttonLoading = false;
                });
              }
            },
            width: 120,
            height: 40,
            color: AppColors.appColorGreen400,
            borderRadius: BorderRadius.circular(10),
            child: Center(
                child: buttonLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Saqlash', style: TextStyle(color: Colors.white, fontSize: 18))),
          ),
        ),
      ],
    );
  }
}

class CellItem extends StatefulWidget {
  const CellItem({
    super.key,
    required this.pasteEvent,
    required this.cell,
    this.inputFormatter,
  });

  final CellItemStruct cell;
  final Function() pasteEvent;
  final List<TextInputFormatter>? inputFormatter;

  @override
  State<CellItem> createState() => _CellItemState();
}

class _CellItemState extends State<CellItem> {
  FocusNode focusNode = FocusNode();
  FocusNode focusNodeInkWell = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNodeInkWell.onKey = (node, event) {
      if (event.isControlPressed && event.logicalKey == LogicalKeyboardKey.keyV) {
        widget.pasteEvent();
      }
      return KeyEventResult.handled;
    };
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 200,
        height: 60,
        child: Card(
            margin: EdgeInsets.zero,
            color: Colors.transparent,
            shape: const RoundedRectangleBorder(
              side: BorderSide(color: Colors.white12, width: 1),
            ),
            child: widget.cell.isEditable
                ? TextFormField(
                    focusNode: focusNode,
                    autofocus: true,
                    scrollPadding: EdgeInsets.zero,
                    controller: widget.cell.controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white12,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.all(Radius.zero)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white12,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.all(Radius.zero)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.green,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.all(Radius.zero)),
                    ),
                    inputFormatters: widget.inputFormatter,
                    textInputAction: TextInputAction.next,
                    onTapOutside: (details) {
                      setState(() {
                        widget.cell.isEditable = false;
                        widget.cell.selected = false;
                      });
                    },
                  )
                : InkWell(
                    focusNode: focusNodeInkWell,
                    focusColor: Colors.white12,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      if (widget.cell.selected) {
                        setState(() {
                          widget.cell.isEditable = true;
                        });
                        focusNode.requestFocus();
                      } else {
                        setState(() {
                          widget.cell.selected = true;
                        });
                        focusNodeInkWell.requestFocus();
                      }
                    },
                    onFocusChange: (value) {
                      if (value) {
                        setState(() {
                          widget.cell.selected = true;
                        });
                      } else {
                        setState(() {
                          widget.cell.selected = false;
                        });
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          widget.cell.controller.text,
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ))));
  }
}

class TableField {
  String? label;
  String? value;
  List<TextInputFormatter>? inputFormatter;

  TableField({this.label = "", this.value = "", this.inputFormatter = const []});

  @override
  String toString() {
    return 'label: $label, value: $value';
  }
}

class TableResult {
  List<String> values = [];
  List<String> fields = [];

  TableResult({required this.values, required this.fields});

  @override
  String toString() {
    return 'TableResult(values: $values, fields: $fields)';
  }
}

class TableData extends LinkedListEntry<TableData> {
  List<List<CellItemStruct>> data = [];

  TableData({required this.data});
}

class CellItemStruct {
  TextEditingController controller;
  bool selected;
  bool isEditable;
  List<TextInputFormatter>? inputFormatters;

  CellItemStruct({
    required this.controller,
    required this.selected,
    required this.isEditable,
    this.inputFormatters,
  });
}

class Point {
  int x;
  int y;

  Point(this.x, this.y);

  @override
  String toString() {
    return 'Point(x: $x, y: $y)';
  }
}
