import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_select_dropdown/components/dropdown_body.dart';
import 'package:multi_select_dropdown/components/dropdown_header.dart';
import 'package:multi_select_dropdown/components/dropdown_menu_button.dart';
import 'package:multi_select_dropdown/multi_select_dropdown.dart';

import 'mocks/dropdown_options.dart';
import 'test_wrapper.dart';

void main() {
  group('basic functionality', () {
    Future openDropdown(WidgetTester tester) async {
      final dropdownWidget = TestWrapper(
        child: MultiSelectDropdown(
            options: dropdownOptions,
            dismissOnAdd: true,
            initialValues: const [],
            onChanged: (_) {}),
      );

      await tester.pumpWidget(dropdownWidget);

      await tester.tap(find.byType(DropdownHeader));
      await tester.pumpAndSettle();
    }

    testWidgets('should show options', (tester) async {
      await openDropdown(tester);

      final dropdownBody = find.byType(DropdownBody);
      final dropdownButton = find.byType(DropdownMenuButton);

      expect(dropdownBody, findsOneWidget,
          reason: 'Dropdown menu was not shown on tap');
      expect(dropdownButton, findsNWidgets(dropdownOptions.length),
          reason: 'One ore more dropdown options are not visible');

      await tester.tap(find.byType(DropdownHeader));
      await tester.pumpAndSettle();

      expect(dropdownBody, findsNothing,
          reason: 'Dropdown menu was not dismissed');
    });

    testWidgets('should filter based on search', (tester) async {
      await openDropdown(tester);

      final searchField = find.byType(TextField);
      final optionToSearch = dropdownOptions.last;

      await tester.enterText(searchField, optionToSearch.value);
      await tester.pumpAndSettle(defaultDebounceDuration);

      final dropdownButton = find.descendant(
          of: find.byType(DropdownMenuButton),
          matching: find.text(optionToSearch.value));

      expect(dropdownButton, findsOneWidget,
          reason:
              'Only one dropdown should be present with the searched option');
    });
  });
}
