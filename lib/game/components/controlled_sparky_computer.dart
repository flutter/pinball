import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/flame/flame.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template controlled_sparky_computer}
/// [SparkyComputer] with a [SparkyComputerController] attached.
/// {@endtemplate}
class ControlledSparkyComputer extends SparkyComputer
    with Controls<SparkyComputerController>, HasGameRef<PinballGame> {
  /// {@macro controlled_sparky_computer}
  ControlledSparkyComputer() {
    controller = SparkyComputerController(this);
  }

  @override
  void build(Forge2DGame _) {
    addContactCallback(_SparkyTurboChargeSensorBallContactCallback());
    final sparkyTurboChargeSensor = _SparkyTurboChargeSensor()
      ..initialPosition = Vector2(-13, 49.8);
    add(sparkyTurboChargeSensor);
    super.build(_);
  }
}

class _SparkyTurboChargeSensor extends BodyComponent with InitialPosition {
  _SparkyTurboChargeSensor() {
    renderBody = false;
  }

  @override
  Body createBody() {
    final shape = CircleShape()..radius = .1;

    final fixtureDef = FixtureDef(shape)..isSensor = true;

    final bodyDef = BodyDef()
      ..position = initialPosition
      ..userData = this;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

/// {@template sparky_computer_controller}
/// Controller attached to a [SparkyComputer] that handles its game related
/// logic.
/// {@endtemplate}
// TODO(allisonryan0002): listen for turbo charge game bonus and animate Sparky.
class SparkyComputerController
    extends ComponentController<ControlledSparkyComputer> {
  /// {@macro sparky_computer_controller}
  SparkyComputerController(ControlledSparkyComputer controlledComputer)
      : super(controlledComputer);
}

class _SparkyTurboChargeSensorBallContactCallback
    extends ContactCallback<_SparkyTurboChargeSensor, ControlledBall> {
  _SparkyTurboChargeSensorBallContactCallback();

  @override
  void begin(
    _SparkyTurboChargeSensor sparkyTurboChargeSensor,
    ControlledBall ball,
    _,
  ) {
    ball.controller.turboCharge();
  }
}
