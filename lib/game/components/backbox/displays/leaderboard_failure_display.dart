import 'package:flame/components.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template leaderboard_failure_display}
/// Display showing an error message when the leaderboard couldn't be loaded
/// {@endtemplate}
class LeaderboardFailureDisplay extends Component {
  /// {@macro leaderboard_failure_display}
  LeaderboardFailureDisplay();

  @override
  Future<void> onLoad() async {
    final l10n = readProvider<AppLocalizations>();
    await add(
      ErrorComponent(
        label: l10n.leaderboardErrorMessage,
        position: Vector2(0, -18),
      ),
    );
  }
}
