import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';

import '../../helpers/helpers.dart';

void main() {
  group('PlayButtonOverlay', () {
    late PinballGame game;
    late GameFlowController gameFlowController;

    setUp(() {
      game = MockPinballGame();
      gameFlowController = MockGameFlowController();

      when(() => game.gameFlowController).thenReturn(gameFlowController);
      when(gameFlowController.start).thenAnswer((_) {});
    });

    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(PlayButtonOverlay(game: game));

      expect(find.text('Play'), findsOneWidget);
    });

    testWidgets('calls gameFlowController.start when taped', (tester) async {
      await tester.pumpApp(PlayButtonOverlay(game: game));

      await tester.tap(find.text('Play'));
      await tester.pump();

      verify(gameFlowController.start).called(1);
    });
  });
}
