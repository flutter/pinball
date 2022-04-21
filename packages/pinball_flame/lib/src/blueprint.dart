import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';

// TODO(erickzanardo): Keeping this inside our code base
// so we can experiment with the idea, but this is a
// potential upstream change on Flame.

/// {@template blueprint}
/// A [Blueprint] is a virtual way of grouping [Component]s that are related,
/// but they need to be added directly on the [FlameGame] level.
/// {@endtemplate blueprint}
// TODO(alestiago): refactor with feat/make-blueprint-extend-component.
class Blueprint extends Component {
  /// {@macro blueprint}
  Blueprint({
    Iterable<Component>? components,
    Iterable<Blueprint>? blueprints,
  }) {
    if (components != null) _components.addAll(components);
    if (blueprints != null) {
      for (final blueprint in blueprints) {
        _components.addAll(blueprint.components);
      }
    }
  }

  final List<Component> _components = [];

  /// Attaches children.
  @mustCallSuper
  Future<void> _attach(Component parent) async {
    await parent.addAll(_components);
  }

  /// Returns a copy of the components built by this blueprint.
  List<Component> get components => List.unmodifiable(_components);
}

/// Adds helper methods regarding [Blueprint]s to [FlameGame].
extension FlameGameBlueprint on Component {
  /// Shortcut to attach a [Blueprint] instance to this game
  /// equivalent to `MyBluepinrt().attach(game)`
  Future<void> addFromBlueprint(Blueprint blueprint) async {
    await blueprint._attach(this);
  }
}
