import 'package:flame/components.dart';
import 'package:flame/game.dart';

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
      _blueprints.addAll(blueprints);
      for (final blueprint in blueprints) {
        _components.addAll(blueprint.components);
      }
    }
  }

  final List<Component> _components = [];

  final List<Component> _blueprints = [];

  Future<void> _addToParent(Component parent) async {
    await parent.addAll(_components);
  }

  /// Returns a copy of the components built by this blueprint.
  List<Component> get components => List.unmodifiable(_components);

  /// Returns a copy of the blueprints built by this blueprint.
  List<Component> get blueprints => List.unmodifiable(_blueprints);
}

/// Adds helper methods regarding [Blueprint]s to [FlameGame].
extension FlameGameBlueprint on Component {
  /// Shortcut to add a [Blueprint]s components to its parent.
  Future<void> addFromBlueprint(Blueprint blueprint) async {
    await blueprint._addToParent(this);
  }
}
