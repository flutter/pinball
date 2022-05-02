// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../../helpers/helpers.dart';

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

  group('RampSensor', () {
    flameTester.test('closes bloc when removed', (game) async {
      final bloc = MockRampSensorCubit();
      whenListen(
        bloc,
        const Stream<RampSensorState>.empty(),
        initialState: const RampSensorState.initial(),
      );
      when(bloc.close).thenAnswer((_) async {});
      final rampSensor = RampSensor.test(
        type: RampSensorType.door,
        bloc: bloc,
      );
      final parent = SpaceshipRamp.test();

      await game.ensureAdd(parent);
      await parent.ensureAdd(rampSensor);
      parent.remove(rampSensor);
      await game.ready();

      verify(bloc.close).called(1);
    });
  });
}
