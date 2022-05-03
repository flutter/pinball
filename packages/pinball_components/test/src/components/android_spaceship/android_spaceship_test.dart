// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/android_spaceship/behaviors/behaviors.dart';
import 'package:pinball_flame/pinball_flame.dart';

import '../../../helpers/helpers.dart';

class _MockAndroidSpaceshipCubit extends Mock implements AndroidSpaceshipCubit {
}

void main() {
  group('AndroidSpaceship', () {
    final assets = [
      Assets.images.android.spaceship.saucer.keyName,
      Assets.images.android.spaceship.lightBeam.keyName,
    ];
    final flameTester = FlameTester(() => TestGame(assets));

    flameTester.test('loads correctly', (game) async {
      final component = AndroidSpaceship(position: Vector2.zero());
      await game.ensureAdd(component);
      expect(game.contains(component), isTrue);
    });

    flameTester.testGameWidget(
      'renders correctly',
      setUp: (game, tester) async {
        await game.images.loadAll(assets);
        final canvas = ZCanvasComponent(
          children: [AndroidSpaceship(position: Vector2.zero())],
        );
        await game.ensureAdd(canvas);
        game.camera.followVector2(Vector2.zero());
        await game.ready();
        await tester.pump();
      },
      verify: (game, tester) async {
        const goldenFilePath = '../golden/android_spaceship/';
        final animationDuration = game
            .descendants()
            .whereType<SpriteAnimationComponent>()
            .single
            .animation!
            .totalDuration();

        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('${goldenFilePath}start.png'),
        );

        game.update(animationDuration * 0.5);
        await tester.pump();
        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('${goldenFilePath}middle.png'),
        );

        game.update(animationDuration * 0.5);
        await tester.pump();
        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('${goldenFilePath}end.png'),
        );
      },
    );

    // TODO(alestiago): Consider refactoring once the following is merged:
    // https://github.com/flame-engine/flame/pull/1538
    // ignore: public_member_api_docs
    flameTester.test('closes bloc when removed', (game) async {
      final bloc = _MockAndroidSpaceshipCubit();
      whenListen(
        bloc,
        const Stream<AndroidSpaceshipState>.empty(),
        initialState: AndroidSpaceshipState.withoutBonus,
      );
      when(bloc.close).thenAnswer((_) async {});
      final androidSpaceship = AndroidSpaceship.test(bloc: bloc);

      await game.ensureAdd(androidSpaceship);
      game.remove(androidSpaceship);
      await game.ready();

      verify(bloc.close).called(1);
    });

    flameTester.test(
        'AndroidSpaceshipEntrance has an '
        'AndroidSpaceshipEntranceBallContactBehavior', (game) async {
      final androidSpaceship = AndroidSpaceship(position: Vector2.zero());
      await game.ensureAdd(androidSpaceship);

      final androidSpaceshipEntrance =
          androidSpaceship.firstChild<AndroidSpaceshipEntrance>();
      expect(
        androidSpaceshipEntrance!.children
            .whereType<AndroidSpaceshipEntranceBallContactBehavior>()
            .single,
        isNotNull,
      );
    });
  });
}
