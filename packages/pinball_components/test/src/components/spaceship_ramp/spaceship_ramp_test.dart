// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../../helpers/helpers.dart';

class _MockSpaceshipRampCubit extends Mock implements SpaceshipRampCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.android.bumper.a.lit.keyName,
    Assets.images.android.bumper.a.dimmed.keyName,
    Assets.images.android.bumper.b.lit.keyName,
    Assets.images.android.bumper.b.dimmed.keyName,
    Assets.images.android.bumper.cow.lit.keyName,
    Assets.images.android.bumper.cow.dimmed.keyName,
  ];
  final flameTester = FlameTester(() => TestGame(assets));

  flameTester.test('closes bloc when removed', (game) async {
    final bloc = _MockSpaceshipRampCubit();
    whenListen(
      bloc,
      const Stream<SpaceshipRampState>.empty(),
      initialState: SpaceshipRampState.initial(),
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
}
