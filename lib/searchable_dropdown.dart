import 'package:flutter/material.dart';
import 'package:searchable_dropdown/components/dropdown_body.dart';

import 'package:searchable_dropdown/components/dropdown_header.dart';
import 'package:searchable_dropdown/models/dropdown_body_box.dart';
import 'package:searchable_dropdown/models/dropdown_header_options.dart';
import 'package:searchable_dropdown/models/dropdown_menu_button_options.dart';
import 'package:searchable_dropdown/models/dropdown_option.dart';
import 'package:searchable_dropdown/models/dropdown_scroll_notification.dart';

import 'components/dropdown_menu_button.dart';

const defaultHeaderOptions = DrodownHeaderOptions(
  isSearchable: true,
  runSpacing: 8.0,
  spacing: 8.0,
  inputDecoration: InputDecoration(),
);

const defaultItemExtent = 40.0;

typedef HeaderItemBuilder<T> = Widget Function(
    DropdownOption<T> option, void Function(DropdownOption<T> option) remove);

class SearchableDropdown<T> extends StatefulWidget {
  final List<DropdownOption<T>> options;
  final List<DropdownOption<T>> initialValues;
  final DrodownHeaderOptions drodownHeaderOptions;
  final void Function(List<DropdownOption<T>> selectedOption) onChanged;
  final bool Function(DropdownOption<T> option, String searhString)?
      searchFunction;
  final double itemExtent;

  final HeaderItemBuilder<T>? headerItemBuilder;
  final double? popupHeight;

  const SearchableDropdown({
    Key? key,
    required this.options,
    required this.initialValues,
    required this.onChanged,
    this.searchFunction,
    this.popupHeight,
    this.itemExtent = defaultItemExtent,
    this.headerItemBuilder,
    this.drodownHeaderOptions = defaultHeaderOptions,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => SearchableDropdownState();
}

class SearchableDropdownState<T> extends State<SearchableDropdown<T>>
    with WidgetsBindingObserver {
  late final OverlayPortalController _popupController;
  late Map<int, DropdownOption<T>> _options;
  late final TextEditingController _searchController;
  ScrollNotificationObserverState? _scrollNotificationObserverState;
  late final FocusNode _searchFocus;

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (_popupController.isShowing) {
      _popupController.hide();
    }
  }

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
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _searchController.removeListener(onType);
    _searchController.dispose();
    _searchFocus.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _scrollNotificationObserverState?.removeListener(onScrollNotification);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _scrollNotificationObserverState =
        ScrollNotificationObserver.maybeOf(context);
    _scrollNotificationObserverState?.addListener(onScrollNotification);
    super.didChangeDependencies();
  }

  void onScrollNotification(ScrollNotification notification) {
    if (notification is DropdownScrollNotification) {
      return;
    }

    if (notification is ScrollStartNotification && mounted) {
      if (_popupController.isShowing) {
        _popupController.hide();
      }
    }
  }

  bool isPointerInsideMenu(BuildContext context, Offset globalPoint) {
    final (offset, width, popupHeight) = _getGlobalPosition(context);

    return globalPoint.dx >= offset.dx &&
        globalPoint.dx <= (offset.dx + width) &&
        globalPoint.dy >= offset.dy &&
        globalPoint.dy <= (offset.dy + popupHeight);
  }

  void onType() {
    if (!_popupController.isShowing) {
      _popupController.show();
    }
  }

  Widget _defaultHeaderBuilder(
    DropdownOption<T> option,
    void Function(DropdownOption<T> option) remove,
  ) {
    return InputChip(
      label: option.labelBuilder(option.value),
      onDeleted: widget.drodownHeaderOptions.inputDecoration.enabled
          ? () => remove(option)
          : null,
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
          (option) =>
              widget.searchFunction?.call(option, searchString) ??
              option.value.toString().toLowerCase().contains(
                    searchString,
                  ),
        )
        .map((option) =>
            option.menuItemBuilder?.call(
              DropdownMenuButtonOptions(
                  isSelected: _options.containsKey(option.value.hashCode),
                  onTap: () {
                    {
                      _options.putIfAbsent(option.value.hashCode, () {
                        _searchController.clear();
                        return option;
                      });
                      _popupController.hide();
                      setState(() {});
                    }
                  }),
            ) ??
            DropdownMenuButton(
              isSelected: _options.containsKey(option.value.hashCode),
              onTap: () {
                _options.putIfAbsent(option.value.hashCode, () {
                  _searchController.clear();
                  return option;
                });
                _popupController.hide();
                setState(() {});
              },
              child: option.labelBuilder.call(option.value),
            ))
        .toList();
  }

  @override
  void didUpdateWidget(covariant SearchableDropdown<T> oldWidget) {
    _options = {
      for (var option in widget.initialValues) option.value.hashCode: option
    };
    super.didUpdateWidget(oldWidget);
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
                dropdownBodyBox: DropdownBodyBox(
                  offset: offset,
                  width: width,
                  height: popupHeight,
                  itemExtent: widget.itemExtent,
                ),
                options: options,
                parentFocus: _searchFocus,
              );
            });
      },
      child: TapRegion(
          onTapOutside: (event) {
            if (_popupController.isShowing &&
                !isPointerInsideMenu(context, event.position)) {
              _popupController.hide();
            }
          },
          child: DropdownHeader(
            inputDecoration: widget.drodownHeaderOptions.inputDecoration,
            isSearchable: widget.drodownHeaderOptions.isSearchable,
            runSpacing: widget.drodownHeaderOptions.runSpacing,
            spacing: widget.drodownHeaderOptions.spacing,
            searchFieldBuilder: widget.drodownHeaderOptions.searchFieldBuilder,
            focusNode: _searchFocus,
            selectedOptions: _options.values
                .map((option) =>
                    widget.headerItemBuilder?.call(option, onRemove) ??
                    _defaultHeaderBuilder(option, onRemove))
                .toList(),
            onTap: _popupController.toggle,
            searchController: _searchController,
          )),
    );
  }
}
