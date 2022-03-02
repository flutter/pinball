import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';

class MockHasScore extends Mock with ScorePoints {}

class MockBall extends Mock implements Ball {}

class MockGameBloc extends Mock implements GameBloc {}

class MockPinballGame extends Mock implements PinballGame {}

class FakeContact extends Fake implements Contact {}

void main() {
  group('BallScorePointsCallback', () {
    late MockPinballGame game;
    late MockGameBloc bloc;
    late MockBall ball;
    late MockHasScore hasScore;

    setUp(() {
      game = MockPinballGame();
      bloc = MockGameBloc();
      ball = MockBall();
      hasScore = MockHasScore();
    });

    group('begin', () {
      test(
        'emits Scored event with points',
        () {
          const points = 2;

          when<PinballGame>(() => ball.gameRef).thenReturn(game);
          when<GameBloc>(game.read).thenReturn(bloc);
          when<int>(() => hasScore.points).thenReturn(points);

          BallScorePointsCallback().begin(
            ball,
            hasScore,
            FakeContact(),
          );

          verify(
            () => bloc.add(const Scored(points: points)),
          ).called(1);
        },
      );
    });

    group('end', () {
      test('does nothing', () {
        // TODO(alestiago): Write test.
      });
    });
  });
}
