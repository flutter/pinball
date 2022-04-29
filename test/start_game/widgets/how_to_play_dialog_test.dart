// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball/start_game/start_game.dart';

import '../../helpers/helpers.dart';

void main() {
  group('HowToPlayDialog', () {
    testWidgets('displays content', (tester) async {
      final l10n = await AppLocalizations.delegate.load(Locale('en'));

      await tester.pumpApp(HowToPlayDialog());

      expect(find.text(l10n.launchControls), findsOneWidget);
    });
  });

  group('KeyIndicator', () {
    testWidgets('fromKeyName renders correctly', (tester) async {
      const keyName = 'A';

      await tester.pumpApp(
        KeyIndicator.fromKeyName(keyName: keyName),
      );

      expect(find.text(keyName), findsOneWidget);
    });

    testWidgets('fromIcon renders correctly', (tester) async {
      const keyIcon = Icons.keyboard_arrow_down;

      await tester.pumpApp(
        KeyIndicator.fromIcon(keyIcon: keyIcon),
      );

      expect(find.byIcon(keyIcon), findsOneWidget);
    });
  });
}
