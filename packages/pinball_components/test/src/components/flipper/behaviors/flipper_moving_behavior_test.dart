// ignore_for_file: avoid_dynamic_calls, cascade_invocations

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_audio/pinball_audio.dart';
import 'package:pinball_components/pinball_components.dart';

class _TestGame extends Forge2DGame {
  Future<void> pump(
    FlipperMovingBehavior behavior, {
    FlipperCubit? flipperBloc,
    PinballAudioPlayer? audioPlayer,
  }) async {
    final flipper = Flipper.test(side: BoardSide.left);
    await ensureAdd(flipper);
    await flipper.ensureAdd(
      FlameBlocProvider<FlipperCubit, FlipperState>.value(
        value: flipperBloc ?? FlipperCubit(),
        children: [behavior],
      ),
    );
  }
}

class _MockFlipperCubit extends Mock implements FlipperCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(_TestGame.new);

  group('FlipperMovingBehavior', () {
    test('can be instantiated', () {
      expect(
        FlipperMovingBehavior(strength: 0),
        isA<FlipperMovingBehavior>(),
      );
    });

    test('throws assertion error when strength is negative', () {
      expect(
        () => FlipperMovingBehavior(strength: -1),
        throwsAssertionError,
      );
    });

    flameTester.test('can be loaded', (game) async {
      final behavior = FlipperMovingBehavior(strength: 0);
      await game.pump(behavior);
      expect(game.descendants(), contains(behavior));
    });

    flameTester.test(
      'applies vertical velocity to flipper when moving down',
      (game) async {
        final bloc = _MockFlipperCubit();
        final streamController = StreamController<FlipperState>();
        whenListen(
          bloc,
          streamController.stream,
          initialState: FlipperState.movingUp,
        );

        const strength = 10.0;
        final behavior = FlipperMovingBehavior(strength: strength);
        await game.pump(behavior, flipperBloc: bloc);

        streamController.add(FlipperState.movingDown);
        await Future<void>.delayed(Duration.zero);

        final flipper = behavior.ancestors().whereType<Flipper>().single;
        expect(flipper.body.linearVelocity.x, 0);
        expect(flipper.body.linearVelocity.y, strength);
      },
    );

    flameTester.test(
      'applies vertical velocity to flipper when moving up',
      (game) async {
        final bloc = _MockFlipperCubit();
        whenListen(
          bloc,
          Stream.value(FlipperState.movingUp),
          initialState: FlipperState.movingUp,
        );

        const strength = 10.0;
        final behavior = FlipperMovingBehavior(strength: strength);
        await game.pump(behavior, flipperBloc: bloc);
        game.update(0);

        final flipper = behavior.ancestors().whereType<Flipper>().single;
        expect(flipper.body.linearVelocity.x, 0);
        expect(flipper.body.linearVelocity.y, -strength);
      },
    );
  });
}
