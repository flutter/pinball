// ignore_for_file: cascade_invocations

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/chrome_dino/behaviors/behaviors.dart';
import 'package:pinball_theme/pinball_theme.dart' as theme;

import '../../../../helpers/helpers.dart';

class _MockChromeDinoCubit extends Mock implements ChromeDinoCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    theme.Assets.images.dash.ball.keyName,
  ];
  final flameTester = FlameTester(() => TestGame(assets));

  group(
    'ChromeDinoSpittingBehavior',
    () {
      test('can be instantiated', () {
        expect(
          ChromeDinoSpittingBehavior(),
          isA<ChromeDinoSpittingBehavior>(),
        );
      });

      group('on the next time the mouth opens and status is chomping', () {
        flameTester.test(
          'sets ball sprite to visible and sets a linear velocity',
          (game) async {
            final ball = Ball();
            final behavior = ChromeDinoSpittingBehavior();
            final bloc = _MockChromeDinoCubit();
            final streamController = StreamController<ChromeDinoState>();
            final chompingState = ChromeDinoState(
              status: ChromeDinoStatus.chomping,
              isMouthOpen: true,
              ball: ball,
            );
            whenListen(
              bloc,
              streamController.stream,
              initialState: chompingState,
            );

            final chromeDino = ChromeDino.test(bloc: bloc);
            await chromeDino.add(behavior);
            await game.ensureAddAll([chromeDino, ball]);

            streamController.add(chompingState.copyWith(isMouthOpen: false));
            streamController.add(chompingState.copyWith(isMouthOpen: true));
            await game.ready();

            game
                .descendants()
                .whereType<TimerComponent>()
                .single
                .timer
                .onTick!();

            expect(ball.firstChild<SpriteComponent>()!.getOpacity(), equals(1));
            expect(ball.body.linearVelocity, equals(Vector2(-50, 0)));
          },
        );

        flameTester.test(
          'calls onSpit',
          (game) async {
            final ball = Ball();
            final behavior = ChromeDinoSpittingBehavior();
            final bloc = _MockChromeDinoCubit();
            final streamController = StreamController<ChromeDinoState>();
            final chompingState = ChromeDinoState(
              status: ChromeDinoStatus.chomping,
              isMouthOpen: true,
              ball: ball,
            );
            whenListen(
              bloc,
              streamController.stream,
              initialState: chompingState,
            );

            final chromeDino = ChromeDino.test(bloc: bloc);
            await chromeDino.add(behavior);
            await game.ensureAddAll([chromeDino, ball]);

            streamController.add(chompingState.copyWith(isMouthOpen: false));
            streamController.add(chompingState.copyWith(isMouthOpen: true));
            await game.ready();

            game
                .descendants()
                .whereType<TimerComponent>()
                .single
                .timer
                .onTick!();

            verify(bloc.onSpit).called(1);
          },
        );
      });
    },
  );
}
