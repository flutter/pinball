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
        value: plungerBloc ?? PlungerCubit(),
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

    flameTester.testGameWidget(
      'can be loaded',
      setUp: (game, _) async {
        final behavior = PlungerPullingBehavior(strength: 0);
        await game.pump(behavior);
      },
      verify: (game, _) async {
        expect(
          game.descendants().whereType<PlungerPullingBehavior>().length,
          equals(1),
        );
      },
    );

    flameTester.testGameWidget(
      'applies vertical linear velocity when pulled',
      setUp: (game, _) async {
        final plungerBloc = _MockPlungerCubit();
        whenListen<PlungerState>(
          plungerBloc,
          Stream.value(PlungerState.pulling),
          initialState: PlungerState.pulling,
        );

        final behavior = PlungerPullingBehavior(
          strength: 2,
        );
        await game.pump(
          behavior,
          plungerBloc: plungerBloc,
        );
      },
      verify: (game, _) async {
        final behavior =
            game.descendants().whereType<PlungerPullingBehavior>().single;
        game.update(0);

        final plunger = behavior.ancestors().whereType<Plunger>().single;
        expect(plunger.body.linearVelocity.x, equals(0));
        expect(plunger.body.linearVelocity.y, equals(2));
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

    flameTester.testGameWidget(
      'can be loaded',
      setUp: (game, _) async {
        final behavior = PlungerAutoPullingBehavior();
        await game.pump(behavior);
      },
      verify: (game, _) async {
        expect(
          game.descendants().whereType<PlungerAutoPullingBehavior>().length,
          equals(1),
        );
      },
    );

    flameTester.testGameWidget(
      'releases when joint reaches limit',
      setUp: (game, _) async {
        final plungerBloc = _MockPlungerCubit();
        whenListen<PlungerState>(
          plungerBloc,
          Stream.value(PlungerState.autoPulling),
          initialState: PlungerState.autoPulling,
        );

        final behavior = PlungerAutoPullingBehavior();
        final joint = _MockPrismaticJoint();
        when(joint.getJointTranslation).thenReturn(0);
        when(joint.getLowerLimit).thenReturn(0);
        await game.pump(
          behavior,
          plungerBloc: plungerBloc,
        );
        final plunger = game.descendants().whereType<Plunger>().single;
        plunger.body.joints.add(joint);
      },
      verify: (game, _) async {
        final plungerBloc = game
            .descendants()
            .whereType<FlameBlocProvider<PlungerCubit, PlungerState>>()
            .single
            .bloc;

        verify(plungerBloc.released).called(1);
      },
    );
  });
}
