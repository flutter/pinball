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
    SpaceshipRamp child, {
    required SpaceshipRampCubit spaceshipRampCubit,
  }) async {
    await ensureAdd(
      FlameBlocProvider<SpaceshipRampCubit, SpaceshipRampState>.value(
        value: spaceshipRampCubit,
        children: [
          ZCanvasComponent(children: [child]),
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
  ];

  final flameTester = FlameTester(_TestGame.new);

  group('SpaceshipRamp', () {
    flameTester.test(
      'loads correctly',
      (game) async {
        final bloc = _MockSpaceshipRampCubit();
        final streamController = StreamController<SpaceshipRampState>();
        whenListen(
          bloc,
          streamController.stream,
          initialState: SpaceshipRampState.initial(),
        );
        final ramp = SpaceshipRamp();
        await game.pump(
          ramp,
          spaceshipRampCubit: bloc,
        );
        expect(game.descendants(), contains(ramp));
      },
    );

    group('loads', () {
      flameTester.test(
        'a SpaceshipRampBoardOpening',
        (game) async {
          final bloc = _MockSpaceshipRampCubit();
          final streamController = StreamController<SpaceshipRampState>();
          whenListen(
            bloc,
            streamController.stream,
            initialState: SpaceshipRampState.initial(),
          );
          final ramp = SpaceshipRamp();
          await game.pump(
            ramp,
            spaceshipRampCubit: bloc,
          );
          expect(
            game.descendants().whereType<SpaceshipRampBoardOpening>().length,
            equals(1),
          );
        },
      );

      flameTester.test(
        'a SpaceshipRampArrowSpriteComponent',
        (game) async {
          final bloc = _MockSpaceshipRampCubit();
          final streamController = StreamController<SpaceshipRampState>();
          whenListen(
            bloc,
            streamController.stream,
            initialState: SpaceshipRampState.initial(),
          );
          final ramp = SpaceshipRamp();
          await game.pump(
            ramp,
            spaceshipRampCubit: bloc,
          );
          expect(
            game
                .descendants()
                .whereType<SpaceshipRampArrowSpriteComponent>()
                .length,
            equals(1),
          );
        },
      );

      flameTester.test(
        'a RampArrowBlinkingBehavior',
        (game) async {
          final bloc = _MockSpaceshipRampCubit();
          final streamController = StreamController<SpaceshipRampState>();
          whenListen(
            bloc,
            streamController.stream,
            initialState: SpaceshipRampState.initial(),
          );
          final ramp = SpaceshipRamp();
          await game.pump(
            ramp,
            spaceshipRampCubit: bloc,
          );
          expect(
            game.descendants().whereType<RampArrowBlinkingBehavior>().length,
            equals(1),
          );
        },
      );
    });

    group('renders correctly', () {
      const goldenFilePath = '../golden/spaceship_ramp/';
      final centerForSpaceshipRamp = Vector2(-13, -55);

      flameTester.testGameWidget(
        'inactive sprite',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          final bloc = _MockSpaceshipRampCubit();
          final streamController = StreamController<SpaceshipRampState>();
          whenListen(
            bloc,
            streamController.stream,
            initialState: SpaceshipRampState.initial(),
          );
          final ramp = SpaceshipRamp();
          await game.pump(
            ramp,
            spaceshipRampCubit: bloc,
          );

          await tester.pump();

          final current = ramp.children
              .whereType<SpaceshipRampArrowSpriteComponent>()
              .first
              .current;
          expect(
            current,
            ArrowLightState.inactive,
          );

          game.camera.followVector2(centerForSpaceshipRamp);
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<_TestGame>(),
            matchesGoldenFile('${goldenFilePath}inactive.png'),
          );
        },
      );

      flameTester.testGameWidget(
        'active1 sprite',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          final bloc = _MockSpaceshipRampCubit();
          final state = SpaceshipRampState.initial();
          final streamController = StreamController<SpaceshipRampState>();
          whenListen(
            bloc,
            streamController.stream,
            initialState: state,
          );
          final ramp = SpaceshipRamp();
          await game.pump(
            ramp,
            spaceshipRampCubit: bloc,
          );

          streamController.add(
            state.copyWith(lightState: ArrowLightState.active1),
          );

          await game.ready();
          await tester.pump();

          final current = ramp.children
              .whereType<SpaceshipRampArrowSpriteComponent>()
              .first
              .current;
          expect(
            current,
            ArrowLightState.active1,
          );

          game.camera.followVector2(centerForSpaceshipRamp);
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<_TestGame>(),
            matchesGoldenFile('${goldenFilePath}active1.png'),
          );
        },
      );

      flameTester.testGameWidget(
        'active2 sprite',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          final bloc = _MockSpaceshipRampCubit();
          final state = SpaceshipRampState.initial();
          final streamController = StreamController<SpaceshipRampState>();
          whenListen(
            bloc,
            streamController.stream,
            initialState: state,
          );
          final ramp = SpaceshipRamp();
          await game.pump(
            ramp,
            spaceshipRampCubit: bloc,
          );

          streamController.add(
            state.copyWith(lightState: ArrowLightState.active2),
          );

          await game.ready();
          await tester.pump();

          final current = ramp.children
              .whereType<SpaceshipRampArrowSpriteComponent>()
              .first
              .current;
          expect(
            current,
            ArrowLightState.active2,
          );

          game.camera.followVector2(centerForSpaceshipRamp);
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<_TestGame>(),
            matchesGoldenFile('${goldenFilePath}active2.png'),
          );
        },
      );

      flameTester.testGameWidget(
        'active3 sprite',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          final bloc = _MockSpaceshipRampCubit();
          final state = SpaceshipRampState.initial();
          final streamController = StreamController<SpaceshipRampState>();
          whenListen(
            bloc,
            streamController.stream,
            initialState: state,
          );
          final ramp = SpaceshipRamp();
          await game.pump(
            ramp,
            spaceshipRampCubit: bloc,
          );

          streamController.add(
            state.copyWith(lightState: ArrowLightState.active3),
          );

          await game.ready();
          await tester.pump();

          final current = ramp.children
              .whereType<SpaceshipRampArrowSpriteComponent>()
              .first
              .current;
          expect(
            current,
            ArrowLightState.active3,
          );

          game.camera.followVector2(centerForSpaceshipRamp);
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<_TestGame>(),
            matchesGoldenFile('${goldenFilePath}active3.png'),
          );
        },
      );

      flameTester.testGameWidget(
        'active4 sprite',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          final bloc = _MockSpaceshipRampCubit();
          final state = SpaceshipRampState.initial();
          final streamController = StreamController<SpaceshipRampState>();
          whenListen(
            bloc,
            streamController.stream,
            initialState: state,
          );
          final ramp = SpaceshipRamp();
          await game.pump(
            ramp,
            spaceshipRampCubit: bloc,
          );

          streamController.add(
            state.copyWith(lightState: ArrowLightState.active4),
          );

          await game.ready();
          await tester.pump();

          final current = ramp.children
              .whereType<SpaceshipRampArrowSpriteComponent>()
              .first
              .current;
          expect(
            current,
            ArrowLightState.active4,
          );

          game.camera.followVector2(centerForSpaceshipRamp);
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<_TestGame>(),
            matchesGoldenFile('${goldenFilePath}active4.png'),
          );
        },
      );

      flameTester.testGameWidget(
        'active5 sprite',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          final bloc = _MockSpaceshipRampCubit();
          final state = SpaceshipRampState.initial();
          final streamController = StreamController<SpaceshipRampState>();
          whenListen(
            bloc,
            streamController.stream,
            initialState: state,
          );
          final ramp = SpaceshipRamp();
          await game.pump(
            ramp,
            spaceshipRampCubit: bloc,
          );

          streamController.add(
            state.copyWith(lightState: ArrowLightState.active5),
          );

          await game.ready();
          await tester.pump();

          final current = ramp.children
              .whereType<SpaceshipRampArrowSpriteComponent>()
              .first
              .current;
          expect(
            current,
            ArrowLightState.active5,
          );

          game.camera.followVector2(centerForSpaceshipRamp);
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<_TestGame>(),
            matchesGoldenFile('${goldenFilePath}active5.png'),
          );
        },
      );
    });

    group('adds', () {
      flameTester.test('new children', (game) async {
        final bloc = _MockSpaceshipRampCubit();
        final streamController = StreamController<SpaceshipRampState>();
        whenListen(
          bloc,
          streamController.stream,
          initialState: SpaceshipRampState.initial(),
        );
        final component = Component();
        final ramp = SpaceshipRamp(children: [component]);
        await game.pump(
          ramp,
          spaceshipRampCubit: bloc,
        );
        expect(ramp.children, contains(component));
      });
    });
  });

  group('SpaceshipRampBase', () {
    test('can be instantiated', () {
      expect(SpaceshipRampBase(), isA<SpaceshipRampBase>());
    });

    flameTester.test('can be loaded', (game) async {
      final component = SpaceshipRampBase();
      await game.ensureAdd(component);
      expect(game.children, contains(component));
    });

    flameTester.test(
      'postSolves disables contact when ball is not on Layer.board',
      (game) async {
        final ball = _MockBall();
        final contact = _MockContact();
        when(() => ball.layer).thenReturn(Layer.spaceshipEntranceRamp);
        final component = SpaceshipRampBase();
        await game.ensureAdd(component);

        component.preSolve(ball, contact, _MockManifold());

        verify(() => contact.setEnabled(false)).called(1);
      },
    );

    flameTester.test(
      'postSolves enables contact when ball is on Layer.board',
      (game) async {
        final ball = _MockBall();
        final contact = _MockContact();
        when(() => ball.layer).thenReturn(Layer.board);
        final component = SpaceshipRampBase();
        await game.ensureAdd(component);

        component.preSolve(ball, contact, _MockManifold());

        verify(() => contact.setEnabled(true)).called(1);
      },
    );
  });

  group('SpaceshipRampBoardOpening', () {
    test('can be instantiated', () {
      expect(SpaceshipRampBoardOpening(), isA<SpaceshipRampBoardOpening>());
    });

    flameTester.test('can be loaded', (game) async {
      final component = SpaceshipRampBoardOpening();
      final parent = SpaceshipRamp.test();
      await game.pump(
        parent,
        spaceshipRampCubit: _MockSpaceshipRampCubit(),
      );
      await parent.ensureAdd(component);
      expect(parent.children, contains(component));
    });

    flameTester.test('adds a RampBallAscendingContactBehavior', (game) async {
      final component = SpaceshipRampBoardOpening();
      final ramp = SpaceshipRamp.test();
      await game.pump(
        ramp,
        spaceshipRampCubit: _MockSpaceshipRampCubit(),
      );
      await ramp.ensureAdd(component);
      expect(
        component.children.whereType<RampBallAscendingContactBehavior>().length,
        equals(1),
      );
    });
  });
}
