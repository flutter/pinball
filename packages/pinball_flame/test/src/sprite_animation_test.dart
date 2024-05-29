import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_flame/pinball_flame.dart';

class _MockSpriteAnimationController extends Mock
    implements SpriteAnimationController {}

class _MockSpriteAnimation extends Mock implements SpriteAnimation {}

class _MockSpriteAnimationTicker extends Mock implements SpriteAnimationTicker {
  @override
  double totalDuration() {
    return 1;
  }
}

class _MockSprite extends Mock implements Sprite {}

void main() {
  group('PinballSpriteAnimationWidget', () {
    late SpriteAnimationController controller;
    late SpriteAnimation animation;
    late SpriteAnimationTicker animationTicker;
    late Sprite sprite;

    setUp(() {
      controller = _MockSpriteAnimationController();
      animation = _MockSpriteAnimation();
      animationTicker = _MockSpriteAnimationTicker();
      sprite = _MockSprite();

      when(() => animationTicker.getSprite()).thenAnswer((_) => sprite);

      when(() => controller.animation).thenAnswer((_) => animation);
      when(() => controller.animationTicker).thenAnswer((_) => animationTicker);

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
        animationTicker: animationTicker,
      ).notifyListeners();

      verify(() => animationTicker.update(any())).called(1);
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
