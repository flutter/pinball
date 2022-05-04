// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/behaviors/behaviors.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

import '../../helpers/helpers.dart';

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
  final assets = [
    Assets.images.score.fiveThousand.keyName,
    Assets.images.score.twentyThousand.keyName,
    Assets.images.score.twoHundredThousand.keyName,
    Assets.images.score.oneMillion.keyName,
  ];

  late GameBloc bloc;
  late Ball ball;
  late BodyComponent parent;

  setUp(() {
    ball = _MockBall();
    final ballBody = _MockBody();
    when(() => ball.body).thenReturn(ballBody);
    when(() => ballBody.position).thenReturn(Vector2.all(4));

    parent = _TestBodyComponent();
  });

  final flameBlocTester = FlameBlocTester<EmptyPinballTestGame, GameBloc>(
    gameBuilder: EmptyPinballTestGame.new,
    blocBuilder: () {
      bloc = _MockGameBloc();
      const state = GameState(
        score: 0,
        multiplier: 1,
        rounds: 3,
        bonusHistory: [],
      );
      whenListen(bloc, Stream.value(state), initialState: state);
      return bloc;
    },
    assets: assets,
  );

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
      setUp: (game, tester) async {
        final canvas = ZCanvasComponent(children: [parent]);
        final behavior = ScoringBehavior(
          points: Points.fiveThousand,
          position: Vector2.zero(),
        );
        await parent.add(behavior);
        await game.ensureAdd(canvas);

        expect(
          parent.firstChild<ScoringBehavior>(),
          equals(behavior),
        );
      },
    );

    flameBlocTester.testGameWidget(
      'emits Scored event with points when added',
      setUp: (game, tester) async {
        const points = Points.oneMillion;
        final canvas = ZCanvasComponent(children: [parent]);
        await game.ensureAdd(canvas);

        final behavior = ScoringBehavior(
          points: points,
          position: Vector2(0, 0),
        );
        await parent.ensureAdd(behavior);

        verify(
          () => bloc.add(
            Scored(points: points.value),
          ),
        ).called(1);
      },
    );

    flameBlocTester.testGameWidget(
      'correctly renders text',
      setUp: (game, tester) async {
        final canvas = ZCanvasComponent(children: [parent]);
        await game.ensureAdd(canvas);

        const points = Points.oneMillion;
        final position = Vector2.all(1);
        final behavior = ScoringBehavior(
          points: points,
          position: position,
        );
        await parent.ensureAdd(behavior);

        final scoreText = game.descendants().whereType<ScoreComponent>();
        expect(scoreText.length, equals(1));
        expect(
          scoreText.first.points,
          equals(points),
        );
        expect(
          scoreText.first.position,
          equals(position),
        );
      },
    );

    flameBlocTester.testGameWidget(
      'is removed after duration',
      setUp: (game, tester) async {
        final canvas = ZCanvasComponent(children: [parent]);
        await game.ensureAdd(canvas);

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
        final canvas = ZCanvasComponent(children: [parent]);
        await game.ensureAdd(canvas);

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
        final canvas = ZCanvasComponent(children: [parent]);
        await game.ensureAdd(canvas);

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
