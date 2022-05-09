import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/start_game/bloc/start_game_bloc.dart';

import '../../../helpers/helpers.dart';

class _MockStartGameBloc extends Mock implements StartGameBloc {}

class _MockGameBloc extends Mock implements GameBloc {}

void main() {
  group('ReplayButtonOverlay', () {
    late StartGameBloc startGameBloc;
    late _MockGameBloc gameBloc;

    setUp(() async {
      await mockFlameImages();
      startGameBloc = _MockStartGameBloc();
      gameBloc = _MockGameBloc();

      whenListen(
        startGameBloc,
        Stream.value(const StartGameState.initial()),
        initialState: const StartGameState.initial(),
      );
      whenListen(
        gameBloc,
        Stream.value(const GameState.initial()),
        initialState: const GameState.initial(),
      );
    });

    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(const ReplayButtonOverlay());
      expect(find.text('Replay'), findsOneWidget);
    });

    testWidgets('adds ReplayTapped event to StartGameBloc when tapped',
        (tester) async {
      await tester.pumpApp(
        const ReplayButtonOverlay(),
        gameBloc: gameBloc,
        startGameBloc: startGameBloc,
      );

      await tester.tap(find.text('Replay'));
      await tester.pump();

      verify(() => startGameBloc.add(const ReplayTapped())).called(1);
    });

    testWidgets('adds GameStarted event to GameBloc when tapped',
        (tester) async {
      await tester.pumpApp(
        const ReplayButtonOverlay(),
        gameBloc: gameBloc,
        startGameBloc: startGameBloc,
      );

      await tester.tap(find.text('Replay'));
      await tester.pump();

      verify(() => gameBloc.add(const GameStarted())).called(1);
    });
  });
}
