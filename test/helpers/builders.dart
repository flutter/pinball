import 'package:flame_test/flame_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinball/game/game.dart';

FlameTester flameBlocTester({required GameBloc Function() gameBlocBuilder}) {
  return FlameTester(
    PinballGame.new,
    pumpWidget: (gameWidget, tester) async {
      await tester.pumpWidget(
        BlocProvider.value(
          value: gameBlocBuilder(),
          child: gameWidget,
        ),
      );
    },
  );
}
