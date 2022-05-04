// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/components/backbox/displays/initials_input_display.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_theme/pinball_theme.dart' as theme;

import '../../../helpers/helpers.dart';

class _MockAppLocalizations extends Mock implements AppLocalizations {
  @override
  String get score => '';

  @override
  String get name => '';

  @override
  String get enterInitials => '';

  @override
  String get arrows => '';

  @override
  String get andPress => '';

  @override
  String get enterReturn => '';

  @override
  String get toSubmit => '';
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final characterIconPath = theme.Assets.images.dash.leaderboardIcon.keyName;
  final assets = [
    characterIconPath,
    Assets.images.backbox.marquee.keyName,
    Assets.images.backbox.displayDivider.keyName,
  ];
  final flameTester = FlameTester(
    () => EmptyPinballTestGame(
      assets: assets,
      l10n: _MockAppLocalizations(),
    ),
  );

  group('Backbox', () {
    flameTester.test(
      'loads correctly',
      (game) async {
        final backbox = Backbox();
        await game.ensureAdd(backbox);

        expect(game.children, contains(backbox));
      },
    );

    flameTester.testGameWidget(
      'renders correctly',
      setUp: (game, tester) async {
        await game.images.loadAll(assets);
        game.camera
          ..followVector2(Vector2(0, -130))
          ..zoom = 6;
        await game.ensureAdd(Backbox());
        await tester.pump();
      },
      verify: (game, tester) async {
        await expectLater(
          find.byGame<EmptyPinballTestGame>(),
          matchesGoldenFile('../golden/backbox.png'),
        );
      },
    );

    flameTester.test(
      'initialsInput adds InitialsInputDisplay',
      (game) async {
        final backbox = Backbox();
        await game.ensureAdd(backbox);
        await backbox.initialsInput(
          score: 0,
          characterIconPath: characterIconPath,
          onSubmit: (_) {},
        );
        await game.ready();

        expect(backbox.firstChild<InitialsInputDisplay>(), isNotNull);
      },
    );
  });
}
