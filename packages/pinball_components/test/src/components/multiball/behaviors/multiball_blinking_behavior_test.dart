import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/multiball/behaviors/behaviors.dart';

import '../../../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(TestGame.new);

  group(
    'MultiballBlinkingBehavior',
    () {
      flameTester.testGameWidget(
        'calls onBlinked after 0.05 seconds when inactive',
        setUp: (game, tester) async {
          final behavior = MultiballBlinkingBehavior();
          final bloc = MockMultiballCubit();
          final streamController = StreamController<MultiballState>();
          whenListen(
            bloc,
            streamController.stream,
            initialState: MultiballState.dimmed,
          );

          final multiball = Multiball.test(bloc: bloc);
          await multiball.add(behavior);
          await game.ensureAdd(multiball);

          streamController.add(MultiballState.lit);
          await tester.pump();
          game.update(0.05);

          await streamController.close();
          verify(bloc.onBlinked).called(1);
        },
      );
    },
  );
}
