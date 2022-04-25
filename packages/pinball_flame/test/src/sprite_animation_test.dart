import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_flame/pinball_flame.dart';

class MockSpriteAnimationController extends Mock
    implements SpriteAnimationController {}

class MockSpriteAnimation extends Mock implements SpriteAnimation {}

class MockSprite extends Mock implements Sprite {}

// TODO(arturplaczek): Remove when this PR will be merged.
// https://github.com/flame-engine/flame/pull/1552

void main() {
  group('PinballSpriteAnimationWidget', () {
    late SpriteAnimationController controller;
    late SpriteAnimation animation;
    late Sprite sprite;

    setUp(() {
      controller = MockSpriteAnimationController();
      animation = MockSpriteAnimation();
      sprite = MockSprite();

      when(() => controller.animation).thenAnswer((_) => animation);

      when(() => animation.totalDuration()).thenAnswer((_) => 1);
      when(() => animation.getSprite()).thenAnswer((_) => sprite);
      when(() => sprite.srcSize).thenAnswer((_) => Vector2(1, 1));
      when(() => sprite.srcSize).thenAnswer((_) => Vector2(1, 1));
    });

    testWidgets('renders correctly', (tester) async {
      await tester.pumpWidget(
        SpriteAnimationWidget(
          controller: controller,
        ),
      );

      await tester.pumpAndSettle();
      await tester.pumpAndSettle();

      expect(find.byType(SpriteAnimationWidget), findsOneWidget);
    });

    test('SpriteAnimationController is updating animations', () {
      SpriteAnimationController(
        vsync: const TestVSync(),
        animation: animation,
      ).notifyListeners();

      verify(() => animation.update(any())).called(1);
    });

    testWidgets('SpritePainter shouldRepaint returns true when Sprite changed',
        (tester) async {
      final spritePainter = SpritePainter(
        sprite,
        Anchor.center,
        angle: 45,
      );

      final anotherPainter = SpritePainter(
        sprite,
        Anchor.center,
        angle: 30,
      );

      expect(spritePainter.shouldRepaint(anotherPainter), isTrue);
    });
  });
}
