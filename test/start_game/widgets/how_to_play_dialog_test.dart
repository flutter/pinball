// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball/start_game/start_game.dart';

import '../../helpers/helpers.dart';

void main() {
  group('HowToPlayDialog', () {
    late AppLocalizations l10n;

    setUp(() async {
      l10n = await AppLocalizations.delegate.load(Locale('en'));
    });

    testWidgets('displays content', (tester) async {
      await tester.pumpApp(HowToPlayDialog());
      expect(find.text(l10n.howToPlay), findsOneWidget);
      expect(find.text(l10n.tipsForFlips), findsOneWidget);
      expect(find.text(l10n.launchControls), findsOneWidget);
      expect(find.text(l10n.flipperControls), findsOneWidget);
    });
  });

  group('KeyButton', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(
        KeyButton(control: Control.a),
      );

      expect(find.text('A'), findsOneWidget);
    });
  });
}
