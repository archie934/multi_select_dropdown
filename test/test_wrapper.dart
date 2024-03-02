import 'package:flutter/material.dart';

class TestWrapper extends StatelessWidget {
  final Widget child;

  const TestWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Localizations(
      locale: const Locale('en', 'US'),
      delegates: const <LocalizationsDelegate<dynamic>>[
        DefaultWidgetsLocalizations.delegate,
        DefaultMaterialLocalizations.delegate,
      ],
      child: MediaQuery(
        data: const MediaQueryData(),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Material(
            child: Overlay(
              initialEntries: [
                OverlayEntry(
                  builder: (context) => Center(
                    child: child,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
