import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/kicker/behaviors/behaviors.dart';

import '../../../../helpers/helpers.dart';

class _MockKickerCubit extends Mock implements KickerCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(TestGame.new);

  group(
    'KickerBlinkingBehavior',
    () {
      flameTester.testGameWidget(
        'calls onBlinked after 0.05 seconds when dimmed',
        setUp: (game, tester) async {
          final behavior = KickerBlinkingBehavior();
          final bloc = _MockKickerCubit();
          final streamController = StreamController<KickerState>();
          whenListen(
            bloc,
            streamController.stream,
            initialState: KickerState.lit,
          );

          final kicker = Kicker.test(
            side: BoardSide.left,
            bloc: bloc,
          );
          await kicker.add(behavior);
          await game.ensureAdd(kicker);

          streamController.add(KickerState.dimmed);
          await tester.pump();
          game.update(0.05);

          await streamController.close();
          verify(bloc.onBlinked).called(1);
        },
      );
    },
  );
}
