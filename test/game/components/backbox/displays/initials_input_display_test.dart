// ignore_for_file: cascade_invocations

import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/components/backbox/displays/initials_input_display.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_theme/pinball_theme.dart' as theme;

import '../../../../helpers/helpers.dart';

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
  group('InitialsInputDisplay', () {
    final characterIconPath = theme.Assets.images.dash.leaderboardIcon.keyName;
    final assets = [
      characterIconPath,
      Assets.images.backbox.displayDivider.keyName,
    ];
    final tester = FlameTester(
      () => EmptyPinballTestGame(
        assets: assets,
        l10n: _MockAppLocalizations(),
      ),
    );

    tester.test(
      'loads correctly',
      (game) async {
        final initialsInputDisplay = InitialsInputDisplay(
          score: 0,
          characterIconPath: characterIconPath,
          onSubmit: (_) {},
        );
        await game.ensureAdd(initialsInputDisplay);

        expect(game.children, contains(initialsInputDisplay));
      },
    );
  });
}
