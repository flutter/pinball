import 'package:flame/components.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template bottom_group}
/// Grouping of the board's symmetrical bottom [Component]s.
///
/// The [BottomGroup] consists of [Flipper]s, [Baseboard]s and [Kicker]s.
/// {@endtemplate}
// TODO(allisonryan0002): Consider renaming.
class BottomGroup extends Component {
  /// {@macro bottom_group}
  BottomGroup()
      : super(
          children: [
            _BottomGroupSide(side: BoardSide.right),
            _BottomGroupSide(side: BoardSide.left),
          ],
        );
}

/// {@template bottom_group_side}
/// Group with one side of [BottomGroup]'s symmetric [Component]s.
///
/// For example, [Flipper]s are symmetric components.
/// {@endtemplate}
class _BottomGroupSide extends Component {
  /// {@macro bottom_group_side}
  _BottomGroupSide({
    required BoardSide side,
  })  : _side = side,
        super(priority: RenderPriority.bottomGroup);

  final BoardSide _side;

  @override
  Future<void> onLoad() async {
    final direction = _side.direction;
    final centerXAdjustment = _side.isLeft ? 0 : -6.5;

    final flipper = ControlledFlipper(
      side: _side,
    )..initialPosition = Vector2((11.8 * direction) + centerXAdjustment, 43.6);
    final baseboard = Baseboard(side: _side)
      ..initialPosition = Vector2(
        (25.58 * direction) + centerXAdjustment,
        28.69,
      );
    final kicker = Kicker(
      side: _side,
      children: [
        ScoringBehavior(points: 5000),
      ],
    )..initialPosition = Vector2(
        (22.4 * direction) + centerXAdjustment,
        25,
      );

    await addAll([flipper, baseboard, kicker]);
  }
}
