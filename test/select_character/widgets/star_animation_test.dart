// ignore_for_file: invalid_use_of_protected_member

import 'package:flame/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/select_character/select_character.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('loads SpriteAnimationWidget correctly for', () {
    setUpAll(() async {
      StarAnimation.loadAssets();
    });

    testWidgets('starA', (tester) async {
      await tester.pumpApp(
        StarAnimation.starA(),
      );
      await tester.pump();

      expect(find.byType(SpriteAnimationWidget), findsOneWidget);
    });

    testWidgets('starB', (tester) async {
      await tester.pumpApp(
        StarAnimation.starB(),
      );
      await tester.pump();

      expect(find.byType(SpriteAnimationWidget), findsOneWidget);
    });

    testWidgets('starC', (tester) async {
      await tester.pumpApp(
        StarAnimation.starC(),
      );
      await tester.pump();

      expect(find.byType(SpriteAnimationWidget), findsOneWidget);
    });
  });
}
