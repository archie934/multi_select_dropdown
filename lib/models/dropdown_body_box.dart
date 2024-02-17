import 'package:flutter/material.dart';

@immutable
class DropdownBodyBox {
  final Offset offset;
  final double width;
  final double height;
  final double itemExtent;

  const DropdownBodyBox({
    required this.offset,
    required this.width,
    required this.height,
    required this.itemExtent,
  });

  DropdownBodyBox copyWith({
    Offset? offset,
    double? width,
    double? height,
    double? itemExtent,
  }) {
    return DropdownBodyBox(
      offset: offset ?? this.offset,
      width: width ?? this.width,
      height: height ?? this.height,
      itemExtent: itemExtent ?? this.itemExtent,
    );
  }
}
