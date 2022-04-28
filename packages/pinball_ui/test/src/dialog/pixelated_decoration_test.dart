// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_ui/pinball_ui.dart';

void main() {
  group('PixelatedDecoration', () {
    testWidgets('renders header and body', (tester) async {
      const headerText = 'header';
      const bodyText = 'body';

      await tester.pumpWidget(
        MaterialApp(
          home: PixelatedDecoration(
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
