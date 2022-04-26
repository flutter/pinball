import 'package:flame/components.dart';

// TODO(alestiago): Remove once the following is merged:
// https://github.com/flame-engine/flame/pull/1566

/// A mixin that ensures a parent is of the given type [T].
mixin ParentIsA<T extends Component> on Component {
  @override
  T get parent => super.parent! as T;

  @override
  Future<void>? addToParent(Component parent) {
    assert(parent is T, 'Parent must be of type $T');
    return super.addToParent(parent);
  }
}
