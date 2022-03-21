import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/foundation.dart';

const _attachedErrorMessage = "Can't add to attached Blueprints";

// TODO(erickzanardo): Keeping this inside our code base
// so we can experiment with the idea, but this is a
// potential upstream change on Flame.

/// A [Blueprint] is a virtual way of grouping [Component]s
/// that are related, but they need to be added directly on
/// the [FlameGame] level.
abstract class Blueprint {
  final List<Component> _components = [];
  bool _isAttached = false;

  /// Called before the the [Component]s managed
  /// by this blueprint is added to the [FlameGame]
  void build();

  /// Attach the [Component]s built on [build] to the [game]
  /// instance
  @mustCallSuper
  Future<void> attach(FlameGame game) async {
    build();
    await game.addAll(_components);
    _isAttached = true;
  }

  /// Adds a list of [Component]s to this blueprint.
  void addAll(List<Component> components) {
    assert(!_isAttached, _attachedErrorMessage);
    _components.addAll(components);
  }

  /// Adds a single [Component] to this blueprint.
  void add(Component component) {
    assert(!_isAttached, _attachedErrorMessage);
    _components.add(component);
  }

  /// Returns a copy of the components built by this blueprint
  List<Component> get components => List.unmodifiable(_components);
}

/// A [Blueprint] that provides additional
/// structures specific to flame_forge2d
abstract class Forge2DBlueprint extends Blueprint {
  final List<ContactCallback> _callbacks = [];

  /// Adds a single [ContactCallback] to this blueprint
  void addContactCallback(ContactCallback callback) {
    assert(!_isAttached, _attachedErrorMessage);
    _callbacks.add(callback);
  }

  /// Adds a collection of [ContactCallback]s to this blueprint
  void addAllContactCallback(List<ContactCallback> callbacks) {
    assert(!_isAttached, _attachedErrorMessage);
    _callbacks.addAll(callbacks);
  }

  @override
  Future<void> attach(FlameGame game) async {
    await super.attach(game);

    assert(game is Forge2DGame, 'Forge2DBlueprint used outside a Forge2DGame');

    for (final callback in _callbacks) {
      (game as Forge2DGame).addContactCallback(callback);
    }
  }

  /// Returns a copy of the callbacks built by this blueprint
  List<ContactCallback> get callbacks => List.unmodifiable(_callbacks);
}

/// Adds helper methods regardin [Blueprint]s to [FlameGame]
extension FlameGameBlueprint on FlameGame {
  /// Shortcut to attach a [Blueprint] instance to this game
  /// equivalent to `MyBluepinrt().attach(game)`
  Future<void> addFromBlueprint(Blueprint blueprint) async {
    await blueprint.attach(this);
  }
}
