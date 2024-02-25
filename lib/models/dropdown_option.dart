// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/widgets.dart';

import 'package:searchable_dropdown/models/dropdown_menu_button_options.dart';

typedef OptionBuilder<T> = Widget Function(T value);

@immutable
class DropdownOption<T> {
  //Option shown in the header
  final OptionBuilder<dynamic> labelBuilder;
  //Option shown in the dropdown menu
  final OptionBuilder<DropdownMenuButtonOptions>? menuItemBuilder;
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
