import 'package:flutter/widgets.dart';

class DropdownScrollNotification extends ScrollNotification {
  DropdownScrollNotification({
    required ScrollMetrics metrics,
    required BuildContext? context,
  }) : super(metrics: metrics, context: context);
}
