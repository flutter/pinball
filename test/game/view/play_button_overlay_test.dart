import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';

import '../../helpers/helpers.dart';

void main() {
  group('PlayButtonOverlay', () {
    late PinballGame game;
    late GameController gameController;

    setUp(() {
      game = MockPinballGame();
      gameController = MockGameController();

      when(() => game.gameController).thenReturn(gameController);
      when(gameController.start).thenAnswer((_) {});
    });

    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(PlayButtonOverlay(game: game));

      expect(find.text('Play'), findsOneWidget);
    });

    testWidgets('calls gameController.start when taped', (tester) async {
      await tester.pumpApp(PlayButtonOverlay(game: game));

      await tester.tap(find.text('Play'));
      await tester.pump();

      verify(gameController.start).called(1);
    });
  });
}
