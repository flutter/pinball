import 'package:flame_test/flame_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/theme/theme.dart';

import 'mocks.dart';

FlameTester<PinballGame> flameBlocTester({
  GameBloc? gameBloc,
  ThemeCubit? themeCubit,
}) {
  return FlameTester<PinballGame>(
    PinballGame.new,
    pumpWidget: (gameWidget, tester) async {
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: gameBloc ?? MockGameBloc(),
            ),
            BlocProvider.value(
              value: themeCubit ?? MockThemeCubit(),
            ),
          ],
          child: gameWidget,
        ),
      );
    },
  );
}
