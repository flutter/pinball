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
      flameTester.testGameWidget(
        'calls onBlinked after 0.05 seconds when inactive',
        setUp: (game, tester) async {
          final behavior = AlienBumperBlinkingBehavior();
          final bloc = MockAlienBumperCubit();
          final streamController = StreamController<AlienBumperState>();
          whenListen(
            bloc,
            streamController.stream,
            initialState: AlienBumperState.active,
          );

          final alienBumper = AlienBumper.test(bloc: bloc);
          await alienBumper.add(behavior);
          await game.ensureAdd(alienBumper);

          streamController.add(AlienBumperState.inactive);
          await tester.pump();
          game.update(0.05);

          await streamController.close();
          verify(bloc.onBlinked).called(1);
        },
      );
    },
  );
}
