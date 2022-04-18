// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

import '../../helpers/helpers.dart';

void main() {
  group('Spaceship', () {
    late Filter filterData;
    late Fixture fixture;
    late Body body;
    late Ball ball;
    late Forge2DGame game;

    setUp(() {
      filterData = MockFilter();

      fixture = MockFixture();
      when(() => fixture.filterData).thenReturn(filterData);

      body = MockBody();
      when(() => body.fixtures).thenReturn([fixture]);

      game = MockGame();

      ball = MockBall();
      when(() => ball.gameRef).thenReturn(game);
      when(() => ball.body).thenReturn(body);
    });

    group('Spaceship', () {
      final tester = FlameTester(TestGame.new);

      tester.testGameWidget(
        'renders correctly',
        setUp: (game, tester) async {
          final position = Vector2(30, -30);
          await game.addFromBlueprint(Spaceship(position: position));
          game.camera.followVector2(position);
          await game.ready();
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('golden/spaceship.png'),
          );
        },
      );
    });
  });
}
