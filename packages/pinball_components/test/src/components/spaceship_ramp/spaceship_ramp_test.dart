// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/spaceship_ramp/behavior/behavior.dart';
import 'package:pinball_flame/pinball_flame.dart';

import '../../../helpers/helpers.dart';

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
  final flameTester = FlameTester(() => TestGame(assets));

  group('SpaceshipRamp', () {
    flameTester.test(
      'loads correctly',
      (game) async {
        final spaceshipRamp = SpaceshipRamp();
        await game.ensureAdd(spaceshipRamp);
        expect(game.children, contains(spaceshipRamp));
      },
    );

    group('renders correctly', () {
      const goldenFilePath = '../golden/spaceship_ramp/';
      final centerForSpaceshipRamp = Vector2(-13, -55);

      flameTester.testGameWidget(
        'inactive sprite',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          final ramp = SpaceshipRamp();
          final canvas = ZCanvasComponent(children: [ramp]);
          await game.ensureAdd(canvas);

          await tester.pump();

          final index = ramp.children
              .whereType<SpaceshipRampArrowSpriteComponent>()
              .first
              .current;
          expect(
            SpaceshipRampArrowSpriteState.values[index!],
            SpaceshipRampArrowSpriteState.inactive,
          );

          game.camera.followVector2(centerForSpaceshipRamp);
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('${goldenFilePath}inactive.png'),
          );
        },
      );

      flameTester.testGameWidget(
        'active1 sprite',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          final ramp = SpaceshipRamp();
          final canvas = ZCanvasComponent(children: [ramp]);
          await game.ensureAdd(canvas);

          ramp.bloc.onAscendingBallEntered();

          await game.ready();
          await tester.pump();

          final index = ramp.children
              .whereType<SpaceshipRampArrowSpriteComponent>()
              .first
              .current;
          expect(
            SpaceshipRampArrowSpriteState.values[index!],
            SpaceshipRampArrowSpriteState.active1,
          );

          game.camera.followVector2(centerForSpaceshipRamp);
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('${goldenFilePath}active1.png'),
          );
        },
      );

      flameTester.testGameWidget(
        'active2 sprite',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          final ramp = SpaceshipRamp();
          final canvas = ZCanvasComponent(children: [ramp]);
          await game.ensureAdd(canvas);

          ramp.bloc
            ..onAscendingBallEntered()
            ..onAscendingBallEntered();

          await game.ready();
          await tester.pump();

          final index = ramp.children
              .whereType<SpaceshipRampArrowSpriteComponent>()
              .first
              .current;
          expect(
            SpaceshipRampArrowSpriteState.values[index!],
            SpaceshipRampArrowSpriteState.active2,
          );

          game.camera.followVector2(centerForSpaceshipRamp);
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('${goldenFilePath}active2.png'),
          );
        },
      );

      flameTester.testGameWidget(
        'active3 sprite',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          final ramp = SpaceshipRamp();
          final canvas = ZCanvasComponent(children: [ramp]);
          await game.ensureAdd(canvas);

          ramp.bloc
            ..onAscendingBallEntered()
            ..onAscendingBallEntered()
            ..onAscendingBallEntered();

          await game.ready();
          await tester.pump();

          final index = ramp.children
              .whereType<SpaceshipRampArrowSpriteComponent>()
              .first
              .current;
          expect(
            SpaceshipRampArrowSpriteState.values[index!],
            SpaceshipRampArrowSpriteState.active3,
          );

          game.camera.followVector2(centerForSpaceshipRamp);
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('${goldenFilePath}active3.png'),
          );
        },
      );

      flameTester.testGameWidget(
        'active4 sprite',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          final ramp = SpaceshipRamp();
          final canvas = ZCanvasComponent(children: [ramp]);
          await game.ensureAdd(canvas);

          ramp.bloc
            ..onAscendingBallEntered()
            ..onAscendingBallEntered()
            ..onAscendingBallEntered()
            ..onAscendingBallEntered();

          await game.ready();
          await tester.pump();

          final index = ramp.children
              .whereType<SpaceshipRampArrowSpriteComponent>()
              .first
              .current;
          expect(
            SpaceshipRampArrowSpriteState.values[index!],
            SpaceshipRampArrowSpriteState.active4,
          );

          game.camera.followVector2(centerForSpaceshipRamp);
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('${goldenFilePath}active4.png'),
          );
        },
      );

      flameTester.testGameWidget(
        'active5 sprite',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          final ramp = SpaceshipRamp();
          final canvas = ZCanvasComponent(children: [ramp]);
          await game.ensureAdd(canvas);

          ramp.bloc
            ..onAscendingBallEntered()
            ..onAscendingBallEntered()
            ..onAscendingBallEntered()
            ..onAscendingBallEntered()
            ..onAscendingBallEntered();

          await game.ready();
          await tester.pump();

          final index = ramp.children
              .whereType<SpaceshipRampArrowSpriteComponent>()
              .first
              .current;
          expect(
            SpaceshipRampArrowSpriteState.values[index!],
            SpaceshipRampArrowSpriteState.active5,
          );

          game.camera.followVector2(centerForSpaceshipRamp);
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('${goldenFilePath}active5.png'),
          );
        },
      );
    });

    flameTester.test('closes bloc when removed', (game) async {
      final bloc = _MockSpaceshipRampCubit();
      whenListen(
        bloc,
        const Stream<SpaceshipRampState>.empty(),
        initialState: const SpaceshipRampState.initial(),
      );
      when(bloc.close).thenAnswer((_) async {});

      final ramp = SpaceshipRamp.test(
        bloc: bloc,
      );

      await game.ensureAdd(ramp);
      game.remove(ramp);
      await game.ready();

      verify(bloc.close).called(1);
    });

    group('adds', () {
      flameTester.test('new children', (game) async {
        final component = Component();
        final ramp = SpaceshipRamp(children: [component]);
        await game.ensureAdd(ramp);
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
      final parent = SpaceshipRamp.test(bloc: _MockSpaceshipRampCubit());
      final component = SpaceshipRampBoardOpening();
      await game.ensureAdd(parent);
      await parent.ensureAdd(component);
      expect(parent.children, contains(component));
    });

    flameTester.test('adds a RampBallAscendingContactBehavior', (game) async {
      final parent = SpaceshipRamp.test(bloc: _MockSpaceshipRampCubit());
      final component = SpaceshipRampBoardOpening();
      await game.ensureAdd(parent);
      await parent.ensureAdd(component);
      expect(
        component.children.whereType<RampBallAscendingContactBehavior>().length,
        equals(1),
      );
    });
  });
}
