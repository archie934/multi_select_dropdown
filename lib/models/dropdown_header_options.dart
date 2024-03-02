import 'package:flutter/material.dart';

@immutable
class DropdownHeaderOptions {
  /// [Wrap] spacing property of the header
  final double spacing;

  /// [Wrap] runSpacing property of the header
  final double runSpacing;

  /// If false header [TextField] is not rendered
  final bool isSearchable;

  /// [InputDecoration] of the header
  final InputDecoration inputDecoration;

  /// Function that builds the [TextField] for the header
  /// If null a default [TextField] is provided
  final Widget Function(TextEditingController controller, FocusNode focusNode)?
      searchFieldBuilder;

  const DropdownHeaderOptions({
    required this.spacing,
    required this.runSpacing,
    required this.inputDecoration,
    this.isSearchable = true,
    this.searchFieldBuilder,
  });

  DropdownHeaderOptions copyWith({
    double? spacing,
    double? runSpacing,
    bool? isSearchable,
    InputDecoration? inputDecoration,
  }) {
    return DropdownHeaderOptions(
      spacing: spacing ?? this.spacing,
      runSpacing: runSpacing ?? this.runSpacing,
      isSearchable: isSearchable ?? this.isSearchable,
      inputDecoration: inputDecoration ?? this.inputDecoration,
    );
  }
}
