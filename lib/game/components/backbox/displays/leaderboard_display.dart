import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball/leaderboard/models/leader_board_entry.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';
import 'package:pinball_ui/pinball_ui.dart';

final _titleTextPaint = TextPaint(
  style: const TextStyle(
    fontSize: 2,
    color: PinballColors.red,
    fontFamily: PinballFonts.pixeloidSans,
  ),
);

final _bodyTextPaint = TextPaint(
  style: const TextStyle(
    fontSize: 1.8,
    color: PinballColors.white,
    fontFamily: PinballFonts.pixeloidSans,
  ),
);

/// {@template leaderboard_display}
/// Component that builds the leaderboard list of the Backbox.
/// {@endtemplate}
class LeaderboardDisplay extends PositionComponent with HasGameRef {
  /// {@macro leaderboard_display}
  LeaderboardDisplay({required List<LeaderboardEntryData> entries})
      : _entries = entries;

  final List<LeaderboardEntryData> _entries;

  double _calcY(int i) => (i * 3.2) + 3.2;

  static const _columns = [-15.0, 0.0, 15.0];

  String _rank(int number) {
    switch (number) {
      case 1:
        return '${number}st';
      case 2:
        return '${number}nd';
      case 3:
        return '${number}rd';
      default:
        return '${number}th';
    }
  }

  @override
  Future<void> onLoad() async {
    position = Vector2(0, -30);

    final l10n = readProvider<AppLocalizations>();
    final ranking = _entries.take(5).toList();
    await add(
      PositionComponent(
        position: Vector2(0, 4),
        children: [
          PositionComponent(
            children: [
              TextComponent(
                text: l10n.rank,
                textRenderer: _titleTextPaint,
                position: Vector2(_columns[0], 0),
                anchor: Anchor.center,
              ),
              TextComponent(
                text: l10n.score,
                textRenderer: _titleTextPaint,
                position: Vector2(_columns[1], 0),
                anchor: Anchor.center,
              ),
              TextComponent(
                text: l10n.name,
                textRenderer: _titleTextPaint,
                position: Vector2(_columns[2], 0),
                anchor: Anchor.center,
              ),
            ],
          ),
          for (var i = 0; i < ranking.length; i++)
            PositionComponent(
              children: [
                TextComponent(
                  text: _rank(i + 1),
                  textRenderer: _bodyTextPaint,
                  position: Vector2(_columns[0], _calcY(i)),
                  anchor: Anchor.center,
                ),
                TextComponent(
                  text: ranking[i].score.formatScore(),
                  textRenderer: _bodyTextPaint,
                  position: Vector2(_columns[1], _calcY(i)),
                  anchor: Anchor.center,
                ),
                SpriteComponent.fromImage(
                  gameRef.images.fromCache(
                    ranking[i].character.toTheme.leaderboardIcon.keyName,
                  ),
                  anchor: Anchor.center,
                  size: Vector2(1.8, 1.8),
                  position: Vector2(_columns[2] - 2.5, _calcY(i) + .25),
                ),
                TextComponent(
                  text: ranking[i].playerInitials,
                  textRenderer: _bodyTextPaint,
                  position: Vector2(_columns[2] + 1, _calcY(i)),
                  anchor: Anchor.center,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
