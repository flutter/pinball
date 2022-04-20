import 'dart:async';
import 'dart:typed_data';

import 'dart:ui' as ui;

import 'package:flame/assets.dart';
import 'package:flame/flame.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/view/widgets/bonus_animation.dart';

class MockImages extends Mock implements Images {}

class MockImage extends Mock implements ui.Image {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final image = decodeImageFromList(Uint8List.fromList(transparentImage));
  late Images images;

  setUp(() {
    images = MockImages();
    when(() => images.load(any())).thenAnswer((_) => image);

    Flame.images = images;
  });

  group('renders SpriteAnimationWidget for', () {
    testWidgets('dashNest', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BonusAnimation.dashNest(),
            ),
          ),
        );
        await tester.pump();

        expect(find.byType(SpriteAnimationWidget), findsOneWidget);
      });
    });

    testWidgets('dino', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BonusAnimation.dino(),
            ),
          ),
        );
        await tester.pump();

        expect(find.byType(SpriteAnimationWidget), findsOneWidget);
      });
    });

    testWidgets('sparkyTurboCharge', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BonusAnimation.sparkyTurboCharge(),
            ),
          ),
        );
        await tester.pump();

        expect(find.byType(SpriteAnimationWidget), findsOneWidget);
      });
    });
  });

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

const transparentImage = <int>[
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
];
