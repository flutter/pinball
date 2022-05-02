// ignore_for_file: invalid_use_of_protected_member

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flame/assets.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/game/view/widgets/bonus_animation.dart';
import 'package:pinball_flame/pinball_flame.dart';

import '../../../helpers/helpers.dart';

class MockImages extends Mock implements Images {}

class MockImage extends Mock implements ui.Image {}

class MockCallback extends Mock {
  void call();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const animationDuration = 6;

  setUp(() async {
    // TODO(arturplaczek): need to find for a better solution for loading image
    // or use original images from BonusAnimation.loadAssets()
    final image = await decodeImageFromList(Uint8List.fromList(fakeImage));
    final images = MockImages();
    when(() => images.fromCache(any())).thenReturn(image);
    when(() => images.load(any())).thenAnswer((_) => Future.value(image));
    Flame.images = images;
  });

  group('loads SpriteAnimationWidget correctly for', () {
    testWidgets('dashNest', (tester) async {
      await tester.pumpApp(
        BonusAnimation.dashNest(),
      );
      await tester.pump();

      expect(find.byType(SpriteAnimationWidget), findsOneWidget);
    });

    testWidgets('dinoChomp', (tester) async {
      await tester.pumpApp(
        BonusAnimation.dinoChomp(),
      );
      await tester.pump();

      expect(find.byType(SpriteAnimationWidget), findsOneWidget);
    });

    testWidgets('sparkyTurboCharge', (tester) async {
      await tester.pumpApp(
        BonusAnimation.sparkyTurboCharge(),
      );
      await tester.pump();

      expect(find.byType(SpriteAnimationWidget), findsOneWidget);
    });

    testWidgets('googleWord', (tester) async {
      await tester.pumpApp(
        BonusAnimation.googleWord(),
      );
      await tester.pump();

      expect(find.byType(SpriteAnimationWidget), findsOneWidget);
    });

    testWidgets('androidSpaceship', (tester) async {
      await tester.pumpApp(
        BonusAnimation.androidSpaceship(),
      );
      await tester.pump();

      expect(find.byType(SpriteAnimationWidget), findsOneWidget);
    });
  });

  // TODO(arturplaczek): refactor this test when there is a new version of the
  // flame with an onComplete callback in SpriteAnimationWidget
  // https://github.com/flame-engine/flame/issues/1543
  testWidgets('called onCompleted callback at the end of animation ',
      (tester) async {
    final callback = MockCallback();

    await tester.runAsync(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BonusAnimation.dashNest(
              onCompleted: callback.call,
            ),
          ),
        ),
      );

      await tester.pump();

      await Future<void>.delayed(const Duration(seconds: animationDuration));

      await tester.pump();

      verify(callback.call).called(1);
    });
  });

  testWidgets('called onCompleted once when animation changed', (tester) async {
    final callback = MockCallback();
    final secondAnimation = BonusAnimation.sparkyTurboCharge(
      onCompleted: callback.call,
    );

    await tester.runAsync(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BonusAnimation.dashNest(
              onCompleted: callback.call,
            ),
          ),
        ),
      );

      await tester.pump();

      tester
          .state(find.byType(BonusAnimation))
          .didUpdateWidget(secondAnimation);

      await Future<void>.delayed(const Duration(seconds: animationDuration));

      await tester.pump();

      verify(callback.call).called(1);
    });
  });
}
