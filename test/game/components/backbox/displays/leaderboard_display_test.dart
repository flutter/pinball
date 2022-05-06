// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/components/backbox/displays/leaderboard_display.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball_flame/pinball_flame.dart';
import 'package:pinball_theme/pinball_theme.dart';

class _MockAppLocalizations extends Mock implements AppLocalizations {
  @override
  String get rank => 'rank';

  @override
  String get score => 'score';

  @override
  String get name => 'name';
}

class _TestGame extends Forge2DGame {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    images.prefix = '';
    await images.load(const AndroidTheme().leaderboardIcon.keyName);
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

void main() {
  group('LeaderboardDisplay', () {
    TestWidgetsFlutterBinding.ensureInitialized();

    final flameTester = FlameTester(_TestGame.new);

    flameTester.test('renders the titles', (game) async {
      await game.pump(LeaderboardDisplay(entries: const []));

      final textComponents =
          game.descendants().whereType<TextComponent>().toList();
      expect(textComponents.length, equals(3));
      expect(textComponents[0].text, equals('rank'));
      expect(textComponents[1].text, equals('score'));
      expect(textComponents[2].text, equals('name'));
    });

    flameTester.test('renders the entries', (game) async {
      await game.pump(
        LeaderboardDisplay(
          entries: const [
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
          ],
        ),
      );

      for (final text in [
        'AAA',
        'BBB',
        'CCC',
        'DDD',
        '1st',
        '2nd',
        '3rd',
        '4th'
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
    });
  });
}
