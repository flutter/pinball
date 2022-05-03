import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/android_bumper/behaviors/behaviors.dart';

import '../../../../helpers/helpers.dart';

class _MockAndroidBumperCubit extends Mock implements AndroidBumperCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(TestGame.new);

  group(
    'AndroidBumperBlinkingBehavior',
    () {
      flameTester.testGameWidget(
        'calls onBlinked after 0.05 seconds when dimmed',
        setUp: (game, tester) async {
          final behavior = AndroidBumperBlinkingBehavior();
          final bloc = _MockAndroidBumperCubit();
          final streamController = StreamController<AndroidBumperState>();
          whenListen(
            bloc,
            streamController.stream,
            initialState: AndroidBumperState.lit,
          );

          final androidBumper = AndroidBumper.test(bloc: bloc);
          await androidBumper.add(behavior);
          await game.ensureAdd(androidBumper);

          streamController.add(AndroidBumperState.dimmed);
          await tester.pump();
          game.update(0.05);

          await streamController.close();
          verify(bloc.onBlinked).called(1);
        },
      );
    },
  );
}
