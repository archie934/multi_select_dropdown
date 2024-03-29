
A widget for selecting multiple options from a dropdown list.

“![](https://github.com/archie934/multi_select_dropdown/blob/20538abebf94834fb032a222d467f632ba45856e/screenrecords/basic-usage.gif)”

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
* List<DropdownOption<T>> options: the options of the dropdown menu;
* final List<DropdownOption<T>> initialValues: intial list of selected options;
* final DropdownHeaderOptions option for customizing the header;
* void Function(List<DropdownOption<T>> selectedOption) onChanged: Callback that triggers on items are added or removed;
* final bool Function(DropdownOption<T> option, String searhString)?
      searchFunction: Filter function applied when searching for an option;
* final Widget Function({
    required DropdownBodyBox dropdownBodyBox,
    required Widget bodyList,
  })? menuContainerBuilder: Customize dropdown menu container;
* final double itemExtent: Option item extent;
* final int? maxItemsBeforeScroll: Number of visible items in the menu view port;
* final Widget? endAdornment: Widget added at the end of the dropdown;
* final bool dismissOnAdd: If true menu will close after selection;

* final HeaderItemBuilder<T>? headerItemBuilder: Builder used by the header widget to build selected options;
* final double? popupHeight: Menu height;
* final Duration debounceDuration: Search items debounce;
