// ignore_for_file: cascade_invocations, one_member_abstracts

import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

abstract class _VoidCallbackStubBase {
  void onCall();
}

class _VoidCallbackStub extends Mock implements _VoidCallbackStubBase {}

void main() {
  group('ArrowIcon', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    final assets = [
      Assets.images.displayArrows.arrowLeft.keyName,
      Assets.images.displayArrows.arrowRight.keyName,
    ];
    final flameTester = FlameTester(() => TappablesTestGame(assets));

    flameTester.testGameWidget(
      'is tappable',
      setUp: (game, tester) async {
        final stub = _VoidCallbackStub();
        await game.images.loadAll(assets);
        await game.ensureAdd(
          ArrowIcon(
            position: Vector2.zero(),
            direction: ArrowIconDirection.left,
            onTap: stub.onCall,
          ),
        );
        await tester.pump();
        await tester.tapAt(Offset.zero);
        await tester.pump();
      },
      verify: (game, tester) async {
        final icon = game.descendants().whereType<ArrowIcon>().single;
        verify(icon.onTap).called(1);
      },
    );

    group('left', () {
      flameTester.testGameWidget(
        'renders correctly',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          game.camera.followVector2(Vector2.zero());
          await game.add(
            ArrowIcon(
              position: Vector2.zero(),
              direction: ArrowIconDirection.left,
              onTap: () {},
            ),
          );
          await tester.pump();
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('golden/arrow_icon_left.png'),
          );
        },
      );
    });

    group('right', () {
      flameTester.testGameWidget(
        'renders correctly',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          game.camera.followVector2(Vector2.zero());
          await game.add(
            ArrowIcon(
              position: Vector2.zero(),
              direction: ArrowIconDirection.right,
              onTap: () {},
            ),
          );
          await tester.pump();
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('golden/arrow_icon_right.png'),
          );
        },
      );
    });
  });
}
