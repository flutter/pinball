import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/start_game/bloc/start_game_bloc.dart';

import '../../../helpers/helpers.dart';

class _MockStartGameBloc extends Mock implements StartGameBloc {}

void main() {
  group('ReplayButtonOverlay', () {
    late StartGameBloc startGameBloc;

    setUp(() async {
      await mockFlameImages();
      startGameBloc = _MockStartGameBloc();

      whenListen(
        startGameBloc,
        Stream.value(const StartGameState.initial()),
        initialState: const StartGameState.initial(),
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
        startGameBloc: startGameBloc,
      );

      await tester.tap(find.text('Replay'));
      await tester.pump();

      verify(() => startGameBloc.add(const ReplayTapped())).called(1);
    });
  });
}
