// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.alienBumper.a.active.keyName,
    Assets.images.alienBumper.a.inactive.keyName,
    Assets.images.alienBumper.b.active.keyName,
    Assets.images.alienBumper.b.inactive.keyName,
  ];
  final flameTester = FlameTester(
    () => EmptyPinballTestGame(assets: assets),
  );

  group('AlienZone', () {
    flameTester.test(
      'loads correctly',
      (game) async {
        final alienZone = AlienZone();
        await game.ensureAdd(alienZone);

        expect(game.contains(alienZone), isTrue);
      },
    );

    group('loads', () {
      flameTester.test(
        'two AlienBumper',
        (game) async {
          final alienZone = AlienZone();
          await game.ensureAdd(alienZone);

          expect(
            alienZone.descendants().whereType<AlienBumper>().length,
            equals(2),
          );
        },
      );
    });

    group('bumpers', () {
      late GameBloc gameBloc;

      setUp(() {
        gameBloc = MockGameBloc();
        whenListen(
          gameBloc,
          const Stream<GameState>.empty(),
          initialState: const GameState.initial(),
        );
      });

      final flameBlocTester = FlameBlocTester<EmptyPinballTestGame, GameBloc>(
        gameBuilder: EmptyPinballTestGame.new,
        blocBuilder: () => gameBloc,
        assets: assets,
      );
    });
  });
}
