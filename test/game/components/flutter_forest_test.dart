// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FlutterForest', () {
    final flameTester = FlameTester(PinballGameTest.create);

    flameTester.test(
      'loads correctly',
      (game) async {
        await game.ready();
        final flutterForest = FlutterForest(position: Vector2(0, 0));
        await game.ensureAdd(flutterForest);

        expect(game.contains(flutterForest), isTrue);
      },
    );

    flameTester.test(
      'adds a new ball onNewState',
      (game) async {
        await game.ready();
        final flutterForest = FlutterForest(position: Vector2(0, 0));
        await game.ensureAdd(flutterForest);

        final previousBalls = game.descendants().whereType<Ball>().length;
        flutterForest.onNewState(MockGameState());
        await game.ready();

        expect(
          game.descendants().whereType<Ball>().length,
          greaterThan(previousBalls),
        );
      },
    );
  });
}
