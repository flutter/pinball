import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_audio/pinball_audio.dart';
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
    late PinballAudio audio;
    late Ball ball;
    late FakeScorePoints fakeScorePoints;

    setUp(() {
      game = MockPinballGame();
      bloc = MockGameBloc();
      audio = MockPinballAudio();
      fakeScorePoints = FakeScorePoints();

      ball = MockBall();
      final ballBody = MockBody();
      when(() => ball.body).thenReturn(ballBody);
      when(() => ballBody.position).thenReturn(Vector2.all(4));
    });

    setUpAll(() {
      registerFallbackValue(FakeGameEvent());
    });

    group('begin', () {
      test(
        'emits Scored event with points',
        () {
          when(game.read<GameBloc>).thenReturn(bloc);
          when(() => game.audio).thenReturn(audio);

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

      test(
        'plays a Score sound',
        () {
          when(game.read<GameBloc>).thenReturn(bloc);
          when(() => game.audio).thenReturn(audio);

          BallScorePointsCallback(game).begin(
            ball,
            fakeScorePoints,
            FakeContact(),
          );

          verify(audio.score).called(1);
        },
      );

      test(
        "adds a ScoreText component at Ball's position",
        () {
          when(game.read<GameBloc>).thenReturn(bloc);
          when(() => game.audio).thenReturn(audio);

          BallScorePointsCallback(game).begin(
            ball,
            fakeScorePoints,
            FakeContact(),
          );

          verify(
            () => game.add(
              ScoreText(
                text: fakeScorePoints.points.toString(),
                position: ball.body.position,
              ),
            ),
          ).called(1);
        },
      );
    });
  });
}
