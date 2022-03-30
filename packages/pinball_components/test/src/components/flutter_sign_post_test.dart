// ignore_for_file: cascade_invocations

import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(TestGame.new);

  group('FlutterSignPost', () {
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
