// ignore_for_file: prefer_const_constructors

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DialogDecoration', () {
    testWidgets('renders header and body', (tester) async {
      const headerText = 'header';
      const bodyText = 'body';

      await tester.pumpWidget(
        MaterialApp(
          home: DialogDecoration(
            header: Text(headerText),
            body: Text(bodyText),
          ),
        ),
      );

      expect(find.text(headerText), findsOneWidget);
      expect(find.text(bodyText), findsOneWidget);
    });
  });
}
