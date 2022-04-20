import 'package:flame/game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class FlameBlocTester<T extends FlameGame, B extends Bloc<dynamic, dynamic>>
    extends FlameTester<T> {
  FlameBlocTester({
    required GameCreateFunction<T> gameBuilder,
    required B Function() blocBuilder,
    // TODO(allisonryan0002): find alternative for testGameWidget. Loading
    // assets in onLoad fails because the game loads after
    List<String>? assets,
    List<RepositoryProvider> Function()? repositories,
  }) : super(
          gameBuilder,
          pumpWidget: (gameWidget, tester) async {
            if (assets != null) {
              await Future.wait(assets.map(gameWidget.game.images.load));
            }
            await tester.pumpWidget(
              BlocProvider.value(
                value: blocBuilder(),
                child: repositories == null
                    ? gameWidget
                    : MultiRepositoryProvider(
                        providers: repositories.call(),
                        child: gameWidget,
                      ),
              ),
            );
          },
        );
}
