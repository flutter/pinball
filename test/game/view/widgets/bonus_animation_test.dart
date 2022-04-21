import 'dart:async';

import 'dart:ui' as ui;

import 'package:flame/assets.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/view/widgets/bonus_animation.dart';

import '../../../helpers/helpers.dart';

class MockImages extends Mock implements Images {}

class MockImage extends Mock implements ui.Image {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await BonusAnimation.loadAssets();
  });

  group('loads SpriteAnimationWidget correctly for', () {
    testWidgets('dashNest', (tester) async {
      await tester.pumpApp(
        BonusAnimation.dashNest(),
      );
      await tester.pump();

      expect(find.byType(SpriteAnimationWidget), findsOneWidget);
    });

    testWidgets('dino', (tester) async {
      await tester.pumpApp(
        BonusAnimation.dino(),
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

    testWidgets('google', (tester) async {
      await tester.pumpApp(
        BonusAnimation.google(),
      );
      await tester.pump();

      expect(find.byType(SpriteAnimationWidget), findsOneWidget);
    });

    testWidgets('android', (tester) async {
      await tester.pumpApp(
        BonusAnimation.android(),
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
    final completer = Completer<void>();

    await tester.runAsync(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BonusAnimation.dashNest(
              onCompleted: completer.complete,
            ),
          ),
        ),
      );

      await tester.pump();

      await Future<void>.delayed(const Duration(seconds: 4));

      await tester.pump();

      expect(completer.isCompleted, isTrue);
    });
  });
}
