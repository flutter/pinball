// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/chrome_dino/behaviors/behaviors.dart';

import '../../../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(TestGame.new);

  group(
    'ChromeDinoMouthOpeningBehavior',
    () {
      test('can be instantiated', () {
        expect(
          ChromeDinoMouthOpeningBehavior(),
          isA<ChromeDinoMouthOpeningBehavior>(),
        );
      });

      flameTester.test(
        'preSolve disables contact when the mouth is open '
        'and there is not ball in the mouth',
        (game) async {
          final behavior = ChromeDinoMouthOpeningBehavior();
          final bloc = MockChromeDinoCubit();
          whenListen(
            bloc,
            const Stream<ChromeDinoState>.empty(),
            initialState: const ChromeDinoState(
              status: ChromeDinoStatus.idle,
              isMouthOpen: true,
            ),
          );

          final chromeDino = ChromeDino.test(bloc: bloc);
          await chromeDino.add(behavior);
          await game.ensureAdd(chromeDino);

          final contact = MockContact();
          final fixture = MockFixture();
          when(() => contact.fixtureA).thenReturn(fixture);
          when(() => fixture.userData).thenReturn('mouth_opening');

          behavior.preSolve(MockBall(), contact, Manifold());

          verify(() => contact.setEnabled(false)).called(1);
        },
      );
    },
  );
}
