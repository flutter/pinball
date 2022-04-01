import 'package:flame/src/game/flame_game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlameBlocTester<T extends FlameGame, B extends Bloc<dynamic, dynamic>>
    extends FlameTester<T> {
  FlameBlocTester({
    required GameCreateFunction<T> gameBuilder,
    required B Function() blocBuilder,
  }) : super(
          gameBuilder,
          pumpWidget: (gameWidget, tester) async {
            await tester.pumpWidget(
              BlocProvider.value(
                value: blocBuilder(),
                child: gameWidget,
              ),
            );
          },
        );
}
