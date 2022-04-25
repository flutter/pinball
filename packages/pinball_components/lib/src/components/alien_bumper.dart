import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';

abstract class State<T> {
  // TODO(alestiago): Investigate approaches to avoid having this as late.
  late T _state;

  T get state => _state;

  set state(T value) {
    if (value == _state) return;
    _state = value;
    _stream.sink.add(value);
  }

  final StreamController<T> _stream = StreamController<T>.broadcast();

  Stream<T> get stream => _stream.stream;
}

/// Indicates the [AlienBumper]'s current sprite state.
enum AlienBumperState {
  /// A lit up bumper.
  active,

  /// A dimmed bumper.
  inactive,
}

/// {@template alien_bumper}
/// Bumper for area under the [Spaceship].
/// {@endtemplate}
class AlienBumper extends BodyComponent
    with InitialPosition, State<AlienBumperState> {
  /// {@macro alien_bumper}
  AlienBumper._({
    required double majorRadius,
    required double minorRadius,
    required String onAssetPath,
    required String offAssetPath,
    Iterable<Component>? children,
  })  : _majorRadius = majorRadius,
        _minorRadius = minorRadius,
        super(
          priority: RenderPriority.alienBumper,
          children: [
            if (children != null) ...children,
          ],
          renderBody: false,
        ) {
    _state = AlienBumperState.active;
    _spriteGroupComponent = _AlienBumperSpriteGroupComponent(
      offAssetPath: offAssetPath,
      onAssetPath: onAssetPath,
      state: state,
    );
  }

  /// {@macro alien_bumper}
  AlienBumper.a({
    Iterable<Component>? children,
  }) : this._(
          majorRadius: 3.52,
          minorRadius: 2.97,
          onAssetPath: Assets.images.alienBumper.a.active.keyName,
          offAssetPath: Assets.images.alienBumper.a.inactive.keyName,
          children: children,
        );

  /// {@macro alien_bumper}
  AlienBumper.b({
    Iterable<Component>? children,
  }) : this._(
          majorRadius: 3.19,
          minorRadius: 2.79,
          onAssetPath: Assets.images.alienBumper.b.active.keyName,
          offAssetPath: Assets.images.alienBumper.b.inactive.keyName,
          children: children,
        );

  final double _majorRadius;

  final double _minorRadius;

  late final _AlienBumperSpriteGroupComponent _spriteGroupComponent;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await add(_spriteGroupComponent);
  }

  @override
  Body createBody() {
    final shape = EllipseShape(
      center: Vector2.zero(),
      majorRadius: _majorRadius,
      minorRadius: _minorRadius,
    )..rotate(1.29);
    final fixtureDef = FixtureDef(
      shape,
      restitution: 4,
    );
    final bodyDef = BodyDef(
      position: initialPosition,
    );

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

class _AlienBumperSpriteGroupComponent
    extends SpriteGroupComponent<AlienBumperState> with HasGameRef {
  _AlienBumperSpriteGroupComponent({
    required String onAssetPath,
    required String offAssetPath,
    required AlienBumperState state,
  })  : _onAssetPath = onAssetPath,
        _offAssetPath = offAssetPath,
        super(
          anchor: Anchor.center,
          position: Vector2(0, -0.1),
          current: state,
        );

  final String _onAssetPath;
  final String _offAssetPath;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sprites = {
      AlienBumperState.active: Sprite(
        gameRef.images.fromCache(_onAssetPath),
      ),
      AlienBumperState.inactive:
          Sprite(gameRef.images.fromCache(_offAssetPath)),
    };
    this.sprites = sprites;
    size = sprites[current]!.originalSize / 10;

    // TODO(alestiago): Refactor once the following is merged:
    // https://github.com/flame-engine/flame/pull/1566
    final parent = this.parent;
    if (parent is! AlienBumper) return;

    parent.stream.listen((state) => current = state);
  }
}
