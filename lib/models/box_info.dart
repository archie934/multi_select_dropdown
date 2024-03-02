import 'package:flutter/material.dart';

@immutable
class BoxInfo {
  /// The point is used by [Positioned] to position the dropdown menu
  final Offset offset;

  /// Width of the dropdown menu computed based on the [RenderBox] of header
  final double width;

  /// Height of the dropdown menu computed based on the [RenderBox] of header
  final double height;

  const BoxInfo({
    required this.offset,
    required this.width,
    required this.height,
  });

  BoxInfo copyWith({
    Offset? offset,
    double? width,
    double? height,
  }) {
    return BoxInfo(
      offset: offset ?? this.offset,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  @override
  bool operator ==(covariant BoxInfo other) {
    if (identical(this, other)) return true;

    return other.offset == offset &&
        other.width == width &&
        other.height == height;
  }

  @override
  int get hashCode => offset.hashCode ^ width.hashCode ^ height.hashCode;
}
