import 'package:flutter/material.dart';
import 'package:searchable_dropdown/models/dropdown_body_box.dart';

import '../models/dropdown_scroll_notification.dart';

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

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: dropdownBodyBox.offset.dy,
      left: dropdownBodyBox.offset.dx,
      child: SizedBox(
        width: dropdownBodyBox.width,
        height: dropdownBodyBox.height,
        child: FocusScope(
          autofocus: true,
          parentNode: parentFocus,
          child: NotificationListener(
            onNotification: (notification) {
              if (notification is ScrollNotification) {
                DropdownScrollNotification(
                        metrics: notification.metrics,
                        context: notification.context)
                    .dispatch(context);
              }
              return true;
            },
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
        ),
      ),
    );
  }
}
