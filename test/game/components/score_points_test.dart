import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

class MockGameBloc extends Mock implements GameBloc {}

class MockPinballGame extends Mock implements PinballGame {}

class FakeContact extends Fake implements Contact {}

class FakeGameEvent extends Fake implements GameEvent {}

class FakeScorePoints extends BodyComponent with ScorePoints {
  @override
  Body createBody() {
    throw UnimplementedError();
  }

  @override
  int get points => 2;
}

void main() {
  group('BallScorePointsCallback', () {
    late PinballGame game;
    late GameBloc bloc;
    late Ball ball;
    late ComponentSet componentSet;
    late BallController ballController;
    late FakeScorePoints fakeScorePoints;

    setUp(() {
      game = MockPinballGame();
      bloc = MockGameBloc();
      ball = MockBall();
      componentSet = MockComponentSet();
      ballController = MockBallController();
      fakeScorePoints = FakeScorePoints();
    });

    setUpAll(() {
      registerFallbackValue(FakeGameEvent());
    });

    group('begin', () {
      test(
        'emits Scored event with points',
        () {
          when(() => componentSet.whereType<BallController>())
              .thenReturn([ballController]);
          when(() => ball.children).thenReturn(componentSet);
          when<Forge2DGame>(() => ballController.gameRef).thenReturn(game);
          when<GameBloc>(game.read).thenReturn(bloc);

          BallScorePointsCallback().begin(
            ball,
            fakeScorePoints,
            FakeContact(),
          );

          verify(
            () => bloc.add(
              Scored(points: fakeScorePoints.points),
            ),
          ).called(1);
        },
      );
    });

    group('end', () {
      test("doesn't add events to GameBloc", () {
        BallScorePointsCallback().end(
          ball,
          fakeScorePoints,
          FakeContact(),
        );

        verifyNever(
          () => bloc.add(any()),
        );
      });
    });
  });
}
