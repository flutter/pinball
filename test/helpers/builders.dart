import 'package:flame_test/flame_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_theme/pinball_theme.dart';

FlameTester<PinballGame> flameBlocTester({
  required GameBloc gameBloc,
}) {
  return FlameTester<PinballGame>(
    PinballGameX.initial,
    pumpWidget: (gameWidget, tester) async {
      await tester.pumpWidget(
        BlocProvider.value(
          value: gameBloc,
          child: gameWidget,
        ),
      );
    },
  );
}

extension PinballGameX on PinballGame {
  static PinballGame initial() => PinballGame(
        theme: const PinballTheme(
          characterTheme: DashTheme(),
        ),
      );
}
