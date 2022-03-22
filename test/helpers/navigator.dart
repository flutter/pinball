import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'helpers.dart';

Future<void> expectNavigatesToRoute<Type>(
  WidgetTester tester,
  Route route, {
  bool hasFlameGameInside = false,
}) async {
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
  if (hasFlameGameInside) {
    // We can't use pumpAndSettle here because the page renders a Flame game
    // which is an infinity animation, so it will timeout
    await tester.pump(); // Runs the button action
    await tester.pump(); // Runs the navigation
  } else {
    await tester.pumpAndSettle();
  }

  expect(find.byType(Type), findsOneWidget);
}
