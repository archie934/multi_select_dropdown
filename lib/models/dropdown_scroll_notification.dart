import 'package:flutter/widgets.dart';

/// This class is used as custom [ScrollNotification] to avoid dropdown menu dismissal when scrolling inside the menu
class DropdownScrollNotification extends ScrollNotification {
  DropdownScrollNotification({
    required super.metrics,
    required super.context,
  });
}
