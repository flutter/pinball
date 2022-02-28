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
  });
}
