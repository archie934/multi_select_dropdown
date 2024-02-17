import 'package:flutter/material.dart';

@immutable
class DrodownHeaderOptions {
  final double spacing;
  final double runSpacing;
  final bool isSearchable;
  final InputDecoration inputDecoration;
  final Widget Function(TextEditingController controller, FocusNode focusNode)?
      searchFieldBuilder;

  const DrodownHeaderOptions({
    required this.spacing,
    required this.runSpacing,
    required this.isSearchable,
    required this.inputDecoration,
    this.searchFieldBuilder,
  });

  DrodownHeaderOptions copyWith({
    double? spacing,
    double? runSpacing,
    bool? isSearchable,
    InputDecoration? inputDecoration,
  }) {
    return DrodownHeaderOptions(
      spacing: spacing ?? this.spacing,
      runSpacing: runSpacing ?? this.runSpacing,
      isSearchable: isSearchable ?? this.isSearchable,
      inputDecoration: inputDecoration ?? this.inputDecoration,
    );
  }
}
