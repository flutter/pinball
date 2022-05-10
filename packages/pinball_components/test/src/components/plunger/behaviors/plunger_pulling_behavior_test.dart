// ignore_for_file: cascade_invocations

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';

class _TestGame extends Forge2DGame {
  Future<void> pump(
    Component behavior, {
    PlungerCubit? plungerBloc,
  }) async {
    final plunger = Plunger.test();
    await ensureAdd(plunger);
    return plunger.ensureAdd(
      FlameBlocProvider<PlungerCubit, PlungerState>.value(
        value: plungerBloc ?? _MockPlungerCubit(),
        children: [behavior],
      ),
    );
  }
}

class _MockPlungerCubit extends Mock implements PlungerCubit {}

class _MockPrismaticJoint extends Mock implements PrismaticJoint {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(_TestGame.new);

  group('PlungerPullingBehavior', () {
    test('can be instantiated', () {
      expect(
        PlungerPullingBehavior(strength: 0),
        isA<PlungerPullingBehavior>(),
      );
    });

    test('throws assertion error when strength is negative ', () {
      expect(
        () => PlungerPullingBehavior(strength: -1),
        throwsAssertionError,
      );
    });

    flameTester.test('can be loaded', (game) async {
      final behavior = PlungerPullingBehavior(strength: 0);
      await game.pump(behavior);
      expect(game.descendants(), contains(behavior));
    });

    flameTester.test(
      'applies vertical linear velocity when pulled',
      (game) async {
        final plungerBloc = _MockPlungerCubit();
        whenListen<PlungerState>(
          plungerBloc,
          Stream.value(PlungerState.pulling),
          initialState: PlungerState.pulling,
        );

        const strength = 2.0;
        final behavior = PlungerPullingBehavior(
          strength: strength,
        );
        await game.pump(
          behavior,
          plungerBloc: plungerBloc,
        );
        game.update(0);

        final plunger = behavior.ancestors().whereType<Plunger>().single;
        expect(plunger.body.linearVelocity.x, equals(0));
        expect(plunger.body.linearVelocity.y, equals(strength));
      },
    );
  });

  group('PlungerAutoPullingBehavior', () {
    test('can be instantiated', () {
      expect(
        PlungerAutoPullingBehavior(),
        isA<PlungerAutoPullingBehavior>(),
      );
    });

    flameTester.test('can be loaded', (game) async {
      final behavior = PlungerAutoPullingBehavior();
      await game.pump(behavior);
      expect(game.descendants(), contains(behavior));
    });

    flameTester.test(
      'releases when joint reaches limit',
      (game) async {
        final plungerBloc = _MockPlungerCubit();
        whenListen<PlungerState>(
          plungerBloc,
          Stream.value(PlungerState.autoPulling),
          initialState: PlungerState.autoPulling,
        );

        final behavior = PlungerAutoPullingBehavior();
        await game.pump(
          behavior,
          plungerBloc: plungerBloc,
        );
        final plunger = behavior.ancestors().whereType<Plunger>().single;
        final joint = _MockPrismaticJoint();
        when(joint.getJointTranslation).thenReturn(0);
        when(joint.getLowerLimit).thenReturn(0);
        plunger.body.joints.add(joint);

        game.update(0);

        verify(plungerBloc.released).called(1);
      },
    );
  });
}
