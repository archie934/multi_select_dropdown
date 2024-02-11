import 'package:flutter/material.dart';
import 'package:searchable_dropdown/components/dropdown_body.dart';

import 'package:searchable_dropdown/components/dropdown_header.dart';
import 'package:searchable_dropdown/models/dropdown_body_info.dart';
import 'package:searchable_dropdown/models/dropdown_option.dart';

import 'components/dropdown_menu_button.dart';

typedef HeaderItemBuilder<T> = Widget Function(
    DropdownOption<T> option, void Function(DropdownOption<T> option) onRemove);

class SearchableDropdown<T> extends StatefulWidget {
  final List<DropdownOption<T>> options;
  final List<DropdownOption<T>> initialValues;
  final void Function(List<DropdownOption<T>> selectedOption) onChanged;
  final HeaderItemBuilder<T>? headerItemBuilder;
  final double itemExtent;
  final double? popupHeight;

  const SearchableDropdown({
    Key? key,
    required this.options,
    required this.initialValues,
    required this.onChanged,
    this.popupHeight,
    this.itemExtent = 40,
    this.headerItemBuilder,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => SearchableDropdownState();
}

class SearchableDropdownState<T> extends State<SearchableDropdown<T>> {
  late final OverlayPortalController _popupController;
  late final Map<int, DropdownOption<T>> _options;
  late final TextEditingController _searchController;
  late final FocusNode _searchFocus;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _options = {
      for (var option in widget.initialValues) option.value.hashCode: option
    };
    _popupController = OverlayPortalController();
    _searchFocus = FocusNode();
    _searchController.addListener(onType);
  }

  @override
  void didUpdateWidget(SearchableDropdown<T> oldWidget) {
    _options = {
      for (var option in widget.initialValues) option.value.hashCode: option
    };
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _searchController.removeListener(onType);
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void onType() {
    if (!_popupController.isShowing) {
      _popupController.show();
    }
  }

  Widget _defaultHeaderBuilder(
    DropdownOption<T> option,
    void Function(DropdownOption<T> option) onRemove,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        option.optionBuilder(option.value),
        IconButton(
            onPressed: () => onRemove(option),
            icon: const Icon(Icons.cancel_outlined))
      ],
    );
  }

  void onRemove(DropdownOption<T> option) {
    this._options.remove(option.value.hashCode);
    setState(() {});
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
                _options.putIfAbsent(option.value.hashCode, () {
                  _searchController.clear();
                  return option;
                });
                _popupController.hide();
                setState(() {});
              },
              child: option.optionBuilder(option.value),
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
        focusNode: _searchFocus,
        selectedOptions: _options.values
            .map((option) =>
                widget.headerItemBuilder?.call(option, onRemove) ??
                _defaultHeaderBuilder(option, onRemove))
            .toList(),
        onTap: _popupController.toggle,
        searchController: _searchController,
      ),
    );
  }
}
