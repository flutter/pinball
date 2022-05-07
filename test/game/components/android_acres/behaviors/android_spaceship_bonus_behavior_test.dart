// ignore_for_file: cascade_invocations

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/components/android_acres/behaviors/behaviors.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

class _TestGame extends Forge2DGame {
  @override
  Future<void> onLoad() async {
    images.prefix = '';
    await images.loadAll([
      Assets.images.android.spaceship.saucer.keyName,
      Assets.images.android.spaceship.animatronic.keyName,
      Assets.images.android.spaceship.lightBeam.keyName,
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
      Assets.images.android.bumper.a.lit.keyName,
      Assets.images.android.bumper.a.dimmed.keyName,
      Assets.images.android.bumper.b.lit.keyName,
      Assets.images.android.bumper.b.dimmed.keyName,
      Assets.images.android.bumper.cow.lit.keyName,
      Assets.images.android.bumper.cow.dimmed.keyName,
    ]);
  }

  Future<void> pump(
    AndroidAcres child, {
    required GameBloc gameBloc,
    required AndroidSpaceshipCubit androidSpaceshipCubit,
  }) async {
    // Not needed once https://github.com/flame-engine/flame/issues/1607
    // is fixed
    await onLoad();
    await ensureAdd(
      FlameMultiBlocProvider(
        providers: [
          FlameBlocProvider<GameBloc, GameState>.value(
            value: gameBloc,
          ),
          FlameBlocProvider<AndroidSpaceshipCubit, AndroidSpaceshipState>.value(
            value: androidSpaceshipCubit,
          ),
        ],
        children: [child],
      ),
    );
  }
}

class _MockGameBloc extends Mock implements GameBloc {}

class _MockAndroidSpaceshipCubit extends Mock implements AndroidSpaceshipCubit {
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AndroidSpaceshipBonusBehavior', () {
    late GameBloc gameBloc;

    setUp(() {
      gameBloc = _MockGameBloc();
    });

    final flameTester = FlameTester(_TestGame.new);

    flameTester.testGameWidget(
      'adds GameBonus.androidSpaceship to the game '
      'when android spaceship has a bonus',
      setUp: (game, tester) async {
        final behavior = AndroidSpaceshipBonusBehavior();
        final parent = AndroidAcres.test();
        final androidSpaceship = AndroidSpaceship(position: Vector2.zero());
        final androidSpaceshipCubit = _MockAndroidSpaceshipCubit();
        final streamController = StreamController<AndroidSpaceshipState>();

        whenListen(
          androidSpaceshipCubit,
          streamController.stream,
          initialState: AndroidSpaceshipState.withoutBonus,
        );

        await parent.add(androidSpaceship);
        await game.pump(
          parent,
          androidSpaceshipCubit: androidSpaceshipCubit,
          gameBloc: gameBloc,
        );
        await parent.ensureAdd(behavior);

        streamController.add(AndroidSpaceshipState.withBonus);

        await tester.pump();

        verify(
          () => gameBloc.add(const BonusActivated(GameBonus.androidSpaceship)),
        ).called(1);
      },
    );
  });
}
