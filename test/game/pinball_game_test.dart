import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';

import '../helpers/helpers.dart';

void main() {
  group('PinballGame', () {
    // TODO(alestiago): test if [PinballGame] registers
    // [BallScorePointsCallback] once the following issue is resolved:
    // https://github.com/flame-engine/flame/issues/1416
  });

  group('PinballGame.initial', () {
    final gameBloc = MockGameBloc();

    setUp(() {
      whenListen(
        gameBloc,
        const Stream<GameState>.empty(),
        initialState: const GameState.initial(),
      );
    });

    flameBlocTester(gameBloc: gameBloc).test(
      'has initial theme',
      (game) async {
        expect(game.theme, PinballGame.initial().theme);
      },
    );
  });
}
