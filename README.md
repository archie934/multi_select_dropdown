
A widget for selecting multiple options from a dropdown list.

“![](screenrecords/basic-usage.gif)”

<?code-excerpt "lib/basic.dart (basic-example)"?>
```dart
import 'models/dropdown_option.dart';
import 'multi_select_dropdown.dart';

MultiSelectDropdown(
    options: List.generate(
        50,
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
    onChanged: (List<DropdownOption<String>> selectedOption) {
        //Do something with the list
    },
)
```

## Some of the options are listed below:
* List<DropdownOption<T>> options: the options of the dropdown menu
* final List<DropdownOption<T>> initialValues: intial list of selected options
* final DropdownHeaderOptions option for customizing the header;
* void Function(List<DropdownOption<T>> selectedOption) onChanged: 
