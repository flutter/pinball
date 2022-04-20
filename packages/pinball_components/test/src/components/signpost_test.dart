// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(TestGame.new);

  group('Signpost', () {
    flameTester.test(
      'loads correctly',
      (game) async {
        final signpost = Signpost();
        await game.ready();
        await game.ensureAdd(signpost);

        expect(game.contains(signpost), isTrue);
      },
    );

    group('renders correctly', () {
      flameTester.testGameWidget(
        'inactive sprite',
        setUp: (game, tester) async {
          final signpost = Signpost();
          await game.ensureAdd(signpost);

          expect(
            signpost.firstChild<SpriteGroupComponent>()!.current,
            SignpostSpriteState.inactive,
          );

          game.camera.followVector2(Vector2.zero());
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('golden/signpost/inactive.png'),
          );
        },
      );

      flameTester.testGameWidget(
        'active1 sprite',
        setUp: (game, tester) async {
          final signpost = Signpost();
          await game.ensureAdd(signpost);
          signpost.progress();

          expect(
            signpost.firstChild<SpriteGroupComponent>()!.current,
            SignpostSpriteState.active1,
          );

          game.camera.followVector2(Vector2.zero());
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('golden/signpost/active1.png'),
          );
        },
      );

      flameTester.testGameWidget(
        'active2 sprite',
        setUp: (game, tester) async {
          final signpost = Signpost();
          await game.ensureAdd(signpost);
          signpost
            ..progress()
            ..progress();

          expect(
            signpost.firstChild<SpriteGroupComponent>()!.current,
            SignpostSpriteState.active2,
          );

          game.camera.followVector2(Vector2.zero());
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('golden/signpost/active2.png'),
          );
        },
      );

      flameTester.testGameWidget(
        'active3 sprite',
        setUp: (game, tester) async {
          final signpost = Signpost();
          await game.ensureAdd(signpost);
          signpost
            ..progress()
            ..progress()
            ..progress();

          expect(
            signpost.firstChild<SpriteGroupComponent>()!.current,
            SignpostSpriteState.active3,
          );

          game.camera.followVector2(Vector2.zero());
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('golden/signpost/active3.png'),
          );
        },
      );
    });

    flameTester.test(
      'progress correctly cycles through all sprites',
      (game) async {
        final signpost = Signpost();
        await game.ready();
        await game.ensureAdd(signpost);

        final spriteComponent = signpost.firstChild<SpriteGroupComponent>()!;

        for (var i = 0; i < 4; i++) {
          expect(spriteComponent.current, SignpostSpriteState.inactive);
          signpost.progress();
          expect(spriteComponent.current, SignpostSpriteState.active1);
          signpost.progress();
          expect(spriteComponent.current, SignpostSpriteState.active2);
          signpost.progress();
          expect(spriteComponent.current, SignpostSpriteState.active3);
          signpost.progress();
        }
      },
    );
  });
}