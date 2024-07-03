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
    flameTester.testGameWidget(
      'loads correctly',
      setUp: (game, _) async {
        await game.onLoad();
        final skillShot = SkillShot();
        await game.ensureAdd(skillShot);
        await game.ready();
      },
      verify: (game, _) async {
        expect(game.descendants().whereType<SkillShot>().length, equals(1));
      },
    );

    flameTester.testGameWidget(
      'closes bloc when removed',
      setUp: (game, _) async {
        await game.onLoad();
        final bloc = _MockSkillShotCubit();
        whenListen(
          bloc,
          const Stream<SkillShotState>.empty(),
          initialState: const SkillShotState.initial(),
        );
        when(bloc.close).thenAnswer((_) async {});
        final skillShot = SkillShot.test(bloc: bloc);

        await game.ensureAdd(skillShot);
        await game.ready();
      },
      verify: (game, _) async {
        final skillShot = game.descendants().whereType<SkillShot>().single;
        game.remove(skillShot);
        game.update(0);
        verify(skillShot.bloc.close).called(1);
      },
    );

    group('adds', () {
      flameTester.testGameWidget(
        'new children',
        setUp: (game, _) async {
          await game.onLoad();
          final component = Component();
          final skillShot = SkillShot(
            children: [component],
          );
          await game.ensureAdd(skillShot);
          await game.ready();
        },
        verify: (game, _) async {
          final skillShot = game.descendants().whereType<SkillShot>().single;
          expect(skillShot.children.whereType<Component>(), isNotEmpty);
        },
      );

      flameTester.testGameWidget(
        'a SkillShotBallContactBehavior',
        setUp: (game, _) async {
          await game.onLoad();
          final skillShot = SkillShot();
          await game.ensureAdd(skillShot);
          await game.ready();
        },
        verify: (game, _) async {
          final skillShot = game.descendants().whereType<SkillShot>().single;
          expect(
            skillShot.children.whereType<SkillShotBallContactBehavior>().single,
            isNotNull,
          );
        },
      );

      flameTester.testGameWidget(
        'a SkillShotBlinkingBehavior',
        setUp: (game, _) async {
          await game.onLoad();
          final skillShot = SkillShot();
          await game.ensureAdd(skillShot);
          await game.ready();
        },
        verify: (game, _) async {
          final skillShot = game.descendants().whereType<SkillShot>().single;
          expect(
            skillShot.children.whereType<SkillShotBlinkingBehavior>().single,
            isNotNull,
          );
        },
      );
    });

    flameTester.testGameWidget(
      'pin stops animating after animation completes',
      setUp: (game, _) async {
        await game.onLoad();
        final skillShot = SkillShot();
        await game.ensureAdd(skillShot);
        await game.ready();
      },
      verify: (game, _) async {
        final skillShot = game.descendants().whereType<SkillShot>().single;

        final pinSpriteAnimationComponent =
            skillShot.firstChild<PinSpriteAnimationComponent>()!;

        pinSpriteAnimationComponent.playing = true;
        game.update(
          pinSpriteAnimationComponent.animationTicker!.totalDuration() + 0.1,
        );

        expect(pinSpriteAnimationComponent.playing, isFalse);
      },
    );
  });
}
