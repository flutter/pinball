// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball/start_game/start_game.dart';
import 'package:platform_helper/platform_helper.dart';

import '../../helpers/helpers.dart';

class MockPlatformHelper extends Mock implements PlatformHelper {}

void main() {
  group('HowToPlayDialog', () {
    late AppLocalizations l10n;
    late PlatformHelper platformHelper;

    setUp(() async {
      l10n = await AppLocalizations.delegate.load(Locale('en'));
      platformHelper = MockPlatformHelper();
    });

    testWidgets(
      'can be instantiated without passing in a platform helper',
      (tester) async {
        await tester.pumpApp(HowToPlayDialog());
        expect(find.byType(HowToPlayDialog), findsOneWidget);
      },
    );

    testWidgets('displays content for desktop', (tester) async {
      when(() => platformHelper.isMobile).thenAnswer((_) => false);
      await tester.pumpApp(
        HowToPlayDialog(
          platformHelper: platformHelper,
        ),
      );
      expect(find.text(l10n.howToPlay), findsOneWidget);
      expect(find.text(l10n.tipsForFlips), findsOneWidget);
      expect(find.text(l10n.launchControls), findsOneWidget);
      expect(find.text(l10n.flipperControls), findsOneWidget);
      expect(find.byType(KeyButton), findsNWidgets(7));
    });

    testWidgets('displays content for mobile', (tester) async {
      when(() => platformHelper.isMobile).thenAnswer((_) => true);
      await tester.pumpApp(
        HowToPlayDialog(
          platformHelper: platformHelper,
        ),
      );
      expect(find.text(l10n.howToPlay), findsOneWidget);
      expect(find.text(l10n.tipsForFlips), findsOneWidget);
      expect(find.text(l10n.tapAndHoldRocket), findsOneWidget);
      expect(find.text(l10n.tapLeftRightScreen), findsOneWidget);
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
