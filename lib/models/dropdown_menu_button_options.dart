import 'package:flutter/material.dart';

@immutable
class DropdownMenuButtonOptions {
  final bool isSelected;
  final void Function() onTap;

  const DropdownMenuButtonOptions({
    required this.isSelected,
    required this.onTap,
  });
}
