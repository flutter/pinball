import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/alien_bumper/behaviors/behaviors.dart';

import '../../../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(TestGame.new);

  group(
    'AlienBumperBlinkingBehavior',
    () {
      flameTester.test(
        'calls onBlinked after 0.5 seconds when inactive',
        (game) async {
          // TODO(alestiago): Make this pass.
          final behavior = AlienBumperBlinkingBehavior();
          final bloc = MockAlienBumperCubit();
          final streamController =
              StreamController<AlienBumperState>.broadcast();
          whenListen(
            bloc,
            streamController.stream,
            initialState: AlienBumperState.active,
          );

          final alienBumper = AlienBumper.test(bloc: bloc);
          await alienBumper.add(behavior);
          await game.ensureAdd(alienBumper);

          streamController.sink.add(AlienBumperState.inactive);
          game.update(0.05);

          verify(bloc.onBlinked).called(1);
        },
      );
    },
  );
}
