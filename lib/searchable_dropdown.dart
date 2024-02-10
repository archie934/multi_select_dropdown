import 'package:flutter/material.dart';

import 'package:searchable_dropdown/components/dropdown_header.dart';
import 'package:searchable_dropdown/models/dropdown_option.dart';

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

class SearchableDropdownState<T>
    extends State<SearchableDropdown<T>> {
  late final OverlayPortalController _popupController;
  late final Map<int, DropdownOption<T>> _options;

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: _popupController.toggle,
      child: DefaultTextStyle(
        style: DefaultTextStyle.of(context).style.copyWith(fontSize: 24),
        child: OverlayPortal(
          controller: _popupController,
          overlayChildBuilder: (_) {
            final (offset, width, popupHeight) = _getGlobalPosition(context);

            return Positioned(
              top: offset.dy,
              left: offset.dx,
              child: Container(
                width: width,
                height: popupHeight,
                color: Colors.amber,
                child: CustomScrollView(
                  slivers: [
                    SliverFixedExtentList(
                      itemExtent: 40,
                      delegate: SliverChildListDelegate(widget.options
                          .map((option) => InkResponse(
                                onTap: () {
                                  _options.putIfAbsent(
                                      option.value.hashCode, () => option);
                                  _popupController.hide();
                                  setState(() {});
                                },
                                child: option.labelBuilder(option.value),
                              ))
                          .toList()),
                    )
                  ],
                ),
              ),
            );
          },
          child: DropdownHeader<T>(
            options: _options.values.toList(),
          ),
        ),
      ),
    );
  }
}
