// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/skill_shot/behaviors/behaviors.dart';

import '../../../../helpers/helpers.dart';

class _MockBall extends Mock implements Ball {}

class _MockContact extends Mock implements Contact {}

class _MockSkillShotCubit extends Mock implements SkillShotCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(TestGame.new);

  group(
    'SkillShotBallContactBehavior',
    () {
      test('can be instantiated', () {
        expect(
          SkillShotBallContactBehavior(),
          isA<SkillShotBallContactBehavior>(),
        );
      });

      flameTester.testGameWidget(
        'beginContact animates pin and calls onBallContacted '
        'when contacts with a ball',
        setUp: (game, tester) async {
          await game.images.load(Assets.images.skillShot.pin.keyName);
          final behavior = SkillShotBallContactBehavior();
          final bloc = _MockSkillShotCubit();
          whenListen(
            bloc,
            const Stream<SkillShotState>.empty(),
            initialState: const SkillShotState.initial(),
          );

          final skillShot = SkillShot.test(bloc: bloc);
          await skillShot.addAll([behavior, PinSpriteAnimationComponent()]);
          await game.ensureAdd(skillShot);

          behavior.beginContact(_MockBall(), _MockContact());
          await tester.pump();

          expect(
            skillShot.firstChild<PinSpriteAnimationComponent>()!.playing,
            isTrue,
          );
          verify(skillShot.bloc.onBallContacted).called(1);
        },
      );
    },
  );
}
