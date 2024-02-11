import 'package:flutter/material.dart';
import 'package:searchable_dropdown/models/dropdown_option.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: SearchableDropdown<String>(
              options: [
                DropdownOption(
                  value: 'ASDFS',
                  optionBuilder: (value) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.abc_rounded),
                      Text(value),
                    ],
                  ),
                ),
                DropdownOption(
                  value: 'Some',
                  optionBuilder: (value) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.abc_rounded),
                      Text(value),
                    ],
                  ),
                ),
                DropdownOption(
                  value: 'AAAA',
                  optionBuilder: (value) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.abc_rounded),
                      Text(value),
                    ],
                  ),
                )
              ],
              initialValues: [
                DropdownOption<String>(
                  value: 'Some',
                  optionBuilder: (value) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.abc_rounded),
                      Text(value),
                    ],
                  ),
                )
              ],
              onChanged: (List<DropdownOption<Object?>> selectedOption) {},
            ),
          ),
        ),
      ),
    );
  }
}
