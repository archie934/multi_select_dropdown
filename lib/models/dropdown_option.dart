import 'package:flutter/widgets.dart';

typedef OptionBuilder = Widget Function(dynamic value);

@immutable
class DropdownOption<T> {
  final OptionBuilder optionBuilder;
  final T value;

  const DropdownOption({
    required this.value,
    required this.optionBuilder,
  });

  DropdownOption<T> copyWith({
    OptionBuilder? optionBuilder,
    T? value,
  }) {
    return DropdownOption<T>(
      optionBuilder: optionBuilder ?? this.optionBuilder,
      value: value ?? this.value,
    );
  }
}
