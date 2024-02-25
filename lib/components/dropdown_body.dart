import 'package:flutter/material.dart';
import 'package:searchable_dropdown/models/dropdown_body_box.dart';
import 'package:searchable_dropdown/models/dropdown_scroll_notification.dart';

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
        width: dropdownBodyBox.width,
        height: dropdownBodyBox.height,
        color: Colors.white,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: dropdownBodyBox.offset.dy,
      left: dropdownBodyBox.offset.dx,
      child: defaultContainer(
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
