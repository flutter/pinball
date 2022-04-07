import 'package:flame/components.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template board}
/// The main flat surface of the [PinballGame].
/// {endtemplate}
class Board extends Component {
  /// {@macro board}
  // TODO(alestiago): Make Board a Blueprint and sort out priorities.
  Board() : super(priority: 1);

  @override
  Future<void> onLoad() async {
    final bottomGroup = _BottomGroup();

    final flutterForest = FlutterForest();
    final alienZone = AlienZone();

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
      alienZone,
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
  _BottomGroup();

  @override
  Future<void> onLoad() async {
    final rightSide = _BottomGroupSide(
      side: BoardSide.right,
    );
    final leftSide = _BottomGroupSide(
      side: BoardSide.left,
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
  }) : _side = side;

  final BoardSide _side;

  @override
  Future<void> onLoad() async {
    final direction = _side.direction;
    final centerXAdjustment = _side.isLeft ? 0 : -6.5;

    final flipper = ControlledFlipper(
      side: _side,
    )..initialPosition = Vector2((11.0 * direction) + centerXAdjustment, -42.4);
    final baseboard = Baseboard(side: _side)
      ..initialPosition = Vector2(
        (25.58 * direction) + centerXAdjustment,
        -28.69,
      );
    final kicker = Kicker(
      side: _side,
    )..initialPosition = Vector2(
        (22.4 * direction) + centerXAdjustment,
        -25,
      );

    await addAll([flipper, baseboard, kicker]);
  }
}
