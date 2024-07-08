// ignore_for_file: cascade_invocations

import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/behaviors/behaviors.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

class _TestGame extends Forge2DGame {
  @override
  Future<void> onLoad() async {
    images.prefix = '';
    await images.loadAll([
      Assets.images.score.fiveThousand.keyName,
      Assets.images.score.twentyThousand.keyName,
      Assets.images.score.twoHundredThousand.keyName,
      Assets.images.score.oneMillion.keyName,
    ]);
  }

  Future<void> pump(BodyComponent child, {GameBloc? gameBloc}) {
    return ensureAdd(
      FlameBlocProvider<GameBloc, GameState>.value(
        value: gameBloc ?? GameBloc(),
        children: [
          ZCanvasComponent(children: [child]),
        ],
      ),
    );
  }
}

class _TestBodyComponent extends BodyComponent {
  @override
  Body createBody() => world.createBody(BodyDef());
}

class _MockBall extends Mock implements Ball {}

class _MockBody extends Mock implements Body {}

class _MockGameBloc extends Mock implements GameBloc {}

class _MockContact extends Mock implements Contact {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late GameBloc bloc;
  late Ball ball;
  late BodyComponent parent;

  setUp(() {
    bloc = _MockGameBloc();
    ball = _MockBall();
    final ballBody = _MockBody();
    when(() => ball.body).thenReturn(ballBody);
    when(() => ballBody.position).thenReturn(Vector2.all(4));

    parent = _TestBodyComponent();
  });

  final flameBlocTester = FlameTester(_TestGame.new);

  group('ScoringBehavior', () {
    test('can be instantiated', () {
      expect(
        ScoringBehavior(
          points: Points.fiveThousand,
          position: Vector2.zero(),
        ),
        isA<ScoringBehavior>(),
      );
    });

    flameBlocTester.testGameWidget(
      'can be loaded',
      setUp: (game, _) async {
        await game.onLoad();
        await game.pump(parent);
        final behavior = ScoringBehavior(
          points: Points.fiveThousand,
          position: Vector2.zero(),
        );
        await parent.ensureAdd(behavior);
      },
      verify: (game, _) async {
        expect(
          parent.firstChild<ScoringBehavior>(),
          isNotNull,
        );
      },
    );

    flameBlocTester.testGameWidget(
      'emits Scored event with points when added',
      setUp: (game, _) async {
        await game.onLoad();
        await game.pump(parent, gameBloc: bloc);

        final behavior = ScoringBehavior(
          points: Points.oneMillion,
          position: Vector2(0, 0),
        );
        await parent.ensureAdd(behavior);
      },
      verify: (game, _) async {
        verify(
          () => bloc.add(
            Scored(points: Points.oneMillion.value),
          ),
        ).called(1);
      },
    );

    flameBlocTester.testGameWidget(
      'correctly renders text',
      setUp: (game, _) async {
        await game.onLoad();
        await game.pump(parent);

        final behavior = ScoringBehavior(
          points: Points.oneMillion,
          position: Vector2.all(1),
        );
        await parent.ensureAdd(behavior);
      },
      verify: (game, _) async {
        final scoreText = game.descendants().whereType<ScoreComponent>();
        expect(scoreText.length, equals(1));
        expect(
          scoreText.first.points,
          equals(Points.oneMillion),
        );
        expect(
          scoreText.first.position,
          equals(Vector2.all(1)),
        );
      },
    );

    flameBlocTester.testGameWidget(
      'is removed after duration',
      setUp: (game, tester) async {
        await game.onLoad();
        await game.pump(parent);

        const duration = 2.0;
        final behavior = ScoringBehavior(
          points: Points.oneMillion,
          position: Vector2(0, 0),
          duration: duration,
        );
        await parent.ensureAdd(behavior);

        game.update(duration);
        game.update(0);
        await tester.pump();
      },
      verify: (game, _) async {
        expect(
          game.descendants().whereType<ScoringBehavior>(),
          isEmpty,
        );
      },
    );
  });

  group('ScoringContactBehavior', () {
    flameBlocTester.testGameWidget(
      'beginContact adds a ScoringBehavior',
      setUp: (game, tester) async {
        await game.onLoad();
        await game.pump(parent);

        final behavior = ScoringContactBehavior(points: Points.oneMillion);
        await parent.ensureAdd(behavior);

        behavior.beginContact(ball, _MockContact());
        await game.ready();

        expect(
          parent.firstChild<ScoringBehavior>(),
          isNotNull,
        );
      },
    );

    flameBlocTester.testGameWidget(
      "beginContact positions text at contact's position",
      setUp: (game, tester) async {
        await game.onLoad();
        await game.pump(parent);

        final behavior = ScoringContactBehavior(points: Points.oneMillion);
        await parent.ensureAdd(behavior);

        behavior.beginContact(ball, _MockContact());
        await game.ready();

        final scoreText = game.descendants().whereType<ScoreComponent>();
        expect(
          scoreText.first.position,
          equals(ball.body.position),
        );
      },
    );
  });
}
