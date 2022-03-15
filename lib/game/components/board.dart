import 'package:flame/components.dart';
import 'package:pinball/game/game.dart';

/// {@template bottom_group}
///
/// {@endtemplate}
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
    final rightSide = _BottomGroupSide.right(
      position: position + Vector2(spacing, 0),
    );
    final leftSide = _BottomGroupSide.left(
      position: position + Vector2(-spacing, 0),
    );

    await addAll([rightSide, leftSide]);
  }
}

/// Group with [BottomGroup]'s symmetric [Component]s.
///
/// For example, [Flipper.right] and [Flipper.left] are symmetric components.
class _BottomGroupSide extends Component {
  _BottomGroupSide._({
    required BoardSide side,
    required Vector2 position,
  })  : _side = side,
        _position = position;

  _BottomGroupSide.right({required Vector2 position})
      : this._(side: BoardSide.right, position: position);

  _BottomGroupSide.left({required Vector2 position})
      : this._(side: BoardSide.left, position: position);

  final BoardSide _side;

  final Vector2 _position;

  @override
  Future<void> onLoad() async {
    final magnitude = _side.isLeft ? -1 : 1;
    final flipper = Flipper.fromSide(
      side: _side,
      position: _position,
    );
    await add(flipper);

    final bumper = Baseboard(
      side: _side,
      position: _position +
          Vector2(
            (Flipper.width * magnitude) - magnitude,
            Flipper.height,
          ),
    );
    await add(bumper);
  }
}
