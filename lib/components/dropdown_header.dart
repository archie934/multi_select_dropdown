import 'package:flutter/material.dart';
import 'package:searchable_dropdown/models/dropdown_option.dart';

class DropdownHeader<T> extends StatelessWidget {
  final List<DropdownOption<T>> options;

  const DropdownHeader({super.key, required this.options});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Wrap(
        children: options
            .map((option) => option.labelBuilder(option.value))
            .toList(),
      ),
    );
  }
}
