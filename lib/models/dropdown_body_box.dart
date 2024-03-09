import 'package:flutter/material.dart';

import 'box_info.dart';

@immutable
class DropdownBodyBox {
  /// Used by [SliverFixedExtentList] in the dropdown menu
  final double itemExtent;

  final BoxInfo boxInfo;

  final Widget Function({
    required DropdownBodyBox dropdownBodyBox,
    required Widget bodyList,
  })? containerBuilder;

  const DropdownBodyBox({
    required this.itemExtent,
    required this.boxInfo,
    this.containerBuilder,
  });

  DropdownBodyBox copyWith({
    double? itemExtent,
    BoxInfo? boxInfo,
  }) {
    return DropdownBodyBox(
      itemExtent: itemExtent ?? this.itemExtent,
      boxInfo: boxInfo ?? this.boxInfo,
    );
  }
}
