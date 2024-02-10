import 'dart:async';

import 'package:flutter/material.dart';
import 'package:searchable_dropdown/components/dropdown_body.dart';

import 'package:searchable_dropdown/components/dropdown_header.dart';
import 'package:searchable_dropdown/models/dropdown_body_info.dart';
import 'package:searchable_dropdown/models/dropdown_option.dart';

import 'components/dropdown_menu_button.dart';

class SearchableDropdown<T> extends StatefulWidget {
  final List<DropdownOption<T>> options;
  final List<DropdownOption<T>> initialValues;
  final void Function(List<DropdownOption<T>> selectedOption) onChanged;
  final double itemExtent;
  final double? popupHeight;

  const SearchableDropdown({
    Key? key,
    required this.options,
    required this.initialValues,
    required this.onChanged,
    this.popupHeight,
    this.itemExtent = 40,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => SearchableDropdownState();
}

class SearchableDropdownState<T> extends State<SearchableDropdown<T>> {
  late final OverlayPortalController _popupController;
  late final Map<int, DropdownOption<T>> _options;
  late final TextEditingController _searchController;
  Timer? _debounceSearch;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _options = {
      for (var value in widget.initialValues) value.value.hashCode: value
    };
    _popupController = OverlayPortalController();
  }

  @override
  void didUpdateWidget(SearchableDropdown<T> oldWidget) {
    _options = {
      for (var value in widget.initialValues) value.value.hashCode: value
    };
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  (Offset offset, double width, double popupHeight) _getGlobalPosition(
      BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset globalPosition = renderBox.localToGlobal(Offset.zero);
    final int items = widget.options.length;
    double topPosition = globalPosition.dy + renderBox.size.height;

    final double popupHeight = widget.popupHeight ??
        (items > 5 ? (5 * widget.itemExtent) : items * widget.itemExtent);

    final isPopupMenuAboveHeader =
        topPosition + popupHeight >= MediaQuery.of(context).size.height;

    if (isPopupMenuAboveHeader) {
      topPosition = globalPosition.dy - popupHeight;
    }

    return (
      Offset(globalPosition.dx, topPosition),
      renderBox.size.width,
      popupHeight
    );
  }

  List<Widget> _getOptions(String searchString) {
    return widget.options
        .where(
          (option) => option.value.toString().toLowerCase().contains(
                searchString,
              ),
        )
        .map((option) => DropdownMenuButton(
              isSelected: _options.containsKey(option.value.hashCode),
              onTap: () {
                _options.putIfAbsent(option.value.hashCode, () => option);
                _popupController.hide();
                setState(() {});
              },
              child: option.labelBuilder(option.value),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: _popupController,
      overlayChildBuilder: (_) {
        final (offset, width, popupHeight) = _getGlobalPosition(context);

        return ValueListenableBuilder(
            valueListenable: _searchController,
            builder: (_, textEditingValue, ___) {
              final options = _getOptions(textEditingValue.text);

              return DropdownBody(
                  dropdownBodyInfo: DropdownBodyInfo(
                    offset: offset,
                    width: width,
                    height: popupHeight,
                    itemExtent: widget.itemExtent,
                  ),
                  options: options);
            });
      },
      child: DropdownHeader<T>(
        selectedOptions: _options.values.toList(),
        onTap: _popupController.toggle,
        searchController: _searchController,
      ),
    );
  }
}
