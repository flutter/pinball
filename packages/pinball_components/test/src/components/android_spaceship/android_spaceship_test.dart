// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
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
    late AndroidSpaceshipCubit bloc;

    setUp(() {
      bloc = _MockAndroidSpaceshipCubit();
    });

    flameTester.test('loads correctly', (game) async {
      final component =
          FlameBlocProvider<AndroidSpaceshipCubit, AndroidSpaceshipState>.value(
        value: bloc,
        children: [AndroidSpaceship(position: Vector2.zero())],
      );
      await game.ensureAdd(component);
      expect(game.contains(component), isTrue);
    });

    flameTester.testGameWidget(
      'renders correctly',
      setUp: (game, tester) async {
        await game.images.loadAll(assets);
        final canvas = ZCanvasComponent(
          children: [
            FlameBlocProvider<AndroidSpaceshipCubit,
                AndroidSpaceshipState>.value(
              value: bloc,
              children: [AndroidSpaceship(position: Vector2.zero())],
            ),
          ],
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

    flameTester.test(
        'AndroidSpaceshipEntrance has an '
        'AndroidSpaceshipEntranceBallContactBehavior', (game) async {
      final androidSpaceship = AndroidSpaceship(position: Vector2.zero());
      final provider =
          FlameBlocProvider<AndroidSpaceshipCubit, AndroidSpaceshipState>.value(
        value: bloc,
        children: [androidSpaceship],
      );
      await game.ensureAdd(provider);

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
