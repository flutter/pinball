// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_ui/pinball_ui.dart';

void main() {
  group('PinballLoadingIndicator', () {
    group('assert value', () {
      test('throws error if value <= 0.0', () {
        expect(
          () => PinballLoadingIndicator(value: -0.5),
          throwsA(isA<AssertionError>()),
        );
      });

      test('throws error if value >= 1.0', () {
        expect(
          () => PinballLoadingIndicator(value: 1.5),
          throwsA(isA<AssertionError>()),
        );
      });
    });

    testWidgets(
        'renders 12 LinearProgressIndicators and '
        '6 FractionallySizedBox to indicate progress', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PinballLoadingIndicator(value: 0.75),
          ),
        ),
      );
      expect(find.byType(FractionallySizedBox), findsNWidgets(6));
      expect(find.byType(LinearProgressIndicator), findsNWidgets(12));
      final progressIndicators = tester.widgetList<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      for (final i in progressIndicators) {
        expect(i.value, 0.75);
      }
    });
  });
}
