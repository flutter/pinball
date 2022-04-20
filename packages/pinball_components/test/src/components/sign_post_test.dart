// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

// TODO(allisonryan0002): Refactor loading assets in test with
// https://github.com/VGVentures/pinball/pull/204

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(TestGame.new);

  group('SignPost', () {
    final assets = [
      Assets.images.signPost.inactive.keyName,
      Assets.images.signPost.active1.keyName,
      Assets.images.signPost.active2.keyName,
      Assets.images.signPost.active3.keyName,
    ];

    flameTester.test(
      'loads correctly',
      (game) async {
        await game.images.loadAll(assets);
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
          await game.images.loadAll(assets);
          await game.ensureAdd(SignPost());
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
          await game.images.loadAll(assets);

          final signPost = SignPost();
          await game.ensureAdd(signPost);
          signPost.progress();

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
          await game.images.loadAll(assets);

          final signPost = SignPost();
          await game.ensureAdd(signPost);
          signPost
            ..progress()
            ..progress();

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
          await game.images.loadAll(assets);

          final signPost = SignPost();
          await game.ensureAdd(signPost);
          signPost
            ..progress()
            ..progress()
            ..progress();

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
        await game.images.loadAll(assets);
        final signPost = SignPost();
        await game.ready();
        await game.ensureAdd(signPost);

        final spriteComponent = signPost.firstChild<SpriteGroupComponent>()!;
        final sprites = <Sprite>{};

        for (var i = 0; i < 4; i++) {
          sprites.add(spriteComponent.sprite!);
          signPost.progress();
        }

        expect(sprites.length, equals(4));
      },
    );
  });
}
