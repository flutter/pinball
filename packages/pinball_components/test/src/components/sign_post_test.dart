// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(TestGame.new);

  group('SignPost', () {
    flameTester.test(
      'loads correctly',
      (game) async {
        final signPost = SignPost();
        await game.ready();
        await game.ensureAdd(signPost);

        expect(game.contains(signPost), isTrue);
      },
    );

    group('renders correctly', () {
      flameTester.testGameWidget(
        'inactive sprite',
        setUp: (game, tester) async {
          final signPost = SignPost();
          await game.ensureAdd(signPost);

          expect(
            signPost.firstChild<SpriteGroupComponent>()!.current,
            SignPostSpriteState.inactive,
          );

          game.camera.followVector2(Vector2.zero());
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('golden/sign_post/inactive.png'),
          );
        },
      );

      flameTester.testGameWidget(
        'active1 sprite',
        setUp: (game, tester) async {
          final signPost = SignPost();
          await game.ensureAdd(signPost);
          signPost.progress();

          expect(
            signPost.firstChild<SpriteGroupComponent>()!.current,
            SignPostSpriteState.active1,
          );

          game.camera.followVector2(Vector2.zero());
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('golden/sign_post/active1.png'),
          );
        },
      );

      flameTester.testGameWidget(
        'active2 sprite',
        setUp: (game, tester) async {
          final signPost = SignPost();
          await game.ensureAdd(signPost);
          signPost
            ..progress()
            ..progress();

          expect(
            signPost.firstChild<SpriteGroupComponent>()!.current,
            SignPostSpriteState.active2,
          );

          game.camera.followVector2(Vector2.zero());
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('golden/sign_post/active2.png'),
          );
        },
      );

      flameTester.testGameWidget(
        'active3 sprite',
        setUp: (game, tester) async {
          final signPost = SignPost();
          await game.ensureAdd(signPost);
          signPost
            ..progress()
            ..progress()
            ..progress();

          expect(
            signPost.firstChild<SpriteGroupComponent>()!.current,
            SignPostSpriteState.active3,
          );

          game.camera.followVector2(Vector2.zero());
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('golden/sign_post/active3.png'),
          );
        },
      );
    });

    flameTester.test(
      'progress changes correctly between four sprites',
      (game) async {
        final signPost = SignPost();
        await game.ready();
        await game.ensureAdd(signPost);

        final spriteComponent = signPost.firstChild<SpriteGroupComponent>()!;

        for (var i = 0; i < 4; i++) {
          expect(spriteComponent.current, SignPostSpriteState.inactive);
          signPost.progress();
          expect(spriteComponent.current, SignPostSpriteState.active1);
          signPost.progress();
          expect(spriteComponent.current, SignPostSpriteState.active2);
          signPost.progress();
          expect(spriteComponent.current, SignPostSpriteState.active3);
          signPost.progress();
        }
      },
    );
  });
}
