import 'package:flutter/material.dart';
import 'package:searchable_dropdown/models/dropdown_body_info.dart';

class DropdownBody extends StatelessWidget {
  final DropdownBodyInfo dropdownBodyInfo;
  final List<Widget> options;

  const DropdownBody({
    super.key,
    required this.dropdownBodyInfo,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: dropdownBodyInfo.offset.dy,
      left: dropdownBodyInfo.offset.dx,
      child: SizedBox(
        width: dropdownBodyInfo.width,
        height: dropdownBodyInfo.height,
        child: CustomScrollView(
          slivers: [
            SliverFixedExtentList(
              itemExtent: dropdownBodyInfo.itemExtent,
              delegate: SliverChildListDelegate(options),
            )
          ],
        ),
      ),
    );
  }
}
