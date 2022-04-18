// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SpaceshipRail', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    final flameTester = FlameTester(TestGame.new);

    flameTester.testGameWidget(
      'renders correctly',
      setUp: (game, tester) async {
        await game.addFromBlueprint(SpaceshipRail());
        game.camera.followVector2(Vector2.zero());
        game.camera.zoom = 8;
      },
      verify: (game, tester) async {
        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('golden/spaceship-rail.png'),
        );
      },
    );

    flameTester.test(
      'loads correctly',
      (game) async {
        final spaceshipRail = SpaceshipRail();
        await game.addFromBlueprint(spaceshipRail);
        await game.ready();

        for (final element in spaceshipRail.components) {
          expect(game.contains(element), isTrue);
        }
      },
    );
  });

  // TODO(alestiago): Make ContactCallback private and use `beginContact`
  // instead.
  group('SpaceshipRailExitBallContactCallback', () {
    late Forge2DGame game;
    late SpaceshipRailExit railExit;
    late Ball ball;
    late Body body;
    late Fixture fixture;
    late Filter filterData;

    setUp(() {
      game = MockGame();

      railExit = MockSpaceshipRailExit();

      ball = MockBall();
      body = MockBody();
      when(() => ball.gameRef).thenReturn(game);
      when(() => ball.body).thenReturn(body);

      fixture = MockFixture();
      filterData = MockFilter();
      when(() => body.fixtures).thenReturn([fixture]);
      when(() => fixture.filterData).thenReturn(filterData);
    });

    setUp(() {
      when(() => ball.priority).thenReturn(1);
      when(() => railExit.outsideLayer).thenReturn(Layer.board);
      when(() => railExit.outsidePriority).thenReturn(0);
    });

    test('changes the ball priority on contact', () {
      SpaceshipRailExitBallContactCallback().begin(
        railExit,
        ball,
        MockContact(),
      );

      verify(() => ball.sendTo(railExit.outsidePriority)).called(1);
    });

    test('changes the ball layer on contact', () {
      SpaceshipRailExitBallContactCallback().begin(
        railExit,
        ball,
        MockContact(),
      );

      verify(() => ball.layer = railExit.outsideLayer).called(1);
    });
  });
}
