// cSpell:ignore sublist
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
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

double _calcY(int i) => (i * 3.2) + 3.2;

const _columns = [-14.0, 0.0, 14.0];

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

/// {@template leaderboard_display}
/// Component that builds the leaderboard list of the Backbox.
/// {@endtemplate}
class LeaderboardDisplay extends PositionComponent with HasGameRef {
  /// {@macro leaderboard_display}
  LeaderboardDisplay({required List<LeaderboardEntryData> entries})
      : _entries = entries;

  final List<LeaderboardEntryData> _entries;

  _MovePageArrow _findArrow({required bool active}) {
    return descendants()
        .whereType<_MovePageArrow>()
        .firstWhere((arrow) => arrow.active == active);
  }

  void _changePage(List<LeaderboardEntryData> ranking, int offset) {
    final current = descendants().whereType<_RankingPage>().single;
    final activeArrow = _findArrow(active: true);
    final inactiveArrow = _findArrow(active: false);

    activeArrow.active = false;

    current.add(
      ScaleEffect.to(
        Vector2(0, 1),
        EffectController(
          duration: 0.5,
          curve: Curves.easeIn,
        ),
      )..onFinishCallback = () {
          current.removeFromParent();
          inactiveArrow.active = true;
          firstChild<PositionComponent>()?.add(
            _RankingPage(
              ranking: ranking,
              offset: offset,
            )
              ..scale = Vector2(0, 1)
              ..add(
                ScaleEffect.to(
                  Vector2(1, 1),
                  EffectController(
                    duration: 0.5,
                    curve: Curves.easeIn,
                  ),
                ),
              ),
          );
        },
    );
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
          _MovePageArrow(
            position: Vector2(20, 9),
            onTap: () {
              _changePage(_entries.sublist(5), 5);
            },
          ),
          _MovePageArrow(
            position: Vector2(-20, 9),
            direction: ArrowIconDirection.left,
            active: false,
            onTap: () {
              _changePage(_entries.take(5).toList(), 0);
            },
          ),
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
          _RankingPage(
            ranking: ranking,
            offset: 0,
          ),
        ],
      ),
    );
  }
}

class _RankingPage extends PositionComponent with HasGameRef {
  _RankingPage({
    required this.ranking,
    required this.offset,
  }) : super(children: []);

  final List<LeaderboardEntryData> ranking;
  final int offset;

  @override
  Future<void> onLoad() async {
    await addAll([
      for (var i = 0; i < ranking.length; i++)
        PositionComponent(
          children: [
            TextComponent(
              text: _rank(i + 1 + offset),
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
              position: Vector2(_columns[2] - 3, _calcY(i) + .25),
            ),
            TextComponent(
              text: ranking[i].playerInitials,
              textRenderer: _bodyTextPaint,
              position: Vector2(_columns[2] + 1, _calcY(i)),
              anchor: Anchor.center,
            ),
          ],
        ),
    ]);
  }
}

class _MovePageArrow extends PositionComponent {
  _MovePageArrow({
    required Vector2 position,
    required this.onTap,
    this.direction = ArrowIconDirection.right,
    bool active = true,
  }) : super(
          position: position,
          children: [
            if (active)
              ArrowIcon(
                position: Vector2.zero(),
                direction: direction,
                onTap: onTap,
              ),
            SequenceEffect(
              [
                ScaleEffect.to(
                  Vector2.all(1.2),
                  EffectController(duration: 1),
                ),
                ScaleEffect.to(Vector2.all(1), EffectController(duration: 1)),
              ],
              infinite: true,
            ),
          ],
        );

  final ArrowIconDirection direction;
  final VoidCallback onTap;

  bool get active => children.whereType<ArrowIcon>().isNotEmpty;
  set active(bool value) {
    if (value) {
      add(
        ArrowIcon(
          position: Vector2.zero(),
          direction: direction,
          onTap: onTap,
        ),
      );
    } else {
      firstChild<ArrowIcon>()?.removeFromParent();
    }
  }
}
