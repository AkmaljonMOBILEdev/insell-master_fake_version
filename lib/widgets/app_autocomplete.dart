import 'package:easy_sell/constants/colors.dart';
import 'package:flutter/material.dart';

class AppAutoComplete extends StatefulWidget {
  const AppAutoComplete({
    super.key,
    required this.getValue,
    required this.options,
    required this.hintText,
    this.prefixIcon,
    this.initialValue,
    this.suffixIcon, this.borderBottom,
  });

  final Function(AutocompleteDataStruct selected) getValue;
  final List<AutocompleteDataStruct> options;
  final String hintText;
  final IconData? prefixIcon;
  final String? initialValue;
  final IconButton? suffixIcon;
  final bool? borderBottom;

  @override
  State<AppAutoComplete> createState() => _AppAutoCompleteState();
}

class _AppAutoCompleteState extends State<AppAutoComplete> {
  final SearchController _searchController = SearchController();

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.initialValue ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 10,
          child: Container(
            decoration: BoxDecoration(
              border: widget.borderBottom == null ? Border(bottom: BorderSide(color: AppColors.appColorGrey700)) : null// Border(bottom: BorderSide(color: AppColors.appColorGrey700)),
            ),
            child: SearchAnchor(
              searchController: _searchController,
              viewBackgroundColor: AppColors.appColorBlackBg,
              headerHintStyle: const TextStyle(color: Colors.white),
              dividerColor: AppColors.appColorGrey700,
              headerTextStyle: const TextStyle(color: Colors.white),
              viewLeading: IconButton(
                onPressed: () => _searchController.closeView(''),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              viewSide: const BorderSide(color: Colors.grey),
              viewSurfaceTintColor: AppColors.appColorBlackBg,
              builder: (BuildContext context, SearchController controller) {
                return SearchBar(
                  textStyle: MaterialStateProperty.all(const TextStyle(color: Colors.white)),
                  surfaceTintColor: MaterialStateProperty.all(AppColors.appColorBlackBg),
                  backgroundColor: MaterialStateProperty.all(Colors.transparent),
                  constraints: const BoxConstraints(minHeight: 40),
                  controller: controller,
                  onChanged: (_) => controller.openView(),
                  onTap: () => controller.openView(),
                  leading: widget.prefixIcon == null ? null : Icon(widget.prefixIcon, color: AppColors.appColorGrey400),
                  hintText: widget.hintText,
                  elevation: MaterialStateProperty.all(0),
                  hintStyle: MaterialStateProperty.all(const TextStyle(color: Colors.white)),
                );
              },
              suggestionsBuilder: (BuildContext context, SearchController controller) {
                return widget.options
                    .where((element) => element.value.toLowerCase().contains(controller.text.toLowerCase()))
                    .map((e) => Column(
                          children: [
                            ListTile(
                              onTap: () {
                                controller.closeView(e.value);
                                widget.getValue(e);
                              },
                              title: Text(e.value, style: const TextStyle(color: Colors.white)),
                            ),
                            Divider(color: AppColors.appColorGrey700, height: 0, thickness: 1)
                          ],
                        ))
                    .toList();
              },
              viewElevation: 0,
              viewHintText: widget.hintText,
              viewTrailing: [
                IconButton(
                  onPressed: () {
                    _searchController.closeView('');
                    widget.getValue(AutocompleteDataStruct(value: '', uniqueId: -1));
                  },
                  icon: const Icon(Icons.close, color: Colors.white),
                )
              ],
            ),
          ),
        ),
        if (widget.suffixIcon != null) Expanded(flex: 1, child: widget.suffixIcon ?? Container()),
      ],
    );
  }
}

class AutocompleteDataStruct {
  final String value;
  final int uniqueId;

  AutocompleteDataStruct({required this.value, required this.uniqueId});

  @override
  String toString() {
    return 'value: $value, uniqueId: $uniqueId';
  }
}
