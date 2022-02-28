import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/landing/landing.dart';

import '../../helpers/helpers.dart';

void main() {
  group('LandingPage', () {
    testWidgets('renders TextButton', (tester) async {
      await tester.pumpApp(const LandingPage());
      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('tapping on TextButton navigates to PinballGamePage',
        (tester) async {
      // TODO(erickzanardo): Make test pass.
      await tester.pumpApp(const LandingPage());
      await tester.tap(
        find.byType(
          TextButton,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(PinballGamePage), findsOneWidget);
      expect(find.byType(LandingPage), findsNothing);
    });
  });
}
