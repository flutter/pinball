// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_audio/pinball_audio.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

class _TestBodyComponent extends BodyComponent {
  @override
  Body createBody() => world.createBody(BodyDef());
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.score.points1m.keyName,
    Assets.images.score.points1m2.keyName,
    Assets.images.score.points2m.keyName,
    Assets.images.score.points3m.keyName,
    Assets.images.score.points4m.keyName,
    Assets.images.score.points5k.keyName,
    Assets.images.score.points5m.keyName,
    Assets.images.score.points6m.keyName,
    Assets.images.score.points10k.keyName,
    Assets.images.score.points15k.keyName,
    Assets.images.score.points20k.keyName,
    Assets.images.score.points25k.keyName,
    Assets.images.score.points30k.keyName,
    Assets.images.score.points40k.keyName,
    Assets.images.score.points50k.keyName,
    Assets.images.score.points60k.keyName,
    Assets.images.score.points80k.keyName,
    Assets.images.score.points100k.keyName,
    Assets.images.score.points120k.keyName,
    Assets.images.score.points200k.keyName,
    Assets.images.score.points400k.keyName,
    Assets.images.score.points600k.keyName,
    Assets.images.score.points800k.keyName,
  ];

  group('ScoringBehavior', () {
    group('beginContact', () {
      late GameBloc bloc;
      late PinballAudio audio;
      late Ball ball;
      late BodyComponent parent;

      setUp(() {
        audio = MockPinballAudio();

        ball = MockBall();
        final ballBody = MockBody();
        when(() => ball.body).thenReturn(ballBody);
        when(() => ballBody.position).thenReturn(Vector2.all(4));

        parent = _TestBodyComponent();
      });

      final flameBlocTester = FlameBlocTester<EmptyPinballTestGame, GameBloc>(
        gameBuilder: () => EmptyPinballTestGame(
          audio: audio,
        ),
        blocBuilder: () {
          bloc = MockGameBloc();
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

      flameBlocTester.testGameWidget(
        'emits Scored event with points',
        setUp: (game, tester) async {
          const points = Points.points_6m;
          final scoringBehavior = ScoringBehavior(points: points);
          await parent.add(scoringBehavior);
          await game.ensureAdd(parent);

          scoringBehavior.beginContact(ball, MockContact());

          verify(
            () => bloc.add(
              Scored(points: points.value),
            ),
          ).called(1);
        },
      );

      flameBlocTester.testGameWidget(
        'plays score sound',
        setUp: (game, tester) async {
          final scoringBehavior = ScoringBehavior(points: Points.points_6m);
          await parent.add(scoringBehavior);
          await game.ensureAdd(parent);

          scoringBehavior.beginContact(ball, MockContact());

          verify(audio.score).called(1);
        },
      );

      flameBlocTester.testGameWidget(
        "adds a ScoreText component at Ball's position with points",
        setUp: (game, tester) async {
          const points = Points.points_6m;
          final scoringBehavior = ScoringBehavior(points: points);
          await parent.add(scoringBehavior);
          await game.ensureAdd(parent);

          scoringBehavior.beginContact(ball, MockContact());
          await game.ready();

          final scoreText = game.descendants().whereType<ScoreComponent>();
          expect(scoreText.length, equals(1));
          expect(
            scoreText.first.points,
            equals(points),
          );
          expect(
            scoreText.first.position,
            equals(ball.body.position),
          );
        },
      );
    });
  });
}
