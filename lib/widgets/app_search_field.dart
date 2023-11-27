import 'dart:async';
import 'package:easy_sell/database/my_database.dart';
import 'package:easy_sell/widgets/app_input_underline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';
import '../constants/colors.dart';

class AppSearchBar extends StatefulWidget {
  const AppSearchBar({
    super.key,
    required this.focusNode,
    required this.controller,
    required this.searchEngine,
    this.focusedColor,
    this.onEditingComplete,
    this.padding,
    this.decoration,
    this.searchWhenEmpty = false,
  });

  final FocusNode focusNode;
  final TextEditingController controller;
  final Color? focusedColor;
  final Future<void> Function(
    String searchTerm, {
    bool isEmptySearch,
  }) searchEngine;
  final Future<void> Function()? onEditingComplete;
  final EdgeInsetsGeometry? padding;
  final BoxDecoration? decoration;
  final bool? searchWhenEmpty;

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  MyDatabase database = Get.find<MyDatabase>();
  late TextEditingController _searchController;
  Timer? _debounce;
  bool loading = false;
  String _lastSearchTerm = '';

  @override
  void initState() {
    super.initState();
    _searchController = widget.controller;
  }

  void search(String searchTerm, Future Function(String searchTerm) callBack) {
    _debounce?.cancel();
    if (searchTerm.isEmpty || searchTerm.length <= 1) {
      widget.searchEngine('', isEmptySearch: true);
      if (widget.searchWhenEmpty == false) {
        _lastSearchTerm = '';
        return;
      }
    }
    if (searchTerm == _lastSearchTerm) return;
    _lastSearchTerm = searchTerm;
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      setState(() {
        loading = true;
      });
      await callBack(searchTerm);
      setState(() {
        loading = false;
      });
    });
    widget.focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: widget.padding,
      decoration: widget.decoration,
      child: AppInputUnderline(
        controller: _searchController,
        hintText: 'Qidirish',
        hintTextColor: AppColors.appColorGrey400,
        prefixIcon: UniconsLine.search,
        iconSize: 22,
        iconColor: AppColors.appColorGreen400,
        enableBorderColor: Colors.transparent,
        focusedBorderColor: widget.focusedColor,
        focusNode: widget.focusNode,
        onChanged: (String searchTerm) => search(searchTerm.trim(), widget.searchEngine),
        onEditingComplete: () async {
          if (_searchController.text.isEmpty) return;
          _debounce?.cancel();
          if (widget.onEditingComplete != null) {
            await widget.onEditingComplete!();
          }
        },
        onTapOutside: (PointerDownEvent event) => widget.focusNode.requestFocus(),
      ),
    );
  }
}
