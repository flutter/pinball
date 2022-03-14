import 'package:flame_test/flame_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinball/game/game.dart';

import 'helpers.dart';

FlameTester<PinballGame> flameBlocTester({
  required GameBloc Function() gameBloc,
}) {
  return FlameTester<PinballGame>(
    PinballGameTest.create,
    pumpWidget: (gameWidget, tester) async {
      await tester.pumpWidget(
        BlocProvider.value(
          value: gameBloc(),
          child: gameWidget,
        ),
      );
    },
  );
}
