import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/sparky_bumper/behaviors/sparky_bumper_blinking_behavior.dart';

import '../../../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(TestGame.new);

  group(
    'SparkyBumperBlinkingBehaviour',
    () {
      flameTester.test(
        'calls onBlinked after 0.5 seconds when inactive',
        (game) async {
          // TODO(alestiago): Make this pass.
          final behavior = SparkyBumperBlinkingBehavior();
          final bloc = MockSparkyBumperCubit();
          final streamController =
              StreamController<SparkyBumperState>.broadcast();
          whenListen(
            bloc,
            streamController.stream,
            initialState: SparkyBumperState.active,
          );

          final sparkyBumper = SparkyBumper.test(bloc: bloc);
          await sparkyBumper.add(behavior);
          await game.ensureAdd(sparkyBumper);

          streamController.sink.add(SparkyBumperState.inactive);
          game.update(0.05);

          verify(bloc.onBlinked).called(1);
        },
      );
    },
  );
}
