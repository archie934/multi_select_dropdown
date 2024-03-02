import 'package:flutter/material.dart';

import '../models/dropdown_body_box.dart';
import 'dropdown_body_animation.dart';

class DropdownBody extends StatelessWidget {
  final DropdownBodyBox dropdownBodyBox;
  final FocusNode parentFocus;
  final List<Widget> options;

  const DropdownBody({
    super.key,
    required this.dropdownBodyBox,
    required this.options,
    required this.parentFocus,
  });

  Widget defaultContainer({required Widget child}) {
    if (dropdownBodyBox.containerBuilder != null) {
      return dropdownBodyBox.containerBuilder!.call(
        dropdownBodyBox: dropdownBodyBox,
        bodyList: child,
      );
    }

    return DrodownBodyAnimation(
      child: Container(
        width: dropdownBodyBox.boxInfo.width,
        height: dropdownBodyBox.boxInfo.height,
        color: Colors.white,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return defaultContainer(
      child: FocusScope(
        autofocus: true,
        parentNode: parentFocus,
        child: CustomScrollView(
          primary: true,
          slivers: [
            SliverFixedExtentList(
              itemExtent: dropdownBodyBox.itemExtent,
              delegate: SliverChildListDelegate(options),
            )
          ],
        ),
      ),
    );
  }
}
