import 'package:flutter/material.dart';

@immutable
class DropdownBodyInfo {
  final Offset offset;
  final double width;
  final double height;
  final double itemExtent;

  const DropdownBodyInfo({
    required this.offset,
    required this.width,
    required this.height,
    required this.itemExtent,
  });

  DropdownBodyInfo copyWith({
    Offset? offset,
    double? width,
    double? height,
    double? itemExtent,
  }) {
    return DropdownBodyInfo(
      offset: offset ?? this.offset,
      width: width ?? this.width,
      height: height ?? this.height,
      itemExtent: itemExtent ?? this.itemExtent,
    );
  }

  @override
  String toString() {
    return 'DropdownBodyInfo(offset: $offset, width: $width, height: $height, itemExtent: $itemExtent)';
  }

  @override
  bool operator ==(covariant DropdownBodyInfo other) {
    if (identical(this, other)) return true;

    return other.offset == offset &&
        other.width == width &&
        other.height == height &&
        other.itemExtent == itemExtent;
  }

  @override
  int get hashCode {
    return offset.hashCode ^
        width.hashCode ^
        height.hashCode ^
        itemExtent.hashCode;
  }
}
