import 'package:flutter/widgets.dart';

class DropdownOption<T> {
  //This will be of type T but dart wont let me have it like that
  Widget Function(dynamic value) labelBuilder;
  T value;

  DropdownOption({
    required this.value,
    required this.labelBuilder,
  });
}