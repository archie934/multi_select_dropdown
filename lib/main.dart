import 'package:flutter/material.dart';
import 'package:searchable_dropdown/models/dropdown_option.dart';
import 'package:searchable_dropdown/multi_select_dropdown.dart';

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
            child: ListView(
              children: List.generate(
                  50,
                  (index) => Padding(
                        padding: const EdgeInsets.all(16),
                        child: MultiSelectDropdown(
                          options: List.generate(
                              50,
                              (index) => DropdownOption(
                                    value: 'Option $index',
                                    labelBuilder: (value) => Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.abc_rounded),
                                        Text(value),
                                      ],
                                    ),
                                  )),
                          initialValues: [
                            DropdownOption(
                              value: 'Option 1',
                              labelBuilder: (value) => Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.abc_rounded),
                                  Text(value),
                                ],
                              ),
                            )
                          ],
                          onChanged:
                              (List<DropdownOption<String>> selectedOption) {
                            debugPrint(
                              selectedOption.toString(),
                            );
                          },
                        ),
                      )),
            ),
          ),
        ),
      ),
    );
  }
}
