import 'package:flame/game.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';

import '../../helpers/helpers.dart';

void main() {
  group('PinballGamePage', () {
    testWidgets('renders single GameWidget with PinballGame', (tester) async {
      await tester.pumpApp(const PinballGamePage());
      expect(find.byType(GameWidget<PinballGame>), findsOneWidget);
    });
  });
}
