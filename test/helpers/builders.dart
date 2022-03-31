import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinball/game/game.dart';

FlameTester<T> flameBlocTester<T extends Forge2DGame>({
  required T Function() game,
  required GameBloc Function() gameBloc,
}) {
  return FlameTester<T>(
    game,
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
