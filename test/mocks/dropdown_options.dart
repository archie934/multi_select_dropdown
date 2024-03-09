import 'package:dropdown_widgets/models/dropdown_option.dart';
import 'package:flutter/material.dart';

final dropdownOptions = List.generate(
    5,
    (index) => DropdownOption(
          value: 'Option $index',
          labelBuilder: (value) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.abc_rounded),
              Text(value),
            ],
          ),
        ));
