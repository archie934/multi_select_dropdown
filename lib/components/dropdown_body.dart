import 'package:flutter/material.dart';
import 'package:searchable_dropdown/models/dropdown_body_box.dart';

class DropdownBody extends StatelessWidget {
  final DropdownBodyBox dropdownBodyInfo;
  final FocusNode parentFocus;
  final List<Widget> options;

  const DropdownBody({
    super.key,
    required this.dropdownBodyInfo,
    required this.options,
    required this.parentFocus,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: dropdownBodyInfo.offset.dy,
      left: dropdownBodyInfo.offset.dx,
      child: SizedBox(
        width: dropdownBodyInfo.width,
        height: dropdownBodyInfo.height,
        child: FocusScope(
            autofocus: true,
            parentNode: parentFocus,
            child: CustomScrollView(
              slivers: [
                SliverFixedExtentList(
                  itemExtent: dropdownBodyInfo.itemExtent,
                  delegate: SliverChildListDelegate(options),
                )
              ],
            )),
      ),
    );
  }
}
