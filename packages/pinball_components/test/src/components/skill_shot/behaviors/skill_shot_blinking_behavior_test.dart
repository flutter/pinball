// ignore_for_file: cascade_invocations

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/skill_shot/behaviors/behaviors.dart';

import '../../../../helpers/helpers.dart';

class _MockSkillShotCubit extends Mock implements SkillShotCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(TestGame.new);

  group(
    'SkillShotBlinkingBehavior',
    () {
      flameTester.testGameWidget(
        'calls switched after 0.15 seconds when isBlinking and lit',
        setUp: (game, tester) async {
          final behavior = SkillShotBlinkingBehavior();
          final bloc = _MockSkillShotCubit();
          final streamController = StreamController<SkillShotState>();
          whenListen(
            bloc,
            streamController.stream,
            initialState: const SkillShotState.initial(),
          );

          final skillShot = SkillShot.test(bloc: bloc);
          await skillShot.add(behavior);
          await game.ensureAdd(skillShot);

          streamController.add(
            const SkillShotState(
              spriteState: SkillShotSpriteState.lit,
              isBlinking: true,
            ),
          );
          await tester.pump();
          game.update(0.15);

          await streamController.close();
          verify(bloc.switched).called(1);
        },
      );

      flameTester.testGameWidget(
        'calls switched after 0.15 seconds when isBlinking and dimmed',
        setUp: (game, tester) async {
          final behavior = SkillShotBlinkingBehavior();
          final bloc = _MockSkillShotCubit();
          final streamController = StreamController<SkillShotState>();
          whenListen(
            bloc,
            streamController.stream,
            initialState: const SkillShotState.initial(),
          );

          final skillShot = SkillShot.test(bloc: bloc);
          await skillShot.add(behavior);
          await game.ensureAdd(skillShot);

          streamController.add(
            const SkillShotState(
              spriteState: SkillShotSpriteState.dimmed,
              isBlinking: true,
            ),
          );
          await tester.pump();
          game.update(0.15);

          await streamController.close();
          verify(bloc.switched).called(1);
        },
      );

      flameTester.testGameWidget(
        'calls onBlinkingFinished after all blinks complete',
        setUp: (game, tester) async {
          final behavior = SkillShotBlinkingBehavior();
          final bloc = _MockSkillShotCubit();
          final streamController = StreamController<SkillShotState>();
          whenListen(
            bloc,
            streamController.stream,
            initialState: const SkillShotState.initial(),
          );

          final skillShot = SkillShot.test(bloc: bloc);
          await skillShot.add(behavior);
          await game.ensureAdd(skillShot);

          for (var i = 0; i <= 8; i++) {
            if (i.isEven) {
              streamController.add(
                const SkillShotState(
                  spriteState: SkillShotSpriteState.lit,
                  isBlinking: true,
                ),
              );
            } else {
              streamController.add(
                const SkillShotState(
                  spriteState: SkillShotSpriteState.dimmed,
                  isBlinking: true,
                ),
              );
            }
            await tester.pump();
            game.update(0.15);
          }

          await streamController.close();
          verify(bloc.onBlinkingFinished).called(1);
        },
      );
    },
  );
}
