// ignore_for_file: prefer_const_constructors, cascade_invocations

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/multiball/behaviors/behaviors.dart';

import '../../../../helpers/helpers.dart';

class _MockMultiballCubit extends Mock implements MultiballCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(TestGame.new);

  group(
    'MultiballBlinkingBehavior',
    () {
      flameTester.testGameWidget(
        'calls onBlink every 0.18 seconds when animation state is animated',
        setUp: (game, tester) async {
          final behavior = MultiballBlinkingBehavior();
          final bloc = _MockMultiballCubit();
          final streamController = StreamController<MultiballState>();
          whenListen(
            bloc,
            streamController.stream,
            initialState: MultiballState.initial(),
          );

          final multiball = Multiball.test(bloc: bloc);
          await multiball.add(behavior);
          await game.ensureAdd(multiball);

          streamController.add(
            MultiballState(
              animationState: MultiballAnimationState.blinking,
              lightState: MultiballLightState.lit,
            ),
          );
          await tester.pump();
          game.update(0);

          verify(bloc.onBlink).called(1);

          await tester.pump();
          game.update(0.18);

          await streamController.close();
          verify(bloc.onBlink).called(1);
        },
      );

      flameTester.testGameWidget(
        'calls onStop when animation state is stopped',
        setUp: (game, tester) async {
          final behavior = MultiballBlinkingBehavior();
          final bloc = _MockMultiballCubit();
          final streamController = StreamController<MultiballState>();
          whenListen(
            bloc,
            streamController.stream,
            initialState: MultiballState.initial(),
          );
          when(bloc.onBlink).thenAnswer((_) async {});

          final multiball = Multiball.test(bloc: bloc);
          await multiball.add(behavior);
          await game.ensureAdd(multiball);

          streamController.add(
            MultiballState(
              animationState: MultiballAnimationState.blinking,
              lightState: MultiballLightState.lit,
            ),
          );
          await tester.pump();

          streamController.add(
            MultiballState(
              animationState: MultiballAnimationState.idle,
              lightState: MultiballLightState.lit,
            ),
          );

          await streamController.close();
          verify(bloc.onStop).called(1);
        },
      );

      flameTester.testGameWidget(
        'onTick stops when there is no animation',
        setUp: (game, tester) async {
          final behavior = MultiballBlinkingBehavior();
          final bloc = _MockMultiballCubit();
          final streamController = StreamController<MultiballState>();
          whenListen(
            bloc,
            streamController.stream,
            initialState: MultiballState.initial(),
          );
          when(bloc.onBlink).thenAnswer((_) async {});

          final multiball = Multiball.test(bloc: bloc);
          await multiball.add(behavior);
          await game.ensureAdd(multiball);

          streamController.add(
            MultiballState(
              animationState: MultiballAnimationState.idle,
              lightState: MultiballLightState.lit,
            ),
          );
          await tester.pump();

          behavior.onTick();

          expect(behavior.timer.isRunning(), false);
        },
      );

      flameTester.testGameWidget(
        'onTick stops after 28 blinks',
        setUp: (game, tester) async {
          final behavior = MultiballBlinkingBehavior();
          final bloc = _MockMultiballCubit();
          final streamController = StreamController<MultiballState>();
          whenListen(
            bloc,
            streamController.stream,
            initialState: MultiballState.initial(),
          );
          when(bloc.onBlink).thenAnswer((_) async {});

          final multiball = Multiball.test(bloc: bloc);
          await multiball.add(behavior);
          await game.ensureAdd(multiball);

          streamController.add(
            MultiballState(
              animationState: MultiballAnimationState.blinking,
              lightState: MultiballLightState.dimmed,
            ),
          );
          await tester.pump();

          for (var i = 0; i < 28; i++) {
            behavior.onTick();
          }

          expect(behavior.timer.isRunning(), false);
        },
      );
    },
  );
}
