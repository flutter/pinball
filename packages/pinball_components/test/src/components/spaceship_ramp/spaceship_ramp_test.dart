// ignore_for_file: cascade_invocations, prefer_const_constructors

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/spaceship_ramp/behavior/behavior.dart';
import 'package:pinball_flame/pinball_flame.dart';

class _TestGame extends Forge2DGame {
  @override
  Future<void> onLoad() async {
    images.prefix = '';
    await images.loadAll([
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
    ]);
  }

  Future<void> pump(
    SpaceshipRamp children, {
    required SpaceshipRampCubit bloc,
  }) async {
    await ensureAdd(
      FlameBlocProvider<SpaceshipRampCubit, SpaceshipRampState>.value(
        value: bloc,
        children: [
          ZCanvasComponent(children: [children]),
        ],
      ),
    );
  }
}

class _MockSpaceshipRampCubit extends Mock implements SpaceshipRampCubit {}

class _MockBall extends Mock implements Ball {}

class _MockContact extends Mock implements Contact {}

class _MockManifold extends Mock implements Manifold {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final flameTester = FlameTester(_TestGame.new);

  group('SpaceshipRamp', () {
    flameTester.testGameWidget(
      'loads correctly',
      setUp: (game, _) async {
        final bloc = _MockSpaceshipRampCubit();
        final streamController = StreamController<SpaceshipRampState>();
        whenListen(
          bloc,
          streamController.stream,
          initialState: SpaceshipRampState.initial(),
        );
        final ramp = SpaceshipRamp.test();
        await game.pump(ramp, bloc: bloc);
      },
      verify: (game, _) async {
        expect(game.descendants().whereType<SpaceshipRamp>().length, equals(1));
      },
    );

    group('adds', () {
      flameTester.testGameWidget(
        'a FlameBlocProvider',
        setUp: (game, _) async {
          final ramp = SpaceshipRamp();
          await game.ensureAdd(ramp);
        },
        verify: (game, _) async {
          final ramp = game.descendants().whereType<SpaceshipRamp>().single;
          expect(
            ramp.children
                .whereType<
                    FlameBlocProvider<SpaceshipRampCubit, SpaceshipRampState>>()
                .single,
            isNotNull,
          );
        },
      );

      flameTester.testGameWidget(
        'a SpaceshipRampBoardOpening',
        setUp: (game, _) async {
          final ramp = SpaceshipRamp();
          await game.ensureAdd(ramp);
        },
        verify: (game, _) async {
          expect(
            game.descendants().whereType<SpaceshipRampBoardOpening>().length,
            equals(1),
          );
        },
      );

      flameTester.testGameWidget(
        'a SpaceshipRampArrowSpriteComponent',
        setUp: (game, _) async {
          final ramp = SpaceshipRamp();
          await game.ensureAdd(ramp);
        },
        verify: (game, _) async {
          expect(
            game
                .descendants()
                .whereType<SpaceshipRampArrowSpriteComponent>()
                .length,
            equals(1),
          );
        },
      );

      flameTester.testGameWidget(
        'new children',
        setUp: (game, _) async {
          final component = Component();
          final ramp = SpaceshipRamp(children: [component]);
          await game.ensureAdd(ramp);
        },
        verify: (game, _) async {
          final ramp = game.descendants().whereType<SpaceshipRamp>().single;

          expect(ramp.descendants().whereType<Component>(), isNotEmpty);
        },
      );
    });
  });

  group('SpaceshipRampBase', () {
    test('can be instantiated', () {
      expect(SpaceshipRampBase(), isA<SpaceshipRampBase>());
    });

    flameTester.testGameWidget(
      'can be loaded',
      setUp: (game, _) async {
        final component = SpaceshipRampBase();
        await game.ensureAdd(component);
      },
      verify: (game, _) async {
        expect(
          game.descendants().whereType<SpaceshipRampBase>().length,
          equals(1),
        );
      },
    );

    flameTester.testGameWidget(
      'postSolves disables contact when ball is not on Layer.board',
      setUp: (game, _) async {
        await game.onLoad();
        final component = SpaceshipRampBase();
        await game.ensureAdd(component);
        await game.ready();
      },
      verify: (game, _) async {
        final component =
            game.descendants().whereType<SpaceshipRampBase>().single;

        final ball = _MockBall();
        when(() => ball.layer).thenReturn(Layer.spaceshipEntranceRamp);
        final contact = _MockContact();
        component.preSolve(ball, contact, _MockManifold());
        game.update(0);
        verify(() => contact.isEnabled = false).called(1);
      },
    );

    flameTester.testGameWidget(
      'postSolves enables contact when ball is on Layer.board',
      setUp: (game, _) async {
        final component = SpaceshipRampBase();
        await game.ensureAdd(component);
      },
      verify: (game, _) async {
        final component =
            game.descendants().whereType<SpaceshipRampBase>().single;
        final ball = _MockBall();
        final contact = _MockContact();
        when(() => ball.layer).thenReturn(Layer.board);

        component.preSolve(ball, contact, _MockManifold());

        verify(() => contact.isEnabled = true).called(1);
      },
    );
  });

  group('SpaceshipRampBoardOpening', () {
    test('can be instantiated', () {
      expect(SpaceshipRampBoardOpening(), isA<SpaceshipRampBoardOpening>());
    });

    flameTester.testGameWidget(
      'can be loaded',
      setUp: (game, _) async {
        final component = SpaceshipRampBoardOpening();
        final parent = SpaceshipRamp.test();
        await game.pump(parent, bloc: _MockSpaceshipRampCubit());

        await parent.ensureAdd(component);
      },
      verify: (game, _) async {
        final spaceshipRamp =
            game.descendants().whereType<SpaceshipRamp>().single;
        expect(
          spaceshipRamp.children.whereType<SpaceshipRampBoardOpening>().length,
          equals(1),
        );
      },
    );

    flameTester.testGameWidget(
      'adds a RampBallAscendingContactBehavior',
      setUp: (game, _) async {
        final component = SpaceshipRampBoardOpening();
        final parent = SpaceshipRamp.test();
        await game.pump(parent, bloc: _MockSpaceshipRampCubit());
        await parent.ensureAdd(component);
        await game.ready();
      },
      verify: (game, _) async {
        final spaceshipRamp =
            game.descendants().whereType<SpaceshipRamp>().single;
        expect(
          spaceshipRamp
              .descendants()
              .whereType<RampBallAscendingContactBehavior>()
              .length,
          equals(1),
        );
      },
    );
  });

  group('SpaceshipRampArrowSpriteComponent', () {
    flameTester.testGameWidget(
      'changes current state '
      'when SpaceshipRampState changes lightState',
      setUp: (game, _) async {
        await game.onLoad();
        await game.ready();
        final bloc = _MockSpaceshipRampCubit();
        final state = SpaceshipRampState.initial();
        final streamController = StreamController<SpaceshipRampState>();
        whenListen(
          bloc,
          streamController.stream,
          initialState: state,
        );
        final arrow = SpaceshipRampArrowSpriteComponent();
        final ramp = SpaceshipRamp.test(children: [arrow]);
        await game.pump(
          ramp,
          bloc: bloc,
        );
        expect(arrow.current, ArrowLightState.inactive);

        streamController
            .add(state.copyWith(lightState: ArrowLightState.active1));
      },
      verify: (game, _) async {
        final arrow = game
            .descendants()
            .whereType<SpaceshipRampArrowSpriteComponent>()
            .single;
        game.update(0);
        expect(arrow.current, ArrowLightState.active1);
      },
    );
  });
}
