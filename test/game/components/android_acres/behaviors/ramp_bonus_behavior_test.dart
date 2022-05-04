// ignore_for_file: cascade_invocations, prefer_const_constructors

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/behaviors/behaviors.dart';
import 'package:pinball/game/components/android_acres/behaviors/behaviors.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

import '../../../../helpers/helpers.dart';

class _MockGameBloc extends Mock implements GameBloc {}

class _MockSpaceshipRampCubit extends Mock implements SpaceshipRampCubit {}

class _MockStreamSubscription extends Mock
    implements StreamSubscription<SpaceshipRampState> {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.android.ramp.boardOpening.keyName,
    Assets.images.android.ramp.railingForeground.keyName,
    Assets.images.android.ramp.railingBackground.keyName,
    Assets.images.android.ramp.main.keyName,
    Assets.images.android.ramp.arrow.inactive.keyName,
    Assets.images.android.ramp.arrow.active1.keyName,
    Assets.images.android.ramp.arrow.active2.keyName,
    Assets.images.android.ramp.arrow.active3.keyName,
    Assets.images.android.ramp.arrow.active4.keyName,
    Assets.images.android.ramp.arrow.active5.keyName,
    Assets.images.android.rail.main.keyName,
    Assets.images.android.rail.exit.keyName,
    Assets.images.score.oneMillion.keyName,
  ];

  group('RampBonusBehavior', () {
    const shotPoints = Points.oneMillion;

    late GameBloc gameBloc;

    setUp(() {
      gameBloc = _MockGameBloc();
      whenListen(
        gameBloc,
        const Stream<GameState>.empty(),
        initialState: const GameState.initial(),
      );
    });

    final flameBlocTester = FlameBlocTester<PinballGame, GameBloc>(
      gameBuilder: EmptyPinballTestGame.new,
      blocBuilder: () => gameBloc,
      assets: assets,
    );

    flameBlocTester.testGameWidget(
      'when hits are multiples of 10 times adds a ScoringBehavior',
      setUp: (game, tester) async {
        final bloc = _MockSpaceshipRampCubit();
        final streamController = StreamController<SpaceshipRampState>();
        whenListen(
          bloc,
          streamController.stream,
          initialState: SpaceshipRampState(hits: 9),
        );
        final behavior = RampBonusBehavior(
          points: shotPoints,
        );
        final parent = SpaceshipRamp.test(
          bloc: bloc,
        );

        await game.ensureAdd(ZCanvasComponent(children: [parent]));
        await parent.ensureAdd(behavior);

        streamController.add(SpaceshipRampState(hits: 10));

        final scores = game.descendants().whereType<ScoringBehavior>();
        await game.ready();

        expect(scores.length, 1);
      },
    );

    flameBlocTester.testGameWidget(
      "when hits are not multiple of 10 times doesn't add any ScoringBehavior",
      setUp: (game, tester) async {
        final bloc = _MockSpaceshipRampCubit();
        final streamController = StreamController<SpaceshipRampState>();
        whenListen(
          bloc,
          streamController.stream,
          initialState: SpaceshipRampState.initial(),
        );
        final behavior = RampBonusBehavior(
          points: shotPoints,
        );
        final parent = SpaceshipRamp.test(
          bloc: bloc,
        );

        await game.ensureAdd(ZCanvasComponent(children: [parent]));
        await parent.ensureAdd(behavior);

        streamController.add(SpaceshipRampState(hits: 1));

        final scores = game.descendants().whereType<ScoringBehavior>();
        await game.ready();

        expect(scores.length, 0);
      },
    );

    flameBlocTester.testGameWidget(
      'closes subscription when removed',
      setUp: (game, tester) async {
        final bloc = _MockSpaceshipRampCubit();
        whenListen(
          bloc,
          const Stream<SpaceshipRampState>.empty(),
          initialState: SpaceshipRampState.initial(),
        );
        when(bloc.close).thenAnswer((_) async {});

        final subscription = _MockStreamSubscription();
        when(subscription.cancel).thenAnswer((_) async {});

        final behavior = RampBonusBehavior.test(
          points: shotPoints,
          subscription: subscription,
        );
        final parent = SpaceshipRamp.test(
          bloc: bloc,
        );

        await game.ensureAdd(ZCanvasComponent(children: [parent]));
        await parent.ensureAdd(behavior);

        parent.remove(behavior);
        await game.ready();

        verify(subscription.cancel).called(1);
      },
    );
  });
}
