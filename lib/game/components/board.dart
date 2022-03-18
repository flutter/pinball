import 'package:flame/components.dart';
import 'package:pinball/game/game.dart';

/// {@template board}
/// The main flat surface of the [PinballGame], where the [Flipper]s,
/// [RoundBumper]s, [SlingShot]s are arranged.
/// {entemplate}
class Board extends Component {
  /// {@macro board}
  Board({required Vector2 size}) : _size = size;

  final Vector2 _size;

  @override
  Future<void> onLoad() async {
    // TODO(alestiago): adjust positioning once sprites are added.
    final bottomGroup = _BottomGroup(
      position: Vector2(
        _size.x / 2,
        _size.y / 1.25,
      ),
      spacing: 2,
    );

    final dashForest = _FlutterForest(
      position: Vector2(
        _size.x / 1.25,
        _size.y / 4.25,
      ),
    );

    await addAll([
      bottomGroup,
      dashForest,
    ]);
  }
}

/// {@template flutter_forest}
/// Area positioned at the top right of the [Board] where the [Ball]
/// can bounce off [RoundBumper]s.
/// {@endtemplate}
class _FlutterForest extends Component {
  /// {@macro flutter_forest}
  _FlutterForest({
    required this.position,
  });

  final Vector2 position;

  @override
  Future<void> onLoad() async {
    // TODO(alestiago): adjust positioning once sprites are added.
    // TODO(alestiago): Use [NestBumper] instead of [RoundBumper] once provided.
    final smallLeftNest = RoundBumper(
      radius: 1,
      points: 10,
    )..initialPosition = position + Vector2(-4.8, 2.8);
    final smallRightNest = RoundBumper(
      radius: 1,
      points: 10,
    )..initialPosition = position + Vector2(0.5, -5.5);
    final bigNest = RoundBumper(
      radius: 2,
      points: 20,
    )..initialPosition = position;

    await addAll([
      smallLeftNest,
      smallRightNest,
      bigNest,
    ]);
  }
}

/// {@template bottom_group}
/// Grouping of the board's bottom [Component]s.
///
/// The [_BottomGroup] consists of[Flipper]s, [Baseboard]s and [SlingShot]s.
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

    final flipper = Flipper.fromSide(
      side: _side,
    )..initialPosition = _position;
    final baseboard = Baseboard(side: _side)
      ..initialPosition = _position +
          Vector2(
            (Flipper.width * direction) - direction,
            Flipper.height,
          );
    final slingShot = SlingShot(
      side: _side,
    )..initialPosition = _position +
        Vector2(
          (Flipper.width) * direction,
          Flipper.height + SlingShot.size.y,
        );

    await addAll([flipper, baseboard, slingShot]);
  }
}
