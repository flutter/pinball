import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';

/// {@template component_controller}
/// A [ComponentController] is a [Component] in charge of handling the logic
/// associated with another [Component].
///
/// [ComponentController]s usually implement [BlocComponent].
/// {@endtemplate}
abstract class ComponentController<T extends Component> extends Component {
  /// {@macro component_controller}
  ComponentController(this.component);

  /// The [Component] controlled by this [ComponentController].
  final T component;

  /// Ads the [ComponentController] to its [component].
  Future<void> attach() async {
    // TODO(alestiago): check if component already attached.
    await component.add(this);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    assert(
      parent! == component,
      'ComponentController should be child of $component. '
      'Use attach() instead.',
    );
  }
}
