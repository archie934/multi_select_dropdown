import 'package:flutter/material.dart';

class DropdownHeader<T> extends StatelessWidget {
  final List<Widget> selectedOptions;
  final VoidCallback onTap;
  final TextEditingController searchController;
  final FocusNode focusNode;

  const DropdownHeader({
    super.key,
    required this.selectedOptions,
    required this.onTap,
    required this.searchController,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      containedInkWell: true,
      radius: 0.1,
      onTap: () {
        onTap();
        if (!focusNode.hasFocus) {
          focusNode.requestFocus();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: Wrap(
          direction: Axis.horizontal,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: selectedOptions
            ..add(TextField(
              controller: searchController,
              focusNode: focusNode,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero.copyWith(left: 16),
                  constraints:
                      const BoxConstraints(maxWidth: 120, maxHeight: 100),
                  suffix: null,
                  prefix: null,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  isDense: true),
            )),
        ),
      ),
    );
  }
}
