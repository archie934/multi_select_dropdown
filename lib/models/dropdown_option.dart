import 'package:flutter/widgets.dart';

import 'dropdown_menu_button_options.dart';

typedef OptionBuilder<T> = Widget Function(T value);

@immutable
class DropdownOption<T> {
  /// Function that builds the option [Widget] shown in the header
  final OptionBuilder<dynamic> labelBuilder;

  /// Function that builds the option [Widget] shown in the menu
  final OptionBuilder<DropdownMenuButtonOptions>? menuItemBuilder;

  /// Value of type [T] of this option.
  /// It's hash code is used by the internal map for selected options
  final T value;

  const DropdownOption({
    required this.value,
    required this.labelBuilder,
    this.menuItemBuilder,
  });

  DropdownOption<T> copyWith({
    OptionBuilder<dynamic>? labelBuilder,
    OptionBuilder<DropdownMenuButtonOptions>? menuItemBuilder,
    T? value,
  }) {
    return DropdownOption<T>(
      labelBuilder: labelBuilder ?? this.labelBuilder,
      menuItemBuilder: menuItemBuilder ?? this.menuItemBuilder,
      value: value ?? this.value,
    );
  }
}
