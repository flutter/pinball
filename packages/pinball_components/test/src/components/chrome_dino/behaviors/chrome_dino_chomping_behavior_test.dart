// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/chrome_dino/behaviors/behaviors.dart';
import 'package:pinball_theme/pinball_theme.dart' as theme;

import '../../../../helpers/helpers.dart';

class _MockChromeDinoCubit extends Mock implements ChromeDinoCubit {}

class _MockContact extends Mock implements Contact {}

class _MockFixture extends Mock implements Fixture {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    theme.Assets.images.dash.ball.keyName,
  ];
  final flameTester = FlameTester(() => TestGame(assets));

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
          final ball = Ball();
          final behavior = ChromeDinoChompingBehavior();
          final bloc = _MockChromeDinoCubit();
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

          final contact = _MockContact();
          final fixture = _MockFixture();
          when(() => contact.fixtureA).thenReturn(fixture);
          when(() => fixture.userData).thenReturn('inside_mouth');

          behavior.beginContact(ball, contact);

          expect(
            ball.descendants().whereType<SpriteComponent>().single.getOpacity(),
            isZero,
          );

          verify(() => bloc.onChomp(ball)).called(1);
        },
      );
    },
  );
}
