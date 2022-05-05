// ignore_for_file: cascade_invocations

import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/behaviors/behaviors.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

import '../../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.dash.bumper.main.active.keyName,
    Assets.images.dash.bumper.main.inactive.keyName,
    Assets.images.dash.bumper.a.active.keyName,
    Assets.images.dash.bumper.a.inactive.keyName,
    Assets.images.dash.bumper.b.active.keyName,
    Assets.images.dash.bumper.b.inactive.keyName,
    Assets.images.dash.animatronic.keyName,
    Assets.images.signpost.inactive.keyName,
    Assets.images.signpost.active1.keyName,
    Assets.images.signpost.active2.keyName,
    Assets.images.signpost.active3.keyName,
  ];
  final flameTester = FlameTester(
    () => EmptyPinballTestGame(assets: assets),
  );

  group('FlutterForest', () {
    flameTester.test(
      'loads correctly',
      (game) async {
        final flutterForest = FlutterForest();
        await game.ensureAdd(ZCanvasComponent(children: [flutterForest]));
        expect(game.descendants(), contains(flutterForest));
      },
    );

    group('loads', () {
      flameTester.test(
        'a Signpost',
        (game) async {
          final flutterForest = FlutterForest();
          await game.ensureAdd(ZCanvasComponent(children: [flutterForest]));
          expect(
            game.descendants().whereType<Signpost>().length,
            equals(1),
          );
        },
      );

      flameTester.test(
        'a DashAnimatronic',
        (game) async {
          final flutterForest = FlutterForest();
          await game.ensureAdd(ZCanvasComponent(children: [flutterForest]));
          expect(
            game.descendants().whereType<DashAnimatronic>().length,
            equals(1),
          );
        },
      );

      flameTester.test(
        'three DashNestBumper',
        (game) async {
          final flutterForest = FlutterForest();
          await game.ensureAdd(ZCanvasComponent(children: [flutterForest]));
          expect(
            game.descendants().whereType<DashNestBumper>().length,
            equals(3),
          );
        },
      );

      flameTester.test(
        'three DashNestBumpers with BumperNoiseBehavior',
        (game) async {
          final flutterForest = FlutterForest();
          await game.ensureAdd(ZCanvasComponent(children: [flutterForest]));
          final bumpers = game.descendants().whereType<DashNestBumper>();
          for (final bumper in bumpers) {
            expect(
              bumper.firstChild<BumperNoiseBehavior>(),
              isNotNull,
            );
          }
        },
      );
    });
  });
}
