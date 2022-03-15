// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball/landing/landing.dart';

import '../../helpers/helpers.dart';

void main() {
  group('LandingPage', () {
    testWidgets('renders correctly', (tester) async {
      final l10n = await AppLocalizations.delegate.load(Locale('en'));
      await tester.pumpApp(LandingPage());

      expect(find.byType(TextButton), findsNWidgets(2));
      expect(find.text(l10n.play), findsOneWidget);
      expect(find.text(l10n.howToPlay), findsOneWidget);
    });

    testWidgets('tapping on play button navigates to CharacterSelectionPage',
        (tester) async {
      final l10n = await AppLocalizations.delegate.load(Locale('en'));
      final navigator = MockNavigator();
      when(() => navigator.push<void>(any())).thenAnswer((_) async {});

      await tester.pumpApp(
        LandingPage(),
        navigator: navigator,
      );

      await tester.tap(find.widgetWithText(TextButton, l10n.play));

      verify(() => navigator.push<void>(any())).called(1);
    });

    testWidgets('tapping on how to play button displays dialog with controls',
        (tester) async {
      final l10n = await AppLocalizations.delegate.load(Locale('en'));
      await tester.pumpApp(LandingPage());

      await tester.tap(find.widgetWithText(TextButton, l10n.howToPlay));
      await tester.pump();

      expect(find.byType(Dialog), findsOneWidget);
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
