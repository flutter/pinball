// ignore_for_file: public_member_api_docs

import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

class AndroidSpaceshipEntranceBallContactBehavior
    extends ContactBehavior<AndroidSpaceshipEntrance>
    with FlameBlocReader<AndroidSpaceshipCubit, AndroidSpaceshipState> {
  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);
    if (other is! Ball) return;

    bloc.onBallEntered();
  }
}
