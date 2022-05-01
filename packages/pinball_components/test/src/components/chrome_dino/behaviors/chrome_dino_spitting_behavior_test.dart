// ignore_for_file: cascade_invocations

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
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
    'ChromeDinoSpittingBehavior',
    () {
      test('can be instantiated', () {
        expect(
          ChromeDinoSpittingBehavior(),
          isA<ChromeDinoSpittingBehavior>(),
        );
      });

      flameTester.test(
        'creates a RevoluteJoint',
        (game) async {
          final behavior = ChromeDinoSpittingBehavior();
          final bloc = MockChromeDinoCubit();
          whenListen(
            bloc,
            const Stream<ChromeDinoState>.empty(),
            initialState: const ChromeDinoState.inital(),
          );

          final chromeDino = ChromeDino.test(bloc: bloc);
          await chromeDino.add(behavior);
          await game.ensureAdd(chromeDino);

          expect(
            game.world.joints.whereType<RevoluteJoint>().single,
            isNotNull,
          );
        },
      );

      group('calls', () {
        flameTester.test(
          'onSpit the next time the mouth opens and status is chomping',
          (game) async {
            final ball = Ball(baseColor: Colors.red);
            final behavior = ChromeDinoSpittingBehavior();
            final bloc = MockChromeDinoCubit();
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
