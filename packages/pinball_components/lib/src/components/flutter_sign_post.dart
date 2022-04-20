import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';

enum _SignPostSpriteState {
  inactive,
  active1,
  active2,
  active3,
}

extension on _SignPostSpriteState {
  String get path {
    switch (this) {
      case _SignPostSpriteState.inactive:
        return Assets.images.signPost.inactive.keyName;
      case _SignPostSpriteState.active1:
        return Assets.images.signPost.active1.keyName;
      case _SignPostSpriteState.active2:
        return Assets.images.signPost.active2.keyName;
      case _SignPostSpriteState.active3:
        return Assets.images.signPost.active3.keyName;
    }
  }

  _SignPostSpriteState get next {
    return _SignPostSpriteState
        .values[(index + 1) % _SignPostSpriteState.values.length];
  }
}

/// {@template flutter_sign_post}
/// A sign, found in the Flutter Forest.
/// {@endtemplate}
class FlutterSignPost extends BodyComponent with InitialPosition {
  /// {@macro flutter_sign_post}
  FlutterSignPost()
      : super(
          priority: RenderPriority.flutterSignPost,
          children: [_FlutterSignPostSpriteComponent()],
        ) {
    renderBody = false;
  }

  /// Forwards the sprite to the next [_SignPostSpriteState].
  ///
  /// If the current state is the last one it goes back to the initial state.
  void progress() => firstChild<_FlutterSignPostSpriteComponent>()!.progress();

  @override
  Body createBody() {
    final shape = CircleShape()..radius = 0.25;
    final fixtureDef = FixtureDef(shape);
    final bodyDef = BodyDef(
      position: initialPosition,
    );

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

class _FlutterSignPostSpriteComponent
    extends SpriteGroupComponent<_SignPostSpriteState> with HasGameRef {
  _FlutterSignPostSpriteComponent()
      : super(
          anchor: Anchor.bottomCenter,
          position: Vector2(0.65, 0.45),
        );

  void progress() => current = current?.next;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sprites = <_SignPostSpriteState, Sprite>{};
    this.sprites = sprites;
    for (final spriteState in _SignPostSpriteState.values) {
      sprites[spriteState] = Sprite(
        gameRef.images.fromCache(spriteState.path),
      );
    }

    current = _SignPostSpriteState.inactive;
    size = sprites[current]!.originalSize / 10;
  }
}
