// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/flapper/behaviors/behaviors.dart';

import '../../../../helpers/helpers.dart';

class _MockBall extends Mock implements Ball {}

class _MockContact extends Mock implements Contact {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.flapper.flap.keyName,
    Assets.images.flapper.backSupport.keyName,
    Assets.images.flapper.frontSupport.keyName,
  ];
  final flameTester = FlameTester(() => TestGame(assets));

  group(
    'FlapperSpinningBehavior',
    () {
      test('can be instantiated', () {
        expect(
          FlapperSpinningBehavior(),
          isA<FlapperSpinningBehavior>(),
        );
      });

      flameTester.test(
        'beginContact plays the flapper animation',
        (game) async {
          final behavior = FlapperSpinningBehavior();
          final entrance = FlapperEntrance();
          final flap = FlapSpriteAnimationComponent();
          final flapper = Flapper.test();
          await flapper.addAll([entrance, flap]);
          await entrance.add(behavior);
          await game.ensureAdd(flapper);

          behavior.beginContact(_MockBall(), _MockContact());

          expect(flap.playing, isTrue);
        },
      );
    },
  );
}
