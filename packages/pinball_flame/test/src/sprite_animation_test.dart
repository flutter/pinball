import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_flame/pinball_flame.dart';

class _MockSpriteAnimationController extends Mock
    implements SpriteAnimationController {}

class _MockSpriteAnimation extends Mock implements SpriteAnimation {}

class _MockSprite extends Mock implements Sprite {}

void main() {
  group('PinballSpriteAnimationWidget', () {
    late SpriteAnimationController controller;
    late SpriteAnimation animation;
    late Sprite sprite;

    setUp(() {
      controller = _MockSpriteAnimationController();
      animation = _MockSpriteAnimation();
      sprite = _MockSprite();

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
