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
// TODO(alestiago): refactor with feat/make-blueprint-extend-component.
abstract class Blueprint<T extends FlameGame> extends Component {
  final List<Component> _components = [];
  final List<Blueprint> _blueprints = [];

  bool _isAttached = false;

  /// Called before the the [Component]s managed
  /// by this blueprint is added to the [FlameGame]
  void build(T gameRef);

  /// Attach the [Component]s built on [build] to the [game]
  /// instance
  @mustCallSuper
  Future<void> attach(T game) async {
    build(game);
    await Future.wait([
      game.addAll(_components),
      ..._blueprints.map(game.addFromBlueprint).toList(),
    ]);
    _isAttached = true;
  }

  /// Adds a single [Component] to this blueprint.
  @override
  Future<void> add(Component component) async {
    assert(!_isAttached, _attachedErrorMessage);
    _components.add(component);
  }

  /// Adds a list of [Blueprint]s to this blueprint.
  void addAllBlueprints(List<Blueprint> blueprints) {
    assert(!_isAttached, _attachedErrorMessage);
    _blueprints.addAll(blueprints);
  }

  /// Adds a single [Blueprint] to this blueprint.
  void addBlueprint(Blueprint blueprint) {
    assert(!_isAttached, _attachedErrorMessage);
    _blueprints.add(blueprint);
  }

  /// Returns a copy of the components built by this blueprint
  List<Component> get components => List.unmodifiable(_components);

  /// Returns a copy of the children blueprints
  List<Blueprint> get blueprints => List.unmodifiable(_blueprints);
}

/// Adds helper methods regardin [Blueprint]s to [FlameGame]
extension FlameGameBlueprint on FlameGame {
  /// Shortcut to attach a [Blueprint] instance to this game
  /// equivalent to `MyBluepinrt().attach(game)`
  Future<void> addFromBlueprint(Blueprint blueprint) async {
    await blueprint.attach(this);
  }
}
