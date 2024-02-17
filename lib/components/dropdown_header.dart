import 'package:flutter/material.dart';

class DropdownHeader extends StatelessWidget {
  final List<Widget> selectedOptions;
  final VoidCallback onTap;
  final TextEditingController searchController;
  final FocusNode focusNode;
  final double spacing;
  final double runSpacing;
  final bool isSearchable;
  final InputDecoration inputDecoration;
  final Widget Function(TextEditingController controller, FocusNode focusNode)?
      searchFieldBuilder;

  const DropdownHeader({
    super.key,
    required this.selectedOptions,
    required this.onTap,
    required this.searchController,
    required this.focusNode,
    required this.inputDecoration,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
    this.searchFieldBuilder,
    this.isSearchable = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (inputDecoration.enabled)
          ? () {
              onTap();
              if (!focusNode.hasFocus) {
                focusNode.requestFocus();
              }
            }
          : null,
      child: InputDecorator(
        decoration: inputDecoration,
        child: Wrap(
          direction: Axis.horizontal,
          spacing: spacing,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: !isSearchable ? selectedOptions : selectedOptions
            ..add(
              searchFieldBuilder?.call(searchController, focusNode) ??
                  TextField(
                    controller: searchController,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                        constraints:
                            const BoxConstraints.tightForFinite(width: 200),
                        contentPadding: EdgeInsets.zero.copyWith(left: 16),
                        suffix: null,
                        prefix: null,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        isDense: true),
                  ),
            ),
        ),
      ),
    );
  }
}
