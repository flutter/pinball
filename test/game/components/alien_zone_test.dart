// ignore_for_file: cascade_invocations

import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.alienBumper.a.active.keyName,
    Assets.images.alienBumper.a.inactive.keyName,
    Assets.images.alienBumper.b.active.keyName,
    Assets.images.alienBumper.b.inactive.keyName,
  ];
  final flameTester = FlameTester(
    () => EmptyPinballTestGame(assets: assets),
  );

  group('AlienZone', () {
    flameTester.test(
      'loads correctly',
      (game) async {
        await game.addFromBlueprint(AlienZone());
        await game.ready();
      },
    );

    group('loads', () {
      flameTester.test(
        'two AlienBumper',
        (game) async {
          final alienZone = AlienZone();
          await game.addFromBlueprint(alienZone);
          await game.ready();

          expect(
            game.descendants().whereType<AlienBumper>().length,
            equals(2),
          );
        },
      );
    });
  });
}
