// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pinball/game/game.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(Forge2DGame.new);

  group('Drain', () {
    flameTester.testGameWidget(
      'loads correctly',
      setUp: (game, _) async {
        final drain = Drain();
        await game.ensureAdd(drain);
      },
      verify: (game, _) async {
        expect(game.descendants().whereType<Drain>(), isNotEmpty);
      },
    );

    flameTester.testGameWidget(
      'body is static',
      setUp: (game, _) async {
        final drain = Drain();
        await game.ensureAdd(drain);
      },
      verify: (game, _) async {
        final drain = game.descendants().whereType<Drain>().single;
        expect(drain.body.bodyType, equals(BodyType.static));
      },
    );

    flameTester.testGameWidget(
      'is sensor',
      setUp: (game, _) async {
        final drain = Drain();
        await game.ensureAdd(drain);
      },
      verify: (game, _) async {
        final drain = game.descendants().whereType<Drain>().single;
        expect(drain.body.fixtures.first.isSensor, isTrue);
      },
    );
  });
}
