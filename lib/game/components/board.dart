import 'package:flame/components.dart';
import 'package:pinball/game/game.dart';

/// {@template bottom_group}
/// Grouping of the board's bottom [Component]s.
///
/// The bottom [Component]s are the [Flipper]s and the [Baseboard]s.
/// {@endtemplate}
// TODO(alestiago): Add [SlingShot] once provided.
// TODO(alestiago): Consider renaming once entire Board is defined.
class BottomGroup extends Component {
  /// {@macro bottom_group}
  BottomGroup({
    required this.position,
    required this.spacing,
  });

  /// The amount of space between the line of symmetry.
  final double spacing;

  /// The position of this [BottomGroup].
  final Vector2 position;

  @override
  Future<void> onLoad() async {
    final spacing = this.spacing + Flipper.width / 2;
    final rightSide = _BottomGroupSide(
      side: BoardSide.right,
      position: position + Vector2(spacing, 0),
    );
    final leftSide = _BottomGroupSide(
      side: BoardSide.left,
      position: position + Vector2(-spacing, 0),
    );

    await addAll([rightSide, leftSide]);
  }
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
    required Vector2 position,
  })  : _side = side,
        _position = position;

  final BoardSide _side;

  final Vector2 _position;

  @override
  Future<void> onLoad() async {
    final direction = _side.direction;

    final flipper = Flipper.fromSide(
      side: _side,
      position: _position,
    );
    final baseboard = Baseboard(
      side: _side,
      position: _position +
          Vector2(
            (Flipper.width * direction) - direction,
            Flipper.height,
          ),
    );

    await addAll([flipper, baseboard]);
  }
}
