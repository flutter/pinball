// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/chrome_dino/behaviors/behaviors.dart';

import '../../../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(TestGame.new);

  group(
    'ChromeDinoChompingBehavior',
    () {
      test('can be instantiated', () {
        expect(
          ChromeDinoChompingBehavior(),
          isA<ChromeDinoChompingBehavior>(),
        );
      });

      flameTester.test(
        'beginContact sets ball sprite to be invisible and calls onChomp',
        (game) async {
          final ball = Ball(baseColor: Colors.red);
          final behavior = ChromeDinoChompingBehavior();
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
          await game.ensureAddAll([chromeDino, ball]);

          final contact = MockContact();
          final fixture = MockFixture();
          when(() => contact.fixtureA).thenReturn(fixture);
          when(() => fixture.userData).thenReturn('inside_mouth');

          behavior.beginContact(ball, contact);

          expect(ball.firstChild<SpriteComponent>()!.getOpacity(), isZero);

          verify(() => bloc.onChomp(ball)).called(1);
        },
      );
    },
  );
}
