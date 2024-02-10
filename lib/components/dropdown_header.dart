import 'package:flutter/material.dart';
import 'package:searchable_dropdown/models/dropdown_option.dart';

class DropdownHeader<T> extends StatefulWidget {
  final List<DropdownOption<T>> selectedOptions;
  final VoidCallback onTap;
  final TextEditingController searchController;

  const DropdownHeader({
    super.key,
    required this.selectedOptions,
    required this.onTap,
    required this.searchController,
  });

  @override
  State<DropdownHeader<T>> createState() => _DropdownHeaderState<T>();
}

class _DropdownHeaderState<T> extends State<DropdownHeader<T>> {
  late final FocusNode _searchFocus;

  @override
  void initState() {
    _searchFocus = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      containedInkWell: true,
      radius: 0.1,
      onTap: () {
        widget.onTap();
        if (!_searchFocus.hasFocus) {
          _searchFocus.requestFocus();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: Wrap(
          direction: Axis.horizontal,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ...widget.selectedOptions
                .map((option) => option.labelBuilder(option.value)),
            TextField(
              controller: widget.searchController,
              focusNode: _searchFocus,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero.copyWith(left: 16),
                  constraints:
                      const BoxConstraints(maxWidth: 120, maxHeight: 100),
                  suffix: null,
                  prefix: null,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  isDense: true),
            )
          ],
        ),
      ),
    );
  }
}
