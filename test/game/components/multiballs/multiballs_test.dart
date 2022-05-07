// ignore_for_file: cascade_invocations

import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

class _TestGame extends Forge2DGame {
  @override
  Future<void> onLoad() async {
    images.prefix = '';
    await images.loadAll([
      Assets.images.multiball.lit.keyName,
      Assets.images.multiball.dimmed.keyName,
    ]);
  }

  Future<void> pump(Multiballs child, {GameBloc? gameBloc}) async {
    // Not needed once https://github.com/flame-engine/flame/issues/1607
    // is fixed
    await onLoad();
    await ensureAdd(
      FlameBlocProvider<GameBloc, GameState>.value(
        value: gameBloc ?? GameBloc(),
        children: [child],
      ),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final flameBlocTester = FlameTester(_TestGame.new);

  group('Multiballs', () {
    flameBlocTester.testGameWidget(
      'loads correctly',
      setUp: (game, tester) async {
        final multiballs = Multiballs();
        await game.pump(multiballs);
      },
      verify: (game, tester) async {
        expect(game.descendants().whereType<Multiballs>().length, equals(1));
      },
    );

    flameBlocTester.test(
      'loads four Multiball',
      (game) async {
        final multiballs = Multiballs();
        await game.pump(multiballs);
        expect(
          multiballs.descendants().whereType<Multiball>().length,
          equals(4),
        );
      },
    );
  });
}
