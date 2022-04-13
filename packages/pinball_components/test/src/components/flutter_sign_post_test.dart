// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(TestGame.new);

  group('FlutterSignPost', () {
    flameTester.testGameWidget(
      'renders correctly',
      setUp: (game, tester) async {
        await game.ensureAdd(FlutterSignPost());
        game.camera.followVector2(Vector2.zero());
      },
      verify: (game, tester) async {
        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('golden/flutter-sign-post.png'),
        );
      },
    );

    flameTester.test(
      'loads correctly',
      (game) async {
        final flutterSignPost = FlutterSignPost();
        await game.ready();
        await game.ensureAdd(flutterSignPost);

        expect(game.contains(flutterSignPost), isTrue);
      },
    );
  });
}
