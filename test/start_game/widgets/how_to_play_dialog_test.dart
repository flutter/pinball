// ignore_for_file: prefer_const_constructors

import 'package:flutter/foundation.dart';
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

    testWidgets('displays content for desktop', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
      await tester.pumpApp(HowToPlayDialog());
      expect(find.text(l10n.howToPlay), findsOneWidget);
      expect(find.text(l10n.tipsForFlips), findsOneWidget);
      expect(find.text(l10n.launchControls), findsOneWidget);
      expect(find.text(l10n.flipperControls), findsOneWidget);
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('displays content for mobile', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      await tester.pumpApp(HowToPlayDialog());
      expect(find.text(l10n.howToPlay), findsOneWidget);
      expect(find.text(l10n.tipsForFlips), findsOneWidget);
      expect(find.text(l10n.tapAndHoldRocket), findsOneWidget);
      expect(find.text(l10n.tapLeftRightScreen), findsOneWidget);
      debugDefaultTargetPlatformOverride = null;
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
