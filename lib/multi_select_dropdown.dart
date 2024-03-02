library multi_select_dropdown;

import 'dart:async';

import 'package:flutter/material.dart';

import 'components/dropdown_body.dart';
import 'components/dropdown_header.dart';
import 'components/dropdown_menu_button.dart';
import 'models/dropdown_body_box.dart';
import 'models/dropdown_header_options.dart';
import 'models/dropdown_menu_button_options.dart';
import 'models/dropdown_option.dart';
import 'models/dropdown_scroll_notification.dart';

const defaultHeaderOptions = DropdownHeaderOptions(
  isSearchable: true,
  runSpacing: 8.0,
  spacing: 8.0,
  inputDecoration: InputDecoration(),
);

const defaultItemExtent = 40.0;
const defaultDebounceDuration = Duration(milliseconds: 200);
const defaultMaxItemsBeforeScroll = 5;

typedef HeaderItemBuilder<T> = Widget Function(
    DropdownOption<T> option, void Function(DropdownOption<T> option) remove);

class MultiSelectDropdown<T> extends StatefulWidget {
  final List<DropdownOption<T>> options;
  final List<DropdownOption<T>> initialValues;
  final DropdownHeaderOptions drodownHeaderOptions;
  final void Function(List<DropdownOption<dynamic>> selectedOption) onChanged;
  final bool Function(DropdownOption<T> option, String searhString)?
      searchFunction;
  final Widget Function({
    required DropdownBodyBox dropdownBodyBox,
    required Widget bodyList,
  })? menuContainerBuilder;
  final double itemExtent;
  final int? maxItemsBeforeScroll;

  final HeaderItemBuilder<T>? headerItemBuilder;
  final double? popupHeight;
  final Duration debounceDuration;

  const MultiSelectDropdown(
      {super.key,
      required this.options,
      required this.initialValues,
      required this.onChanged,
      this.searchFunction,
      this.popupHeight,
      this.itemExtent = defaultItemExtent,
      this.headerItemBuilder,
      this.drodownHeaderOptions = defaultHeaderOptions,
      this.menuContainerBuilder,
      this.maxItemsBeforeScroll = defaultMaxItemsBeforeScroll,
      this.debounceDuration = defaultDebounceDuration});

  @override
  State<StatefulWidget> createState() => MultiSelectDropdownState();
}

class MultiSelectDropdownState<T> extends State<MultiSelectDropdown<T>>
    with WidgetsBindingObserver {
  late final OverlayPortalController _popupController;
  late Map<int, DropdownOption<T>> _options;
  late final TextEditingController _searchController;
  ScrollNotificationObserverState? _scrollNotificationObserverState;
  late final FocusNode _searchFocus;
  var _lastOptions = <Widget>[];
  Timer? _debounceTimer;

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
    _searchController.addListener(onSearch);
    _lastOptions = _mapOptions(widget.options);
    _searchController.addListener(_debounceSetOptions);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _searchController.removeListener(onSearch);
    _searchController.removeListener(_debounceSetOptions);
    _searchController.dispose();
    _searchFocus.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _scrollNotificationObserverState?.removeListener(onScrollNotification);
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _scrollNotificationObserverState =
        ScrollNotificationObserver.maybeOf(context);
    _scrollNotificationObserverState?.addListener(onScrollNotification);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant MultiSelectDropdown<T> oldWidget) {
    _options = {
      for (var option in widget.initialValues) option.value.hashCode: option
    };
    super.didUpdateWidget(oldWidget);
  }

  void onScrollNotification(ScrollNotification notification) {
    if (notification is DropdownScrollNotification) {
      return;
    }

    if (notification is ScrollStartNotification && mounted) {
      if (_popupController.isShowing) {
        _searchController.clear();
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

  void onSearch() {
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
    widget.onChanged(_options.values.toList());
    _debounceSetOptions();
  }

  void onAdd(DropdownOption<T> option) {
    _options.putIfAbsent(option.value.hashCode, () {
      _searchController.clear();
      return option;
    });
    _popupController.hide();
    widget.onChanged(_options.values.toList());
    _debounceSetOptions();
  }

  (Offset offset, double width, double popupHeight) _getGlobalPosition(
      BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset globalPosition = renderBox.localToGlobal(Offset.zero);
    final int items = widget.options.length;
    double topPosition = globalPosition.dy + renderBox.size.height;
    final maxItems = widget.maxItemsBeforeScroll!;

    final double popupHeight = widget.popupHeight ??
        (items > maxItems
            ? (maxItems * widget.itemExtent)
            : items * widget.itemExtent);

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

  String formatOption(DropdownOption<T> option) =>
      option.value.toString().replaceAll(' ', '').toLowerCase();

  List<Widget> _mapOptions(Iterable<DropdownOption<T>> options) {
    return options
        .map((option) =>
            option.menuItemBuilder?.call(
              DropdownMenuButtonOptions(
                  isSelected: _options.containsKey(option.value.hashCode),
                  onTap: () {
                    onAdd(option);
                  }),
            ) ??
            DropdownMenuButton(
              isSelected: _options.containsKey(option.value.hashCode),
              onTap: () {
                onAdd(option);
              },
              child: option.labelBuilder.call(option.value),
            ))
        .toList();
  }

  List<Widget> _getOptions(String searchString) {
    final formattedSearch = searchString.replaceAll(' ', '').toLowerCase();
    final filteredOptions = widget.options.where(
      (option) {
        return widget.searchFunction?.call(option, searchString) ??
            formatOption(option).contains(
              formattedSearch,
            );
      },
    );

    return _mapOptions(filteredOptions);
  }

  void _debounceSetOptions() async {
    _debounceTimer?.cancel();

    _debounceTimer = Timer(widget.debounceDuration, () {
      setState(() {
        _lastOptions = _getOptions(_searchController.text);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: _popupController,
      overlayChildBuilder: (_) {
        final (offset, width, popupHeight) = _getGlobalPosition(context);

        return DropdownBody(
          dropdownBodyBox: DropdownBodyBox(
              offset: offset,
              width: width,
              height: popupHeight,
              itemExtent: widget.itemExtent,
              containerBuilder: widget.menuContainerBuilder),
          options: _lastOptions,
          parentFocus: _searchFocus,
        );
      },
      child: TapRegion(
          onTapOutside: (event) {
            if (_popupController.isShowing &&
                !isPointerInsideMenu(context, event.position)) {
              _searchController.clear();
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
