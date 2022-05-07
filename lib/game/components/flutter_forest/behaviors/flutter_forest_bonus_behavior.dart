import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/select_character/select_character.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// Bonus obtained at the [FlutterForest].
///
/// When all [DashNestBumper]s are hit at least once three times, the [Signpost]
/// progresses. When the [Signpost] fully progresses, the [GameBonus.dashNest]
/// is awarded, and the [DashNestBumper.main] releases a new [Ball].
class FlutterForestBonusBehavior extends Component
    with
        ParentIsA<FlutterForest>,
        HasGameRef,
        FlameBlocReader<GameBloc, GameState> {
  @override
  void onMount() {
    super.onMount();

    final bumpers = parent.children.whereType<DashNestBumper>();
    final signpost = parent.firstChild<Signpost>()!;
    final animatronic = parent.firstChild<DashAnimatronic>()!;
    final canvas = gameRef.descendants().whereType<ZCanvasComponent>().single;

    for (final bumper in bumpers) {
      bumper.bloc.stream.listen((state) {
        final activatedAllBumpers = bumpers.every(
          (bumper) => bumper.bloc.state == DashNestBumperState.active,
        );

        if (activatedAllBumpers) {
          signpost.bloc.onProgressed();
          for (final bumper in bumpers) {
            bumper.bloc.onReset();
          }

          if (signpost.bloc.isFullyProgressed()) {
            bloc.add(const BonusActivated(GameBonus.dashNest));
            final characterTheme =
                readBloc<CharacterThemeCubit, CharacterThemeState>()
                    .state
                    .characterTheme;
            canvas.add(
              Ball(assetPath: characterTheme.ball.keyName)
                ..initialPosition = Vector2(29.2, -24.5)
                ..zIndex = ZIndexes.ballOnBoard,
            );
            animatronic.playing = true;
            signpost.bloc.onProgressed();
          }
        }
      });
    }
  }
}
