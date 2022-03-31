import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

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
    late FakeScorePoints fakeScorePoints;

    setUp(() {
      game = MockPinballGame();
      bloc = MockGameBloc();
      ball = MockBall();
      fakeScorePoints = FakeScorePoints();
    });

    setUpAll(() {
      registerFallbackValue(FakeGameEvent());
    });

    group('begin', () {
      test(
        'emits Scored event with points',
        () {
          when<GameBloc>(game.read).thenReturn(bloc);

          BallScorePointsCallback(game).begin(
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
  });
}
