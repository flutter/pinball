// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/skill_shot/behaviors/behaviors.dart';

import '../../../helpers/helpers.dart';

class _MockSkillShotCubit extends Mock implements SkillShotCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.skillShot.decal.keyName,
    Assets.images.skillShot.pin.keyName,
    Assets.images.skillShot.lit.keyName,
    Assets.images.skillShot.dimmed.keyName,
  ];
  final flameTester = FlameTester(() => TestGame(assets));

  group('SkillShot', () {
    flameTester.test('loads correctly', (game) async {
      final skillShot = SkillShot();
      await game.ensureAdd(skillShot);
      expect(game.contains(skillShot), isTrue);
    });

    flameTester.test('closes bloc when removed', (game) async {
      final bloc = _MockSkillShotCubit();
      whenListen(
        bloc,
        const Stream<SkillShotState>.empty(),
        initialState: const SkillShotState.initial(),
      );
      when(bloc.close).thenAnswer((_) async {});
      final skillShot = SkillShot.test(bloc: bloc);

      await game.ensureAdd(skillShot);
      game.remove(skillShot);
      await game.ready();

      verify(bloc.close).called(1);
    });

    group('adds', () {
      flameTester.test('new children', (game) async {
        final component = Component();
        final skillShot = SkillShot(
          children: [component],
        );
        await game.ensureAdd(skillShot);
        expect(skillShot.children, contains(component));
      });

      flameTester.test('a SkillShotBallContactBehavior', (game) async {
        final skillShot = SkillShot();
        await game.ensureAdd(skillShot);
        expect(
          skillShot.children.whereType<SkillShotBallContactBehavior>().single,
          isNotNull,
        );
      });

      flameTester.test('a SkillShotBlinkingBehavior', (game) async {
        final skillShot = SkillShot();
        await game.ensureAdd(skillShot);
        expect(
          skillShot.children.whereType<SkillShotBlinkingBehavior>().single,
          isNotNull,
        );
      });
    });

    flameTester.test(
      'pin stops animating after animation completes',
      (game) async {
        final skillShot = SkillShot();
        await game.ensureAdd(skillShot);

        final pinSpriteAnimationComponent =
            skillShot.firstChild<PinSpriteAnimationComponent>()!;

        pinSpriteAnimationComponent.playing = true;
        game.update(
          pinSpriteAnimationComponent.animation!.totalDuration() + 0.1,
        );

        expect(pinSpriteAnimationComponent.playing, isFalse);
      },
    );
  });
}
