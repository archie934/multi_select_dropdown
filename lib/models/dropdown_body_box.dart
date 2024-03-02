// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

@immutable
class DropdownBodyBox {
  /// The point is used by [Positioned] to position the dropdown menu
  final Offset offset;

  /// Width of the dropdown menu computed based on the [RenderBox] of header
  final double width;

  /// Height of the dropdown menu computed based on the [RenderBox] of header
  final double height;

  /// Used by [SliverFixedExtentList] in the dropdown menu
  final double itemExtent;

  final Widget Function({
    required DropdownBodyBox dropdownBodyBox,
    required Widget bodyList,
  })? containerBuilder;

  const DropdownBodyBox({
    required this.offset,
    required this.width,
    required this.height,
    required this.itemExtent,
    this.containerBuilder,
  });

  DropdownBodyBox copyWith({
    Offset? offset,
    double? width,
    double? height,
    double? itemExtent,
    Widget Function({
      required DropdownBodyBox dropdownBodyBox,
      required Widget bodyList,
    })? containerBuilder,
  }) {
    return DropdownBodyBox(
      offset: offset ?? this.offset,
      width: width ?? this.width,
      height: height ?? this.height,
      itemExtent: itemExtent ?? this.itemExtent,
      containerBuilder: containerBuilder ?? this.containerBuilder,
    );
  }
}
