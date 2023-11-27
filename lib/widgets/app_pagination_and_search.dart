import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'app_button.dart';
import 'app_search_field.dart';

class AppPaginationAndSearchWidget extends StatefulWidget {
  const AppPaginationAndSearchWidget({
    Key? key,
    required this.length,
    required this.nextPage,
    required this.prevPage,
    required this.limit,
    required this.search,
    required this.resultLength,
    this.width,
    this.searchFlex,
    this.anotherWidget,
    this.label,
  }) : super(key: key);
  final int length;
  final Function nextPage;
  final Function prevPage;
  final int limit;
  final Future<void> Function(String searchTerm) search;
  final int resultLength;
  final double? width;
  final int? searchFlex;
  final Widget? anotherWidget;
  final String? label;

  @override
  State<AppPaginationAndSearchWidget> createState() => _AppPaginationAndSearchWidgetState();
}

class _AppPaginationAndSearchWidgetState extends State<AppPaginationAndSearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.appColorBlackBg.withOpacity(0.4),
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: widget.width ?? screenWidth / 1.38 - 26,
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 13),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: const Radius.circular(17),
                bottomLeft: const Radius.circular(17),
                topLeft: Radius.circular(_searchController.text.isNotEmpty ? 0 : 17),
                topRight: Radius.circular(_searchController.text.isNotEmpty ? 0 : 17),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(color: AppColors.appColorBlackBg, borderRadius: BorderRadius.circular(17)),
                    child: AppSearchBar(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      focusedColor: Colors.transparent,
                      searchEngine: (
                        String searchTerm, {
                        bool isEmptySearch = false,
                      }) async {
                        await widget.search(searchTerm);
                      },
                      onEditingComplete: () async {},
                      searchWhenEmpty: true,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 0,
                        child: Text(
                            widget.label != null ? (widget.label ?? '') : 'Jami ${widget.length} dan ${widget.resultLength} ta',
                            style: TextStyle(color: AppColors.appColorWhite)),
                      ),
                      const SizedBox(width: 20),
                      AppButton(
                        onTap: () => widget.prevPage(),
                        width: 30,
                        height: 30,
                        borderRadius: BorderRadius.circular(10),
                        hoverRadius: BorderRadius.circular(10),
                        hoverColor: AppColors.appColorGreen300,
                        child: Center(child: Icon(Icons.arrow_back_ios_rounded, color: AppColors.appColorWhite, size: 23)),
                      ),
                      const SizedBox(width: 10),
                      AppButton(
                        onTap: () => widget.nextPage(),
                        width: 30,
                        height: 30,
                        borderRadius: BorderRadius.circular(10),
                        hoverRadius: BorderRadius.circular(10),
                        hoverColor: AppColors.appColorGreen300,
                        child: Center(child: Icon(Icons.arrow_forward_ios_rounded, color: AppColors.appColorWhite, size: 23)),
                      ),
                      const SizedBox(width: 15),
                      widget.anotherWidget ?? const SizedBox()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
