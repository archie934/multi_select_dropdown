import 'package:flutter/material.dart';

@immutable
class DropdownMenuButtonOptions {
  /// Used by [Widget] to set selected syle
  final bool isSelected;

  /// Tap event callback
  final VoidCallback onTap;

  const DropdownMenuButtonOptions({
    required this.isSelected,
    required this.onTap,
  });
}
