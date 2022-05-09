import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/how_to_play/how_to_play.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:platform_helper/platform_helper.dart';

import '../helpers/helpers.dart';

class _MockPlatformHelper extends Mock implements PlatformHelper {}

void main() {
  group('HowToPlayDialog', () {
    late AppLocalizations l10n;
    late PlatformHelper platformHelper;

    setUp(() async {
      l10n = await AppLocalizations.delegate.load(const Locale('en'));
      platformHelper = _MockPlatformHelper();
      when(() => platformHelper.isMobile).thenAnswer((_) => false);
    });

    test('can be instantiated', () {
      expect(
        HowToPlayDialog(onDismissCallback: () {}),
        isA<HowToPlayDialog>(),
      );
    });

    testWidgets('displays content for desktop', (tester) async {
      when(() => platformHelper.isMobile).thenAnswer((_) => false);
      await tester.pumpApp(
        HowToPlayDialog(
          onDismissCallback: () {},
        ),
        platformHelper: platformHelper,
      );
      expect(find.text(l10n.howToPlay), findsOneWidget);
      expect(find.text(l10n.tipsForFlips), findsOneWidget);
      expect(find.text(l10n.launchControls), findsOneWidget);
      expect(find.text(l10n.flipperControls), findsOneWidget);
      expect(find.byType(RotatedBox), findsNWidgets(7)); // controls
    });

    testWidgets('displays content for mobile', (tester) async {
      when(() => platformHelper.isMobile).thenAnswer((_) => true);
      await tester.pumpApp(
        HowToPlayDialog(
          onDismissCallback: () {},
        ),
        platformHelper: platformHelper,
      );
      expect(find.text(l10n.howToPlay), findsOneWidget);
      expect(find.text(l10n.tipsForFlips), findsOneWidget);
      expect(find.text(l10n.tapAndHoldRocket), findsOneWidget);
      expect(find.text(l10n.tapLeftRightScreen), findsOneWidget);
    });

    testWidgets('disappears after 3 seconds', (tester) async {
      await tester.pumpApp(
        Builder(
          builder: (context) {
            return TextButton(
              onPressed: () => showDialog<void>(
                context: context,
                builder: (_) => HowToPlayDialog(
                  onDismissCallback: () {},
                ),
              ),
              child: const Text('test'),
            );
          },
        ),
        platformHelper: platformHelper,
      );
      expect(find.byType(HowToPlayDialog), findsNothing);
      await tester.tap(find.text('test'));
      await tester.pumpAndSettle();
      expect(find.byType(HowToPlayDialog), findsOneWidget);
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();
      expect(find.byType(HowToPlayDialog), findsNothing);
    });

    testWidgets('can be dismissed', (tester) async {
      await tester.pumpApp(
        Builder(
          builder: (context) {
            return TextButton(
              onPressed: () => showDialog<void>(
                context: context,
                builder: (_) => HowToPlayDialog(
                  onDismissCallback: () {},
                ),
              ),
              child: const Text('test'),
            );
          },
        ),
        platformHelper: platformHelper,
      );
      expect(find.byType(HowToPlayDialog), findsNothing);
      await tester.tap(find.text('test'));
      await tester.pumpAndSettle();

      await tester.tapAt(Offset.zero);
      await tester.pumpAndSettle();
      expect(find.byType(HowToPlayDialog), findsNothing);
    });
  });
}
