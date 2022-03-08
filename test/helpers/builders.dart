import 'package:flame_test/flame_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinball/game/game.dart';

FlameTester<PinballGame> flameBlocTester({
  required GameBloc gameBloc,
}) {
  return FlameTester<PinballGame>(
    PinballGame.initial,
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
