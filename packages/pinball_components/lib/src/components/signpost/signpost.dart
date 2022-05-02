import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';

export 'cubit/signpost_cubit.dart';

/// {@template signpost}
/// A sign, found in the Flutter Forest.
///
/// Lights up a new sign whenever all three [DashNestBumper]s are hit.
/// {@endtemplate}
class Signpost extends BodyComponent with InitialPosition {
  /// {@macro signpost}
  Signpost({
    Iterable<Component>? children,
  }) : this._(
          children: children,
          bloc: SignpostCubit(),
        );

  Signpost._({
    Iterable<Component>? children,
    required this.bloc,
  }) : super(
          renderBody: false,
          children: [
            _SignpostSpriteComponent(
              current: bloc.state,
            ),
            ...?children,
          ],
        );

  // TODO(alestiago): Consider refactoring once the following is merged:
  // https://github.com/flame-engine/flame/pull/1538
  // ignore: public_member_api_docs
  final SignpostCubit bloc;

  @override
  Body createBody() {
    final shape = CircleShape()..radius = 0.25;
    final bodyDef = BodyDef(
      position: initialPosition,
    );

    return world.createBody(bodyDef)..createFixtureFromShape(shape);
  }
}

class _SignpostSpriteComponent extends SpriteGroupComponent<SignpostState>
    with HasGameRef {
  _SignpostSpriteComponent({
    required SignpostState current,
  }) : super(
          anchor: Anchor.bottomCenter,
          position: Vector2(0.65, 0.45),
          current: current,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sprites = <SignpostState, Sprite>{};
    this.sprites = sprites;
    for (final spriteState in SignpostState.values) {
      sprites[spriteState] = Sprite(
        gameRef.images.fromCache(spriteState.path),
      );
    }

    current = SignpostState.inactive;
    size = sprites[current]!.originalSize / 10;
  }
}

extension on SignpostState {
  String get path {
    switch (this) {
      case SignpostState.inactive:
        return Assets.images.signpost.inactive.keyName;
      case SignpostState.active1:
        return Assets.images.signpost.active1.keyName;
      case SignpostState.active2:
        return Assets.images.signpost.active2.keyName;
      case SignpostState.active3:
        return Assets.images.signpost.active3.keyName;
    }
  }
}
