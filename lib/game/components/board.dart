import 'package:flame/components.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template board}
/// The main flat surface of the [PinballGame].
/// {endtemplate}
class Board extends Component {
  /// {@macro board}
  // TODO(alestiago): Make Board a Blueprint and sort out priorities.
  Board() : super(priority: 5);

  @override
  Future<void> onLoad() async {
    // TODO(alestiago): adjust positioning once sprites are added.
    final bottomGroup = _BottomGroup(
      position: Vector2(
        BoardDimensions.bounds.center.dx,
        BoardDimensions.bounds.bottom + 10,
      ),
      spacing: 2,
    );

    final flutterForest = FlutterForest();

    // TODO(alestiago): adjust positioning to real design.
    final dino = ChromeDino()
      ..initialPosition = Vector2(
        BoardDimensions.bounds.center.dx + 25,
        BoardDimensions.bounds.center.dy + 10,
      );

    await addAll([
      bottomGroup,
      dino,
      flutterForest,
    ]);
  }
}

/// {@template bottom_group}
/// Grouping of the board's bottom [Component]s.
///
/// The [_BottomGroup] consists of[Flipper]s, [Baseboard]s and [Kicker]s.
/// {@endtemplate}
// TODO(alestiago): Consider renaming once entire Board is defined.
class _BottomGroup extends Component {
  /// {@macro bottom_group}
  _BottomGroup({
    required this.position,
    required this.spacing,
  });

  /// The amount of space between the line of symmetry.
  final double spacing;

  /// The position of this [_BottomGroup].
  final Vector2 position;

  @override
  Future<void> onLoad() async {
    final spacing = this.spacing + Flipper.size.x / 2;
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
/// Group with one side of [_BottomGroup]'s symmetric [Component]s.
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

    final flipper = ControlledFlipper(
      side: _side,
    )..initialPosition = _position;

    final baseboard = Baseboard(side: _side)
      ..initialPosition = _position +
          Vector2(
            (Baseboard.size.x / 1.6 * direction),
            Baseboard.size.y - 2,
          );

    final kicker = Kicker(
      side: _side,
    )..initialPosition = _position +
        Vector2(
          (Flipper.size.x) * direction,
          Flipper.size.y + Kicker.size.y,
        );

    await addAll([flipper, baseboard, kicker]);
  }
}
