// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_ui/pinball_ui.dart';

void main() {
  group('AnimatedEllipsisText', () {
    testWidgets(
        'adds a new `.` every 500ms and '
        'resets back to zero after adding 3', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedEllipsisText('test'),
          ),
        ),
      );
      expect(find.text('test'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 600));
      expect(find.text('test.'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 600));
      expect(find.text('test..'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 600));
      expect(find.text('test...'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 600));
      expect(find.text('test'), findsOneWidget);
    });
  });
}
