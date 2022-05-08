// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/components/backbox/displays/displays.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball_components/gen/assets.gen.dart';
import 'package:pinball_flame/pinball_flame.dart';

class _TestGame extends Forge2DGame {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    images.prefix = '';
    await images.loadAll(
      [
        Assets.images.errorBackground.keyName,
      ],
    );
  }

  Future<void> pump(LeaderboardFailureDisplay component) {
    return ensureAdd(
      FlameProvider.value(
        _MockAppLocalizations(),
        children: [component],
      ),
    );
  }
}

class _MockAppLocalizations extends Mock implements AppLocalizations {
  @override
  String get leaderboardErrorMessage => 'Message';
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('LeaderboardFailureDisplay', () {
    final flameTester = FlameTester(_TestGame.new);

    flameTester.test('renders correctly', (game) async {
      await game.pump(LeaderboardFailureDisplay());

      expect(
        game
            .descendants()
            .where(
              (component) =>
                  component is TextComponent && component.text == 'Message',
            )
            .length,
        equals(1),
      );
    });
  });
}
