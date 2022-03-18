import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

Future<void> expectNavigatesTo<Type>(WidgetTester tester, Route route) async {
  // ignore: avoid_dynamic_calls
  await tester.pumpApp(
    Scaffold(
      body: Builder(
        builder: (context) {
          return ElevatedButton(
            onPressed: () {
              Navigator.of(context).push<void>(route);
            },
            child: const Text('Tap me'),
          );
        },
      ),
    ),
  );

  await tester.tap(find.text('Tap me'));
  await tester.pumpAndSettle();

  expect(find.byType(Type), findsOneWidget);
}
