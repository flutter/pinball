// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_ui/pinball_ui.dart';

void main() {
  group('PinballDialog', () {
    group('with title only', () {
      testWidgets('renders the title and the body', (tester) async {
        tester.binding.window.physicalSizeTestValue = const Size(2000, 4000);
        addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
        await tester.pumpWidget(
          const MaterialApp(
            home: PinballDialog(title: 'title', child: Placeholder()),
          ),
        );
        expect(find.byType(PixelatedDecoration), findsOneWidget);
        expect(find.text('title'), findsOneWidget);
        expect(find.byType(Placeholder), findsOneWidget);
      });
    });

    group('with title and subtitle', () {
      testWidgets('renders the title, subtitle and the body', (tester) async {
        tester.binding.window.physicalSizeTestValue = const Size(2000, 4000);
        addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
        await tester.pumpWidget(
          MaterialApp(
            home: PinballDialog(
              title: 'title',
              subtitle: 'sub',
              child: Icon(Icons.home),
            ),
          ),
        );
        expect(find.byType(PixelatedDecoration), findsOneWidget);
        expect(find.text('title'), findsOneWidget);
        expect(find.text('sub'), findsOneWidget);
        expect(find.byType(Icon), findsOneWidget);
      });
    });
  });
}
