// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../../helpers/helpers.dart';

class _MockSpaceshipRampCubit extends Mock implements SpaceshipRampCubit {}

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
        expect(game.descendants(), contains(spaceshipRamp));
      },
    );

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
        final spaceshipRamp = SpaceshipRamp(
          children: [component],
        );
        await game.ensureAdd(spaceshipRamp);
        expect(spaceshipRamp.children, contains(component));
      });
    });
  });
}
