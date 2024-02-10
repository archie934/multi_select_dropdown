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
          child: SearchableDropdown<String>(
            options: [
              DropdownOption<String>(
                value: 'ASDFS',
                labelBuilder: (value) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.abc_rounded),
                    Text(value),
                  ],
                ),
              ),
              DropdownOption<String>(
                value: 'Some',
                labelBuilder: (value) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.abc_rounded),
                    Text(value),
                  ],
                ),
              ),
              DropdownOption<String>(
                value: 'AAAA',
                labelBuilder: (value) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                labelBuilder: (value) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }
}
