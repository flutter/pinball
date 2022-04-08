// ignore_for_file: unawaited_futures

import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  group('Backboard', () {
    final tester = FlameTester(TestGame.new);

    group('on waitingMode', () {
      tester.testGameWidget(
        'renders correctly',
        setUp: (game, tester) async {
          game.camera.zoom = 2;
          game.camera.followVector2(Vector2.zero());
          await game.ensureAdd(Backboard(position: Vector2(0, 15)));
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('golden/backboard/waiting.png'),
          );
        },
      );
    });

    group('on gameOverMode', () {
      tester.testGameWidget(
        'renders correctly',
        setUp: (game, tester) async {
          game.camera.zoom = 2;
          game.camera.followVector2(Vector2.zero());
          final backboard = Backboard(position: Vector2(0, 15));
          await game.ensureAdd(backboard);

          await backboard.gameOverMode();
          await game.ready();
          await tester.pump();
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('golden/backboard/game_over.png'),
          );
        },
      );
    });
  });
}
