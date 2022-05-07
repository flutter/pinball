// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/game/view/widgets/bonus_animation.dart';
import 'package:pinball_flame/pinball_flame.dart';

import '../../../helpers/helpers.dart';

class _MockCallback extends Mock {
  void call();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const animationDuration = 6;

  setUp(() async {
    await mockFlameImages();
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

  testWidgets('called onCompleted callback at the end of animation ',
      (tester) async {
    final callback = _MockCallback();

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
    final callback = _MockCallback();
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
