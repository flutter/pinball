// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/kicker/behaviors/behaviors.dart';

import '../../../../helpers/helpers.dart';

class _MockKickerCubit extends Mock implements KickerCubit {}

class _MockBall extends Mock implements Ball {}

class _MockContact extends Mock implements Contact {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(TestGame.new);

  group(
    'KickerBallContactBehavior',
    () {
      test('can be instantiated', () {
        expect(
          KickerBallContactBehavior(),
          isA<KickerBallContactBehavior>(),
        );
      });

      flameTester.testGameWidget(
        'beginContact emits onBallContacted when contacts with a ball',
        setUp: (game, _) async {
          final behavior = KickerBallContactBehavior();
          final bloc = _MockKickerCubit();
          whenListen(
            bloc,
            const Stream<KickerState>.empty(),
            initialState: KickerState.lit,
          );

          final kicker = Kicker.test(
            side: BoardSide.left,
            bloc: bloc,
          );
          await kicker.add(behavior);
          await game.ensureAdd(kicker);
        },
        verify: (game, _) async {
          final behavior =
              game.descendants().whereType<KickerBallContactBehavior>().single;
          final kicker = game.descendants().whereType<Kicker>().single;

          behavior.beginContact(_MockBall(), _MockContact());

          verify(kicker.bloc.onBallContacted).called(1);
        },
      );
    },
  );
}
