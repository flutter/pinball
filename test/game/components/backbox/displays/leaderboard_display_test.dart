// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/components/backbox/displays/leaderboard_display.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';
import 'package:pinball_theme/pinball_theme.dart' hide Assets;

class _MockAppLocalizations extends Mock implements AppLocalizations {
  @override
  String get rank => 'rank';

  @override
  String get score => 'score';

  @override
  String get name => 'name';
}

class _TestGame extends Forge2DGame with TapCallbacks {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    images.prefix = '';
    await images.loadAll([
      const AndroidTheme().leaderboardIcon.keyName,
      Assets.images.displayArrows.arrowLeft.keyName,
      Assets.images.displayArrows.arrowRight.keyName,
    ]);
  }

  Future<void> pump(LeaderboardDisplay component) {
    return ensureAdd(
      FlameProvider.value(
        _MockAppLocalizations(),
        children: [component],
      ),
    );
  }
}

const leaderboard = [
  LeaderboardEntryData(
    playerInitials: 'AAA',
    score: 123,
    character: CharacterType.android,
  ),
  LeaderboardEntryData(
    playerInitials: 'BBB',
    score: 1234,
    character: CharacterType.android,
  ),
  LeaderboardEntryData(
    playerInitials: 'CCC',
    score: 12345,
    character: CharacterType.android,
  ),
  LeaderboardEntryData(
    playerInitials: 'DDD',
    score: 12346,
    character: CharacterType.android,
  ),
  LeaderboardEntryData(
    playerInitials: 'EEE',
    score: 123467,
    character: CharacterType.android,
  ),
  LeaderboardEntryData(
    playerInitials: 'FFF',
    score: 123468,
    character: CharacterType.android,
  ),
  LeaderboardEntryData(
    playerInitials: 'GGG',
    score: 1234689,
    character: CharacterType.android,
  ),
  LeaderboardEntryData(
    playerInitials: 'HHH',
    score: 12346891,
    character: CharacterType.android,
  ),
  LeaderboardEntryData(
    playerInitials: 'III',
    score: 123468912,
    character: CharacterType.android,
  ),
  LeaderboardEntryData(
    playerInitials: 'JJJ',
    score: 1234689121,
    character: CharacterType.android,
  ),
];

void main() {
  group('LeaderboardDisplay', () {
    TestWidgetsFlutterBinding.ensureInitialized();

    final flameTester = FlameTester(_TestGame.new);

    flameTester.testGameWidget(
      'renders the titles',
      setUp: (game, _) async {
        await game.pump(LeaderboardDisplay(entries: const []));
        await game.ready();
      },
      verify: (game, _) async {
        final textComponents =
            game.descendants().whereType<TextComponent>().toList();
        expect(textComponents.length, equals(3));
        expect(textComponents[0].text, equals('rank'));
        expect(textComponents[1].text, equals('score'));
        expect(textComponents[2].text, equals('name'));
      },
    );

    flameTester.testGameWidget(
      'renders the first 5 entries',
      setUp: (game, _) async {
        await game.pump(LeaderboardDisplay(entries: leaderboard));
      },
      verify: (game, _) async {
        for (final text in [
          'AAA',
          'BBB',
          'CCC',
          'DDD',
          'EEE',
          '1st',
          '2nd',
          '3rd',
          '4th',
          '5th',
        ]) {
          expect(
            game
                .descendants()
                .whereType<TextComponent>()
                .where((textComponent) => textComponent.text == text)
                .length,
            equals(1),
          );
        }
      },
    );

    flameTester.testGameWidget(
      'can open the second page',
      setUp: (game, _) async {
        final display = LeaderboardDisplay(entries: leaderboard);
        await game.pump(display);
        final arrow = game
            .descendants()
            .whereType<ArrowIcon>()
            .where((arrow) => arrow.direction == ArrowIconDirection.right)
            .single;

        // Tap the arrow
        arrow.onTap();
        // Wait for the transition to finish
        display.updateTree(5);
        await game.ready();
      },
      verify: (game, _) async {
        for (final text in [
          'FFF',
          'GGG',
          'HHH',
          'III',
          'JJJ',
          '6th',
          '7th',
          '8th',
          '9th',
          '10th',
        ]) {
          expect(
            game
                .descendants()
                .whereType<TextComponent>()
                .where((textComponent) => textComponent.text == text)
                .length,
            equals(1),
          );
        }
      },
    );

    flameTester.testGameWidget(
      'can open the second page and go back to the first',
      setUp: (game, _) async {
        final display = LeaderboardDisplay(entries: leaderboard);
        await game.pump(display);

        final arrow = game
            .descendants()
            .whereType<ArrowIcon>()
            .where((arrow) => arrow.direction == ArrowIconDirection.right)
            .single;

        // Tap the arrow
        arrow.onTap();
        // Wait for the transition to finish
        display.updateTree(5);
        await game.ready();
      },
      verify: (game, _) async {
        for (final text in [
          'FFF',
          'GGG',
          'HHH',
          'III',
          'JJJ',
          '6th',
          '7th',
          '8th',
          '9th',
          '10th',
        ]) {
          expect(
            game
                .descendants()
                .whereType<TextComponent>()
                .where((textComponent) => textComponent.text == text)
                .length,
            equals(1),
          );
        }

        final arrow = game
            .descendants()
            .whereType<ArrowIcon>()
            .where((arrow) => arrow.direction == ArrowIconDirection.left)
            .single;

        // Tap the arrow
        arrow.onTap();

        // Wait for the transition to finish
        final display = LeaderboardDisplay(entries: leaderboard);
        display.updateTree(5);
        await game.ready();

        for (final text in [
          'AAA',
          'BBB',
          'CCC',
          'DDD',
          'EEE',
          '1st',
          '2nd',
          '3rd',
          '4th',
          '5th',
        ]) {
          expect(
            game
                .descendants()
                .whereType<TextComponent>()
                .where((textComponent) => textComponent.text == text)
                .length,
            equals(1),
          );
        }
      },
    );
  });
}
