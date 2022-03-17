import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';

/// {@template chrome_dino}
/// Dinosour that gobbles up a [Ball], swivel his head around, and shoots it
/// back out.
/// {@endtemplate}
class ChromeDino extends BodyComponent with InitialPosition {
  /// {@macro chrome_dino}
  ChromeDino();

  @override
  Body createBody() {
    // TODO: implement createBody
    throw UnimplementedError();
  }
}
